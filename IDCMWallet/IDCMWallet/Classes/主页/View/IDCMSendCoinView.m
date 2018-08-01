//
//  IDCMSendCoinView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSendCoinView.h"


@implementation IDCMSendCoinView

- (instancetype)init
{
    if (self == [super init]) {
        self.sendTextField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:SWLocaloziString(@"2.1_EnterAmount") attributes:@{
                                                                                                                                              NSFontAttributeName:textFontPingFangRegularFont(16),
                                                                                                                                              NSForegroundColorAttributeName:UIColorMake(196, 200, 208)
                                                                                                                                              
                                                                                                                                              }];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [self.sendLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
        make.height.equalTo(@0.5);
    }];
    [self.coinTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sendLine.mas_top).offset(-6);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@45);
    }];
    [self.sendTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sendLine.mas_top);
        make.left.equalTo(self.coinTypeLabel.mas_right).offset(5);
        make.height.equalTo(@42);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    [self.sendTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.sendTextField.mas_top).offset(-5);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@20);
        make.left.equalTo(self.mas_left).offset(15);
    }];
}

#pragma mark - getter
- (UILabel *)sendTitleLable
{
    return SW_LAZY(_sendTitleLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(153, 153, 153);
        view.font = SetFont(@"PingFang-SC-Regular",14);
        view.textAlignment = NSTextAlignmentLeft;
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)coinTypeLabel
{
    return SW_LAZY(_coinTypeLabel, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Medium",16);
        view.textAlignment = NSTextAlignmentLeft;
        [self addSubview:view];
        view;
    }));
}
- (IDCMTextField *)sendTextField
{
    return SW_LAZY(_sendTextField, ({
        IDCMTextField *textField = [[IDCMTextField alloc] init];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.placeholder = SWLocaloziString(@"2.1_EnterAmount");
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = textFontPingFangMediumFont(30);
        textField.textColor = SetColor(51, 51, 51);
        [self addSubview:textField];
        textField;
    }));
}

- (UIView *)sendLine
{
    return SW_LAZY(_sendLine, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(221, 221, 221);
        [self addSubview:view];
        view;
    }));
}

@end
