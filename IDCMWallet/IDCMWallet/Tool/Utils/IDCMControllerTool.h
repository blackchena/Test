//
//  IDCMControllerTool.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
// 控制器工具栏

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,IDCMPINLoginViewAnmiantionType) {
    IDCMPINLoginViewAnmiantionType_None,//没有动画
    IDCMPINLoginViewAnmiantionType_Discover,//渐变
    IDCMPINLoginViewAnmiantionType_Top_To_Bottom,//从上往下
    IDCMPINLoginViewAnmiantionType_Bottom_To_Top,//从下往上
    IDCMPINLoginViewAnmiantionType_Push_Left_To_Right,//从左往右
    IDCMPINLoginViewAnmiantionType_Push_Right_To_Left,//从右往左
};


@interface IDCMControllerTool : NSObject

/**
 展示输入PIN控制器
 */
+ (void)showInputPINNumberController;

/**
  展示 AlertView的方法

 @param title 需要展示的标题  14px PingFangSC-Regular  333333
 @param message 消息提示     12px PingFangSC-Regular  666666
 @param buttonArray 按钮的标题数组
 @param actionBlock 点击按钮的回调 clickIndex点击的下标
 */
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonArray:(NSArray *)buttonArray actionBlock:(void(^)(NSInteger clickIndex))actionBlock;



/**
 展示 AlertView的方法

 @param title 需要展示的标题
 @param titleFont 需要展示的标题的字体
 @param titleColor 需要展示的标题的颜色
 @param message 消息提示
 @param messageFont 消息提示的字体
 @param messageColor 消息提示的颜色
 @param buttonArray 按钮的标题数组
 @param index 需要加背景颜色的按钮
 @param actionBlock 点击按钮的回调 clickIndex点击的下标
 */
+ (void)showAlertViewWithTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor message:(NSString *)message messageFont:(UIFont *)messageFont messageColor:(UIColor *)messageColor buttonArray:(NSArray *)buttonArray colorIndex:(NSInteger)index actionBlock:(void(^)(NSInteger clickIndex))actionBlock;

/**
 移除view
 */
+ (void)dissmissAlertView;

+ (void)bringToFront;
@end
