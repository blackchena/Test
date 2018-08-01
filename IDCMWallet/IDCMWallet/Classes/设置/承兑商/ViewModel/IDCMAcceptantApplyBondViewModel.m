//
//  IDCMAcceptantApplyBondViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyBondViewModel.h"

@implementation IDCMAcceptantApplyBondViewModel

- (void)initialize {
    
    RACSignal *(^enbledSignal)(void) = ^RACSignal *(void){
        return [[[RACSignal combineLatest:@[RACObserve(self, currency),
                                            RACObserve(self, countValue)]]
                 reduceEach:^(NSString *currency,
                              NSString *countValue){
                     return @(currency.length &&
                     countValue.length);
                 }] distinctUntilChanged];
    };
    
    self.bondcommand = [[RACCommand alloc] initWithEnabled:enbledSignal()
                                               signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                                                   
                                                   return [RACSignal empty];
                                               }];
}

@end
