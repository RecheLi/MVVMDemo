//
//  RFExceptionCapture.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/4.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "RFExceptionCapture.h"
#import "RFExceptionUploader.h"
#import "RFExceptionHelper.h"
#import <mach-o/dyld.h>
#include <execinfo.h>

static NSUncaughtExceptionHandler *ori_vaildUncaughtExceptionHandler;

NSString *const kRFExceptionClient             = @"client";
NSString *const kRFExceptionModel              = @"model";
NSString *const kRFExceptionRomVersion         = @"romVersion";
NSString *const kRFExceptionNetwork            = @"network";
NSString *const kRFExceptionMemorySize         = @"memorySize";
NSString *const kRFExceptionUserId             = @"userId";
NSString *const kRFExceptionPadCode            = @"padCode";
NSString *const kRFExceptionFuncType           = @"funcType";
NSString *const kRFExceptionErrorInfo          = @"errorInfo";
NSString *const kRFExceptionErrorCode          = @"errorCode";
NSString *const kRFExceptionSignalCode         = @"signalCode";
NSString *const kRFExceptionUserInfoBacktrace  = @"kRFExceptionUserInfoBacktrace";
NSString *const kRFExceptionFatalSignal        = @"kRFExceptionFatalSignal";

static id<RFExceptionCaptureProtocol>_delegate = nil;
static NSString *const RFUserInfo = @"kRedFingerUserInfo";


@interface RFExceptionCapture ()

@end

@implementation RFExceptionCapture

#pragma mark - Public
+ (void)registerCrashCapture {
    // 先查看是否有错误日志
    if (_isExistExceptionLog()) {
        _uploadExceptionData();
    }
    _startCapture();
}

+ (void)configureDelegate:(id<RFExceptionCaptureProtocol>)delegate {
    _delegate = delegate;
}

#pragma mark - Private
void _removeExceptionsData () {
    NSFileManager *fileMger = [NSFileManager defaultManager];
    NSString *filePath = [rf_application_documents_directory() stringByAppendingPathComponent:RFExceptionCacheFileName];
    //如果文件路径存在的话
    BOOL bRet = [fileMger fileExistsAtPath:filePath];
    if (bRet) {
        NSError *error;
        [fileMger removeItemAtPath:filePath error:&error];
        if (error) return;
        NSLog(@"delete txt");
    }
}

void _uninstallExceptionHandler() {
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    signal(SIGTRAP, SIG_DFL);
}

void _uploadExceptionData() {
    NSString *filePath = [rf_application_documents_directory() stringByAppendingPathComponent:RFExceptionCacheFileName];
    [RFExceptionUploader uploadExceptionForPath:filePath uploadSuccess:^(NSInteger successCount, NSInteger idx){
        NSInteger dataCount = get_local_exception_array().count;
        // 需要判断有几条异常信息
        if (idx+1 > dataCount) { // 容错
            _removeExceptionsData();
            return;
        }
        if (successCount == dataCount) { //只有1个异常则删除文件
            _removeExceptionsData();
            // 成功上报所有异常后可回调 (optional)
            if (_delegate && [_delegate respondsToSelector:@selector(uploadExceptionCompletion)]) {
                [_delegate uploadExceptionCompletion];
            }
        } else {
            //移除上报成功的异常
            NSMutableArray *localData = get_local_exception_array();
            [localData removeObjectAtIndex:idx];
            [localData writeToFile:filePath atomically:YES];
        }
    } uploadFail:^{
    }];
}

BOOL _isExistExceptionLog() {
    return !get_exception_data() ? NO : YES;
}

void _rf_uncaughtExceptionHandler(NSException *exception) {
    [RFExceptionCapture _handleException:exception];
}

void _rf_signalHandler(int signalCode) {
    const NSInteger kRFStackFramesMax = 128;
    void *stack[kRFStackFramesMax];
    NSInteger frameCount = backtrace(stack, kRFStackFramesMax);
    char **lines = backtrace_symbols(stack, (int)frameCount);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frameCount];
    for (NSInteger i = 1; i < frameCount; i++)
        [backtrace addObject:[NSString stringWithUTF8String:lines[i]]];
    
    free(lines);
    
    NSDictionary *userInfo = @{kRFExceptionSignalCode: @(signalCode), kRFExceptionUserInfoBacktrace: backtrace};
    NSString *reason = [NSString stringWithFormat:@"App terminated by SIG%@", [NSString stringWithUTF8String:sys_signame[signalCode]].uppercaseString];
    NSException *e = [NSException exceptionWithName:kRFExceptionFatalSignal reason:reason userInfo:userInfo];
    
    _rf_uncaughtExceptionHandler(e);
}

void _startCapture() {
    // 判断是否之前已注册handler，避免恶意覆盖
    NSUncaughtExceptionHandler *handler = NSGetUncaughtExceptionHandler();
    if (!handler) {
        NSLog(@"no previous handler");
    } else {
        ori_vaildUncaughtExceptionHandler = handler;
    }
    NSSetUncaughtExceptionHandler(&_rf_uncaughtExceptionHandler);
    signal(SIGABRT, _rf_signalHandler);
    signal(SIGILL, _rf_signalHandler);
    signal(SIGSEGV, _rf_signalHandler);
    signal(SIGFPE, _rf_signalHandler);
    signal(SIGBUS, _rf_signalHandler);
    signal(SIGPIPE, _rf_signalHandler);
    signal(SIGTRAP, _rf_signalHandler);
}

+ (void)_handleException:(NSException *)exception {
    NSString *errorInfo = [NSString stringWithFormat:@"name:%@  reason:%@  callStackSymbols:  %@",exception.name,exception.reason,[[exception callStackSymbols] componentsJoinedByString:@"\n"]];
    NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:RFUserInfo]];
    //上传参数
    NSDictionary *params = @{kRFExceptionClient:@"ios",
                             kRFExceptionModel: get_device_info(),
                             kRFExceptionRomVersion:get_system_version(),
                             kRFExceptionNetwork:get_current_network(),
                             kRFExceptionMemorySize:@"memorySize",
                             kRFExceptionUserId:!userDic[@"userId"]?@"userId":userDic[@"userId"],
                             kRFExceptionPadCode:@"padCode",
                             kRFExceptionFuncType:[RFExceptionHelper convertFuncTypeFromExceptionReason:exception.reason],
                             kRFExceptionErrorInfo:errorInfo,
                             kRFExceptionErrorCode:[RFExceptionHelper convertErrorCodeFromExceptionName:exception.name]};
    NSString *path = [rf_application_documents_directory() stringByAppendingPathComponent:RFExceptionCacheFileName];
    
    // 先查看本地是否有未清除的缓存
    if (!_isExistExceptionLog()) { // 无
        NSMutableArray *array = @[].mutableCopy;
        [array addObject:params];
        if ([array writeToFile:path atomically:YES]) {
            NSLog(@"初次写入成功");
        }
        return;
    }
    // 如果有，则将本地缓存数组取出来再追加本次异常
    NSMutableArray *localData = get_local_exception_array();
    [localData addObject:params];
    if ([localData writeToFile:path atomically:YES]) {
        NSLog(@"追加异常并写入成功");
    }
    _uninstallExceptionHandler();
    //处理之前的handler
    if (ori_vaildUncaughtExceptionHandler) {
        ori_vaildUncaughtExceptionHandler(exception);
    }
}


@end
