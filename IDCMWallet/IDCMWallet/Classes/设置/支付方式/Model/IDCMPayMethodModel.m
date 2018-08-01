//
//  IDCMPayMethodModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPayMethodModel.h"

@implementation IDCMPayMethodModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"CurrencyPaytypeList":[IDCMCurrencyPaytypeListItemModel class],@"LocalCurrencyList":[IDCMLocalCurrencyListItemModel class],@"PaytypeList":[IDCMPaytypeListItemModel class]};
}
@end

@implementation IDCMCurrencyPaytypeListItemModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"Attributes":[IDCMAttributesItemModel class]};
}
@end


@implementation IDCMLocalCurrencyListItemModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"PaytypeList":[IDCMPaytypeListItemModel class]};
}
@end


@implementation IDCMPaytypeListItemModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"LocalCurrencyList":[IDCMLocalCurrencyListItemModel class]};
}
@end


@implementation IDCMAttributesItemModel

@end
