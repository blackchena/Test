//
//  IDCMThirdPayModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/23.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMThirdPayModel : IDCMBaseModel
/**
 *   数量
 */
@property (copy, nonatomic) NSString *amount;
/**
 *   币种
 */
@property (copy, nonatomic) NSString *currency;
/**
 *   地址
 */
@property (copy, nonatomic) NSString *notify_url;
/**
 *   sign
 */
@property (copy, nonatomic) NSString *sign;
/**
 *   time
 */
@property (copy, nonatomic) NSString *time_span;
/**
 *   订单号
 */
@property (copy, nonatomic) NSString *trans_id;

/**
 *   AppID
 */
@property (copy, nonatomic) NSString *appId;
@end
