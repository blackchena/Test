//
//  IDCMPINNewCircleView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/16.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPINNewCircleView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface IDCMPINNewCircleView ()
/**
 *  line
 */
@property (strong, nonatomic) UIView *topLine;
/**
 *  line
 */
@property (strong, nonatomic) UIView *bottomLine;
/**
 *  Circle
 */
@property (strong, nonatomic) UIView *one;
/**
 *  Circle
 */
@property (strong, nonatomic) UIView *two;
/**
 *  Circle
 */
@property (strong, nonatomic) UIView *three;
/**
 *  Circle
 */
@property (strong, nonatomic) UIView *four;
/**
 *  Circle
 */
@property (strong, nonatomic) UIView *five;
/**
 *  Circle
 */
@property (strong, nonatomic) UIView *six;
/**
 *  原点数组
 */
@property (strong, nonatomic) NSArray *arrayList;
@end

@implementation IDCMPINNewCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.arrayList = @[self.one,self.two,self.three,self.four,self.five,self.six];
        
        @weakify(self);
        
        RACSignal *passwordSignal = [RACObserve(self, Password) distinctUntilChanged];
        
        [[passwordSignal deliverOnMainThread]
         subscribeNext:^(NSString *password) {
             @strongify(self);
             NSInteger length = password.length;
             [self.arrayList enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
                 if (idx < length) {
                     view.backgroundColor = kThemeColor;
                 }else{
                     view.backgroundColor = SetColor(192, 197, 208);
                 }
             }];
         }];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.left.right.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    [self.arrayList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:14 leadSpacing:15 tailSpacing:15];
    
    [self.arrayList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@14);
    }];
}
#pragma mark  -- animation
- (void)showShakingMobilePhoneVibrate
{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self shakeAnimationForView:self];
    
}

- (void)shakeAnimationForView:(UIView *) view
{
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:.06];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}
#pragma mark - getter
- (UIView *)topLine
{
    return SW_LAZY(_topLine, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(229, 237, 255);
        [self addSubview:view];
        view;
    }));
}
- (UIView *)bottomLine
{
    return SW_LAZY(_bottomLine, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(229, 237, 255);
        [self addSubview:view];
        view;
    }));
}
- (UIView *)one
{
    return SW_LAZY(_one, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(192, 197, 208);
        view.layer.cornerRadius = 7;
        [self addSubview:view];
        view;
    }));
}
- (UIView *)two
{
    return SW_LAZY(_two, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(192, 197, 208);
        view.layer.cornerRadius = 7;
        [self addSubview:view];
        view;
    }));
}
- (UIView *)three
{
    return SW_LAZY(_three, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(192, 197, 208);
        view.layer.cornerRadius = 7;
        [self addSubview:view];
        view;
    }));
}- (UIView *)four
{
    return SW_LAZY(_four, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(192, 197, 208);
        view.layer.cornerRadius = 7;
        [self addSubview:view];
        view;
    }));
}
- (UIView *)five
{
    return SW_LAZY(_five, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(192, 197, 208);
        view.layer.cornerRadius = 7;
        [self addSubview:view];
        view;
    }));
}
- (UIView *)six
{
    return SW_LAZY(_six, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(192, 197, 208);
        view.layer.cornerRadius = 7;
        [self addSubview:view];
        view;
    }));
}
@end
