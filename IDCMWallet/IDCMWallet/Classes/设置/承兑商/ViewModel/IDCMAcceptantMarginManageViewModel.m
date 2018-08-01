//
//  IDCMAcceptantMarginManageViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/4/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantMarginManageViewModel.h"
#import "IDCMAcceptMarginManageModel.h"

@implementation IDCMAcceptantMarginManageViewModel

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
    
    self.GetOtcAcceptantInfoCommand =
    [RACCommand commandAuth:OTCAcceptantGetDepositList_URL
                 serverName:ExchangeServerName
                     params:nil
              handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                  NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                  if ([status isEqualToString:@"1"] && [response[kData] isKindOfClass:[NSArray class]]) {
                      NSMutableArray * depositList = @[].mutableCopy;
                      
                      for (NSDictionary *dict in response[kData]) {
                          IDCMAcceptMarginManageModel *model = [IDCMAcceptMarginManageModel yy_modelWithDictionary:dict];
                          [depositList addObject:model];
                      }
                      self.DepositList = depositList;
                      [subscriber sendNext:nil];
                  }
                  else{
                      [IDCMShowMessageView showMessageWithCode:status];
                  }
                  [subscriber sendCompleted];
              }];
    
    self.SetPaySequenceCommand =
    [RACCommand commandAuth:OTCAcceptantSetPaySequence_URL
                 serverName:nil params:^id(id input) {
                     NSMutableArray *uploadArr = @[].mutableCopy;
                     NSInteger index = 0;
                     for (IDCMAcceptMarginManageModel *model in self.DepositList) {
                         NSDictionary *dict = @{@"id":model.DepositId, @"Sort":[NSNumber numberWithInteger:index]};
                         [uploadArr addObject:dict];
                         index++;
                     }
                     return uploadArr;
                 }
              handleCommand:nil];
    
    self.CheckWithdrawCommand =
    [RACCommand commandAuth:OTCAcceptantCheckWithdraw_URL
                 serverName:nil
                     params:nil
              handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                  NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                  if ([status isEqualToString:@"1"] && [response[kData] isKindOfClass:[NSNumber class]]) {
                      NSNumber *check;
                      NSNumber *dataCheck = response[kData];
                      if (dataCheck.boolValue == YES) {
                          check = @YES;
                      }
                      else{
                          check = @NO;
                      }
                      [subscriber sendNext:check];
                  }
                  else if ([status isEqualToString:@"642"]){
                      [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                          [configure.getBtnsConfig removeFirstObject];
                          NSString *message = [IDCMUtilsMethod getAlertMessageWithCode:status];

                          configure
                          .title(message)
                          .getBtnsConfig
                          .lastObject
                          .btnTitle(SWLocaloziString(@"3.0_JWRecord_IKown"));
                      }];
                  }
                  else if ([status isEqualToString:@"629"]){
                      [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                          [configure.getBtnsConfig removeFirstObject];
                          NSString *message = [IDCMUtilsMethod getAlertMessageWithCode:status];
                          
                          configure
                          .title(message)
                          .getBtnsConfig
                          .lastObject
                          .btnTitle(SWLocaloziString(@"3.0_JWRecord_IKown"));
                      }];
                  }else if ([status isEqualToString:@"962900"]){
                      [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                          [configure.getBtnsConfig removeFirstObject];
//                          NSString *message = [IDCMUtilsMethod getAlertMessageWithCode:status];
                          
                          configure
                          .title(SWLocaloziString(@"3.0_AcceptantCashDepositOut"))
                          .getBtnsConfig
                          .lastObject
                          .btnTitle(SWLocaloziString(@"3.0_JWRecord_IKown"));
                      }];
                  }else if ([status isEqualToString:@"964200"]){
                      [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                          [configure.getBtnsConfig removeFirstObject];
//                          NSString *message = [IDCMUtilsMethod getAlertMessageWithCode:status];
//                          
                          configure
                          .title(SWLocaloziString(@"3.0_AcceptantCashDepositOutTips"))
                          .getBtnsConfig
                          .lastObject
                          .btnTitle(SWLocaloziString(@"3.0_JWRecord_IKown"));
                      }];
                  }
                  
                  else{
                      [IDCMShowMessageView showMessageWithCode:status];
                  }
                  [subscriber sendCompleted];
              }];
}

#pragma mark - Privater Methods


#pragma mark - Getter & Setter

@end
