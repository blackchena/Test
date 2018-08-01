//
//  IDCMAcceptantPickinBondViewModel.m
//  IDCMWallet
//
//  Created by IDCM on 2018/5/10.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMAcceptantPickinBondViewModel.h"
#import "IDCMAcceptantCoinModel.h"
@implementation IDCMAcceptantPickinBondViewModel

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    
    RACSignal *(^enbledSignal)(void) = ^RACSignal *(void){
        return [[[RACSignal combineLatest:@[RACObserve(self, currency),
                                            RACObserve(self, countValue),
                                            RACObserve(self, address),]]
                 reduceEach:^(NSString *currency,
                              NSString *countValue,
                              NSString *address){
                     return @(currency.length &&
                     countValue.length &&
                     address.length);
                 }] distinctUntilChanged];
    };
    
    //input pin
    RACSignal *(^pickinRequestSignal)(id input) = ^RACSignal*(id input){
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];

            NSDictionary *parm = @{ @"CoinId"  :self.selectCoinModel.coinID,
                                    @"Amount":self.countValue,
                                    @"SysWalletAddress":self.address,
                                    @"PIN":input[@"PIN"],
                                    @"DeviceId":model.device_id
                                    };
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantRecharge_URL params:parm success:^(NSDictionary *response) {
                [subscriber sendNext:response];
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];

            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    };
    
    self.btnToPickinBondcommand = [[RACCommand alloc] initWithEnabled:enbledSignal() signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
    
    self.pickinBondcommand = [[RACCommand alloc] initWithSignalBlock:pickinRequestSignal];
    
    self.getOTCCoincommand = [RACCommand commandAuth:OTCMarginCoinList_URL serverName:nil params:nil handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];

        if ([status isEqualToString:@"1"] && [response[kData] isKindOfClass:[NSArray class]]) {
            NSMutableArray *coinList = @[].mutableCopy;
            for (NSDictionary *dict in response[kData]) {
                IDCMAcceptantCoinModel *model = [IDCMAcceptantCoinModel yy_modelWithDictionary:dict];
                [coinList addObject:model];
            }
            self.coinArray = coinList;
            [subscriber sendNext:coinList];
            [subscriber sendCompleted];
        }
        else{
            [IDCMShowMessageView showMessageWithCode:status];
        }
        [subscriber sendCompleted];
    }];
    
    
    self.getBalanceByCoinCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [self getBalanceByCoinSingal];
    }];
}

- (RACSignal *)getBalanceByCoinSingal
{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSString *url = [NSString idcw_stringWithFormat:@"%@?currency=%@",GetBalanceByCoin_URL,[self.selectCoinModel.coinCode lowercaseString]];
        IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:url params:nil success:^(NSDictionary *response) {
            NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
            if([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]){
                // 当前可用数量
                NSString *currentBalance = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"currentBalance"]];
                NSString *current = [IDCMUtilsMethod precisionControl:[NSDecimalNumber decimalNumberWithString:currentBalance]];
                NSString *currentStr = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:current] fractionDigits:4];
                self.withdrawAmount = currentBalance;
                [subscriber sendNext:currentStr];
            }
            else{
                [IDCMShowMessageView showMessageWithCode:status];
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
