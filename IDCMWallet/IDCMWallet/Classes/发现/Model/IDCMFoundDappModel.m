//
//  IDCMFoundDappModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/22.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMFoundDappModel.h"

@implementation IDCMDappModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"Id"};
}
@end

@implementation IDCMFoundDappModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"DappList":[IDCMDappModel class]};
}
@end
