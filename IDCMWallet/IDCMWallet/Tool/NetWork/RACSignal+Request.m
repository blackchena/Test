//
//  RACSignal+Request.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "RACSignal+Request.h"
#import "IDCMRequestList+Server.h"


// 请求成功订阅函数
typedef void (^successBlock)(NSDictionary *response);
successBlock subscribSuccesss(id<RACSubscriber> subscriber,  requestSignalBlock signalBlock) {
    
    return ^(NSDictionary *response) {
        signalBlock ?
        signalBlock(response, subscriber) :
        ({
            NSString *status= [NSString stringWithFormat:@"%@",kStatus];
            if ([status isEqualToString:@"100"]) {
                [subscriber sendError:nil];
            }else{
                [subscriber sendNext:response];
                [subscriber sendCompleted];
            }
        });
    };
}

// 请求失败订阅函数
typedef void (^failBlock)(NSError *error, NSURLSessionDataTask *task);
failBlock subscribfail(id<RACSubscriber>  _Nonnull subscriber) {
    
    return ^(NSError *error, NSURLSessionDataTask *task) {
        [subscriber sendError:error];
    };
}

// disposableBlock 函数
typedef void(^disposableBlock)(void);
disposableBlock taskDisposableBlock(IDCMURLSessionTask *task) {
    
    return ^{
        if (task.state != NSURLSessionTaskStateCanceling &&
            task.state != NSURLSessionTaskStateCompleted) {
            [task cancel];
        }
    };
}



@implementation RACSignal (Request)

+ (instancetype)signalNotAuth:(NSString *)url
                   serverName:(NSString *)serverName
                       params:(id)params
                 handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([IDCMRequestList requestNotAuth:url
                                      serverName:serverName
                                          params:params
                                         success:subscribSuccesss(subscriber, handleSignal)
                                            fail:subscribfail(subscriber)])];
    }];
}


+ (instancetype)signalPostNoHUDAuth:(NSString *)url
                         serverName:(NSString *)serverName
                             params:(id)params
                       handleSignal:(requestSignalBlock)handleSignal{
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([IDCMRequestList requestPostNoHUDAuth:url
                                            serverName:serverName
                                                params:params
                                               success:subscribSuccesss(subscriber, handleSignal)
                                                  fail:subscribfail(subscriber)])];
    }];
}


+ (instancetype)signalGetNotAuth:(NSString *)url
                      serverName:(NSString *)serverName
                          params:(id)params
                    handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([IDCMRequestList requestGetNotAuth:url
                                         serverName:serverName
                                             params:params
                                            success:subscribSuccesss(subscriber, handleSignal)
                                               fail:subscribfail(subscriber)])];
    }];
}


+ (instancetype)signalGetNotAuthHUD:(NSString *)url
                         serverName:(NSString *)serverName
                             params:(id)params
                       handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([IDCMRequestList requestGetNotAuthHUD:url
                                            serverName:serverName
                                                params:params
                                               success:subscribSuccesss(subscriber, handleSignal)
                                                  fail:subscribfail(subscriber)])];
    }];
}


+ (instancetype)signalAuth:(NSString *)url
                serverName:(NSString *)serverName
                    params:(id)params
              handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([IDCMRequestList requestAuth:url
                                   serverName:serverName
                                       params:params
                                      success:subscribSuccesss(subscriber, handleSignal)
                                         fail:subscribfail(subscriber)])];
    }];
}


+ (instancetype)signalPostAuthNoHUD:(NSString *)url
                         serverName:(NSString *)serverName
                             params:(id)params
                       handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([IDCMRequestList requestPostAuthNoHUD:url
                                            serverName:serverName
                                                params:params
                                               success:subscribSuccesss(subscriber, handleSignal)
                                                  fail:subscribfail(subscriber)])];
    }];
}


+ (instancetype)signalGetAuth:(NSString *)url
                   serverName:(NSString *)serverName
                       params:(id)params
                 handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([IDCMRequestList requestGetAuth:url
                                      serverName:serverName
                                          params:params
                                         success:subscribSuccesss(subscriber, handleSignal)
                                            fail:subscribfail(subscriber)])];
    }];
}


+ (instancetype)signalGetNoHUDAuth:(NSString *)url
                        serverName:(NSString *)serverName
                            params:(id)params
                      handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([IDCMRequestList requestGetNoHUDAuth:url
                                           serverName:serverName
                                               params:params
                                              success:subscribSuccesss(subscriber, handleSignal)
                                                 fail:subscribfail(subscriber)])];
    }];
}


+ (instancetype)signalGetAuthNotStatus:(NSString *)url
                            serverName:(NSString *)serverName
                                params:(id)params
                          handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([IDCMRequestList requestGetAuthNotStatus:url
                                               serverName:serverName
                                                   params:params
                                                  success:subscribSuccesss(subscriber, handleSignal)
                                                     fail:subscribfail(subscriber)])];
    }];
}



@end









