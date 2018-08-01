//
//  IDCMCustomerTextField.m
//  IDCMWallet
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMCustomerTextField.h"

@implementation IDCMCustomerTextField

//-(CGRect)leftViewRectForBounds:(CGRect)bounds{
//
//    CGRect leftRect = [super leftViewRectForBounds:bounds];
//
//    leftRect.origin.x =10;
//
//    return leftRect;
//
//}
-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightRect = [super rightViewRectForBounds:bounds];
    rightRect.origin.x = rightRect.origin.x + 2;
    return rightRect;
}
@end
