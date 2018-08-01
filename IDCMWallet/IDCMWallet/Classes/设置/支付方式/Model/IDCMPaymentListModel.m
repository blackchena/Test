//
//  IDCMPaymentListModel.m
//  IDCMWallet
//
//  Created by IDCM on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPaymentListModel.h"

@implementation IDCMPaymentListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"PayAttributes":[IDCMPayListAttributesModel class]};
}
@end

@implementation IDCMPayListAttributesModel

@end
