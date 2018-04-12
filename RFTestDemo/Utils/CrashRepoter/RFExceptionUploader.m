//
//  RFExceptionUploader.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/4.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "RFExceptionUploader.h"

static NSString *const RFExceptionUploaderUrl = @"http://10.100.0.253:8801/fingergather/error/errorInfo.html";

@implementation RFExceptionUploader

+ (void)uploadExceptionForPath:(NSString *)filePath
                 uploadSuccess:(RFExceptionUploadSucceed)succeed
                 uploadFail:(RFExceptionUploadFailed)failed {
    NSLog(@"  上报崩溃信息  ");    
    NSMutableArray <NSDictionary *>*exceptionData = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSLog(@"exceptionData is %@",exceptionData);
    if (!exceptionData||exceptionData.count==0) return;
    // 测试
#if DEBUG
    [self _sendRequest:exceptionData uploadSuccess:succeed uploadFail:failed];
#else
    [self _sendRequest:exceptionData uploadSuccess:succeed uploadFail:failed];
#endif

}

+ (void)_sendRequest:(NSMutableArray *)exceptionData
       uploadSuccess:(RFExceptionUploadSucceed)succeed
          uploadFail:(RFExceptionUploadFailed)failed {
    __block NSInteger successCount = 0;
    [exceptionData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.redfinger.RFTestDemo"];
//        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:RFExceptionUploaderUrl parameters:obj progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"resultCode"]integerValue] != 0) {
                NSLog(@"report fail");
                if (failed) {
                    failed();
                }
                
            } else {
                NSLog(@"report success");
                if (succeed) {
                    successCount += 1;
                    succeed(successCount,idx);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"report fail");
            if (failed) {
                failed();
            }
        }];
    }];
}

@end
