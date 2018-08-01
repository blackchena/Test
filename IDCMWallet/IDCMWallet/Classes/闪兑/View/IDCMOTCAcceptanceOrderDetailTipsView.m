//
//  IDCMOTCAcceptanceOrderDetailTipsView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/6/13.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOTCAcceptanceOrderDetailTipsView.h"

@implementation IDCMOTCAcceptanceOrderDetailTipsView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}
- (void)initUI{
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.currencyLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.greaterThanOrEqualTo(@25);
        make.top.bottom.equalTo(self);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(4);
        make.width.greaterThanOrEqualTo(@35);
        make.top.bottom.equalTo(self);
    }];
    [self.currencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.greaterThanOrEqualTo(@25);
        make.top.bottom.equalTo(self);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.currencyLabel.mas_left).offset(-4);
        make.width.greaterThanOrEqualTo(@50);
        make.top.bottom.equalTo(self);
    }];
}
#pragma mark - Getter & Setter
- (UILabel *)titleLabel{
    return SW_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = textColor666666;
        label;
    }));
}
- (UILabel *)subTitleLabel{
    
    return SW_LAZY(_subTitleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = textColor999999;
        label;
    }));
}
- (UILabel *)contentLabel{
    return SW_LAZY(_contentLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = textColor333333;
        label;
    }));
}
- (UILabel *)currencyLabel{
    return SW_LAZY(_currencyLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = textColor333333;
        label;
    }));
}
@end
