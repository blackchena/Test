//
//  IDCMDebugItemView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/30.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMDebugPosition.h"

typedef NS_ENUM(NSInteger, IDCMDebugItemViewType) {

    IDCMDebugItemViewSystem      = 1,  // 系统的样式
    IDCMDebugItemViewTypeBack    = 2,  // 返回样式
    IDCMDebugItemViewTypeText    = 3   // 文本样式
};

@interface IDCMDebugItemView : UIView

@property (nonatomic, strong) IDCMDebugPosition *position;

+ (instancetype)itemWithType:(IDCMDebugItemViewType)type;

+ (CGFloat)itemWidth;
+ (CGFloat)itemImageWidth;
+ (CGRect)contentViewSpreadFrame;
+ (CGPoint)cotentViewDefaultPoint;
+ (CGFloat)cornerRadius;
+ (CGFloat)margin;
+ (NSUInteger)maxCount;
+ (CGFloat)inactiveAlpha;
+ (CGFloat)animationDuration;
+ (CGFloat)activeDuration;
@end
