//
//  IDCMPrecisionModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/25.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMPrecisionModel.h"
#import "IDCMPrecisionBaseModel.h"

@implementation IDCMPrecisionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"TotalAssets":[IDCMPrecisionBaseModel class],
             @"Assets":[IDCMPrecisionBaseModel class],
             @"Market":[IDCMPrecisionBaseModel class],
             @"CurrencyMoney":[IDCMPrecisionBaseModel class],
             @"CurrencyQuantity":[IDCMPrecisionBaseModel class]
             };
}
@end
