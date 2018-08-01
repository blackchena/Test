//
//  IDCMWhiteNavigationBar.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMWhiteNavigationBar
// @abstract <#类的描述#>
// @discussion <#类的功能#>
#import "IDCMWhiteNavigationBar.h"
#import "UIView+UIViewController.h"

@implementation IDCMWhiteNavigationBar

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}


#pragma mark - Public Methods


#pragma mark - Privater Methods
- (void)initUI
{
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(15);
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(kSafeAreaTop+10);
        make.height.equalTo(@25);
        make.width.equalTo(@60);
    }];
    [self.titlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(kSafeAreaTop+10);
        make.height.equalTo(@25);
        make.width.equalTo(@300);
    }];
    
    @weakify(self);
    [[[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         
         @strongify(self);
         self.backBtnCallbak ? self.backBtnCallbak() : nil;
         if ([self viewController].presentingViewController) {
             [self.viewController dismissViewControllerAnimated:YES completion:nil];
         } else {
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

#pragma mark - Action


#pragma mark - Getter & Setter
- (UIButton *)backButton
{
    return SW_LAZY(_backButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"2.0_fanhuihei"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"2.0_fanhuihei"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:button];
        button;
    }));
}
- (UILabel *)titlelable
{
    return SW_LAZY(_titlelable, ({
        UILabel *view = [UILabel new];
        view.textColor = kSubtopicBlackColor;
        view.font = textFontPingFangMediumFont(18);
        view.textAlignment = NSTextAlignmentCenter;
        [self addSubview:view];
        view;
    }));
}

@end
