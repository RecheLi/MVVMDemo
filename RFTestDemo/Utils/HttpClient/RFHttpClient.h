//
//  RFHttpClient.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/2.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFHttpConfig.h"

typedef NSURLSessionTask RFURLSessionTask;

/*!
 *  请求成功的回调
 *
 *  @param result 服务端返回的数据类型，通常是字典
 */
typedef void(^RFHttpRequestSuccess)(id result);

/*!
 *  下载进度
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 */
typedef void (^RFDownloadProgress)(int64_t bytesRead,
                                   int64_t totalBytesRead);

typedef RFDownloadProgress RFGetProgress;
typedef RFDownloadProgress RFPostProgress;

/*!
 *  网络响应失败时的回调
 *
 *  @param error 错误信息
 */
typedef void(^RFHttpRequestFailed)(NSError *error);


@interface RFHttpClient : NSObject

/**
 Get请求方法
 
 @param url 请求地址
 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 @return NSURLSessionTask  可取消请求
 */
+ (RFURLSessionTask *)GET:(NSString *)url
                parameters:(NSDictionary *)params
                   success:(RFHttpRequestSuccess)success
                   failure:(RFHttpRequestFailed)fail;

/**
 Post请求方法

 @param url 请求地址
 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 @return NSURLSessionTask  可取消请求
 */
+ (RFURLSessionTask *)POST:(NSString *)url
                parameters:(NSDictionary *)params
                   success:(RFHttpRequestSuccess)success
                   failure:(RFHttpRequestFailed)fail;

+ (RFURLSessionTask *)POST:(NSString *)url
               parameters:(NSDictionary *)params
                  success:(RFHttpRequestSuccess)success
                  failure:(RFHttpRequestFailed)fail
                   cached:(BOOL)cached;

+ (RFURLSessionTask *)GET:(NSString *)url
               parameters:(NSDictionary *)params
                  success:(RFHttpRequestSuccess)success
                  failure:(RFHttpRequestFailed)fail
                   cached:(BOOL)cached;

+ (RFURLSessionTask *)GET:(NSString *)url
               parameters:(NSDictionary *)params
                 progress:(RFGetProgress)progress
                  success:(RFHttpRequestSuccess)success
                  failure:(RFHttpRequestFailed)fail
                    cached:(BOOL)cached;
@end

