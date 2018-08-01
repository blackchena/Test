//
//  IDCMPrecisionBaseModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/25.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMPrecisionBaseModel : IDCMBaseModel
/**
 *   币种
 */
@property (copy, nonatomic) NSString *currency;
/**
 *   类型
 */
@property (assign, nonatomic) NSInteger type;
/**
 *   精度
 */
@property (assign, nonatomic) NSInteger accuracy;
@end
