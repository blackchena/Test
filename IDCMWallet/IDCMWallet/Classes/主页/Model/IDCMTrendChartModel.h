//
//  IDCMTrendChartModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMTrendChartModel : IDCMBaseModel
/**
 *   币种id
 */
@property (strong, nonatomic) NSNumber *ID;
/**
 *   币种名称
 */
@property (copy, nonatomic) NSString *currencyName;
/**
 *   logo
 */
@property (copy, nonatomic) NSString *logo_url;
/**
 *   货币类型
 */
@property (copy, nonatomic) NSString *currency;
/**
 *   排序下标
 */
@property (strong, nonatomic) NSNumber *sortIndex;
/**
 *  是否显示
 */
@property (assign, nonatomic) BOOL isShow;
/**
 *  是否选中
 */
@property (assign, nonatomic) BOOL isDefault;
@end

/*
 "id": 0,
 "currency": "string",
 "currencyName": "string",
 "logo": "string",
 "sortIndex": 0,
 "isShow": true,
 "isDefault": true
 
 */
