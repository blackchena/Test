//
//  IDCMUserInfoModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMUserInfoModel.h"

@implementation IDCMUserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID" : @"id"};
}

@end


