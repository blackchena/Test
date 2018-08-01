//
//  IDCMPINLoginView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPINLoginView.h"

#import "IDCMCurrentMarketView.h"
#import "IDCMSignalRTool.h"
#import "IDCMPINNewCircleView.h"
#import "IDCMPINPasswordNumberView.h"

#define PINBigModeHeightRate (isiPhone6Big ? 0.80 : 1)
#define PINBigModeSpaceRate (isiPhone6Big ? 0.45 : 1)

@interface IDCMPINLoginView ()
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logo;
/**
 *  tip
 */
@property (strong, nonatomic) UILabel *tipsLabel;
/**
 *  实时价格
 */
@property (strong, nonatomic) IDCMCurrentMarketView *priceView;
/**
 *  原点view
 */
@property (strong, nonatomic) IDCMPINNewCircleView *circleView;
/**
 *  输入框
 */
@property (strong, nonatomic) IDCMPINPasswordNumberView *pwInputView;
/**
 *  网络状态变换Disposable
 */
@property (strong, nonatomic) RACDisposable *netstatusDisposable;
/**
 *  价格Disposable
 */
@property (strong, nonatomic) RACDisposable *priceDisposable;
@end

@implementation IDCMPINLoginView


- (instancetype)init
{
    
    if (self = [super init]) {
        self.backgroundColor = UIColorWhite;
        
        [self bindAction];
    }
    return self;
}
#pragma mark - layout subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat space = SCREEN_WIDTH*40/375;
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15+kSafeAreaTop);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@(25*PINBigModeHeightRate));
        make.width.greaterThanOrEqualTo(@80);
    }];
    [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(55+kSafeAreaTop);
        make.width.height.equalTo(@(55*PINBigModeHeightRate));
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@(55*PINBigModeHeightRate));
        make.top.equalTo(self.logo.mas_bottom).offset(45*PINBigModeSpaceRate);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@25);
        make.top.equalTo(self.priceView.mas_bottom).offset(40*PINBigModeSpaceRate);
    }];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(space);
        make.right.equalTo(self.mas_right).offset(-space);
        make.height.equalTo(@(55*PINBigModeHeightRate));
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(15);
    }];
    
    [self.pwInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@240);
        make.bottom.equalTo(self.mas_bottom).offset(-20-kSafeAreaBottom);
    }];
}
#pragma mark - Action
- (void)bindAction
{
    self.password = @"";
    
    [[IDCMSignalRTool sharedSignal] getSignalrUrl];
    
    @weakify(self);
    
    self.pwInputView.PINNumberBlock = ^(NSInteger number, IDCMPINNumberType type) {
        @strongify(self);
        if (type == IDCMPINNumberAdd) {
            if (self.password.length < 6) {
                self.password = [NSString stringWithFormat:@"%@%ld",self.password,(long)number];
                self.circleView.Password = self.password;
            }
        }else{
            if (self.password.length > 0) {
                self.password = [self.password substringToIndex:([self.password length]-1)];
                self.circleView.Password = self.password;
            }
        }
    };
    
    // 监听网络状态
    self.netstatusDisposable = [[RACObserve(IDCM_APPDelegate, networkStatus) deliverOnMainThread]
     subscribeNext:^(id  _Nullable x) {
         @strongify(self);
         if ([x integerValue] == NotReachable) { // 无网络
             self.tipsLabel.text = SWLocaloziString(@"2.0_NotNetWork");
         }else{ // 有网络
             self.tipsLabel.text = SWLocaloziString(@"2.0_PleaseEnterPayWord");
         }
     }];
    
    // 监听BTC/ETH最新价格
    self.priceDisposable = [[[IDCMSignalRTool sharedSignal].realTrendSubject deliverOnMainThread]
     subscribeNext:^(RACTuple *tupe) {
         @strongify(self);
         [self.priceView setBTCPrice:tupe.first withETHPrice:tupe.second];
     }];
}
- (void)showShakingMobilePhoneVibrate
{
    [self.circleView showShakingMobilePhoneVibrate];
    
    // 清除原有的Password
    self.password = @"";
    self.circleView.Password = self.password;
}

#pragma mark - getter
- (UIButton *)logoutButton
{
    return SW_LAZY(_logoutButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = textFontPingFangRegularFont(16);
        [button setTitle:SWLocaloziString(@"2.1_exit") forState:UIControlStateNormal];
        [button setTitleColor:textColor333333 forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:button];
        button;
    }));
}
- (UIImageView *)logo
{
    return SW_LAZY(_logo, ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        view.image = UIImageMake(@"2.2.1_PINLogo");
        [self addSubview:view];
        view;
    }));
}
- (IDCMCurrentMarketView *)priceView
{
    return SW_LAZY(_priceView, ({
        IDCMCurrentMarketView *view = [IDCMCurrentMarketView new];
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)tipsLabel
{
    return SW_LAZY(_tipsLabel, ({
        UILabel *label = [UILabel new];
        label.text = SWLocaloziString(@"2.0_PleaseEnterPayWord");
        label.textColor = textColor666666;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFontPingFangRegularFont(16);
        [self addSubview:label];
        label;
    }));
}
- (IDCMPINNewCircleView *)circleView
{
    return SW_LAZY(_circleView, ({
        IDCMPINNewCircleView *view = [IDCMPINNewCircleView new];
        [self addSubview:view];
        view;
    }));
}

- (IDCMPINPasswordNumberView *)pwInputView
{
    return SW_LAZY(_pwInputView, ({
        IDCMPINPasswordNumberView *view = [IDCMPINPasswordNumberView new];
        [self addSubview:view];
        view;
    }));
}

#pragma mark - delloc
- (void)dealloc
{
    [[IDCMSignalRTool sharedSignal] closeSignalR];

    [self.netstatusDisposable dispose];
    
    [self.priceDisposable dispose];
}
@end
