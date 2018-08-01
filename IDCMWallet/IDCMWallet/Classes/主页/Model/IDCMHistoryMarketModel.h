//
//  IDCMHistoryMarketModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMHistoryMarketModel : NSObject
/**
 *   币种缩写
 */
@property (copy, nonatomic) NSString *currency;
/**
 *   排序下标
 */
@property (strong, nonatomic) NSNumber *sortIndex;
/**
 *   本地货币
 */
@property (copy, nonatomic) NSString *localCurrency;
/**
 *  是否选中
 */
@property (assign, nonatomic) BOOL isDefault;
/**
 *  七天数据
 */
@property (copy, nonatomic) NSArray *dateList;
@end
