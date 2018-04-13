//
//  RFHttpConfig.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/11.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFHttpClientDelegate.h"

static NSInteger const rf_sessionInvalidCode = -9999;
static NSInteger const rf_requestSuccessCode = 0;

typedef NS_ENUM(NSUInteger, RFHttpMethod) {
    RFHttpMethodGet = 1,
    RFHttpMethodPost,
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

typedef NS_ENUM(NSUInteger, RFNetworkStatusType) {
    RFNetworkStatusTypeUnknown, // 未知网络
    RFNetworkStatusTypeNotReachable, // 无网络
    RFNetworkStatusTypeReachableViaWWAN, // 手机网络
    RFNetworkStatusTypeReachableViaWiFi // WIFI网络
};

@interface RFHttpConfig : NSObject

/**
 返回请求地址
 @return 请求地址 @"http://www.somecompany.com"
 */
+ (NSString *)rf_baseUrl;

/**
 返回用户名

 @return @"linitial"
 */
+ (NSString *)rf_userName;

/**
 返回公共请求头
 @return 公共请求头的@{}
 */
+ (NSDictionary *)rf_httpHeaders;

/**
 返回公共请求参数
 @return @{@"sessionID":@"xxx"};
 */
+ (NSDictionary *)rf_parameters;

/**
 返回request类型
 @return RFRequestTypeJSON
 */
+ (RFRequestType)rf_requestType;

/**
 返回response类型
 @return RFResponseTypeJSON
 */
+ (RFResponseType)rf_responseType;


/**
 返回代理对象

 @return RFHttpClientDelegate
 */
+ (id<RFHttpClientDelegate>)rf_delegate;

/**
 返回是否请求失败时返回缓存数据
 @return YES
 */
+ (BOOL)rf_enableCacheWhenRequestFailed;


/**
 返回是否开启转圈圈
 @return YES
 */
+ (BOOL)rf_enableActivityIndicator;

/**
 配置请求头
 @param httpHeaders 请求头字典
 */
+ (void)configureHTTPHeaders:(NSDictionary *)httpHeaders;

/**
 配置请求头
 @param commonParams 公共请求体字典
 */
+ (void)configureCommonParams:(NSDictionary *)commonParams;


/**
 配置用户名，以区分不同用户的cache

 @param userName @"linitial"
 */
+ (void)configureUserName:(NSString *)userName;

/**
 配置请求地址 可在Appdelegate中配置
 @param baseURL 请求地址
 */
+ (void)updateBaseURL:(NSString *)baseURL;


/**
 配置请求返回的代理，可由代理统一处理特殊值
 @param delegate 代理
 */
+ (void)configureResponseDelegate:(id<RFHttpClientDelegate>)delegate;


/**
 配置是否当请求失败时返回缓存数据
 @param enable default is NO
 */
+ (void)enableCacheWhenRequestFailed:(BOOL)enable;


/**
 配置是否开启转圈圈

 @param enable default is YES
 */
+ (void)enableActivityIndicator:(BOOL)enable;

@end
