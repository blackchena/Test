//
//  IDCMCurrencyListModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/17.
//  Copyright © 2018年 BinBear. All rights reserved.
// 币种列表的model

#import <Foundation/Foundation.h>

@interface IDCMCurrencyListModel : NSObject
/**
 *   币种名称
 */
@property (copy, nonatomic) NSString *currencyName;
/**
 *   余额
 */
@property (strong, nonatomic) NSNumber *balance;
/**
 *   当前真实余额
 */
@property (strong, nonatomic) NSNumber *realityBalance;
/**
 *   货币类型
 */
@property (copy, nonatomic) NSString *currency;
/**
 *   货币单位
 */
@property (copy, nonatomic) NSString *currency_unit;
/**
 *   本地货币行情
 */
@property (strong, nonatomic) NSNumber *localCurrencyMarket;
/**
 *   本地货币名称
 */
@property (copy, nonatomic) NSString *localCurrencyName;
/**
 *   logo
 */
@property (copy, nonatomic) NSString *logo;
/**
 *   钱包id
 */
@property (strong, nonatomic) NSNumber *ID;
/**
 *   钱包类型
 */
@property (copy, nonatomic) NSString *wallet_type;
/**
 *  是否选中
 */
@property (assign, nonatomic) BOOL isSelect;
@end
