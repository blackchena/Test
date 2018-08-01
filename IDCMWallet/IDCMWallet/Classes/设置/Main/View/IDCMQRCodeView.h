//
//  IDCMQRCodeView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/3.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMQRCodeView : UIView
/**
 创建一个展示二维码的View
 
 
 @param btnTitle 确认按钮的标题
 @param dataTupe 展示的信息，为一个元组
 @param sureBtnInput 关闭按钮事件
 @return 信息展示的View
 */
+ (instancetype)bondSureViewWithSureBtnTitle:(NSString *)btnTitle
                                  confidTupe:(RACTuple *)dataTupe
                                sureBtnInput:(CommandInputBlock)sureBtnInput;
@end
