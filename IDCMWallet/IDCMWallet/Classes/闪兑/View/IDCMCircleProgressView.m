//
//  IDCMCircleProgressView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/4.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMCircleProgressView.h"


@interface IDCMCircleProgressView ()
// 外界参数
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,assign) CGFloat  circleLineWidth;
@property (nonatomic,strong) UIColor *circleBackColor;
@property (nonatomic,strong) UIColor *circleColor;
@property (nonatomic,copy)   void(^finishCallback)(void);
// 内部参数
@property (nonatomic,assign) NSInteger step;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) CAShapeLayer *backlayer;
@property (nonatomic,strong) CAShapeLayer *progresslayer;
@end


@implementation IDCMCircleProgressView
+ (instancetype)circleProgressViewWithFrame:(CGRect)frame
                                 totalCount:(NSInteger)totalCount
                                 titleColor:(UIColor *)titleColor
                                  titleFont:(UIFont *)titleFont
                            circleLineWidth:(CGFloat)circleLineWidth
                            circleBackColor:(UIColor *)circleBackColor
                                circleColor:(UIColor *)circleColor
                             finishCallback:(void(^)(void))finishCallback {
    
    IDCMCircleProgressView *view = [[self alloc] init];
    view.finishCallback = [finishCallback copy];
    view.circleLineWidth = circleLineWidth;
    view.circleBackColor = circleBackColor;
    view.circleColor = circleColor;
    view.totalCount = totalCount;
    view.titleColor = titleColor;
    view.titleFont = titleFont;
    view.step = totalCount;
    view.frame = frame;
    [view initConfigre];
    return view;
}

- (void)refreshProgressWithCount:(NSInteger)count {
    if (!self.timer) {
        if (self.progresslayer.strokeColor != self.circleColor.CGColor) {
            [self configLayer];
        }
        [self drawProgressWithCount:count];
    }
}

- (void)refreshTotalCount:(NSInteger)totalCount {
    _totalCount = totalCount;
}

- (void)startTimer {
    
    if (self.timer || self.label.text.length) {return;}
    [self configLayer];
    self.label.text = [NSString stringWithFormat:@"%lds", (long)self.totalCount];
    self.timer =
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(timerAction)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)initConfigre {
    [self.layer addSublayer:self.backlayer];
    [self.layer addSublayer:self.progresslayer];
    [self addSubview:self.label];
}

- (void)configLayer {
    self.backlayer.lineWidth =
    self.progresslayer.lineWidth = self.circleLineWidth;
    self.backlayer.strokeColor = self.circleBackColor.CGColor;
    self.progresslayer.strokeColor = self.circleColor.CGColor;
}

- (void)timerAction {
    self.step -= 1;
    [self drawProgressWithCount:self.step];
}

-(void)drawProgressWithCount:(NSInteger)count {
    
    if (count <= -1) {
        self.label.text = [NSString stringWithFormat:@"%ds",0];
        !self.finishCallback ?: self.finishCallback();
        [self invalidateTimer];
    } else {
        CGFloat percent = MAX(0, (self.totalCount - count) * (M_PI*2) / self.totalCount);
        UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y) radius:self.frame.size.height/2 startAngle:(-M_PI_2) endAngle:percent-M_PI_2 clockwise:YES];
        self.progresslayer.path = [progressPath CGPath];
        self.label.text = [NSString stringWithFormat:@"%lds",(long)count];
    }
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (CAShapeLayer *)backlayer {
    return SW_LAZY(_backlayer, ({
        
        CAShapeLayer *backlayer = [CAShapeLayer layer];
        backlayer.fillColor = nil;
        UIBezierPath *backpath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y) radius:self.frame.size.height/2 startAngle:(0*M_PI) endAngle:(2*M_PI) clockwise:YES];
        backlayer.path = [backpath CGPath];
        backlayer;
    }));
}

- (CAShapeLayer *)progresslayer {
    return SW_LAZY(_progresslayer, ({
        
        CAShapeLayer *progresslayer = [CAShapeLayer layer];
        progresslayer.fillColor = nil;
        progresslayer;
    }));
}

- (UILabel *)label {
    return SW_LAZY(_label, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = self.titleColor ?: textColor333333;
        label.font = self.titleFont ?: textFontPingFangRegularFont(16);
        label.textAlignment = NSTextAlignmentCenter;
        label.size = CGSizeMake(self.width, [label.font lineHeight]);
        label.centerX = self.width / 2;
        label.centerY = self.height / 2;
        label;
    }));
}

- (void)dealloc {
    [self invalidateTimer];
}

@end



