//
//  IDCMChartModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMChartModel : IDCMBaseModel
/**
 *   id
 */
@property (strong, nonatomic) NSNumber *ID;
/**
 *   显示类型 0：资产  1：行情
 */
@property (strong, nonatomic) NSNumber *showType;
/**
 *  货币列表
 */
@property (strong, nonatomic) NSArray *currencyList;
@end
