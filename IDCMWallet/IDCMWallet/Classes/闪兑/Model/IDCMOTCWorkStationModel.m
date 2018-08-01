//
//  IDCMOTCWorkStationModel.m
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCWorkStationModel.h"

@implementation IDCMOTCWorkStationPayType

@end

@implementation IDCMOTCWorkStationModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"PayTypes":[IDCMOTCWorkStationPayType class],
             };
}

@end
