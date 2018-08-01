//
//  IDCMBottomListTipView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseBottomTipView.h"



typedef void(^itemClickAction)(id item);
@interface IDCMBottomListTipViewItemConfigure : NSObject
typedef IDCMBottomListTipViewItemConfigure *(^clickItemConfigBlock)(itemClickAction action);
typedef IDCMBottomListTipViewItemConfigure *(^itemConfigBlock)(id value);

- (itemConfigBlock)title;
- (itemConfigBlock)customView;
- (itemConfigBlock)height;
- (clickItemConfigBlock)itemClick;

@end




typedef void (^BottomListTipViewConfigBlock)(IDCMBottomListTipViewItemConfigure *configure, NSInteger item);
typedef void(^itemClickBlock)(NSInteger index, id title);
@interface IDCMBottomListTipView : IDCMBaseBottomTipView


// 简单title
+ (void)showTipViewToView:(UIView *)toView
               titleArray:(NSArray *)titleArray // NSString 或者富文本
        itemClickCallback:(itemClickBlock)itemClickCallback;

+ (void)showTipViewToView:(UIView *)toView
               titleArray:(NSArray *)titleArray
           disabledIndexs:(NSArray *)disabledIndexs // 不能点的列
        itemClickCallback:(itemClickBlock)itemClickCallback;

// 复杂自定义view 配置每个item
+ (void)showTipViewToView:(UIView *)toView
                itmeCount:(NSInteger)itemCount
                configure:(BottomListTipViewConfigBlock)configure;

+ (void)showTipViewToView:(UIView *)toView
                itmeCount:(NSInteger)itemCount
           disabledIndexs:(NSArray *)disabledIndexs // 不能点的列
                configure:(BottomListTipViewConfigBlock)configure;


@end








