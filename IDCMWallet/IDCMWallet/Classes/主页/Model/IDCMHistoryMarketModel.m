//
//  IDCMHistoryMarketModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMHistoryMarketModel.h"
#import "IDCMPriceModel.h"

@implementation IDCMHistoryMarketModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"dateList" : IDCMPriceModel.class};
}
@end
