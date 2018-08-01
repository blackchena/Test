//
//  IDCMTradingDeatailViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/27.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMTradingDeatailViewModel.h"


@implementation IDCMTradingDeatailViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.dealModel = params[@"dealModel"];
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    self.editeCommand =  [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:ModifyTradeDescription_URL params:input success:^(NSDictionary *response) {
                
                
                NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
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
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSDictionary *param = @{@"tradeType":self.dealModel.trade_type,
                                @"currency":[self.dealModel.currency lowercaseString],
                                @"txid":self.dealModel.txhash
                                };
        IDCMURLSessionTask *task = [IDCMRequestList requestPostAuthNoHUD:GetTxByTxId_URL params:param success:^(NSDictionary *response) {
            
            NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
            if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [subscriber sendNext:response];
            }else if ([status isEqualToString:@"100"]){
                [subscriber sendError:nil];
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
