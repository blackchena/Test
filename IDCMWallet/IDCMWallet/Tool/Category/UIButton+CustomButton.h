//
//  UIButton+CustomButton.h
//  RMTiOSApp
//
//  Created by Jason on 2016/11/2.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CustomButton)
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
+(UIButton *)creatCustomButtonNormalStateWithTitile:(NSString *)buttonTitle titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor butttonImage:(UIImage *)image backgroundImage:(UIImage *)backgroundImage backgroundColor:(UIColor *)backgroundColor clickThingTarget:(id)target action:(SEL)action;




@end
