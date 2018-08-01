//
//  IDCMAmountModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/1.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMAmountModel : IDCMBaseModel
/**
 *   货币符号
 */
@property (copy, nonatomic) NSString *currencySymbol;
/**
 *   本地货币
 */
@property (copy, nonatomic) NSString *localCurrency;
/**
 *   总金额
 */
@property (strong, nonatomic) NSNumber *totalAssetMoney;
/**
 *   展示类型
 */
@property (strong, nonatomic) NSNumber *showType;
/**
 *   资产变化类型
 */
@property (strong, nonatomic) NSNumber *assetChangeType;
/**
 *   百分比
 */
@property (copy, nonatomic) NSString *persent;
/**
 *   一天的变化值 今天-昨天的差值 
 */
@property (copy, nonatomic) NSString *dValue;
/**
 *   行情数据
 */
@property (copy, nonatomic) NSArray *historyMarketData;
/**
 *   资产数据
 */
@property (copy, nonatomic) NSArray *historyAssetData;
@end


