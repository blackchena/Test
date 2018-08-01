//
//  IDCMNewCurrencyTradingViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/28.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMNewCurrencyTradingViewModel.h"


@interface IDCMNewCurrencyTradingViewModel ()
@property (nonatomic,strong) RACCommand *pullDownCommand;
@property (nonatomic,strong) RACCommand *pullUpCommand;
@end


@implementation IDCMNewCurrencyTradingViewModel
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.tradeType = 2;
        self.currencyListData = params[@"currencyListData"];
        @weakify(self);
        [self.currencyListData enumerateObjectsUsingBlock:^(IDCMCurrencyMarketModel *obj,
                                                        NSUInteger idx, BOOL *stop) {
            @strongify(self);
            if (obj.isSelect) {
                self.marketModel = obj;
                obj.currentSelect = YES;
            }
        }];
    }
    return self;
}

- (tableViewCommandBlock)tableViewExecuteCommand {
    @weakify(self);
    return ^RACCommand *(IDCMTableViewLoadDataType type){
        @strongify(self);
        if (!type) { [IDCMHUD show]; }
        self.currentLoadDataType = type;
        return type == IDCMTableViewLoadDataTypeMore ?
        self.pullUpCommand : self.pullDownCommand;
    };
}

- (RACCommand *)pullDownCommand {
    return SW_LAZY(_pullDownCommand, ({
        @weakify(self);
        [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
            @strongify(self);
            self.currentLoadDataType = IDCMTableViewLoadDataTypeNew;
            return [[RACSignal
                     combineLatest:@[[self getBalanceByCoin], [self getFirstWalletHistories:input]]
                     reduce:^(NSDictionary *balanceResponse, NSNumber *value) {
                         return value;
                     }]
                    distinctUntilChanged];
        }];
    }));
}

- (RACCommand *)pullUpCommand {
    return SW_LAZY(_pullUpCommand, ({
        @weakify(self);
        [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
            @strongify(self);
            return [self getWalletHistories];
        }];
    }));
}

#pragma mark
#pragma mark - 请求数据信号
// 根据币种获得最新的金额
- (RACSignal *)getBalanceByCoin {
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        
        NSString *curreny = [self getCurreny];
        if (curreny.length <= 0) {
            [subscriber sendError:nil];
            return [RACDisposable disposableWithBlock:^{}];
        }
        
        NSString *url = [NSString idcw_stringWithFormat:@"%@?currency=%@",GetBalanceByCoin_URL,curreny];
        IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:url params:nil success:^(NSDictionary *response) {
            @strongify(self);
            
            NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
            if ([status isEqualToString:@"100"]) {
                [subscriber sendError:nil];
            }else if([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]){
                
                // 是否是代币
                if ([response[@"data"][@"tokenInfo"] isKindOfClass:[NSDictionary class]]) {
                    self.marketModel.tokenCategory = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"tokenInfo"][@"tokenCategory"]];
                    self.marketModel.coinUnit = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"tokenInfo"][@"coinUnit"]];
                    NSString *tokrnBalance = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"tokenInfo"][@"ethBalanceForToken"]];
                    NSString *tokenForBalance = [IDCMUtilsMethod precisionControl:[NSDecimalNumber decimalNumberWithString:tokrnBalance]];
                    NSInteger tokenPresion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:self.marketModel.coinUnit withType:kIDCMCurrencyPrecisionQuantity];
                    NSString *tokenStr = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:tokenForBalance] fractionDigits:tokenPresion];
                    self.marketModel.ethBalanceForToken = [NSDecimalNumber decimalNumberWithString:tokenStr];
                    if ([response[@"data"][@"tokenInfo"][@"isToken"] integerValue] == 1) {
                        self.marketModel.isToken = YES;
                    }else{
                        self.marketModel.isToken = NO;
                    }
                }
                
                // 真实数量
                NSString *balance = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"realityBalance"]];
                NSString *realelybalance = [IDCMUtilsMethod precisionControl:[NSDecimalNumber decimalNumberWithString:balance]];
                NSInteger currencyPresion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:self.marketModel.currency_unit withType:kIDCMCurrencyPrecisionQuantity];
                NSString *realeyStr = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:realelybalance] fractionDigits:currencyPresion];
                self.marketModel.realityBalance = [NSDecimalNumber decimalNumberWithString:realeyStr];
                
                // 当前可用数量
                NSString *currentBalance = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"currentBalance"]];
                NSString *current = [IDCMUtilsMethod precisionControl:[NSDecimalNumber decimalNumberWithString:currentBalance]];
                NSString *currentStr = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:current] fractionDigits:currencyPresion];
                self.marketModel.balance = [NSDecimalNumber decimalNumberWithString:currentStr];
                
                //数字货币
                NSString *bitcoinStr = [NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod separateNumberUseCommaWith:realeyStr]];
                
                //法币
                double totalAmout = [self.marketModel.realityBalance doubleValue] * [self.marketModel.localCurrencyMarket doubleValue];
                NSInteger coinPresion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:self.marketModel.currency_unit withType:kIDCMCurrencyPrecisionMoney];
                NSString  *money = [NSString stringFromNumber:[NSNumber numberWithDouble:totalAmout] fractionDigits:coinPresion];
                NSString  *uSDStr = [NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod separateNumberUseCommaWith:money]];
                
                NSDictionary *balanceDic = @{@"CoinBalance":bitcoinStr,
                                             @"CoinType":[[self.marketModel.currency uppercaseString] isNotBlank] ? [self.marketModel.currency uppercaseString] : @"",
                                             @"CurrencyNumber":uSDStr,
                                             @"CurrencyType":[[self.marketModel.localCurrencyName uppercaseString] isNotBlank] ?  [self.marketModel.localCurrencyName uppercaseString] : @""
                                             };
                self.blanceDict = balanceDic;
                [subscriber sendNext:@0];
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

// 获得第一次进入或者选择币种之后的交易记录
- (RACSignal *)getFirstWalletHistories:(NSDictionary *)input {
    @weakify(self);
    return [[self receivedWalletOpt] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        @strongify(self);
        NSString *status = [NSString idcw_stringWithFormat:@"%@",value[@"status"]];
        if ([status isEqualToString:@"1"] && ![value[@"data"] isEqual:[NSNull class]] && value[@"data"]) {
            return  [self getWalletHistories];
        }else{
            return  [RACSignal return:@1];
        }
    }];
}

// 请求轮询接口
- (RACSignal *)receivedWalletOpt {
    @weakify(self);
    return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        
        NSString *curreny = [self getCurreny];
        if (curreny.length <= 0) {
            [subscriber sendError:nil];
            return [RACDisposable disposableWithBlock:^{}];
        }
        
        NSString *url = [NSString stringWithFormat:@"%@?currency=%@",ReceivedWalletOpt_URL,curreny];
        IDCMURLSessionTask *task =
        [IDCMRequestList requestGetNoHUDAuth:url params:nil success:^(NSDictionary *response) {
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
}

// 获得交易记录
- (RACSignal *)getWalletHistories {
    @weakify(self);
    
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        
        NSString *curreny = [self getCurreny];
        if (curreny.length <= 0) {
            [subscriber sendError:nil];
            return [RACDisposable disposableWithBlock:^{}];
        }
        
        NSDictionary *param = @{@"trade_type":@(self.tradeType),
                                @"currency":curreny,
                                @"index": @([self getLoadDataPageNumber]),
                                @"size":@(self.pageSize)
                              };
        IDCMURLSessionTask *task =
        [IDCMRequestList requestPostAuthNoHUD:GetWalletHistories_URL params:param success:^(NSDictionary *response) {
            @strongify(self);
            if ([self configrequestCommand]) {
                [self configrequestCommand](nil, response, subscriber);
            }
        } fail:^(NSError *error, NSURLSessionDataTask *task) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
        
    }] retry:1];
}

- (NSString *)getCurreny {
    if (!self.marketModel.currency ||
        [self.marketModel.currency isKindOfClass:[NSNull class]] ||
        ![self.marketModel.currency isNotBlank]) {
        return @"";
    }
    return [self.marketModel.currency lowercaseString];
}

- (tableViewDataAnalyzeBlock)configDataParams {
    return ^ NSDictionary * (id response){
        if ([response isKindOfClass:[NSDictionary class]]) {
            id res = response[@"data"];
            if (!res || [res isKindOfClass:[NSNull class]]) {
                res = @"";
            }
        return @{
                 CellModelClassKey : [IDCMNewCurrencyTradingModel class],
                 CellModelDataKey : res
                 };
        } else {
            return nil;
        }
    };
}

- (void)cancelAllRequest {
    
    IDCMCurrencyMarketModel *marketModel = self.marketModel;
    NSString *optUrl = [NSString stringWithFormat:@"%@?currency=%@",ReceivedWalletOpt_URL,[marketModel.currency lowercaseString]];
    [IDCMNetWorking cancelRequestWithURL:optUrl];
    [IDCMNetWorking cancelRequestWithURL:GetWalletHistories_URL];
    NSString *url = [NSString stringWithFormat:@"%@?currency=%@",GetBalanceByCoin_URL,[marketModel.currency lowercaseString]];
    [IDCMNetWorking cancelRequestWithURL:url];
}

@end













