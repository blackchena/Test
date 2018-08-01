//
//  IDCMAcceptantCoinModel.m
//  IDCMWallet
//
//  Created by wangpu on 2018/5/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantCoinModel.h"

@implementation IDCMAcceptantCoinModel


+ (NSDictionary *)modelCustomPropertyMapper {

    return @{
             @"coinID":@"id",
             @"coinCode":@"CoinCode",
             @"conLogo":@"Logo",
             @"minAmount":@"MinAmount",
             @"sysWalletAddress":@"SysWalletAddress",
             };
}

-(NSString *) coinCodeUpperString{
    
    return [_coinCode.uppercaseString isNotBlank] ? _coinCode.uppercaseString : @"";
}
@end
