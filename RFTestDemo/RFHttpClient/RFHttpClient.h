//
//  RFHttpClient.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/2.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFHttpSessionInvalidDelegate.h"
typedef NSURLSessionTask RFURLSessionTask;

/*!
 *  请求成功的回调
 *
 *  @param result 服务端返回的数据类型，通常是字典
 */
typedef void(^RFHttpRequestSuccess)(id result);

/*!
 *  网络响应失败时的回调
 *
 *  @param error 错误信息
 */
typedef void(^RFHttpRequestFailed)(NSError *error);

typedef NS_ENUM(NSUInteger, RFHttpMethod) {
    RFHttpMethodPost,
    RFHttpMethodGet,
    RFHttpMethodPut,
    RFHttpMethodDelete
};

typedef NS_ENUM(NSUInteger, RFResponseType) {
    RFResponseTypeJSON = 1, // 默认
    RFResponseTypeXML  = 2, // XML
    RFResponseTypeData = 3  // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
};

typedef NS_ENUM(NSUInteger, RFRequestType) {
    RFRequestTypeJSON = 1, // 默认
    RFRequestTypePlainText  = 2 // 普通text/html
};

@interface RFHttpClient : NSObject

@property (assign, nonatomic) RFRequestType requestType;

@property (assign, nonatomic) RFResponseType responseType;

@property (copy, nonatomic) NSString *baseUrl;

@property (weak, nonatomic) id<RFHttpSessionInvalidDelegate>delegate;

+ (instancetype)sharedInstance;


/**
 配置请求头

 @param httpHeaders 请求头字典
 */
- (void)configureHTTPHeaders:(NSDictionary *)httpHeaders;

/**
 Get请求方法
 
 @param url 请求地址
 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 @return NSURLSessionTask  可取消请求
 */
- (RFURLSessionTask *)GET:(NSString *)url
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
- (RFURLSessionTask *)POST:(NSString *)url
                parameters:(NSDictionary *)params
                   success:(RFHttpRequestSuccess)success
                   failure:(RFHttpRequestFailed)fail;
@end

