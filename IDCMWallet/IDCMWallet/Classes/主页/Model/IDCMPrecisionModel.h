//
//  IDCMPrecisionModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/25.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMPrecisionModel : IDCMBaseModel
/**
 *  总资产部分精度
 */
@property (strong, nonatomic) NSArray *TotalAssets;
/**
 *  资产部分精度
 */
@property (strong, nonatomic) NSArray *Assets;
/**
 *  行情部分精度
 */
@property (strong, nonatomic) NSArray *Market;
/**
 *  币种法币部分精度
 */
@property (strong, nonatomic) NSArray *CurrencyMoney;
/**
 *  币种数量部分精度
 */
@property (strong, nonatomic) NSArray *CurrencyQuantity;
@end
