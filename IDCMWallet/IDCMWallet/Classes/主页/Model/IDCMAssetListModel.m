//
//  IDCMAssetListModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAssetListModel.h"

@implementation IDCMAssetListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"timeDate" : @"date"};
}
@end
