//
//  IDCMChartModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChartModel.h"
#import "IDCMTrendChartModel.h"

@implementation IDCMChartModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"currencyList" : IDCMTrendChartModel.class};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end
