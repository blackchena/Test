//
//  IDCMDebugPosition.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMDebugPosition.h"
#import "IDCMDebugItemView.h"

@implementation IDCMDebugPosition

+ (instancetype)positionWithCount:(NSInteger)count index:(NSInteger)index {
    return [[self alloc] initWithCount:count index:index];
}

- (instancetype)init {
    return [self initWithCount:0 index:0];
}

- (instancetype)initWithCount:(NSInteger)count index:(NSInteger)index {
    self = [super init];
    if (self) {
        _count = count < 0? 0: count;
        _count = _count > [IDCMDebugItemView maxCount] ? [IDCMDebugItemView maxCount] : _count;
        _index = index < 0 ? 0: index;
        _index = _index > _count? [IDCMDebugItemView maxCount] : _index;
        _center = [self getCenter];
        _frame = [self getFrame];
    }
    return self;
}

- (CGPoint)getCenter {
    
    NSInteger count = _count;
    NSInteger index = _index;
    if (!_count) {
        count = 1;
        index = 1;
    }
    CGFloat angle = 5 * M_PI_2 - M_PI * 2 / count * index;
    CGFloat k = tan(angle);
    CGFloat x;
    CGFloat y;
    if (M_PI_4 * 9 < angle || angle <= M_PI_4 * 3) {
        y = [IDCMDebugItemView itemWidth];
        if (angle == M_PI_2 * 5 || angle == M_PI_2 * 3) {
            x = 0;
        } else {
            x = y / k;
        }
    } else if (M_PI_4 * 7 < angle && angle <= M_PI_4 * 9) {
        x = [IDCMDebugItemView itemWidth];
        y = k * x;
    } else if (M_PI_4 * 5 < angle && angle <= M_PI_4 * 7) {
        y = -[IDCMDebugItemView itemWidth];
        if (angle == M_PI_2 * 5 || angle == M_PI_2 * 3) {
            x = 0;
        } else {
            x = y / k;
        }
    } else if (M_PI_4 * 3 < angle && angle <= M_PI_4 * 5) {
        x = -[IDCMDebugItemView itemWidth];
        y = k * x;
    }
    CGPoint center = [self coordinatesTransform:CGPointMake(x, y)];
    return center;
}

- (CGRect)getFrame {
    CGPoint center = self.center;
    CGRect frame = CGRectMake(center.x - [IDCMDebugItemView itemWidth] / 2,
                              center.y - [IDCMDebugItemView itemWidth] / 2,
                              [IDCMDebugItemView itemWidth],
                              [IDCMDebugItemView itemWidth]);
    return frame;
}

- (CGPoint)coordinatesTransform:(CGPoint)point {
    CGRect rect = [UIScreen mainScreen].bounds;
    CGPoint screenCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    point.y = -point.y;
    CGPoint transformPoint = CGPointMake(screenCenter.x + point.x,
                                         screenCenter.y + point.y);
    return transformPoint;
}

@end
