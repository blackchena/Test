//
//  IDCMCurrentMarketView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMCurrentMarketView.h"

@interface IDCMCurrentMarketView ()
/**
 *  BTC币种标题
 */
@property (strong, nonatomic) UILabel *BTCTitleLable;
/**
 *  ETH币种标题
 */
@property (strong, nonatomic) UILabel *ETHTitleLable;
/**
 *  BTC价格
 */
@property (strong, nonatomic) UILabel *BTCLable;
/**
 *  ETH价格
 */
@property (strong, nonatomic) UILabel *ETHLable;
/**
 *  line
 */
@property (strong, nonatomic) UIView *line;
@end

@implementation IDCMCurrentMarketView

- (void)setBTCPrice:(NSString *)btc withETHPrice:(NSString *)eth
{
    if (![btc isNotBlank] || ![eth isNotBlank]) {
        return;
    }
    self.BTCLable.text = btc;
    self.ETHLable.text = eth;
    [self configPriceText:self.BTCLable];
    [self configPriceText:self.ETHLable];
}
- (void)configPriceText:(UILabel *)label
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attrStr addAttribute:NSFontAttributeName value:textFontPingFangRegularFont(12) range:NSMakeRange(0, 1)];
    label.attributedText = attrStr;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@1);
    }];
    [self.BTCTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.height.equalTo(@25);
        make.right.equalTo(self.line.mas_left);
    }];
    [self.BTCLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.equalTo(@25);
        make.right.equalTo(self.line.mas_left);
    }];
    [self.ETHTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.height.equalTo(@25);
        make.left.equalTo(self.line.mas_right);
    }];
    [self.ETHLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.equalTo(@25);
        make.left.equalTo(self.line.mas_right);
    }];
    
    [self configPriceText:self.BTCLable];
    [self configPriceText:self.ETHLable];
}

#pragma mark - getter
- (UILabel *)BTCTitleLable
{
    return SW_LAZY(_BTCTitleLable, ({
        UILabel *view = [UILabel new];
        view.textColor = textColor333333;
        view.font = textFontPingFangRegularFont(16);
        view.text = @"BTC";
        view.textAlignment = NSTextAlignmentCenter;
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)ETHTitleLable
{
    return SW_LAZY(_ETHTitleLable, ({
        UILabel *view = [UILabel new];
        view.textColor = textColor333333;
        view.font = textFontPingFangRegularFont(16);
        view.text = @"ETH";
        view.textAlignment = NSTextAlignmentCenter;
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)BTCLable
{
    return SW_LAZY(_BTCLable, ({
        UILabel *view = [UILabel new];
        view.textColor = textColor333333;
        view.font = textFontPingFangRegularFont(18);
        view.textAlignment = NSTextAlignmentCenter;
        view.text = @"$ 0.00";
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)ETHLable
{
    return SW_LAZY(_ETHLable, ({
        UILabel *view = [UILabel new];
        view.textColor = textColor333333;
        view.font = textFontPingFangRegularFont(18);
        view.textAlignment = NSTextAlignmentCenter;
        view.text = @"$ 0.00";
        [self addSubview:view];
        view;
    }));
}
- (UIView *)line
{
    return SW_LAZY(_line, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(229, 237, 255);
        [self addSubview:view];
        view;
    }));
}
@end
