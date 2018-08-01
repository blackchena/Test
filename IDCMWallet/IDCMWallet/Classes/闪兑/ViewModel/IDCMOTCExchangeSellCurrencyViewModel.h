//
//  IDCMOTCExchangeSellCurrencyViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMOTCSettingModel.h"
@interface IDCMOTCExchangeSellCurrencyViewModel : IDCMBaseViewModel

@property(nonatomic,copy) NSString * coinText  ;

/**
 请求交易相关配置信息
 */
@property(nonatomic,strong)RACCommand * OTCTradeSettingCommand;


/**
 请求交易配置信息  （没hub）
 */
@property(nonatomic,strong)RACCommand *  OTCTradeNoHudSettingCommand ;
/**
 发送订单
 */
@property(nonatomic,strong)RACCommand * OTCSendOrderCommand ;


/**
 订单基本信息配置
 */
@property(nonatomic,strong)RACCommand * OTCBaseSettingCommand ;


/**
 获取用户资产
 */
@property(nonatomic,strong)RACCommand * userAssestCommand;

/**
 OTC交易配置信息
 */
@property(nonatomic,strong)IDCMOTCSettingModel  * settingModel ;

@property(nonatomic,copy) NSString *  coinName;
@property(nonatomic,copy) NSString *  amount;


@end
