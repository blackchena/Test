//
//  IDCMCircleProgressView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/4.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMCircleProgressView : UIView

/**
 创建

 @param frame frame
 @param totalCount 总时间
 @param titleColor 中间标题颜色
 @param titleFont 中间标题字体
 @param circleLineWidth 圆圈宽度
 @param circleBackColor 默认圆颜色
 @param circleColor 圆颜色
 @param finishCallback 完成回调
 @return IDCMCircleProgressView
 */
+ (instancetype)circleProgressViewWithFrame:(CGRect)frame
                                 totalCount:(NSInteger)totalCount
                                 titleColor:(UIColor *)titleColor
                                  titleFont:(UIFont *)titleFont
                            circleLineWidth:(CGFloat)circleLineWidth
                            circleBackColor:(UIColor *)circleBackColor
                                circleColor:(UIColor *)circleColor
                             finishCallback:(void(^)(void))finishCallback;


/**
 外界刷新 内部不创建定时器

 @param count 时间count
 */
- (void)refreshProgressWithCount:(NSInteger)count;
- (void)refreshTotalCount:(NSInteger)totalCount;



/**
 开始计时进度 内部会创建定时器
 */
- (void)startTimer;
- (void)invalidateTimer;



@end







