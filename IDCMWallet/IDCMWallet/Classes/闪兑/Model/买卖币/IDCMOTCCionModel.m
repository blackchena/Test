//
//  IDCMOTCCionModel.m
//  IDCMWallet
//
//  Created by mac on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCCionModel.h"

@implementation IDCMOTCCionModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"id":@"coin_id"};
}
-(NSString *)dk_uppercaseLetter{
    
    return self.CoinCode.uppercaseString;
}
@end
