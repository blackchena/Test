//
//  IDCMLocalCurrencyModel.m
//  IDCMWallet
//
//  Created by wangpu on 2018/5/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMLocalCurrencyModel.h"

@implementation IDCMLocalCurrencyModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"currencyID":@"id",
             @"localCurrencyCode":@"LocalCurrencyCode",
             @"currencyLogo":@"Logo",
             };
}
-(NSString *) localCurrencyCodeUpperString{
    
    return [_localCurrencyCode.uppercaseString isNotBlank] ? _localCurrencyCode.uppercaseString : @"";
}
@end
