//
//  IDCMAcceptantApplyStepsEndViewModel.h
//  IDCMWallet
//
//  Created by wangpu on 2018/5/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMAcceptantCoinModel.h"

@interface IDCMAcceptantApplyStepsEndViewModel : IDCMBaseViewModel

//步骤1
@property (nonatomic,strong) RACCommand *OTCGetExchangeBuyListCommand;//承兑买币信息
@property (nonatomic,strong) RACCommand *OTCGetExchangeSellListCommand;//承兑卖币信息
@property (nonatomic,strong) RACCommand *OTCExchangeCoinRemoveCommand; //承兑买币/卖币 移除 币种和限额
//步骤2
@property (nonatomic,strong) RACCommand *OTCGetExchangePayModeListCommand;//承兑买币  获取 法币币种和支付方式
@property (nonatomic,strong) RACCommand *OTCExchangePayModeRemoveCommand;//承兑买币 移除 法币币种和支付方式
@property (nonatomic,strong) RACCommand *OTCExchangePayModeAddCommand;//承兑买币 增加 法币币种和支付方式
@property (nonatomic,strong) RACCommand *OTCExchangeLocalCurrencyRemoveCommand;//移除 币种及资金量
@property (nonatomic,strong) RACCommand *OTCSetCurrentStepCommand;//设置当前步数

@property (nonatomic,copy) NSString  *  currentStep;

@end
