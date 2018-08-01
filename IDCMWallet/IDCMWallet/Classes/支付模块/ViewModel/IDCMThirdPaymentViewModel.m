//
//  IDCMThirdPaymentViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMThirdPaymentViewModel.h"

@implementation IDCMThirdPaymentViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.payModel = params[@"payModel"];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:self.payModel.amount];
        self.payModel.amount = [NSString idcw_stringWithFormat:@"%@",amount];
        
        NSString *url = [NSString idcw_stringWithFormat:@"%@?appid=%@&lang=%@",GetCustomerInfo_URL,self.payModel.appId,[IDCMUtilsMethod getServiceLanguage]];
        self.getInfoCommand = [RACCommand commandGetNotAuthHUD:url serverName:nil params:nil handleCommand:nil];
    }
    return self;
}

- (RACSignal *)executeRequestDataSignal:(id)input
{
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSDictionary *dic = @{@"sign":[self.payModel.sign isNotBlank] ? self.payModel.sign : @"",
                          @"appid":[self.payModel.appId isNotBlank] ? self.payModel.appId : @"",
                          @"type":@(0),
                          @"trans_id":[self.payModel.trans_id isNotBlank] ?  self.payModel.trans_id : @"",
                          @"time_span":[self.payModel.time_span isNotBlank] ? self.payModel.time_span : @"",
                          @"notify_url":[self.payModel.notify_url isNotBlank] ? self.payModel.notify_url : @"",
                          @"comment":[self.payModel.trans_id isNotBlank] ? self.payModel.trans_id : @"",
                          @"payPassword":[self.payPassword isNotBlank] ? self.payPassword : @"",
                          @"toAddress":@"",
                          @"amount":[self.payModel.amount isNotBlank] ? self.payModel.amount : @"",
                          @"fee":@(0),
                          @"currency": [self.payModel.currency isNotBlank] ? [self.payModel.currency lowercaseString] : @"",
                          @"device_id":model.device_id,
                          @"newVersion":@"true"
                          };
    
    return [RACSignal signalAuth:SecurityPaySendFrom_URL serverName:nil params:dic handleSignal:nil];
}
@end
