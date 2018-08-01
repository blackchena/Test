//
//  IDCMCountDotView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/6/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMCountDotView : UIView


/**
 IDCMCountDotView

 @param origin 位置
 @param imageRadius 按钮半径
 @param dotRadius 数字点半径
 @param margin 距离
 @param angle 角度
 @param image 图片
 @param countStr 数字
 @param countFont 数字字体
 @param countColor 数字颜色
 @param dotBackColor 点背景颜色
 @param clickCallback 点击回调
 @return IDCMCountDotView
 */
+ (instancetype)countDotViewWithOrigin:(CGPoint)origin
                           imageRadius:(CGFloat)imageRadius
                             dotRadius:(CGFloat)dotRadius
                             dotMargin:(CGFloat)margin
                              dotAngle:(NSUInteger)angle
                                 image:(UIImage *)image
                              countStr:(NSString *)countStr
                             countFont:(UIFont *)countFont
                            countColor:(UIColor *)countColor
                          dotBackColor:(UIColor *)dotBackColor
                         clickCallback:(CommandInputBlock)clickCallback;


- (void)refreshCountStr:(NSString *)countStr;
- (void)bindCountSignal:(RACSignal*)signal;

@property (nonatomic,strong) RACSubject *dotSignal;

@end




