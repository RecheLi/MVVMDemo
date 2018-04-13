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
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytesWritten         总上传大小
 */
typedef void (^RFUploadProgress)(int64_t bytesWritten,
                                 int64_t totalBytesWritten);

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


/**
 上传图片

 @param imageData NSData类型：UIImageJPEGRepresentation(image, 1)返回
 @param url 上传路径
 @param filename 文件名
 @param mimeType mimeType
 @param parameters 参数
 @param progress 上传进度
 @param success 上传成功回调
 @param fail 上传失败回调
 */
+ (RFURLSessionTask *)uploadWithImageData:(NSData *)imageData
                                      url:(NSString *)url
                                 filename:(NSString *)filename
                                 mimeType:(NSString *)mimeType
                               parameters:(NSDictionary *)parameters
                                 progress:(RFUploadProgress)progress
                                  success:(RFHttpRequestSuccess)success
                                     fail:(RFHttpRequestFailed)fail;
/**
 *    上传文件操作
 *
 *    @param url                        上传路径
 *    @param uploadingFile    待上传文件的路径
 *    @param progress            上传进度
 *    @param success                上传成功回调
 *    @param fail                    上传失败回调
 *
 *    @return session RFURLSessionTask
 */
+ (RFURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(RFUploadProgress)progress
                                success:(RFHttpRequestSuccess)success
                                   fail:(RFHttpRequestFailed)fail;

/*!
 *  下载文件
 *
 *  @param url           下载URL
 *  @param saveToPath    下载到哪个路径下
 *  @param progressBlock 下载进度
 *  @param success       下载成功后的回调
 *  @param failure       下载失败后的回调
 */
+ (RFURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(RFDownloadProgress)progressBlock
                              success:(RFHttpRequestSuccess)success
                              failure:(RFHttpRequestFailed)failure;

@end

