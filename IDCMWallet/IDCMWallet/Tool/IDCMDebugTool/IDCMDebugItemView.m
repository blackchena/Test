//
//  IDCMDebugItemView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/30.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMDebugItemView.h"

typedef NS_ENUM(NSInteger, IDCMInnerCircle) {
    IDCMInnerCircleSmall,
    IDCMInnerCircleMiddle,
    IDCMInnerCircleLarge
};

@implementation IDCMDebugItemView

+ (instancetype)itemWithType:(IDCMDebugItemViewType)type{
    
    CALayer *layer = nil;
    switch (type) {
        case IDCMDebugItemViewTypeBack:
            layer = [self createLayerSystemType];
            break;
        case IDCMDebugItemViewTypeText:
            layer = [self createLayerWithText];
            break;
        default:
            layer = [self createLayerSystemType];
            break;
    }
    IDCMDebugItemView *item = [[self alloc] initWithLayer:layer];
    if (type == IDCMDebugItemViewSystem) {
        item.bounds = CGRectMake(0, 0, [self itemImageWidth], [self itemImageWidth]);
        item.layer.zPosition = FLT_MAX;
    }
    return item;
}
- (instancetype)initWithLayer:(nullable CALayer *)layer {
    self = [super initWithFrame:CGRectMake(0, 0, [IDCMDebugItemView itemWidth], [IDCMDebugItemView itemWidth])];
    if (self) {
        if (layer) {
            layer.contentsScale = [UIScreen mainScreen].scale;
            if (CGRectEqualToRect(layer.bounds, CGRectZero)) {
                layer.bounds = CGRectMake(0, 0, [IDCMDebugItemView itemImageWidth], [IDCMDebugItemView itemImageWidth]);
            }
            if (CGPointEqualToPoint(layer.position, CGPointZero)) {
                layer.position = CGPointMake([IDCMDebugItemView itemWidth] / 2,
                                             [IDCMDebugItemView itemWidth] / 2);
            }
            [self.layer addSublayer:layer];
        }
    }
    return self;
}
#pragma mark - CreateLayer

+ (CALayer *)createLayerSystemType {
    CALayer *layer = [CALayer layer];
    [layer addSublayer:[[self class] createInnerCircle:IDCMInnerCircleLarge]];
    [layer addSublayer:[[self class] createInnerCircle:IDCMInnerCircleMiddle]];
    [layer addSublayer:[[self class] createInnerCircle:IDCMInnerCircleSmall]];
    layer.position = CGPointMake([self itemImageWidth] / 2, [self itemImageWidth] / 2);
    return layer;
}

+ (CALayer *)createLayerBackType {
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGSize size = CGSizeMake(22, 22);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width / 2, 8.5 + size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width / 2, 3.5 + size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width, 3.5 + size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width, -3.5 + size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width / 2, -3.5 + size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width / 2, -8.5 + size.height / 2)];
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 2;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.bounds = CGRectMake(0, 0, size.width, size.height);
    return layer;
}

+ (CALayer *)createLayerWithText{
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGRect bounds = CGRectMake(0, 0, [self itemImageWidth], [self itemImageWidth]);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:bounds];
    [path appendPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectInset(bounds, 3, 3)] bezierPathByReversingPath]];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.bounds = bounds;
    
    CATextLayer *textLayer = [CATextLayer layer];
    NSString *addStr = [CommonUtils getStrValueInUDWithKey:DebugSetServerAddKey];
    NSString *enStr = @"";
    if (addStr && [addStr isNotBlank]) {
        
        if ([addStr isEqualToString:@"00"]) {
            enStr = @"测试环境";
            [IDCMServerConfig setHTConfigEnv:@"00"];
        }else if([addStr isEqualToString:@"01"]){
            enStr = @"正式环境";
            [IDCMServerConfig setHTConfigEnv:@"01"];
        }else if([addStr isEqualToString:@"02"]){
            enStr = @"预发布";
            [IDCMServerConfig setHTConfigEnv:@"02"];
        }else if([addStr isEqualToString:@"03"]){
            enStr = @"开发环境";
            [IDCMServerConfig setHTConfigEnv:@"03"];
        }else if([addStr isEqualToString:@"04"]){
            enStr = @"灰度环境";
            [IDCMServerConfig setHTConfigEnv:@"04"];
        }else{
            enStr = @"外网映射";
            [IDCMServerConfig setHTConfigEnv:@"05"];
        }
        
    }else{
        enStr = @"开发环境";
        [IDCMServerConfig setHTConfigEnv:@"03"];
        [CommonUtils saveStrValueInUD:@"03" forKey:DebugSetServerAddKey];
    }
    
    textLayer.string = enStr;
    textLayer.fontSize = 12;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.frame = CGRectMake(0, [self itemImageWidth]*0.5-10, [self itemImageWidth], 20);;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [layer addSublayer:textLayer];
    
    return layer;
}

+ (CAShapeLayer *)createInnerCircle:(IDCMInnerCircle)circleType {

    CGFloat circleAlpha = 0;
    CGFloat radius = 0;
    CGFloat borderAlpha = 0;
    switch (circleType) {
        case IDCMInnerCircleSmall: {
            circleAlpha = 1;
            radius = IS_IPAD ? 16: 14.5;
            borderAlpha = 0.3;
            break;
        } case IDCMInnerCircleMiddle: {
            circleAlpha = 0.4;
            radius = IS_IPAD ? 20: 18.5;
            borderAlpha = 0.15;
            break;
        } case IDCMInnerCircleLarge: {
            circleAlpha = 0.2;
            radius = IS_IPAD ? 24: 22;
            borderAlpha = 0;
            break;
        } default: {
            break;
        }
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGPoint position = CGPointMake([self itemImageWidth] / 2, [self itemImageWidth] / 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:position radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    layer.fillColor = [UIColor colorWithWhite:1 alpha:circleAlpha].CGColor;
    layer.strokeColor = [UIColor colorWithWhite:0 alpha:borderAlpha].CGColor;
    layer.bounds = CGRectMake(0, 0, [self itemImageWidth], [self itemImageWidth]);
    layer.position = CGPointMake(position.x, position.y);
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}
+ (CGFloat)itemWidth{
    
    return CGRectGetWidth([self contentViewSpreadFrame]) / 3.0;
}
+ (CGFloat)itemImageWidth{
    
    return IS_IPAD ? 76: 60;
}
+ (CGRect)contentViewSpreadFrame {
    CGFloat spreadWidth = IS_IPAD ? 390: 295;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake((CGRectGetWidth(screenFrame) - spreadWidth) / 2,
                              (CGRectGetHeight(screenFrame) - spreadWidth) / 2,
                              spreadWidth, spreadWidth);
    return frame;
}

+ (CGPoint)cotentViewDefaultPoint {
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGPoint point = CGPointMake(CGRectGetWidth(screenFrame)
                                - [self itemImageWidth] / 2
                                - 2,
                                CGRectGetMidY(screenFrame));
    return point;
}

+ (CGFloat)cornerRadius {
    return 14;
}

+ (CGFloat)margin {
    return 2;
}

+ (NSUInteger)maxCount {
    return 8;
}

+ (CGFloat)inactiveAlpha {
    return 0.4;
}

+ (CGFloat)animationDuration {
    return 0.25;
}

+ (CGFloat)activeDuration {
    return 4;
}

@end
