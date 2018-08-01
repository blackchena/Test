//
//  IDCMNetWorking.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMNetWorking.h"
#import "IDCMConfig.h"
#import "IDCMServerConfig.h"
#import "IDCMAppDotNetAPIClient.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "IDCMHUD.h"
#import "IDCMMaintenanceViewController.h"
/**
 *  基础URL
 */
static NSString *IDCM_privateNetworkBaseUrl = nil;
/**
 *  是否开启接口打印信息
 */
static BOOL IDCM_isEnableInterfaceDebug = NO;
/**
 *  是否开启自动转换URL里的中文
 */
static BOOL IDCM_shouldAutoEncode = NO;
/**
 *  设置请求头，默认为空
 */
static NSDictionary *IDCM_httpHeaders = nil;
/**
 *  设置的返回数据类型
 */
static IDCMResponseType IDCM_responseType = kIDCMResponseTypeData;
/**
 *  设置的请求数据类型
 */
static IDCMRequestType  IDCM_requestType  = kIDCMRequestTypeJSON;
/**
 *  监测网络状态
 */
static IDCMNetworkStatus IDCM_networkStatus = kIDCMNetworkStatusUnknown;
/**
 *  保存所有网络请求的task
 */
static NSMutableArray *IDCM_requestTasks;
/**
 *  GET请求设置不缓存，Post请求不缓存
 */
static BOOL IDCM_cacheGet  = NO;
static BOOL IDCM_cachePost = NO;
/**
 *  是否开启取消请求
 */
static BOOL IDCM_shouldCallbackOnCancelRequest = YES;
/**
 *  请求的超时时间
 */
static NSTimeInterval IDCM_timeout = 40.0f;
/**
 *  是否从从本地提取数据
 */
static BOOL IDCM_shoulObtainLocalWhenUnconnected = NO;
/**
 *  基础url是否更改，默认为yes
 */
static BOOL IDCM_isBaseURLChanged = YES;
/**
 *  请求管理者
 */
static IDCMAppDotNetAPIClient *IDCM_sharedManager = nil;
@implementation IDCMNetWorking
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost {
    IDCM_cacheGet = isCacheGet;
    IDCM_cachePost = shouldCachePost;
}

+ (void)updateBaseUrl:(NSString *)baseUrl {
    if ([baseUrl isEqualToString:IDCM_privateNetworkBaseUrl] && baseUrl && baseUrl.length) {
        IDCM_isBaseURLChanged = YES;
    } else {
        IDCM_isBaseURLChanged = NO;
    }
    IDCM_privateNetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl {
    return IDCM_privateNetworkBaseUrl;
}

+ (void)setTimeout:(NSTimeInterval)timeout {
    IDCM_timeout = timeout;
}

+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain {
    IDCM_shoulObtainLocalWhenUnconnected = shouldObtain;
}

+ (void)enableInterfaceDebug:(BOOL)isDebug {
    IDCM_isEnableInterfaceDebug = isDebug;
}

+ (BOOL)isDebug {
    return IDCM_isEnableInterfaceDebug;
}

static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/IDCMNetworkingCaches"];
}

+ (void)clearCaches {
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error) {
            DDLogDebug(@"IDCMNetworking clear caches error: %@", error);
        } else {
            DDLogDebug(@"IDCMNetworking clear caches ok");
        }
    }
}

+ (unsigned long long)totalCacheSize {
    NSString *directoryPath = cachePath();
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (IDCM_requestTasks == nil) {
            IDCM_requestTasks = @[].mutableCopy;
        }
    });
    
    return IDCM_requestTasks;
}

+ (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(IDCMURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[IDCMURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(IDCMURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[IDCMURLSessionTask class]] && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

+ (void)configRequestType:(IDCMRequestType)requestType
             responseType:(IDCMResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest {
    IDCM_requestType = requestType;
    IDCM_responseType = responseType;
    IDCM_shouldAutoEncode = shouldAutoEncode;
    IDCM_shouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}

+ (BOOL)shouldEncode {
    return IDCM_shouldAutoEncode;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
    IDCM_httpHeaders = httpHeaders;
}

// 无进度回调 无提示框
+ (IDCMURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          success:(IDCMResponseSuccess)success
                             fail:(IDCMResponseFail)fail{
    return [self IDCM_requestWithUrl:url
                       refreshCache:YES
                          isShowHUD:NO
                            showHUD:nil
                          httpMedth:1
                             params:nil
                           progress:nil
                            success:success
                               fail:fail];
}
// 无进度回调 有提示框
+ (IDCMURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          showHUD:(NSString *)statusText
                          success:(IDCMResponseSuccess)success
                             fail:(IDCMResponseFail)fail{
    return [self IDCM_requestWithUrl:url
                       refreshCache:YES
                          isShowHUD:YES
                            showHUD:statusText
                          httpMedth:1
                             params:nil
                           progress:nil
                            success:success
                               fail:fail];
}
// 无进度回调 无提示框
+ (IDCMURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(id)params
                          success:(IDCMResponseSuccess)success
                             fail:(IDCMResponseFail)fail{
    return [self IDCM_requestWithUrl:url
                       refreshCache:YES
                          isShowHUD:NO
                            showHUD:nil
                          httpMedth:1
                             params:params
                           progress:nil
                            success:success
                               fail:fail];
}
// 无进度回调 有提示框
+ (IDCMURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          showHUD:(NSString *)statusText
                           params:(id)params
                          success:(IDCMResponseSuccess)success
                             fail:(IDCMResponseFail)fail{
    return [self IDCM_requestWithUrl:url
                       refreshCache:YES
                          isShowHUD:YES
                            showHUD:statusText
                          httpMedth:1
                             params:params
                           progress:nil
                            success:success
                               fail:fail];
}
// 有进度回调 无提示框
+ (IDCMURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(id)params
                         progress:(IDCMGetProgress)progress
                          success:(IDCMResponseSuccess)success
                             fail:(IDCMResponseFail)fail {
    return [self IDCM_requestWithUrl:url
                       refreshCache:YES
                          isShowHUD:NO
                            showHUD:nil
                          httpMedth:1
                             params:params
                           progress:progress
                            success:success
                               fail:fail];
}
// 有进度回调 有提示框
+ (IDCMURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          showHUD:(NSString *)statusText
                           params:(id)params
                         progress:(IDCMGetProgress)progress
                          success:(IDCMResponseSuccess)success
                             fail:(IDCMResponseFail)fail{
    return [self IDCM_requestWithUrl:url
                       refreshCache:YES
                          isShowHUD:YES
                            showHUD:statusText
                          httpMedth:1
                             params:params
                           progress:progress
                            success:success
                               fail:fail];
}
/**
 *  无进度回调 无提示框
 */

+ (IDCMURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(id)params
                           success:(IDCMResponseSuccess)success
                              fail:(IDCMResponseFail)fail{
    return [self IDCM_requestWithUrl:url
                       refreshCache:YES
                          isShowHUD:NO
                            showHUD:nil
                          httpMedth:2
                             params:params
                           progress:nil
                            success:success
                               fail:fail];
}

/**
 *  无进度回调 有提示框
 *
 */
+ (IDCMURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                           showHUD:(NSString *)statusText
                            params:(id)params
                           success:(IDCMResponseSuccess)success
                              fail:(IDCMResponseFail)fail{
    return [self IDCM_requestWithUrl:url
                       refreshCache:YES
                          isShowHUD:YES
                            showHUD:statusText
                          httpMedth:2
                             params:params
                           progress:nil
                            success:success
                               fail:fail];
}
// 有进度回调 无提示框
+ (IDCMURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(id)params
                          progress:(IDCMPostProgress)progress
                           success:(IDCMResponseSuccess)success
                              fail:(IDCMResponseFail)fail {
    
    return [self IDCM_requestWithUrl:url
                       refreshCache:YES
                          isShowHUD:NO
                            showHUD:nil
                          httpMedth:2
                             params:params
                           progress:progress
                            success:success
                               fail:fail];
}
// 有进度回调 有提示框
+ (IDCMURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                           showHUD:(NSString *)statusText
                            params:(id)params
                          progress:(IDCMPostProgress)progress
                           success:(IDCMResponseSuccess)success
                              fail:(IDCMResponseFail)fail{
    
    return [self IDCM_requestWithUrl:url
                       refreshCache:YES
                          isShowHUD:YES
                            showHUD:statusText
                          httpMedth:2
                             params:params
                           progress:progress
                            success:success
                               fail:fail];
}

+ (IDCMURLSessionTask *)IDCM_requestWithUrl:(NSString *)url
                             refreshCache:(BOOL)refreshCache
                                isShowHUD:(BOOL)isShowHUD
                                  showHUD:(NSString *)statusText
                                httpMedth:(NSUInteger)httpMethod
                                   params:(id)params
                                 progress:(IDCMDownloadProgress)progress
                                  success:(IDCMResponseSuccess)success
                                     fail:(IDCMResponseFail)fail {
    
    
    if (url) {
        
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            
        } else if ([url hasPrefix:serverSign]) {
            
            url = [url componentsSeparatedByString:serverSign].lastObject;
        } else {
            
            NSString *serverAddress = [IDCMServerConfig getIDCMServerAddr];
            url = [serverAddress stringByAppendingString:url];
        }
        
    }else{
        return nil;
    }
    
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    AFHTTPSessionManager *manager = [self manager];
    manager.requestSerializer.timeoutInterval = 40;
    if ([url containsString:ExchangeExchangeIn_URL]) {
        manager.requestSerializer.timeoutInterval = 60;
    }
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    IDCMURLSessionTask *session = nil;
    // 显示提示框
    if (isShowHUD) {
        [IDCMNetWorking showHUD:statusText];
    }
    if (httpMethod == 1) {
        if (IDCM_cacheGet) {
            if (IDCM_shoulObtainLocalWhenUnconnected) {
                if (IDCM_networkStatus == kIDCMNetworkStatusNotReachable ||  IDCM_networkStatus == kIDCMNetworkStatusUnknown ) {
                    id response = [IDCMNetWorking cahceResponseWithURL:absolute
                                                           parameters:params];
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success withTask:nil];
                            
                            if ([self isDebug]) {
                                [self logWithSuccessResponse:response
                                                         url:absolute
                                                      params:params];
                            }
                        }
                        return nil;
                    }
                }
            }
            if (!refreshCache) {
                id response = [IDCMNetWorking cahceResponseWithURL:absolute
                                                       parameters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success withTask:nil];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                    return nil;
                }
            }
        }
        
        session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            

            // 移除提示框
            if (isShowHUD) {
                [IDCMNetWorking dismissSuccessHUD];
            }
            [self successResponse:responseObject callback:success withTask:task];
            
            if (IDCM_cacheGet) {
                [self cacheResponseObject:responseObject request:task.currentRequest parameters:params];
            }
            
            [[self allTasks] removeObject:task];
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:absolute
                                      params:params];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 移除提示框
            if (isShowHUD) {
                [IDCMNetWorking dismissErrorHUD];
            }
            [[self allTasks] removeObject:task];
            if ([error code] < 0 && IDCM_cacheGet) {// 获取缓存
                id response = [IDCMNetWorking cahceResponseWithURL:absolute
                                                       parameters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success withTask:nil];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                } else {
                    [self handleCallbackWithError:error andWith:task fail:fail url:url];
                    
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
            } else {
                [self handleCallbackWithError:error andWith:task fail:fail url:url];
                
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
            }
        }];
    }
    else if (httpMethod == 2) {
        if (IDCM_cachePost ) {// 获取缓存
            if (IDCM_shoulObtainLocalWhenUnconnected) {
                if (IDCM_networkStatus == kIDCMNetworkStatusNotReachable ||  IDCM_networkStatus == kIDCMNetworkStatusUnknown ) {
                    id response = [IDCMNetWorking cahceResponseWithURL:absolute
                                                           parameters:params];
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success withTask:nil];
                            
                            if ([self isDebug]) {
                                [self logWithSuccessResponse:response
                                                         url:absolute
                                                      params:params];
                            }
                        }
                        return nil;
                    }
                }
            }
            if (!refreshCache) {
                id response = [IDCMNetWorking cahceResponseWithURL:absolute
                                                       parameters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success withTask:nil];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                    return nil;
                }
            }
        }
        
        
        session = [manager POST:url parameters:params  progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 移除提示框
            if (isShowHUD) {
                [IDCMNetWorking dismissSuccessHUD];
            }
            
            [self successResponse:responseObject callback:success withTask:task];
            
            if (IDCM_cachePost) {
                [self cacheResponseObject:responseObject request:task.currentRequest  parameters:params];
            }
            
            [[self allTasks] removeObject:task];
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:absolute
                                      params:params];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 移除提示框
            if (isShowHUD) {
                [IDCMNetWorking dismissErrorHUD];
            }
            [[self allTasks] removeObject:task];
            if ([error code] < 0 && IDCM_cachePost) {// 获取缓存
                id response = [IDCMNetWorking cahceResponseWithURL:absolute
                                                       parameters:params];
                
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success withTask:nil];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                } else {
                    [self handleCallbackWithError:error andWith:task fail:fail url:url];
                    
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
            } else {
                [self handleCallbackWithError:error andWith:task fail:fail url:url];
                
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
            }
        }];
    }
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (IDCMURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(IDCMUploadProgress)progress
                                 success:(IDCMResponseSuccess)success
                                    fail:(IDCMResponseFail)fail {
    if ([NSURL URLWithString:uploadingFile] == nil) {
        DDLogDebug(@"uploadingFile无效，无法生成URL。请检查待上传文件是否存在");
        return nil;
    }
    
    NSURL *uploadURL = nil;
    if ([self baseUrl] == nil) {
        uploadURL = [NSURL URLWithString:url];
    } else {
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
    }
    
    if (uploadURL == nil) {
        DDLogDebug(@"URLString无效，无法生成URL。可能是URL中有中文或特殊字符");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    IDCMURLSessionTask *session = nil;
    
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        [self successResponse:responseObject callback:success withTask:nil];
        
        if (error) {
            [self handleCallbackWithError:error andWith:nil fail:fail url:url];
            
            if ([self isDebug]) {
                [self logWithFailError:error url:response.URL.absoluteString params:nil];
            }
        } else {
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:response.URL.absoluteString
                                      params:nil];
            }
        }
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (IDCMURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(id)parameters
                              progress:(IDCMUploadProgress)progress
                               success:(IDCMResponseSuccess)success
                                  fail:(IDCMResponseFail)fail {
    if (url) {
        
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            
        } else if ([url hasPrefix:serverSign]) {
            
            url = [url componentsSeparatedByString:serverSign].lastObject;
        } else {
            
            NSString *serverAddress = [IDCMServerConfig getIDCMServerAddr];
            url = [serverAddress stringByAppendingString:url];
        }
        
    }else{
        return nil;
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    AFHTTPSessionManager *manager = [self manager];
    IDCMURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.png", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success withTask:task];
        
        if ([self isDebug]) {
            [self logWithSuccessResponse:responseObject
                                     url:absolute
                                  params:parameters];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        
        [self handleCallbackWithError:error andWith:task fail:fail url:url];
        
        if ([self isDebug]) {
            [self logWithFailError:error url:absolute params:nil];
        }
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (IDCMURLSessionTask *)uploadWithImages:(NSArray *)images
                                     url:(NSString *)url
                                filename:(NSString *)filename
                                    name:(NSString *)name
                                mimeType:(NSString *)mimeType
                              parameters:(NSDictionary *)parameters
                                progress:(IDCMUploadProgress)progress
                                 success:(IDCMResponseSuccess)success
                                    fail:(IDCMResponseFail)fail {
    if (url) {
        
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            
        } else if ([url hasPrefix:serverSign]) {
            
            url = [url componentsSeparatedByString:serverSign].lastObject;
        } else {
            
            NSString *serverAddress = [IDCMServerConfig getIDCMServerAddr];
            url = [serverAddress stringByAppendingString:url];
        }
        
    }else{
        return nil;
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    AFHTTPSessionManager *manager = [self manager];
    manager.requestSerializer.timeoutInterval = 60.0f;
    
    IDCMURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSInteger i = 0; i<images.count; i++) {
            UIImage * image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            NSString *imageFileName = filename;
            if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
            }
            
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%@%ld",name,i] fileName:imageFileName mimeType:mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success withTask:task];
        [IDCMNetWorking dismissSuccessHUD];
        if ([self isDebug]) {
            [self logWithSuccessResponse:responseObject
                                     url:absolute
                                  params:parameters];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        [IDCMNetWorking dismissErrorHUD];
        
        [self handleCallbackWithError:error andWith:task fail:fail url:url];
        
        if ([self isDebug]) {
            [self logWithFailError:error url:absolute params:nil];
        }
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (IDCMURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(IDCMDownloadProgress)progressBlock
                               success:(IDCMResponseSuccess)success
                               failure:(IDCMResponseFail)failure {
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            DDLogDebug(@"URLString无效，无法生成URL。可能是URL中有中文");
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            DDLogDebug(@"URLString无效，无法生成URL。可能是URL中有中文");
            return nil;
        }
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self manager];
    
    IDCMURLSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        if (error == nil) {
            if (success) {
                success(filePath.absoluteString,nil);
            }
            
            if ([self isDebug]) {
                DDLogDebug(@"Download success for url %@",
                      [self absoluteUrlWithPath:url]);
            }
        } else {
            [self handleCallbackWithError:error andWith:nil fail:failure url:url];
            
            if ([self isDebug]) {
                DDLogDebug(@"Download fail for url %@, reason : %@",
                      [self absoluteUrlWithPath:url],
                      [error description]);
            }
        }
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark - Private
+ (AFHTTPSessionManager *)manager {
    
    
    // 只要不切换baseurl，就一直使用同一个session manager
    if (IDCM_sharedManager == nil || IDCM_isBaseURLChanged) {
        
        
        IDCMAppDotNetAPIClient *manager = nil;;
        
        
        if ([self baseUrl] != nil) {
            manager = [[IDCMAppDotNetAPIClient sharedClient] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
        } else {
            manager = [IDCMAppDotNetAPIClient sharedClient];
        }
        
        switch (IDCM_requestType) {
            case kIDCMRequestTypeJSON: {
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                break;
            }
            case kIDCMRequestTypePlainText: {
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                break;
            }
            default: {
                break;
            }
        }
        
        switch (IDCM_responseType) {
            case kIDCMResponseTypeJSON: {
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                break;
            }
            case kIDCMResponseTypeXML: {
                manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                break;
            }
            case kIDCMResponseTypeData: {
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
            }
            default: {
                break;
            }
        }
        
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        
        for (NSString *key in IDCM_httpHeaders.allKeys) {
            
            if ([IDCM_httpHeaders[key] isKindOfClass:[NSString class]] && [IDCM_httpHeaders[key] isNotBlank]) {
                
                if (IDCM_httpHeaders[key] != nil) {
                    [manager.requestSerializer setValue:IDCM_httpHeaders[key] forHTTPHeaderField:key];
                }
                
            }else{
                [manager.requestSerializer setValue:nil forHTTPHeaderField:key];
            }
            
        }
        
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                  @"text/html",
                                                                                  @"text/json",
                                                                                  @"text/plain",
                                                                                  @"text/javascript",
                                                                                  @"text/xml",
                                                                                  @"image/*",
                                                                                  @"application/x-www-form-urlencoded",
                                                                                  @"multipart/form-data"
                                                                                  ]];
        
        manager.requestSerializer.timeoutInterval = IDCM_timeout;
        
        // 设置允许同时最大并发数量，过大容易出问题
        manager.operationQueue.maxConcurrentOperationCount = 5;
        
        IDCM_sharedManager = manager;
    }
    
    
//    if (IDCM_shoulObtainLocalWhenUnconnected && (IDCM_cacheGet || IDCM_cachePost)) {
//        [self detectNetwork];
//    }
    
    return IDCM_sharedManager;
}

+ (void)detectNetwork{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){
            IDCM_networkStatus = kIDCMNetworkStatusNotReachable;
        }else if (status == AFNetworkReachabilityStatusUnknown){
            IDCM_networkStatus = kIDCMNetworkStatusUnknown;
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            IDCM_networkStatus = kIDCMNetworkStatusReachableViaWWAN;
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            IDCM_networkStatus = kIDCMNetworkStatusReachableViaWiFi;
        }
    }];
}

+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    DDLogDebug(@"\n");
    DDLogDebug(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",
          [self generateGETAbsoluteURL:url params:params],
          params,
          [self tryToParseData:response]);
}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    NSString *format = @" params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    
    DDLogDebug(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        DDLogDebug(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params);
    } else {
        DDLogDebug(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params,
              [error localizedDescription]);
    }
}

// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(NSDictionary *)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}


+ (NSString *)encodeUrl:(NSString *)url {
    return [self IDCM_URLEncode:url];
}
// 解析json数据
+ (id)tryToParseData:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

+ (void)successResponse:(id)responseData callback:(IDCMResponseSuccess)success withTask:(NSURLSessionDataTask *)task{
    if (success) {
        
        NSDictionary *dataDic = [self tryToParseData:responseData];
        success(dataDic,task);
    }
}

+ (NSString *)IDCM_URLEncode:(NSString *)url {
    if ([url respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        
        static NSString * const kAFCharacterIDCMeneralDelimitersToEncode = @":#[]@";
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharacterIDCMeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < url.length) {
            NSUInteger length = MIN(url.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            range = [url rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [url substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)url,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
    id cacheData = nil;
    
    if (url) {
        
        NSString *directoryPath = cachePath();
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [absoluteURL md5String];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            DDLogDebug(@"Read data from cache for url: %@\n", url);
        }
    }
    
    return cacheData;
}

+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                DDLogDebug(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
        NSString *key = [absoluteURL md5String];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                DDLogDebug(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                DDLogDebug(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}

+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if ([self baseUrl] == nil || [[self baseUrl] length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([[self baseUrl] hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString * mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",
                               [self baseUrl], mutablePath];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }
        }else {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",
                               [self baseUrl], path];
            }
        }
    }
    
    
    return absoluteUrl;
}

+ (void)handleCallbackWithError:(NSError *)error andWith:(NSURLSessionDataTask *)task fail:(IDCMResponseFail)fail url:(NSString *)urlString{
    if ([error code] == NSURLErrorCancelled) {
        if (IDCM_shouldCallbackOnCancelRequest) {
            if (fail) {
                fail(error,task);
            }
        }
    } else {
        if (![urlString containsString:CheckServerMaintenance_URL]) {
            if (IDCM_APPDelegate.networkStatus != NotReachable) {
                UIViewController *vc = [IDCMUtilsMethod currentViewController];
                if ([vc isKindOfClass:[IDCMMaintenanceViewController class]]) {
                    return;
                }
                [self requestMaintenance];
            }
        }
        if (fail) {
            fail(error,task);
        }
    }
}

#pragma mark - 维护页面
+ (void)requestMaintenance{
    
    // 区分客户端类型   1:企业分发   3:App Store
    NSString *clientName = [[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey] ? @"1" : @"3";
    NSString *url = [NSString stringWithFormat:@"%@?client=%@&lang=%@",CheckServerMaintenance_URL,clientName,[IDCMUtilsMethod getServiceLanguage]];
    [[[RACSignal signalGetNotAuthHUD:url serverName:MaintenanceServerName params:nil handleSignal:nil] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]] && [response[@"data"][@"isMaintenance"] isKindOfClass:[NSNumber class]]) {
             if ([response[@"data"][@"isMaintenance"] integerValue] == 1) {
                 UIViewController *vc = [IDCMUtilsMethod currentViewController];
                 if ([vc isKindOfClass:[IDCMMaintenanceViewController class]]) {
                     return;
                 }
                 NSString *url = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"url"]];
                 [IDCM_APPDelegate setMaintenanceController:url];
             }
         }
     }];
}

#pragma mark - HUD
+ (void)showHUD:(NSString *)showMessge{
    dispatch_main_async_safe(^{
        [IDCMHUD show];
    });
}
+ (void)dismissSuccessHUD{
    dispatch_main_async_safe(^{
        [IDCMHUD dismiss];
    });
}
+ (void)dismissErrorHUD{
    dispatch_main_async_safe(^{
        [IDCMHUD dismiss];
    });
}

@end
