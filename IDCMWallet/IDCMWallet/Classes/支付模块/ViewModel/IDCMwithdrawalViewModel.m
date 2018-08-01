//
//  IDCMwithdrawalViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/27.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMwithdrawalViewModel.h"

@implementation IDCMwithdrawalViewModel
#pragma mark - Life Cycle
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.payModel = params[@"payModel"];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:self.payModel.amount];
        self.payModel.amount = [NSString idcw_stringWithFormat:@"%@",amount];
        
        NSString *url = [NSString stringWithFormat:@"%@?currency=%@",GetAccountAddress_URL,[self.payModel.currency lowercaseString]];
        self.reciveCommand = [RACCommand commandGetAuth:url serverName:nil params:nil handleCommand:nil];
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    

    self.validAddressSignal = [[RACObserve(self, reciveAddress) map:^id _Nullable(NSString *value) {
        return @(value.length > 0);
    }] distinctUntilChanged];
    
    self.varifyAddressCommand = [RACCommand commandAuth:ValidAddress_URL serverName:nil params:nil handleCommand:nil];
    self.validComplicatedAddressCommand = [RACCommand commandPostNoHUDAuth:ValidComplicatedAddressAsync_URL serverName:nil params:nil handleCommand:nil];
}

#pragma mark - Privater Methods


#pragma mark - Getter & Setter
- (RACSignal *)executeRequestDataSignal:(id)input
{

    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSDictionary *dic = @{@"sign":[self.payModel.sign isNotBlank] ? self.payModel.sign : @"",
                          @"appid":[self.payModel.appId isNotBlank] ? self.payModel.appId : @"",
                          @"type":@(1),
                          @"trans_id":[self.payModel.trans_id isNotBlank] ?  self.payModel.trans_id : @"",
                          @"time_span":[self.payModel.time_span isNotBlank] ? self.payModel.time_span : @"",
                          @"notify_url":[self.payModel.notify_url isNotBlank] ? self.payModel.notify_url : @"",
                          @"comment":[self.payModel.trans_id isNotBlank] ? self.payModel.trans_id : @"",
                          @"payPassword":[self.payPassword isNotBlank] ? self.payPassword : @"",
                          @"toAddress":[self.reciveAddress isNotBlank] ? self.reciveAddress : @"",
                          @"amount":[self.payModel.amount isNotBlank] ? self.payModel.amount : @"",
                          @"fee":@(0),
                          @"currency": [self.payModel.currency isNotBlank] ? [self.payModel.currency lowercaseString] : @"",
                          @"device_id":model.device_id,
                          @"newVersion":@"true"
                          };
    return [RACSignal signalAuth:SecurityPaySendFrom_URL serverName:nil params:dic handleSignal:nil];
}
@end
