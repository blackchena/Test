//
//  IDCMWithdrawalAddressView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/27.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMSendAddressView.h"

typedef NS_ENUM(NSInteger , IDCMWithdrawCloseButtonImageType) {
    IDCMWithdrawCloseButtonImageCloseType              = 1, // 按钮为关闭样式
    IDCMWithdrawCloseButtonImageBackType               = 2, // 按钮为返回样式
};

@interface IDCMWithdrawalAddressView : UIView
/**
 *  接收地址
 */
@property (strong, nonatomic) IDCMSendAddressView *reciveView;
/**
 *  提取按钮
 */
@property (strong, nonatomic) UIButton *rechargeBtn;
/**
 创建一个信息展示的View
 
 @param buttontype 关闭按钮的样式
 @param title 标题
 @param subTitle 副标题
 @param btnTitle 确认按钮的标题
 @param pasteBtnInput 粘贴按钮事件
 @param scanBtnInput  扫一扫按钮事件
 @param closeBtnInput 关闭按钮事件
 @param sureBtnInput 确认按钮事件
 @return 信息展示的View
 */
+ (instancetype)bondSureViewWithCloseButtonType:(IDCMWithdrawCloseButtonImageType)buttontype
                                          Title:(NSString *)title
                                       subTitle:(NSString *)subTitle
                                   sureBtnTitle:(NSString *)btnTitle
                                  pasteBtnInput:(CommandInputBlock)pasteBtnInput
                                   scanBtnInput:(CommandInputBlock)scanBtnInput
                                  closeBtnInput:(CommandInputBlock)closeBtnInput
                                   sureBtnInput:(CommandInputBlock)sureBtnInput
                                   templeSignal:(RACSignal *)templeSignal;
@end
