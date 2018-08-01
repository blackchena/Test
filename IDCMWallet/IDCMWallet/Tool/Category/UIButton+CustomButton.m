//
//  UIButton+CustomButton.m
//  RMTiOSApp
//
//  Created by Jason on 2016/11/2.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "UIButton+CustomButton.h"

@implementation UIButton (CustomButton)
/**
 *  快速创建一个正常状态下的按钮
 *
 *  @param buttonTitle     按钮的标题
 *  @param titleFont       按钮标题的字体
 *  @param titleColor      按钮标题的字体颜色
 *  @param image           按钮的图片
 *  @param backgroundImage 按钮的背景图片
 *  @param target          点击事件对象
 *  @param action          点击事件
 *  @param backgroundColor 按钮的背景颜色
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)creatCustomButtonNormalStateWithTitile:(NSString *)buttonTitle titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor butttonImage:(UIImage *)image backgroundImage:(UIImage *)backgroundImage backgroundColor:(UIColor *)backgroundColor clickThingTarget:(id)target action:(SEL)action
{
    //创建按钮
    UIButton *button = [[self class] buttonWithType:UIButtonTypeCustom];
    //设置按钮的标题
    if (buttonTitle) {[button setTitle:buttonTitle forState:UIControlStateNormal];}
    //设置按钮的字体
    if (titleFont) {button.titleLabel.font = titleFont;}
    //设置按钮的字体颜色
    if (titleColor) { [button setTitleColor:titleColor forState:UIControlStateNormal];}
    //设置按钮的图标
    if (image) {[button setImage:image forState:UIControlStateNormal];}
    //设置按钮的背景图标
    if (backgroundImage) {[button setBackgroundImage:backgroundImage forState:UIControlStateNormal];}
    //设置按钮背景颜色
    if (backgroundColor) {[button setBackgroundColor:backgroundColor];}
    //设置按钮的点击事件
    if (target && action) {[button addButtonTouchUpInsideTarget:target action:action];}
    return button;
    
}
/**
 *  给按钮增加一个点击事件
 *
 *  @param target 时间的对象
 *  @param action 事件
 */
- (void)addButtonTouchUpInsideTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
