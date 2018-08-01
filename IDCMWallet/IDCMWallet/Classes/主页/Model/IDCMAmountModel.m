//
//  IDCMAmountModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/1.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMAmountModel.h"
#import "IDCMHistoryAssetModel.h"
#import "IDCMHistoryMarketModel.h"

@implementation IDCMAmountModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"historyAssetData" : IDCMHistoryAssetModel.class,
             @"historyMarketData": IDCMHistoryMarketModel.class
             };
}
@end
