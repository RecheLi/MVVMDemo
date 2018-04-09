//
//  RFHttpClient.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/2.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "RFHttpClient.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface RFHttpClient ()

@property (copy, nonatomic) NSDictionary *httpHeaders;

@end

@implementation RFHttpClient

+ (instancetype)sharedInstance {
    static RFHttpClient *httpClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpClient = [[RFHttpClient alloc]init];
    });
    return httpClient;
}

- (RFURLSessionTask *)GET:(NSString *)url
               parameters:(NSDictionary *)params
                  success:(RFHttpRequestSuccess)success
                  failure:(RFHttpRequestFailed)fail {
    AFHTTPSessionManager *manager = [self manager];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //securityPolicy.validatesDomainName = NO;
    manager.securityPolicy  = securityPolicy;
    @weakify(self);
    RFURLSessionTask *session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        @strongify(self);
        if (self.delegate) {
            
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == -9999) {
            
            return;
        }
        if (success) {
            success(responseObject);
        }
        [manager.session invalidateAndCancel];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
   
        [manager.session invalidateAndCancel];
    }];
    return session;
}

- (RFURLSessionTask *)POST:(NSString *)url
               parameters:(NSDictionary *)params
                  success:(RFHttpRequestSuccess)success
                  failure:(RFHttpRequestFailed)fail {
    return nil;
}

#pragma mark - Private
- (void)configureHTTPHeaders:(NSDictionary *)httpHeaders {
    self.httpHeaders = httpHeaders;
}

- (AFHTTPSessionManager *)manager {
    // 开启转圈圈
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = nil;;
    if (self.baseUrl != nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]];
    } else {
        manager = [AFHTTPSessionManager manager];
    }
    
    switch (_requestType) {
        case RFRequestTypeJSON: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            break;
        }
        case RFRequestTypePlainText: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        default: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            break;
        }
    }
    
    switch (_responseType) {
        case RFResponseTypeJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case RFResponseTypeXML: {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case RFResponseTypeData: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
    }
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    
    for (NSString *key in self.httpHeaders.allKeys) {
        if (self.httpHeaders[key] != nil) {
            [manager.requestSerializer setValue:self.httpHeaders[key] forHTTPHeaderField:key];
        }
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = 3;
    return manager;
}

@end
