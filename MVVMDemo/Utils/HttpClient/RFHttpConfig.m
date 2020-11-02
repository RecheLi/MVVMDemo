//
//  RFHttpConfig.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/11.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "RFHttpConfig.h"

static NSString *rf_baseUrl = nil;
static NSDictionary *rf_httpHeaders = nil;
static NSDictionary *rf_parameters = nil;
static BOOL rf_enableCacheWhenRequestFailed = NO;
static BOOL rf_enableActivityIndicator = YES;
static id<RFHttpClientDelegate>_delegate = nil;
static RFRequestType rf_requestType = RFRequestTypeJSON;
static RFResponseType rf_responseType = RFResponseTypeJSON;
static NSString *rf_userName = nil;

@implementation RFHttpConfig

#pragma mark - Public
+ (void)updateBaseURL:(NSString *)baseURL {
    rf_baseUrl = baseURL;
}

+ (void)configureUserName:(NSString *)userName {
    rf_userName = userName;
}

+ (void)configureHTTPHeaders:(NSDictionary *)httpHeaders {
    rf_httpHeaders = httpHeaders;
}

+ (void)configureCommonParams:(NSDictionary *)commonParams {
    rf_parameters = commonParams.mutableCopy;
}

+ (void)configureResponseDelegate:(id<RFHttpClientDelegate>)delegate {
    _delegate = delegate;
}

+ (void)enableCacheWhenRequestFailed:(BOOL)enable {
    rf_enableCacheWhenRequestFailed = enable;
}

+ (void)enableActivityIndicator:(BOOL)enable {
    rf_enableActivityIndicator = enable;
}

+ (NSString *)rf_baseUrl {
    return rf_baseUrl;
}

+ (NSString *)rf_userName {
    return rf_userName;
}

+ (NSDictionary *)rf_httpHeaders {
    return rf_httpHeaders;
}

+ (NSDictionary *)rf_parameters {
    return rf_parameters;
}

+ (RFRequestType)rf_requestType {
    return rf_requestType;
}

+ (RFResponseType)rf_responseType {
    return rf_responseType;
}

+ (BOOL)rf_enableCacheWhenRequestFailed {
    return rf_enableCacheWhenRequestFailed;
}

+ (BOOL)rf_enableActivityIndicator {
    return rf_enableActivityIndicator;
}

+ (id<RFHttpClientDelegate>)rf_delegate {
    return _delegate;
}

@end
