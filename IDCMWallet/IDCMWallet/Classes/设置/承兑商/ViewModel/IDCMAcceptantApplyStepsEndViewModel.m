//
//  IDCMAcceptantApplyStepsEndViewModel.m
//  IDCMWallet
//
//  Created by wangpu on 2018/5/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyStepsEndViewModel.h"

@implementation IDCMAcceptantApplyStepsEndViewModel


- (void)initialize
{
    [super initialize];

    //承兑买币信息
    _OTCGetExchangeBuyListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //请求余额
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantGetExchangeBuyList_URL params:nil success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"]) {
                    [subscriber sendNext:response];
                }else{
                    [IDCMShowMessageView showMessageWithCode:status];
                }
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
    //承兑卖币信息
    _OTCGetExchangeSellListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //请求余额
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantGetExchangeSellList_URL params:nil success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"]) {
                    [subscriber sendNext:response];
                }else{
                    [IDCMShowMessageView showMessageWithCode:status];
                }
                [subscriber sendCompleted];
                
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
    
    //承兑买币/卖币 移除 币种和限额
    _OTCExchangeCoinRemoveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * input) {

        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantExchangeCoinRemove_URL params:input success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"]) {
                    [subscriber sendNext:response];
                }else{
                    [IDCMShowMessageView showMessageWithCode:status];
                }
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
   //承兑买币  获取 法币币种和支付方式
    _OTCGetExchangePayModeListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * input) {
        
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantGetExchangePayModeList_URL params:nil success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if (status.length>0) {
                    [subscriber sendNext:response];
                }else{
                    [subscriber sendError:nil];
                }
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
   //承兑买币 移除 法币币种和支付方式
    _OTCExchangePayModeRemoveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * input) {

        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantExchangePayModeRemove_URL params:input success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"]) {
                    [subscriber sendNext:response];
                }else{
                    [IDCMShowMessageView showMessageWithCode:status];
                }
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
    
    //承兑买币 增加 法币币种和支付方式
    _OTCExchangePayModeAddCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * input) {
        
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantExchangePayModeAdd_URL params:input success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"]) {
                    [subscriber sendNext:response];
                }else{
                    if ([status isEqualToString:@"622"]) {
                        
                        [IDCMViewTools ToastView:[UIApplication sharedApplication].delegate.window info:[NSString stringWithFormat:@"%@",SWLocaloziString(@"3.0_AcceptantReAddPayType")] position:QMUIToastViewPositionBottom];
                    }else{
                        
                        [IDCMShowMessageView showMessageWithCode:status];
                    }
                    
                }
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
    
  //移除 币种及资金量
    _OTCExchangeLocalCurrencyRemoveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * input) {
        
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantExchangeLocalCurrencyRemove_URL params:input success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"]) {
                    [subscriber sendNext:response];
                }else{
                    [IDCMShowMessageView showMessageWithCode:status];
                }
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
    //设置当前步骤
    _OTCSetCurrentStepCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber * input) {
        
        NSDictionary * params = @{@"step":input};
        
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantSetCurrentStep_URL params:params success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"]) {
                    [subscriber sendNext:response];
                }else{
                    [IDCMShowMessageView showMessageWithCode:status];
                }
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
    
}
@end
