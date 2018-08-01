//
//  IDCMHistoryAssetModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMHistoryAssetModel.h"
#import "IDCMAssetListModel.h"
@implementation IDCMHistoryAssetModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"dateList" : IDCMAssetListModel.class};
}
@end
