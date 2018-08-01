//
//  IDCMScrollViewPageTipView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ScrollViewPageTipViewPositionType) {
    ScrollViewPageTipViewPositionType_Center = 0,
    ScrollViewPageTipViewPositionType_Bottom
};


@interface IDCMScrollViewPageTipView : UIView

/**
 滚动tipView
 
 @param toView toView数组
 @param contentViews 内容数组
 @param contentSizes 内容size数组 当多个内容只传一个size则所有内容大小都是size
 @param initialPageIndex 初始化在第一页
 @param scrollEnabled 是否能滚动
 @param positionType 位置
 */
+ (void)showTipViewToView:(UIView *)toView
             contentViews:(NSArray<UIView *> *)contentViews
             contentSizes:(NSArray *)contentSizes
         initialPageIndex:(NSInteger)initialPageIndex
            scrollEnabled:(BOOL)scrollEnabled
             positionType:(ScrollViewPageTipViewPositionType)positionType;


+ (void)scrollToLastPage;  // 滚到上一页
+ (void)scrollToNextPage; // 滚到下一页
+ (void)scrollToPageIndex:(NSInteger)pageIndex;  // 滚到指定页
+ (void)reSetScrollEnabled:(BOOL)scrollEnabled; // 设置滚动

+ (void)showHUD;     // 添加菊花 窗口
+ (void)dismissHUD; // 消除菊花 窗口

+ (void)dismissWithComletion:(void(^)(void))completion; // 消失及消失完成回调 窗口


@end










