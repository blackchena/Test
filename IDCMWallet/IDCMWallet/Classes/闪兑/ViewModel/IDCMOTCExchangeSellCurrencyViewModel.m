//
//  IDCMOTCExchangeSellCurrencyViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCExchangeSellCurrencyViewModel.h"
#import "IDCMOrderResultModel.h"
#import "IDCMSysSettingModel.h"
@implementation IDCMOTCExchangeSellCurrencyViewModel
-(void)initialize{
    [super initialize]; //commandAuth //commandPostAuthNoHUD
   
    self.OTCTradeSettingCommand = [RACCommand commandAuth:GetOtcSettingInfo_URL serverName:nil params:nil handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
        NSInteger status= [response[@"status"] integerValue];

        if (status == 1 && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            IDCMOTCSettingModel *settingModel = [IDCMOTCSettingModel yy_modelWithDictionary:response[@"data"]];
            [IDCMDataManager sharedDataManager].cancelCount = settingModel.CancelCount + 1;
            [subscriber sendNext:settingModel];
            [subscriber sendCompleted];
        }else{
            [subscriber sendError:nil];
        }
        
    }];
    self.OTCTradeNoHudSettingCommand =  [RACCommand commandPostAuthNoHUD:GetOtcSettingInfo_URL serverName:nil params:nil handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
        NSInteger status= [response[@"status"] integerValue];
        
        if (status == 1 && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            IDCMOTCSettingModel *settingModel = [IDCMOTCSettingModel yy_modelWithDictionary:response[@"data"]];
            [subscriber sendNext:settingModel];
            [subscriber sendCompleted];
        }else{
            [subscriber sendError:nil];
        }
    }];
    self.OTCSendOrderCommand = [RACCommand commandAuth:GetOtcSendOrder_URL serverName:nil params:^id(id input) {
         return input;
    } handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
        if ([response[@"status"] integerValue] == 1 && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            IDCMOrderResultModel * resultModel = [IDCMOrderResultModel yy_modelWithDictionary:response[@"data"]];
            [subscriber sendNext:resultModel];
            [subscriber sendCompleted];
        }else{
            [subscriber sendError:response];
        }
    }];
    

    
   self.OTCBaseSettingCommand = [RACCommand commandGetAuth:GetOTCBaseSet_URL serverName:nil params:nil handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
       if ([response[@"status"] integerValue] == 1 && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
           IDCMSysSettingModel * model =[IDCMSysSettingModel yy_modelWithDictionary:response[@"data"]];
           
           [IDCMDataManager sharedDataManager].settingModel = model;
           [subscriber sendNext:model];
           [subscriber sendCompleted];
       }else{
           [subscriber sendError:nil];
       }
       
    }] ;
    @weakify(self);
    self.userAssestCommand  =[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       @strongify(self);
        return [self getBalanceByCoinSingal:input];
    }];
    
}
- (RACSignal *)getBalanceByCoinSingal:(NSString *)coinCode
{
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSString *url = [NSString idcw_stringWithFormat:@"%@?currency=%@",GetBalanceByCoin_URL,[coinCode lowercaseString]];
        IDCMURLSessionTask *task = [IDCMRequestList requestGetAuth:url params:nil success:^(NSDictionary *response) {
            NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
            if([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]){
                // 当前可用数量
                NSString *currentBalance = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"currentBalance"]];
                NSString *current = [IDCMUtilsMethod precisionControl:[NSDecimalNumber decimalNumberWithString:currentBalance]];
                NSString *currentStr = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:current] fractionDigits:4];
//                self.withdrawAmount = currentBalance;
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
