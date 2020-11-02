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
    NSMutableArray <NSDictionary *>*exceptionData = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (!exceptionData||exceptionData.count==0) return;
    // 测试
    [self _sendRequest:exceptionData uploadSuccess:succeed uploadFail:failed];
}

+ (void)_sendRequest:(NSMutableArray *)exceptionData
       uploadSuccess:(RFExceptionUploadSucceed)succeed
          uploadFail:(RFExceptionUploadFailed)failed {
    __block NSInteger successCount = 0;
    [exceptionData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:RFExceptionUploaderUrl parameters:obj progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"resultCode"]integerValue] != 0) {
                if (failed) {
                    failed();
                }
                
            } else {
                if (succeed) {
                    successCount += 1;
                    succeed(successCount,idx);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failed) {
                failed();
            }
        }];
    }];
}

@end
