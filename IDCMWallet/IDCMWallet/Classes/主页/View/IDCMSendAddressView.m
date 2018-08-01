//
//  IDCMSendAddressView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSendAddressView.h"

@implementation IDCMSendAddressView

- (instancetype)init
{
    if (self == [super init]) {
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 接收地址模块
    [self.reciveLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.equalTo(@0.5);
    }];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.reciveLine.mas_top).offset(-8);
        make.height.equalTo(@40);
        make.width.equalTo(@30);
    }];
    
    [self.reciveAddressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scanButton.mas_left).offset(-5);
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.reciveLine.mas_top).offset(-8);
        make.height.equalTo(@17);
    }];

    [self.reciveAddressTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.reciveAddressTextField.mas_top).offset(-8);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@(30));
    }];
    CGFloat width = [NSLocalizedString(@"2.0_pasteAddress", nil) widthForFont:SetFont(@"PingFang-SC-Regular",10)] + 15;
    [self.pasterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.reciveAddressTitleLable.mas_centerY);
        make.left.equalTo(self.reciveAddressTitleLable.mas_right).offset(10);
        make.height.equalTo(@16);
        make.width.equalTo(@(width));
    }];
}
#pragma mark - getter
- (UILabel *)reciveAddressTitleLable
{
    return SW_LAZY(_reciveAddressTitleLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(102, 102, 102);
        view.font = SetFont(@"PingFang-SC-Regular",12);
        view.text = NSLocalizedString(@"2.0_SendReciveAddress", nil);
        view.textAlignment = NSTextAlignmentLeft;
        [self addSubview:view];
        view;
    }));
}
- (QMUIButton *)scanButton
{
    return SW_LAZY(_scanButton, ({
        QMUIButton *button = [[QMUIButton alloc] init];
        button.imagePosition = QMUIButtonImagePositionTop;
        button.spacingBetweenImageAndTitle = 5;
        [button setImage:UIImageMake(@"2.0_saomiao") forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"2.1_ScanButton", nil) forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 10);
        [button setTitleColor:SetColor(41, 104, 185) forState:UIControlStateNormal];
        [self addSubview:button];
        button;
    }));
}
- (UIButton *)pasterButton
{
    return SW_LAZY(_pasterButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"2.0_pasteAddress", nil) forState:UIControlStateNormal];
        [button setTitleColor:SetColor(41, 104, 185) forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular",10);
        button.layer.cornerRadius = 2;
        button.layer.borderWidth = 1;
        button.layer.borderColor = SetColor(41, 104, 185).CGColor;
        [self addSubview:button];
        button;
    }));
}
- (UIView *)reciveLine
{
    return SW_LAZY(_reciveLine, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(221, 221, 221);
        [self addSubview:view];
        view;
    }));
}
- (UITextField *)reciveAddressTextField
{
    return SW_LAZY(_reciveAddressTextField, ({
        UITextField *textField = [[UITextField alloc] init];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.placeholder = SWLocaloziString(@"2.1_EnterAddress");
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = SetFont(@"PingFang-SC-Regular", 12);
        textField.textColor = SetColor(51, 51, 51);
        UIButton *passwordBtn = [textField valueForKey:@"_clearButton"];
        [passwordBtn setImage:[UIImage imageNamed:@"2.1_addressClearButton"] forState:UIControlStateNormal];
        textField.returnKeyType = UIReturnKeyDone;
        [self addSubview:textField];
        textField;
    }));
}
@end
