//
//  IDCMRequestList.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCMNetWorking.h"

/*!
 *
 *  请求成功的回调
 *
 *  @param response 服务端返回的数据类型，通常是字典
 */
typedef void(^IDCMDataSuccess)(NSDictionary *response);

/*!
 *
 *  网络响应失败时的回调
 *
 *  @param error 错误信息
 */
typedef void(^IDCMDataFail)(NSError *error,NSURLSessionDataTask *task);

@interface IDCMRequestList : NSObject
/**
 不需要Ticket的post请求(需要hud)
 
 @param url 请求地址
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestNotAuth:(NSString *)url
                                params:(id)params
                               success:(IDCMDataSuccess)success
                                  fail:(IDCMDataFail)fail;
/**
 不需要Ticket的post请求(不需要hud)
 
 @param url 请求地址
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestPostNoHUDAuth:(NSString *)url
                                      params:(id)params
                                     success:(IDCMDataSuccess)success
                                        fail:(IDCMDataFail)fail;
/**
 不需要Ticket的get请求(不需要hud)
 
 @param url 请求地址
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestGetNotAuth:(NSString *)url
                                   params:(id)params
                                  success:(IDCMDataSuccess)success
                                     fail:(IDCMDataFail)fail;
/**
 不需要Ticket的get请求(需要hud)
 
 @param url 请求地址
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestGetNotAuthHUD:(NSString *)url
                                   params:(id)params
                                  success:(IDCMDataSuccess)success
                                     fail:(IDCMDataFail)fail;

/**
 需要Ticket的post请求(需要hud)
 
 @param url 请求地址
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestAuth:(NSString *)url
                             params:(id)params
                            success:(IDCMDataSuccess)success
                               fail:(IDCMDataFail)fail;
/**
 需要Ticket的post请求(不需要hud)
 
 @param url 请求地址
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestPostAuthNoHUD:(NSString *)url
                             params:(id)params
                            success:(IDCMDataSuccess)success
                               fail:(IDCMDataFail)fail;

/**
 需要Ticket的get请求(需要hud)
 
 @param url 请求地址
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestGetAuth:(NSString *)url
                                params:(id)params
                               success:(IDCMDataSuccess)success
                                  fail:(IDCMDataFail)fail;

/**
 需要Ticket的get请求(不需要hud)
 
 @param url 请求地址
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestGetNoHUDAuth:(NSString *)url
                                     params:(id)params
                                    success:(IDCMDataSuccess)success
                                   fail:(IDCMDataFail)fail;


/**
 需要Ticket的get请求(需要hud，内部不判断status)
 
 @param url 请求地址
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestGetAuthNotStatus:(NSString *)url
                                         params:(id)params
                                        success:(IDCMDataSuccess)success
                                           fail:(IDCMDataFail)fail;
@end
