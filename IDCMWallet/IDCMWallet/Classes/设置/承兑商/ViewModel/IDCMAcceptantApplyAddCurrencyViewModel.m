//
//  IDCMAcceptantApplyAddCurrencyViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyAddCurrencyViewModel.h"
#import "IDCMAcceptantCoinModel.h"

@implementation IDCMAcceptantApplyAddCurrencyViewModel

- (void)initialize {
    
    
    @weakify(self);
    RACSignal *(^enbledSignal)(void) = ^RACSignal *(void){
        return [[[RACSignal combineLatest:@[RACObserve(self, currency),
                                            RACObserve(self, maxValue),
                                            RACObserve(self, minValue),
                                            RACObserve(self, premiumPrice)
                                             ]]
                               reduceEach:^(NSString *currency,
                                            NSString *maxValue,
                                            NSString *minValue,
                                            NSString *premiumPrice){
                                     return @(currency.length &&
                                              maxValue.length &&
                                              minValue.length &&
                                              premiumPrice.length);
                             }] distinctUntilChanged];
                };
    
    //保存
    self.saveCommand = [[RACCommand alloc] initWithEnabled:enbledSignal()
                                               signalBlock:^RACSignal * _Nonnull(NSDictionary * input) {
    
       NSDecimalNumber * premium =  [NSDecimalNumber decimalNumberWithString:self.premiumPrice];
       NSDecimalNumber * limitup = [NSDecimalNumber decimalNumberWithString:@"10"];
       NSDecimalNumber * limitDown = [NSDecimalNumber decimalNumberWithString:@"-10"];
       if (self.minValue.doubleValue>=self.maxValue.doubleValue) {
           
           [IDCMViewTools ToastView:[UIApplication sharedApplication].delegate.window info:[NSString stringWithFormat:@"%@",SWLocaloziString(@"3.0_AcceptantOutLimitation")] position:QMUIToastViewPositionBottom];
           
           return [RACSignal empty];
       }
       if ([premium compare:limitup] == NSOrderedDescending  || [premium compare:limitDown] == NSOrderedAscending) {
           
           [IDCMViewTools ToastView:[UIApplication sharedApplication].delegate.window info:[NSString stringWithFormat:@"%@",SWLocaloziString(@"3.0_AcceptantOutPremium")] position:QMUIToastViewPositionBottom];
           
           return [RACSignal empty];
       }else{
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               //
               //请求参数
               NSInteger coindID = 0;
               for (IDCMAcceptantCoinModel * model in self.acceptantCoinList) {
                   if ([model.coinCode isEqualToString:self.selectModel.coinCode]) {
                       coindID = model.coinID.integerValue;
                   }
               }
               NSNumber * direction = nil;
               //买
               if (self.currencyType == AddCurrencyType_BuyEdit || self.currencyType == AddCurrencyType_Buy ) {
                   direction = @1;
               }
               //卖
               if (self.currencyType == AddCurrencyType_SellEdit || self.currencyType == AddCurrencyType_Sell ) {
                   direction = @2;
               }
               NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
               [params setObject:[NSNumber numberWithInteger:coindID] forKey:@"CoinId"];
               [params setObject:[NSDecimalNumber decimalNumberWithString:self.maxValue] forKey:@"Max"];
               [params setObject:[NSDecimalNumber decimalNumberWithString:self.minValue] forKey:@"Min"];
               [params setObject:[NSDecimalNumber decimalNumberWithString:self.premiumPrice] forKey:@"Premium"];
               [params setObject:direction forKey:@"Direction"];
               //编辑
               if (self.currencyType == AddCurrencyType_BuyEdit || self.currencyType == AddCurrencyType_SellEdit) {
                   NSString * dataID =  self.editDict[@"dataID"] ? : @"";
                   
                   [params setObject:dataID forKey:@"id"];
               }else{
                   [params setObject:@"" forKey:@"id"];
               }
               //添加
               IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantExchangeCoinChange_URL params:params success:^(NSDictionary *response) {
                   NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                   if ([status isEqualToString:@"1"]) {
                       [subscriber sendNext:response];
                   }else{
                       if ([status isEqualToString:@"622"]) {
                           
                           [IDCMViewTools ToastView:[UIApplication sharedApplication].delegate.window info:[NSString stringWithFormat:@"%@",SWLocaloziString(@"3.0_AcceptantReAddCoinType")] position:QMUIToastViewPositionBottom];
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
       }

    }];
    
    //获取承兑币种列表
    self.getOtcCoinListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       
        @strongify(self);
       return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
           IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantGetOtcCoinList_URL params:input success:^(NSDictionary *response) {
               NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
               if (![status isEqualToString:@"1"]) {
                   
                   [IDCMShowMessageView showMessageWithCode:status];
               }else {
                   
                   if([status isEqualToString:@"1"]  && [response[@"data"] isKindOfClass:[NSArray class] ] ){
                       
                       NSArray * data = response[@"data"];
                       NSMutableArray * coinlist = [[NSMutableArray alloc] init];
                       [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         
                         IDCMAcceptantCoinModel * model =  [IDCMAcceptantCoinModel yy_modelWithDictionary:obj];
                           // 此数据多余
                           model.minAmount = nil;
                           [coinlist addObject:model];
                       }];
                       
                       self.acceptantCoinList  = coinlist;
                   }
                   [subscriber sendNext:nil];
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

- (NSString *)title {
    
    switch (self.currencyType) {
        case AddCurrencyType_Buy:
            return NSLocalizedString(@"3.0_AcceptantAddBuyCurrency", nil);
            break;
        case AddCurrencyType_Sell:
            return  NSLocalizedString(@"3.0_AcceptantAddSellCurrency", nil);
            break;
        case AddCurrencyType_BuyEdit:
        case AddCurrencyType_SellEdit:
            return  self.editDict[@"title"];
            break;
    }
}
@end








