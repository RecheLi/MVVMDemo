//
//  RFExceptionHelper.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/4.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "RFExceptionHelper.h"
#import <UIKit/UIDevice.h>
#import "AFNetworkReachabilityManager.h"

NSString *const kRFExceptionDateFormat              = @"yyyy-MM-dd HH:mm:ss";
NSString *const RFExceptionCacheFileName            = @"RFException.txt";
NSString *const RFExceptionNameUnknown              = @"RFExceptionNameUnknown";
NSString *const RFExceptionReasonUnknown            = @"RFExceptionReasonUnknown";
NSString *const RFNetworkReachabilityStatusUnknown  = @"RFNetworkReachabilityStatusUnknown";

@implementation RFExceptionHelper

#pragma mark - Public
NSString *get_current_date() {
    NSDate *date =  [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:kRFExceptionDateFormat];
    NSString *crashTime = [dateFormatter stringFromDate:date];
    return crashTime; // eg 2222-02-02 12:12:12
}

NSString *get_device_info() {
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceInfo = [NSString stringWithFormat:@"%@ %@ %@",device.model,device.systemName,device.systemVersion];
    return deviceInfo; // eg: iPhone 6 iOS 10.0
}

NSString *get_system_version() {
    UIDevice *device = [UIDevice currentDevice];
    NSString *systemVersion = [NSString stringWithFormat:@"%@ %@",device.systemName,device.systemVersion];
    return systemVersion; // eg: iPhone 6 iOS 10.0
}

NSString *get_current_network() {
    NSString *networkReachabilityStatus = RFNetworkReachabilityStatusUnknown; // 表示未知
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
            networkReachabilityStatus = @"1";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            networkReachabilityStatus = @"2";
            break;
        default:
            break;
    }
    return networkReachabilityStatus;
}

NSString *rf_application_documents_directory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

NSData *get_exception_data() {
    NSString *dataPath = [rf_application_documents_directory() stringByAppendingPathComponent:RFExceptionCacheFileName];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    return data;
}

NSMutableArray *get_local_exception_array() {
    NSString *dataPath = [rf_application_documents_directory() stringByAppendingPathComponent:RFExceptionCacheFileName];
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:dataPath];
    return data;
}

+ (NSString *)convertErrorCodeFromExceptionName:(NSString *)name {
    if (_is_empty(name)) {
        return RFExceptionNameUnknown;
    }
    return name;
}

+ (NSString *)convertFuncTypeFromExceptionReason:(NSString *)reason {
    if (_is_empty(reason)) {
        return RFExceptionReasonUnknown;
    }
    return reason;
}

#pragma mark - Private
BOOL _is_empty(NSString *string) {
    if (!string || [string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end
