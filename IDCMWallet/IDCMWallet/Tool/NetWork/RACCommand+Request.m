//
//  RACCommand+Request.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "RACCommand+Request.h"
#import "RACSignal+Request.h"



// command 订阅函数
requestSignalBlock requestCommand(id input, requestCommandBlock handleCommand) {
    return !handleCommand  ? nil :
    ^(id response, id<RACSubscriber> subscriber) {
        handleCommand(input, response, subscriber);
    };
}

// 处理参数函数
id requestParams(id input, requestParamsBlock params) {
   return params ? params(input) : input;
}

// 处理Url函数
id requestUrl(id input, requestUrlBlock url) {
    return url ? url(input) : @"";
}



@implementation RACCommand (Request)

+ (instancetype)commandNotAuth:(NSString *)url
                    serverName:(NSString *)serverName
                        params:(requestParamsBlock)params
                 handleCommand:(requestCommandBlock)handleCommand{
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {;
        return [RACSignal signalNotAuth:url
                             serverName:serverName
                                 params:requestParams(input, params)
                           handleSignal:requestCommand(input, handleCommand)];
    }];
}
+ (instancetype)commandNotAuthWithUrl:(requestUrlBlock)url
                           serverName:(NSString *)serverName
                               params:(requestParamsBlock)params
                        handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {;
        return [RACSignal signalNotAuth:requestUrl(input, url)
                             serverName:serverName
                                 params:requestParams(input, params)
                           handleSignal:requestCommand(input, handleCommand)];
    }];
}




+ (instancetype)commandPostNoHUDAuth:(NSString *)url
                          serverName:(NSString *)serverName
                              params:(requestParamsBlock)params
                       handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalPostNoHUDAuth:url
                                   serverName:serverName
                                       params:requestParams(input, params)
                                 handleSignal:requestCommand(input, handleCommand)];
    }];
}
+ (instancetype)commandPostNoHUDAuthWithUrl:(requestUrlBlock)url
                                 serverName:(NSString *)serverName
                                     params:(requestParamsBlock)params
                              handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalPostNoHUDAuth:requestUrl(input, url)
                                   serverName:serverName
                                       params:requestParams(input, params)
                                 handleSignal:requestCommand(input, handleCommand)];
    }];
}




+ (instancetype)commandGetNotAuth:(NSString *)url
                       serverName:(NSString *)serverName
                           params:(requestParamsBlock)params
                    handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalGetNotAuth:url
                                serverName:serverName
                                    params:requestParams(input, params)
                              handleSignal:requestCommand(input, handleCommand)];
    }];
}
+ (instancetype)commandGetNotAuthWithUrl:(requestUrlBlock)url
                              serverName:(NSString *)serverName
                                  params:(requestParamsBlock)params
                           handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalGetNotAuth:requestUrl(input, url)
                                serverName:serverName
                                    params:requestParams(input, params)
                              handleSignal:requestCommand(input, handleCommand)];
    }];
}




+ (instancetype)commandGetNotAuthHUD:(NSString *)url
                          serverName:(NSString *)serverName
                              params:(requestParamsBlock)params
                       handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalGetNotAuthHUD:url
                                   serverName:serverName
                                       params:requestParams(input, params)
                                 handleSignal:requestCommand(input, handleCommand)];
    }];
}
+ (instancetype)commandGetNotAuthHUDWithUrl:(requestUrlBlock)url
                                 serverName:(NSString *)serverName
                                     params:(requestParamsBlock)params
                              handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalGetNotAuthHUD:requestUrl(input, url)
                                   serverName:serverName
                                       params:requestParams(input, params)
                                 handleSignal:requestCommand(input, handleCommand)];
    }];
}





+ (instancetype)commandAuth:(NSString *)url
                 serverName:(NSString *)serverName
                     params:(requestParamsBlock)params
              handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalAuth:url
                          serverName:serverName
                              params:requestParams(input, params)
                        handleSignal:requestCommand(input, handleCommand)];
    }];
}
+ (instancetype)commandAuthWithUrl:(requestUrlBlock)url
                        serverName:(NSString *)serverName
                            params:(requestParamsBlock)params
                     handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalAuth:requestUrl(input, url)
                          serverName:serverName
                              params:requestParams(input, params)
                        handleSignal:requestCommand(input, handleCommand)];
    }];
}





+ (instancetype)commandPostAuthNoHUD:(NSString *)url
                          serverName:(NSString *)serverName
                              params:(requestParamsBlock)params
                       handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalPostAuthNoHUD:url
                                   serverName:serverName
                                       params:requestParams(input, params)
                                 handleSignal:requestCommand(input, handleCommand)];
    }];
}
+ (instancetype)commandPostAuthNoHUDWithUrl:(requestUrlBlock)url
                                 serverName:(NSString *)serverName
                                     params:(requestParamsBlock)params
                              handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalPostAuthNoHUD:requestUrl(input, url)
                                   serverName:serverName
                                       params:requestParams(input, params)
                                 handleSignal:requestCommand(input, handleCommand)];
    }];
}





+ (instancetype)commandGetAuth:(NSString *)url
                    serverName:(NSString *)serverName
                        params:(requestParamsBlock)params
                 handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalGetAuth:url
                             serverName:serverName
                                 params:requestParams(input, params)
                           handleSignal:requestCommand(input, handleCommand)];
    }];
}
+ (instancetype)commandGetAuthWithUrl:(requestUrlBlock)url
                           serverName:(NSString *)serverName
                               params:(requestParamsBlock)params
                        handleCommand:(requestCommandBlock)handleCommand {
   
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalGetAuth:requestUrl(input, url)
                             serverName:serverName
                                 params:requestParams(input, params)
                           handleSignal:requestCommand(input, handleCommand)];
    }];
}




+ (instancetype)commandGetNoHUDAuth:(NSString *)url
                         serverName:(NSString *)serverName
                             params:(requestParamsBlock)params
                      handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalGetNoHUDAuth:url
                                  serverName:serverName
                                      params:requestParams(input, params)
                                handleSignal:requestCommand(input, handleCommand)];
    }];
}
+ (instancetype)commandGetNoHUDAuthWithUrl:(requestUrlBlock)url
                                serverName:(NSString *)serverName
                                    params:(requestParamsBlock)params
                             handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalGetNoHUDAuth:requestUrl(input, url)
                                  serverName:serverName
                                      params:requestParams(input, params)
                                handleSignal:requestCommand(input, handleCommand)];
    }];
}




+ (instancetype)commandGetAuthNotStatus:(NSString *)url
                             serverName:(NSString *)serverName
                                 params:(requestParamsBlock)params
                          handleCommand:(requestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalGetAuthNotStatus:url
                                      serverName:serverName
                                          params:requestParams(input, params)
                                    handleSignal:requestCommand(input, handleCommand)];
    }];
}
+ (instancetype)commandGetAuthNotStatusWithUrl:(requestUrlBlock)url
                                    serverName:(NSString *)serverName
                                        params:(requestParamsBlock)params
                                 handleCommand:(requestCommandBlock)handleCommand {
 
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal signalGetAuthNotStatus:requestUrl(input, url)
                                      serverName:serverName
                                          params:requestParams(input, params)
                                    handleSignal:requestCommand(input, handleCommand)];
    }];
}
@end



















