//
//  IDCMCurrencyMarketModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMCurrencyMarketModel : NSObject
/* 3.1.2新增字段 */
/**
 *  是否启用收发按钮
 */
@property (assign, nonatomic) BOOL is_enable_ransceiver;

/* 2.2.1新增字段 */

/**
 *  是否代币
 */
@property (assign, nonatomic) BOOL isToken;
/**
 *  代币种类
 */
@property (copy, nonatomic) NSString *tokenCategory;
/**
 *  货币单位
 */
@property (copy, nonatomic) NSString *coinUnit;
/**
 *  代币父类币种余额
 */
@property (strong, nonatomic) NSNumber *ethBalanceForToken;


/* 2.2新增字段 */

/**
 *  币种布局类型  0:常规 1:私有 vhkd、btl
 */
@property (strong, nonatomic) NSNumber *currencyLayoutType;

/* 2.1新增字段 */

/**
*   排序下标
*/
@property (strong, nonatomic) NSNumber *sortIndex;
/**
 *  是否显示
 */
@property (assign, nonatomic) BOOL isShow;
/**
 *   新的货币logo url地址
 */
@property (copy, nonatomic) NSString *logo_url;

/* 2.0 */

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
 *   本地货币符号
 */
@property (copy, nonatomic) NSString *currencySymbol;
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


/**
 *  customer 是否是当前选中的
 */
@property (assign, nonatomic) BOOL currentSelect;




@end

/*
 balance = "3104.9782";
 currency = btl;
 currencyName = "Bitcoin Link";
 currencySymbol = "$";
 "currency_unit" = btl;
 id = 2210;
 label = "My Bitcoin Link Wallet";
 localCurrencyMarket = 100;
 localCurrencyName = USD;
 logo = "/upload/coin/ico_btl.png";
 realityBalance = "3104.9782";
 sortIndex = 0;
 "wallet_type" = btl;
 */
