//
//  IDCMOTCSettingModel.h
//  IDCMWallet
//
//  Created by mac on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMOTCCionModel.h"
#import "IDCMOTCCurrencyModel.h"
#import "IDCMOTCPaymentModel.h"
@interface IDCMOTCSettingModel : IDCMBaseModel

@property(nonatomic,strong)NSArray<IDCMOTCCionModel *> *CoinSettings ;///<(Array[OtcCoinSettingDTO], optional): 虚拟币相关设置信息 ,
@property(nonatomic,strong)NSArray<IDCMOTCCurrencyModel *> *Currencies;///< (Array[OtcCurrencySettingDTO], optional): 法定货币相关设置信息 ,
@property(nonatomic,strong)NSArray<IDCMOTCPaymentModel *> *Payments;///< (Array[OtcPaymentModeDTO], optional): 支付方式 ,
@property(nonatomic,assign) BOOL IsForbidTrade ;///<(boolean, optional): 是否禁止交易 ,
@property(nonatomic,copy) NSString * ForbidExpireDate ;///<(string, optional): 解禁到期时间
@property(nonatomic,copy)NSString * ForbidExpireTimestamp ; ///<(integer, optional, read only): 解禁到期时间戳
@property(nonatomic,assign)NSInteger  ForbidExpiredSeconds ;///<(integer, optional): 解禁到期时间剩余秒数 ,
@property(nonatomic,assign) NSInteger  CancelCount ;///< (integer, optional): 取消次数) ;


/**
 选中的币种
 */
@property(nonatomic,copy)NSString * selectCurrency;

/**
 对应法币的支付方式
 */
@property(nonatomic,strong)NSMutableArray <IDCMOTCPaymentModel *>* dk_correspondPayments ;

@end
