//
//  IDCMTradingPageNavigationBar.m
//  IDCMWallet
//
//  Created by BinBear on 2018/4/27.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMTradingPageNavigationBar.h"

@implementation IDCMTradingPageNavigationBar

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}


#pragma mark - Public Methods
- (void)showTabBadgePoint{
    
    self.dotView.hidden = NO;
}
- (void)removeTabBadgePoint{
    
    self.dotView.hidden = YES;
}
#pragma mark - Privater Methods
- (void)initUI
{
    self.backgroundColor = kThemeColor;
    
    [self.swapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(70);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.equalTo(@25);
    }];
    
    [self.OTCButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-70);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.equalTo(@25);
    }];
    [self.swapLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.height.equalTo(@2);
        make.width.left.equalTo(self.swapButton);
    }];
    [self.OTCLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.height.equalTo(@2);
        make.width.left.equalTo(self.OTCButton);
    }];
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@9);
        make.top.equalTo(self.OTCButton.mas_top);
        make.left.equalTo(self.OTCButton.mas_right);
    }];
}

#pragma mark - Action


#pragma mark - Getter & Setter
- (QMUIButton *)swapButton
{
    return SW_LAZY(_swapButton, ({
        QMUIButton *button = [[QMUIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"3.0_UnselectSwap"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"3.0_SelectSwap"] forState:UIControlStateSelected];
        [button setTitle:SWLocaloziString(@"3.0_FlashExchange") forState:UIControlStateNormal];
        [button setTitleColor:UIColorWhite forState:UIControlStateSelected];
        [button setTitleColor:SetAColor(255, 255, 255, 0.5) forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        button.imagePosition = QMUIButtonImagePositionLeft;
        button.spacingBetweenImageAndTitle = 5;
        [self addSubview:button];
        button;
    }));
}
- (QMUIButton *)OTCButton
{
    return SW_LAZY(_OTCButton, ({
        QMUIButton *button = [[QMUIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"3.0_UnselectOTC"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"3.0_SelectOTC"] forState:UIControlStateSelected];
        [button setTitle:SWLocaloziString(@"3.0_OTCExchange") forState:UIControlStateNormal];
        [button setTitleColor:UIColorWhite forState:UIControlStateSelected];
        [button setTitleColor:SetAColor(255, 255, 255, 0.5) forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        button.imagePosition = QMUIButtonImagePositionLeft;
        button.spacingBetweenImageAndTitle = 5;
        [self addSubview:button];
        button;
    }));
}
- (UIView *)swapLine
{
    return SW_LAZY(_swapLine, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorWhite;
        view.layer.cornerRadius = 1;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        view;
    }));
}
- (UIView *)OTCLine
{
    return SW_LAZY(_OTCLine, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorWhite;
        view.layer.cornerRadius = 1;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        view;
    }));
}
- (UIView *)dotView{
    
    return SW_LAZY(_dotView, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(255, 63, 63);
        view.layer.cornerRadius = 4.5;
        view.layer.masksToBounds = YES;
        view.hidden = YES;
        [self addSubview:view];
        view;
    }));
}
@end
