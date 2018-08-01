//
//  IDCMCountDotView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/6/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMCountDotView.h"
#import <math.h>


@interface IDCMCountDotView ()
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,assign) CGFloat imageRadius;
@property (nonatomic,assign) CGFloat dotRadius;
@property (nonatomic,assign) CGFloat margin;
@property (nonatomic,assign) NSUInteger angle;
@end


@implementation IDCMCountDotView
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
                         clickCallback:(CommandInputBlock)clickCallback {
    
    IDCMCountDotView *view = [[IDCMCountDotView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.dotRadius = dotRadius;
    view.imageRadius = imageRadius;
    view.dotRadius = dotRadius;
    view.margin = margin;
    view.angle = angle;
    view.origin = origin;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setBackgroundImage:image forState:UIControlStateNormal];
//    [btn setBackgroundImage:image forState:UIControlStateHighlighted];
    
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    btn.imageView.contentMode = UIViewContentModeScaleToFill;
    
    btn.size = CGSizeMake(imageRadius * 2, imageRadius * 2);
    btn.bottom = view.height;
    [view setRadius:btn];
    [view addSubview:btn];
    view.btn = btn;
    btn.rac_command = RACCommand.emptyCommand(clickCallback);
//    [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
//     subscribeNext:^(UIControl *x) {
//         @strongify(btn);
//         [view animationWithView:btn completion:clickCallback];
//     }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorWhite;
    label.font = countFont ?: textFontPingFangRegularFont(14);
    label.text = countStr;
    label.textColor = countColor ?: UIColorWhite;
    label.backgroundColor = dotBackColor ?: [UIColor colorWithHexString:@"#FF3F3F"];
    label.textAlignment = NSTextAlignmentCenter;
    label.size = CGSizeMake(dotRadius * 2, dotRadius * 2);
    label.hidden = ![countStr integerValue];
    [view setRadius:label];
    [view addSubview:label];
    view.label = label;
    
    [view configLayout];
    
    return view;
}


- (void)configLayout {
    NSUInteger angle = self.angle;
    angle = angle % 360;
    
    CGFloat circleDistance = self.dotRadius + self.imageRadius + self.margin;
    CGFloat radiusMargin =  self.imageRadius + self.dotRadius;
    CGFloat circleDistanceWidth = 0.0;
    CGFloat circleDistanceHeight = 0.0;
    
    if (angle < 90) {
        
        circleDistanceWidth =  circleDistance * sin(angle * (M_PI/180.0));
        circleDistanceHeight = circleDistance * cos(angle * (M_PI/180.0));
        CGFloat width = radiusMargin + circleDistanceWidth;
        CGFloat height = radiusMargin + circleDistanceHeight;
        CGFloat tempWidth = width;
        CGFloat tempHeight = height;
        if (width < self.imageRadius * 2) {
            tempWidth = self.imageRadius * 2;
        }
        if (height < self.imageRadius * 2) {
            tempHeight = self.imageRadius * 2;
        }
        self.size = CGSizeMake(tempWidth, tempHeight);
        self.label.right = self.width;
        self.label.top = 0;
        self.btn.bottom = self.height;
        self.btn.left = 0;
        if (width < self.imageRadius * 2) {
            self.label.right = self.imageRadius + circleDistanceWidth + self.dotRadius;
        }
        if (height < self.imageRadius * 2) {
            self.label.top =  self.imageRadius - (circleDistanceHeight + self.dotRadius);
        }
        
    } else if (angle >= 90 && angle < 180) {
        angle = 180 - angle;
        
        circleDistanceWidth =  circleDistance * sin(angle * (M_PI/180.0));
        circleDistanceHeight = circleDistance * cos(angle * (M_PI/180.0));
        CGFloat width = radiusMargin + circleDistanceWidth;
        CGFloat height = radiusMargin + circleDistanceHeight;
        CGFloat tempWidth = width;
        CGFloat tempHeight = height;
        if (width < self.imageRadius * 2) {
            tempWidth = self.imageRadius * 2;
        }
        if (height < self.imageRadius * 2) {
            tempHeight = self.imageRadius * 2;
        }
        self.size = CGSizeMake(tempWidth, tempHeight);
        
        self.btn.left = 0;
        self.btn.top = 0;
        self.label.right = self.width;
        self.label.bottom = self.height;
        if (width <self. imageRadius * 2) {
            self.label.right = self.imageRadius + circleDistanceWidth + self.dotRadius;
        }
        if (height < self.imageRadius * 2) {
            self.label.bottom =  self.imageRadius + (circleDistanceHeight + self.dotRadius);
        }
        
    } else if (angle >= 180 && angle < 270) {
        angle = angle - 180;
        
        circleDistanceWidth =  circleDistance * sin(angle * (M_PI/180.0));
        circleDistanceHeight = circleDistance * cos(angle * (M_PI/180.0));
        CGFloat width = radiusMargin + circleDistanceWidth;
        CGFloat height = radiusMargin + circleDistanceHeight;
        CGFloat tempWidth = width;
        CGFloat tempHeight = height;
        if (width < self.imageRadius * 2) {
            tempWidth = self.imageRadius * 2;
        }
        if (height < self.imageRadius * 2) {
            tempHeight = self.imageRadius * 2;
        }
        self.size = CGSizeMake(tempWidth, tempHeight);
        
        self.label.bottom = self.height;
        self.label.left = 0;
        self.btn.right = self.width;
        self.btn.top = 0;
        if (width < self.imageRadius * 2) {
            self.label.left = self.imageRadius - (circleDistanceWidth + self.dotRadius);
        }
        if (height < self.imageRadius * 2) {
            self.label.bottom =  self.imageRadius + (circleDistanceHeight + self.dotRadius);
        }
        
    } else {
        angle = angle - 270;
        
        circleDistanceWidth =  circleDistance * sin(angle * (M_PI/180.0));
        circleDistanceHeight = circleDistance * cos(angle * (M_PI/180.0));
        CGFloat width = radiusMargin + circleDistanceWidth;
        CGFloat height = radiusMargin + circleDistanceHeight;
        CGFloat tempWidth = width;
        CGFloat tempHeight = height;
        if (width < self.imageRadius * 2) {
            tempWidth = self.imageRadius * 2;
        }
        if (height < self.imageRadius * 2) {
            tempHeight = self.imageRadius * 2;
        }
        self.size = CGSizeMake(tempWidth, tempHeight);
        self.btn.bottom = self.height;
        self.btn.right = self.width;
        self.label.left = 0;
        self.label.top = 0;
        
        if (width < self.imageRadius * 2) {
            self.label.left = self.imageRadius - (circleDistanceWidth + self.dotRadius);
        }
        if (height < self.imageRadius * 2) {
            self.label.top = self.imageRadius - (circleDistanceHeight + self.dotRadius);
        }
    }
}

- (void)bindCountSignal:(RACSignal *)signal {
    
    @weakify(self);
    [signal subscribeNext:^(NSString *x) {
        @strongify(self);
        [self.dotSignal sendNext:@([x integerValue])];
        [self refreshCountStr:x];
    }];
}

- (void)refreshCountStr:(NSString *)countStr {
    self.label.hidden = ![countStr integerValue];
    countStr = [countStr integerValue] > 99 ? @"99+" : countStr;
    CGFloat width = [countStr widthForFont:self.label.font];
    if (width > self.dotRadius * 2 - 4) {
        self.dotRadius = width / 2 + 4;
        self.label.size = CGSizeMake(self.dotRadius * 2, self.dotRadius * 2);
        [self setRadius:self.label];
        [self configLayout];
    }
    self.label.text = countStr;
    [self animationWithView:self.label completion:nil];
}

- (void)setRadius:(UIView *)view {
    view.layer.cornerRadius = view.width / 2;
    view.layer.masksToBounds = YES;
}

- (void)animationWithView:(UIView *)view
               completion:(void(^)(UIView *))completion {
    
    [UIView animateWithDuration:0.1
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [view.layer setValue:@(1.15) forKeyPath:@"transform.scale"];
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.1
                                                  delay:0
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 [view.layer setValue:@(1) forKeyPath:@"transform.scale"];
                                             } completion:^(BOOL finished) {
                                                 !completion ?: completion(view);
                                             }];
                        }];
}

@end












