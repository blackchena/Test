//
//  IDCMOTCACceptanceOrederDetailViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCACceptanceOrederDetailViewModel.h"

@interface IDCMOTCACceptanceOrederDetailViewModel ()

@end

@implementation IDCMOTCACceptanceOrederDetailViewModel
#pragma mark - Life Cycle
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    self.quotePriceCommand = [RACCommand commandAuth:QuotePrice_URL
                                          serverName:nil
                                              params:nil
                                       handleCommand:nil];
    self.validPriceSignal = [[RACSignal
                              combineLatest:@[ RACObserve(self, totalPrice), RACObserve(self, unitPrice)]
                              reduce:^(NSNumber *totalPrice, NSNumber *unitPrice) {
                                  return @(![totalPrice isEqualToNumber:@(0)] && ![unitPrice isEqualToNumber:@(0)]);
                              }]
                             distinctUntilChanged];
}

#pragma mark - Privater Methods


#pragma mark - Getter & Setter
@end
