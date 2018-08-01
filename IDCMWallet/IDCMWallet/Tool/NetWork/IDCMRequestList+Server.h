//
//  IDCMRequestList+Server.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMRequestList.h"
#import "IDCMNetWorking.h"


@interface IDCMRequestList (Server)



/**
 不需要Ticket的post请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestNotAuth:(NSString *)url
                            serverName:(NSString *)serverName
                                params:(id)params
                               success:(IDCMDataSuccess)success
                                  fail:(IDCMDataFail)fail;




/**
 不需要Ticket的post请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestPostNoHUDAuth:(NSString *)url
                                  serverName:(NSString *)serverName
                                      params:(id)params
                                     success:(IDCMDataSuccess)success
                                        fail:(IDCMDataFail)fail;




/**
 不需要Ticket的get请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestGetNotAuth:(NSString *)url
                               serverName:(NSString *)serverName
                                   params:(id)params
                                  success:(IDCMDataSuccess)success
                                     fail:(IDCMDataFail)fail;





/**
 不需要Ticket的get请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestGetNotAuthHUD:(NSString *)url
                                  serverName:(NSString *)serverName
                                      params:(id)params
                                     success:(IDCMDataSuccess)success
                                        fail:(IDCMDataFail)fail;




/**
 需要Ticket的post请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestAuth:(NSString *)url
                         serverName:(NSString *)serverName
                             params:(id)params
                            success:(IDCMDataSuccess)success
                               fail:(IDCMDataFail)fail;





/**
 需要Ticket的post请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestPostAuthNoHUD:(NSString *)url
                                  serverName:(NSString *)serverName
                                      params:(id)params
                                     success:(IDCMDataSuccess)success
                                        fail:(IDCMDataFail)fail;





/**
 需要Ticket的get请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestGetAuth:(NSString *)url
                            serverName:(NSString *)serverName
                                params:(id)params
                               success:(IDCMDataSuccess)success
                                  fail:(IDCMDataFail)fail;






/**
 需要Ticket的get请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestGetNoHUDAuth:(NSString *)url
                                serverName:(NSString *)serverName
                                     params:(id)params
                                    success:(IDCMDataSuccess)success
                                       fail:(IDCMDataFail)fail;






/**
 需要Ticket的get请求(需要hud，内部不判断status)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (IDCMURLSessionTask *)requestGetAuthNotStatus:(NSString *)url
                                     serverName:(NSString *)serverName
                                         params:(id)params
                                        success:(IDCMDataSuccess)success
                                           fail:(IDCMDataFail)fail;




@end










