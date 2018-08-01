//
//  IDCMRequestList+Server.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMRequestList+Server.h"

@implementation IDCMRequestList (Server)

+ (IDCMURLSessionTask *)requestNotAuth:(NSString *)url
                           serverName:(NSString *)serverName
                                params:(id)params
                               success:(IDCMDataSuccess)success
                                  fail:(IDCMDataFail)fail {
    
    return [self requestNotAuth:[self handelServiceUrl:url serverName:serverName]
                        params:params
                       success:success
                          fail:fail];
}


+ (IDCMURLSessionTask *)requestPostNoHUDAuth:(NSString *)url
                                 serverName:(NSString *)serverName
                                      params:(id)params
                                     success:(IDCMDataSuccess)success
                                        fail:(IDCMDataFail)fail {
    
    return [self requestPostNoHUDAuth:[self handelServiceUrl:url serverName:serverName]
                               params:params
                              success:success
                                 fail:fail];
}


+ (IDCMURLSessionTask *)requestGetNotAuth:(NSString *)url
                              serverName:(NSString *)serverName
                                   params:(id)params
                                  success:(IDCMDataSuccess)success
                                     fail:(IDCMDataFail)fail {
    
    return [self requestGetNotAuth:[self handelServiceUrl:url serverName:serverName]
                            params:params
                           success:success
                              fail:fail];
}


+ (IDCMURLSessionTask *)requestGetNotAuthHUD:(NSString *)url
                                 serverName:(NSString *)serverName
                                      params:(id)params
                                     success:(IDCMDataSuccess)success
                                        fail:(IDCMDataFail)fail {
    
    return [self requestGetNotAuthHUD:[self handelServiceUrl:url serverName:serverName]
                               params:params
                              success:success
                                 fail:fail];
}


+ (IDCMURLSessionTask *)requestAuth:(NSString *)url
                        serverName:(NSString *)serverName
                             params:(id)params
                            success:(IDCMDataSuccess)success
                               fail:(IDCMDataFail)fail {
    
    return [self requestAuth:[self handelServiceUrl:url serverName:serverName]
                      params:params
                     success:success
                        fail:fail];
}


+ (IDCMURLSessionTask *)requestPostAuthNoHUD:(NSString *)url
                                 serverName:(NSString *)serverName
                                      params:(id)params
                                     success:(IDCMDataSuccess)success
                                        fail:(IDCMDataFail)fail {
    
    return [self requestPostAuthNoHUD:[self handelServiceUrl:url serverName:serverName]
                               params:params
                              success:success
                                 fail:fail];
}


+ (IDCMURLSessionTask *)requestGetAuth:(NSString *)url
                           serverName:(NSString *)serverName
                                params:(id)params
                               success:(IDCMDataSuccess)success
                                  fail:(IDCMDataFail)fail {
    
    return [self requestGetAuth:[self handelServiceUrl:url serverName:serverName]
                         params:params
                        success:success
                           fail:fail];
}


+ (IDCMURLSessionTask *)requestGetNoHUDAuth:(NSString *)url
                                serverName:(NSString *)serverName
                                     params:(id)params
                                    success:(IDCMDataSuccess)success
                                       fail:(IDCMDataFail)fail {
    
   return  [self requestGetNoHUDAuth:[self handelServiceUrl:url serverName:serverName]
                              params:params
                             success:success
                                fail:fail];
}


+ (IDCMURLSessionTask *)requestGetAuthNotStatus:(NSString *)url
                                    serverName:(NSString *)serverName
                                         params:(id)params
                                        success:(IDCMDataSuccess)success
                                           fail:(IDCMDataFail)fail {
    
    return [self requestGetAuthNotStatus:[self handelServiceUrl:url serverName:serverName]
                                  params:params
                                 success:success
                                    fail:fail];
}


+ (NSString *)handelServiceUrl:(NSString *)url
                   serverName:(NSString *)serverName {
    
    if ((serverName.length && ![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"])) {
        NSString *serverAddress = [IDCMServerConfig getIDCMServerAddrWithServerName:serverName];
        NSString *newUrl = [serverAddress stringByAppendingString:url];
        return [NSString stringWithFormat:@"%@%@", serverSign, newUrl];
    }
    return url;
}


@end








