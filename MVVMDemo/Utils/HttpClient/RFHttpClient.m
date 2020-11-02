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
#import "RFHttpClientDelegate.h"
#import "RFCache.h"

@interface RFHttpClient ()

@end

@implementation RFHttpClient

#pragma mark - Public

+ (RFURLSessionTask *)GET:(NSString *)url
               parameters:(NSDictionary *)params
                  success:(RFHttpRequestSuccess)success
                  failure:(RFHttpRequestFailed)fail {
    return [self GET:url
          parameters:params
             success:success
             failure:fail
              cached:NO];
}

+ (RFURLSessionTask *)POST:(NSString *)url
               parameters:(NSDictionary *)params
                  success:(RFHttpRequestSuccess)success
                  failure:(RFHttpRequestFailed)fail {
    return [self POST:url
           parameters:params
              success:success
              failure:false
               cached:NO];
}

+ (RFURLSessionTask *)POST:(NSString *)url
               parameters:(NSDictionary *)params
                  success:(RFHttpRequestSuccess)success
                  failure:(RFHttpRequestFailed)fail
                   cached:(BOOL)cached {
    return [self _requestWithUrl:url
                      httpMethod:RFHttpMethodPost
                      parameters:params
                        progress:nil
                         success:success
                         failure:fail
                          cached:cached];
}

+ (RFURLSessionTask *)POST:(NSString *)url
                parameters:(NSDictionary *)params
                  progress:(RFPostProgress)progress
                   success:(RFHttpRequestSuccess)success
                   failure:(RFHttpRequestFailed)fail
                    cached:(BOOL)cached {
    return [self _requestWithUrl:url
                      httpMethod:RFHttpMethodPost
                      parameters:params
                        progress:progress
                         success:success
                         failure:fail
                          cached:cached];
}

+ (RFURLSessionTask *)GET:(NSString *)url
               parameters:(NSDictionary *)params
                  success:(RFHttpRequestSuccess)success
                  failure:(RFHttpRequestFailed)fail
                   cached:(BOOL)cached {
    return [self GET:url
          parameters:params
            progress:nil
             success:success
             failure:fail
              cached:cached];
}

+ (RFURLSessionTask *)GET:(NSString *)url
               parameters:(NSDictionary *)params
                 progress:(RFGetProgress)progress
                  success:(RFHttpRequestSuccess)success
                  failure:(RFHttpRequestFailed)fail
                   cached:(BOOL)cached {
    return [self _requestWithUrl:url
                      httpMethod:RFHttpMethodGet
                      parameters:params
                        progress:progress
                         success:success
                         failure:fail
                          cached:cached];
}

+ (RFURLSessionTask *)uploadWithImageData:(NSData *)imageData
                                      url:(NSString *)url
                                 filename:(NSString *)filename
                                 mimeType:(NSString *)mimeType
                               parameters:(NSDictionary *)parameters
                                 progress:(RFUploadProgress)progress
                                  success:(RFHttpRequestSuccess)success
                                     fail:(RFHttpRequestFailed)fail {
    AFHTTPSessionManager *manager = [self _manager];
    RFURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss"; // can be modified
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:[imageFileName stringByDeletingPathExtension] fileName:imageFileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self _handleSucceedResponse:responseObject
                      successHandler:success
                              cached:NO
                          requestURL:url];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self _handleFailedError:error
                  failureHandler:fail
                  successHandler:success
            enableCacheWhenFaied:NO
                      requestURL:url];
    }];
    return session;
}

+ (RFURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(RFUploadProgress)progress
                                success:(RFHttpRequestSuccess)success
                                   fail:(RFHttpRequestFailed)fail {
    AFHTTPSessionManager *manager = [self _manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    RFURLSessionTask *session = [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [self _handleSucceedResponse:responseObject
                          successHandler:success
                                  cached:NO
                              requestURL:url];
            return;
        }
        [self _handleFailedError:error
                  failureHandler:fail
                  successHandler:success
            enableCacheWhenFaied:NO
                      requestURL:url];
    }];
    return session;
}

+ (RFURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(RFDownloadProgress)progressBlock
                              success:(RFHttpRequestSuccess)success
                              failure:(RFHttpRequestFailed)failure {
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self _manager];
    
    RFURLSessionTask *session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (success) {
            success(filePath.absoluteString);
        }
    }];
    return session;
}

#pragma mark - Private
+ (RFURLSessionTask *)_requestWithUrl:(NSString *)url
                           httpMethod:(RFHttpMethod)httpMethod
                           parameters:(NSDictionary *)params
                             progress:(RFDownloadProgress)progress
                              success:(RFHttpRequestSuccess)success
                              failure:(RFHttpRequestFailed)fail
                               cached:(BOOL)cached {
    AFHTTPSessionManager *manager = [self _manager];
    // 这里如果有公共请求体，则需要添加
    NSDictionary *completedParams = [self _completedParamsWithPortionParams:params];
    RFURLSessionTask *session = nil;
    // 目前需求仅需要Post和Get请求
    if (httpMethod == RFHttpMethodPost) {
        session = [manager POST:url
                     parameters:completedParams
                       progress:^(NSProgress * _Nonnull uploadProgress) {
            [self _handleUploadProgress:uploadProgress
                       progressCallBack:progress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self _handleSucceedResponse:responseObject
                          successHandler:success
                                  cached:cached
                              requestURL:url];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self _handleFailedError:error
                      failureHandler:fail
                      successHandler:success
                enableCacheWhenFaied:[RFHttpConfig rf_enableCacheWhenRequestFailed]
                          requestURL:url];
        }];
    } else if (httpMethod == RFHttpMethodGet) {
        session = [manager GET:url
                    parameters:completedParams
                      progress:^(NSProgress * _Nonnull downloadProgress) {
            [self _handleDownloadProgress:downloadProgress
                         progressCallBack:progress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self _handleSucceedResponse:responseObject
                          successHandler:success
                                  cached:cached
                              requestURL:url];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self _handleFailedError:error
                      failureHandler:fail
                      successHandler:success
                enableCacheWhenFaied:[RFHttpConfig rf_enableCacheWhenRequestFailed]
                          requestURL:url];
        }];
    } else if (httpMethod == RFHttpMethodPut) {
        // TODO:
    } else if (httpMethod == RFHttpMethodDelete) {
        // TODO:
    }
    return session;
}

+ (AFHTTPSessionManager *)_manager {
    // 开启转圈圈
    [AFNetworkActivityIndicatorManager sharedManager].enabled = [RFHttpConfig rf_enableActivityIndicator];

    AFHTTPSessionManager *manager = nil;;
    if ([self _baseUrl] != nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self _baseUrl]]];
    } else {
        manager = [AFHTTPSessionManager manager];
    }
    manager.securityPolicy  = [self _securityPolicy];
    manager.requestSerializer = [self _managerRequestSerializer];
    manager.responseSerializer = [self _managerResponseSerializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    for (NSString *key in [self _httpHeaders].allKeys) {
        if ([self _httpHeaders][key] != nil) {
            [manager.requestSerializer setValue:self._httpHeaders[key] forHTTPHeaderField:key];
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

+ (void)_handleUploadProgress:(NSProgress * _Nonnull)uploadProgress
             progressCallBack:(RFPostProgress)progress {
    if (progress) {
        progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    }
}

+ (void)_handleDownloadProgress:(NSProgress * _Nonnull)downloadProgress
             progressCallBack:(RFGetProgress)progress {
    if (progress) {
        progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    }
}

+ (void)_handleSucceedResponse:(id)responseObject
                successHandler:(RFHttpRequestSuccess)success
                        cached:(BOOL)cached
                    requestURL:(NSString *)requestURL {
    if (![responseObject isKindOfClass:[NSData class]]) {
        if (success) {
            success(responseObject);
        }
        return;
    }
    NSError *error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
    if ([responseObject[@"code"] integerValue] == rf_sessionInvalidCode) {
        // 处理session失效
        if ([self _delegate] && [[self _delegate] respondsToSelector:@selector(enterLoginInterfaceTologin)]) {
            [[self _delegate] enterLoginInterfaceTologin];
        }
        return;
    }
    if (cached && [response[@"code"] integerValue] == rf_requestSuccessCode) {
        [RFCache setData:response forKey:[NSString stringWithFormat:@"%@/%@",[self _userName],requestURL]];
    }
    if (success) {
        success(response);
    }
}

+ (void)_handleFailedError:(NSError *)error
            failureHandler:(RFHttpRequestFailed)fail
            successHandler:(RFHttpRequestSuccess)success
      enableCacheWhenFaied:(BOOL)enableCacheWhenFaied
                requestURL:(NSString *)requestURL {
    if (!enableCacheWhenFaied) { // 未开启 请求失败返回缓存 开关
        if (fail) {
            fail(error);
        }
    } else {// 请求失败取缓存
        [RFCache objectForKey:[NSString stringWithFormat:@"%@/%@",[self _userName],requestURL] completion:^(NSDictionary *result) {// 获取本地缓存
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!result && fail) { // 本地没有，则回调fail
                    if (fail) {
                        fail(error);
                    }
                    return;
                }
                if (success) {
                    success(result);
                }
            });
        }];
    }
}

+ (NSDictionary *)_completedParamsWithPortionParams:(NSDictionary *)portionParams {
    if (![self _commonParams]) {
        return portionParams;
    }
    NSMutableDictionary *tempParams = [NSMutableDictionary dictionaryWithDictionary:portionParams];
    [tempParams addEntriesFromDictionary:[self _commonParams]];
    return [tempParams copy];
}

+ (NSString *)_baseUrl {
    return [RFHttpConfig rf_baseUrl];
}

+ (NSString *)_userName {
    return [RFHttpConfig rf_userName];
}

+ (NSDictionary *)_httpHeaders {
    return [RFHttpConfig rf_httpHeaders];
}

+ (NSDictionary *)_commonParams {
    return [RFHttpConfig rf_parameters];
}

+ (RFRequestType)_requestType {
    return [RFHttpConfig rf_requestType];
}

+ (RFResponseType)_responseType {
    return [RFHttpConfig rf_responseType];
}

+ (BOOL)_enableActivityIndicator {
    return [RFHttpConfig rf_enableActivityIndicator];
}

+ (id<RFHttpClientDelegate>)_delegate {
    return [RFHttpConfig rf_delegate];
}

+ (AFSecurityPolicy *)_securityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // validatesDomainName 是否需要验证域名，默认为YES；
    // securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}

+ (AFHTTPResponseSerializer *)_managerResponseSerializer {
    switch ([self _responseType]) {
        case RFResponseTypeJSON: {
            return [AFJSONResponseSerializer serializer];
            break;
        }
        case RFResponseTypeXML: {
            return [AFXMLParserResponseSerializer serializer];
            break;
        }
        case RFResponseTypeData: {
            return [AFHTTPResponseSerializer serializer];
            break;
        }
    }
}

+ (AFHTTPRequestSerializer *)_managerRequestSerializer {
    switch ([self _requestType]) {
        case RFRequestTypeJSON: {
            AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
            [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            return requestSerializer;
            break;
        }
        case RFRequestTypePlainText: {
            AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
            return requestSerializer;
            break;
        }
    }
}

@end
