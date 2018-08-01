//
//  IDCMLocalCurrencyViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMLocalCurrencyViewModel.h"


@implementation IDCMLocalCurrencyViewModel

- (void)initialize
{
    [super initialize];
    
    self.setLocalCurrencyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSDictionary *para = @{
                                   @"content":input,
                                   @"verifyCode":@"",
                                   @"type":@(4)
                                   };
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:ModifyUserInfo_URL params:para success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                
                if ([status isEqualToString:@"100"]) {
                    [subscriber sendError:nil];
                }else{
                    [subscriber sendNext:response];
                }
                
                [subscriber sendCompleted];
                
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }] retry:1];
    }];
}

- (RACSignal *)executeRequestDataSignal:(id)input
{
    
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:GetLoaclCurrency_URL params:nil success:^(NSDictionary *response) {
            
            NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
            
            if ([status isEqualToString:@"100"]) {
                [subscriber sendError:nil];
            }else{
                [subscriber sendNext:response];
            }
            
            [subscriber sendCompleted];
            
        } fail:^(NSError *error, NSURLSessionDataTask *task) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
        
    }] retry:1];
}
@end
