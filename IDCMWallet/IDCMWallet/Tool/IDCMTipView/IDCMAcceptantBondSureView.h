//
//  IDCMAcceptantBondSureView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseBottomTipView.h"

typedef NS_ENUM(NSInteger , IDCMCloseButtonImageType) {
    IDCMCloseButtonImageCloseType              = 1, // 按钮为关闭样式
    IDCMCloseButtonImageBackType               = 2, // 按钮为返回样式
};

@interface IDCMAcceptantBondSureView : IDCMBaseBottomTipView


/**
 创建一个信息展示的View，默认关闭的样式为关闭样式

 @param title 标题
 @param subTitle 副标题
 @param btnTitle 确认按钮的标题
 @param arr 展示的信息，为一个元组数组
 @param closeBtnInput 关闭按钮事件
 @param sureBtnInput 确认按钮事件
 @return 信息展示的View
 */
+ (instancetype)bondSureViewWithTitle:(NSString *)title
                             subTitle:(NSString *)subTitle
                         sureBtnTitle:(NSString *)btnTitle
                            confidArr:(NSArray <RACTuple *> *)arr
                        closeBtnInput:(CommandInputBlock)closeBtnInput
                         sureBtnInput:(CommandInputBlock)sureBtnInput;


/**
 创建一个信息展示的View

 @param buttontype 关闭按钮的样式
 @param title 标题
 @param subTitle 副标题
 @param btnTitle 确认按钮的标题
 @param arr 展示的信息，为一个元组数组
 @param closeBtnInput 关闭按钮事件
 @param sureBtnInput 确认按钮事件
 @param updateSignal 更新数据信号
 @param templeSignal 确认按钮是否可用信号
 @return 信息展示的View
 */
+ (instancetype)bondSureViewWithCloseButtonType:(IDCMCloseButtonImageType)buttontype
                                          Title:(NSString *)title
                                       subTitle:(NSString *)subTitle
                                   sureBtnTitle:(NSString *)btnTitle
                                      confidArr:(NSArray <RACTuple *> *)arr
                                  closeBtnInput:(CommandInputBlock)closeBtnInput
                                   sureBtnInput:(CommandInputBlock)sureBtnInput
                               updateDataSignal:(RACSignal *)updateSignal
                                   templeSignal:(RACSignal *)templeSignal;
@end




