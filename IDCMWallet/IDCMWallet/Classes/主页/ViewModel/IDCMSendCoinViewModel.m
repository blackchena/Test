//
//  IDCMSendCoinViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMSendCoinViewModel.h"
#import "IDCMCurrencyMarketModel.h"

@implementation IDCMSendCoinViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.marketModel = params[@"marketModel"];
        if ([self.marketModel.currencyLayoutType integerValue] == 0) { // 正常
            
            self.currencyLayoutType = kIDCMCurrencyLayoutTypeNomal;
        }else if([self.marketModel.currencyLayoutType integerValue] == 1){ // 隐藏滑条
            self.currencyLayoutType = kIDCMCurrencyLayoutTypeHidenSlider;
        }else{ // 隐藏矿工费
            self.currencyLayoutType = kIDCMCurrencyLayoutTypeHidenFee;
        }
   
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    @weakify(self);
    self.validAddressSignal = [[RACSignal
                                    combineLatest:@[ RACObserve(self, reciveAddress), RACObserve(self, amount)]
                                    reduce:^(NSString *address, NSString *blance) {
                                        return @(address.length > 0 && blance.length > 0);
                                    }]
                                   distinctUntilChanged];
    
    self.varifyAddressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            NSDictionary *param = @{
                                    @"address":self.reciveAddress,
                                    @"currency":[self.marketModel.currency lowercaseString]
                                    };
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:ValidAddress_URL params:param success:^(NSDictionary *response) {
                
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
    
    self.validSendFormCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            NSDictionary *param = @{
                                    @"toAddress":self.reciveAddress,
                                    @"amount":self.amount,
                                    @"fee":[IDCMUtilsMethod getStringFrom:self.fee],
                                    @"currency":[self.marketModel.currency lowercaseString]
                                    };
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:ValidSendFrom_URL params:param success:^(NSDictionary *response) {
                
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
    
    self.sendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
            NSDictionary *param = @{
                                    @"toAddress":self.reciveAddress,
                                    @"amount":[NSDecimalNumber decimalNumberWithString:self.amount],
                                    @"comment":self.comment,
                                    @"fee":[IDCMUtilsMethod getStringFrom:self.fee],
                                    @"currency":[self.marketModel.currency lowercaseString],
                                    @"payPassword":self.payPassword,
                                    @"device_id":model.device_id,
                                    @"newVersion":@"true"
                                    };
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:SendFrom_URL params:param success:^(NSDictionary *response) {
                
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
            
        }];
    }];
    
    self.sendFaceIDCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
            NSDictionary *param = @{
                                    @"toAddress":self.reciveAddress,
                                    @"amount":[NSDecimalNumber decimalNumberWithString:self.amount],
                                    @"comment":self.comment,
                                    @"fee":[IDCMUtilsMethod getStringFrom:self.fee],
                                    @"currency":[self.marketModel.currency lowercaseString],
                                    @"payPassword":input,
                                    @"device_id":model.device_id,
                                    @"newVersion":@"true"
                                    };
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:SendFrom_URL params:param success:^(NSDictionary *response) {
                
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
            
        }];
    }];
    self.getRecommendedFeeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            
            IDCMURLSessionTask *task = [IDCMRequestList requestPostAuthNoHUD:RecommendedFeeList_URL params:input success:^(NSDictionary *response) {
                
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
    self.validComplicatedAddressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            
            IDCMURLSessionTask *task = [IDCMRequestList requestPostAuthNoHUD:ValidComplicatedAddressAsync_URL params:input success:^(NSDictionary *response) {
                
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
@end
