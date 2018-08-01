//
//  IDCMAcceptMarginManageModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/4/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMAcceptMarginManageModel : IDCMBaseModel

@property (nonatomic,copy) NSString *DepositId;///< 保证金id
@property (nonatomic,copy) NSString *CoinId;///< 币种ID
@property (nonatomic,copy) NSString *CoinCode;///< 币种编码
@property (nonatomic,copy) NSString *CoinName;///< 币种名称
@property (nonatomic,copy) NSString *Logo;///< Logo
@property (nonatomic,copy) NSNumber *UseNum;///< 可用余额
@property (nonatomic,copy) NSNumber *Precision;///< 精度
@property (nonatomic,copy) NSNumber *Sort;///< 排序

@end
