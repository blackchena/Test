//
//  IDCMAssetListModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMAssetListModel : NSObject
/**
 *   date
 */
@property (copy, nonatomic) NSString *timeDate;
/**
 *   数字货币数量
 */
@property (strong, nonatomic) NSNumber *amount;
/**
 *   法币数量
 */
@property (strong, nonatomic) NSNumber *marketMoney;
@end
