//
//  IDCMFeeView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFeeView.h"

@interface IDCMFeeView()<QMUITextFieldDelegate>
/**
 *  是否隐藏slider
 */
@property (assign, nonatomic) IDCMCurrencyLayoutType currencyLayoutType;
@end


@implementation IDCMFeeView

- (instancetype)initWitdHidn:(IDCMCurrencyLayoutType)type
{
    if (self == [super init]) {
        
        self.currencyLayoutType = type;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.currencyLayoutType == kIDCMCurrencyLayoutTypeNomal) { // 正常
        
        
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(13);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@45);
            make.width.equalTo(@235);
        }];
        
        [self.feeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(12);
            make.right.equalTo(self.slider.mas_left).offset(-2);
            make.height.equalTo(@17);
        }];
        self.feeLabel.textAlignment = NSTextAlignmentLeft;
        [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.feeTitleLable.mas_bottom).offset(9);
            make.left.equalTo(self.mas_left).offset(15);
            make.height.equalTo(@17);
            make.right.equalTo(self.slider.mas_left).offset(-2);
        }];
        [self.feeLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.slider.mas_bottom).offset(5);
            make.height.equalTo(@0.5);
        }];
        [self.leaveTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.feeLine.mas_bottom).offset(12);
            make.height.equalTo(@20);
            make.width.greaterThanOrEqualTo(@50);
        }];
    }else if(self.currencyLayoutType == kIDCMCurrencyLayoutTypeHidenSlider){ // 隐藏slider
        
        self.slider.hidden = YES;
        self.feeLabel.textAlignment = NSTextAlignmentRight;
        [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(12);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@17);
            make.width.greaterThanOrEqualTo(@120);
        }];
        
        [self.feeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(12);
            make.right.equalTo(self.feeLabel.mas_left).offset(-5);
            make.height.equalTo(@17);
        }];
        
        [self.feeLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.feeTitleLable.mas_bottom).offset(6);
            make.height.equalTo(@0.5);
        }];
        [self.leaveTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.feeLine.mas_bottom).offset(12);
            make.height.equalTo(@20);
            make.width.greaterThanOrEqualTo(@50);
        }];
        
    }else{  // 隐藏矿工费
        
        self.slider.hidden = YES;
        self.feeLabel.hidden = YES;
        self.feeLine.hidden = YES;
        self.feeTitleLable.hidden = YES;
        [self.leaveTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(10);
            make.height.equalTo(@20);
            make.width.greaterThanOrEqualTo(@50);
        }];
    }
    
    [self.feeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leaveTitleLabel.mas_centerY);
        make.left.equalTo(self.leaveTitleLabel.mas_right).offset(3);
        make.height.equalTo(@20);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
}
#pragma mark - QMUITextFieldDelegate
- (void)textField:(QMUITextField *)textField didPreventTextChangeInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.1_Maximum")];
}
#pragma mark - getter
- (UILabel *)feeTitleLable
{
    return SW_LAZY(_feeTitleLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(102, 102, 102);
        view.font = SetFont(@"PingFang-SC-Regular",12);
        view.text = SWLocaloziString(@"2.0_MinerFee");
        view.textAlignment = NSTextAlignmentLeft;
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)feeTitleHalfLable
{
    return SW_LAZY(_feeTitleHalfLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(153, 153, 153);
        view.font = SetFont(@"PingFang-SC-Regular",10);
        view.text = SWLocaloziString(@"2.0_MinerFeeHalf");
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)feeLabel
{
    return SW_LAZY(_feeLabel, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Regular",12);
        view.textAlignment = NSTextAlignmentLeft;
        [self addSubview:view];
        view;
    }));
}
- (StepSlider *)slider
{
    return SW_LAZY(_slider, ({
        StepSlider *view = [StepSlider new];
        view.maxCount = 3;
        view.trackCircleRadius = 2.5;
        view.trackHeight = 1;
        view.tintColor = SetColor(41, 104, 185);
        view.trackColor = SetColor(221, 221, 221);
        view.sliderCircleRadius = 7.5;
        [view setIndex:1];
        view.labelColor = SetColor(153, 153, 153);
        view.labelFont = textFontPingFangRegularFont(10);
        view.labelOffset = 8.0f;
        view.labels = @[SWLocaloziString(@"2.1_sendSlow"), SWLocaloziString(@"2.1_sendRecommended"), SWLocaloziString(@"2.1_sendFast")];
        view.sliderCircleImage = UIImageMake(@"2.1_slidrCycle");
        [self addSubview:view];
        view;
    }));
}
- (UIView *)feeLine
{
    return SW_LAZY(_feeLine, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(221, 221, 221);
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)leaveTitleLabel
{
    return SW_LAZY(_leaveTitleLabel, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(102, 102, 102);
        view.font = SetFont(@"PingFang-SC-Regular",12);
        view.text = NSLocalizedString(@"2.0_LeaveTitle", nil);
        view.textAlignment = NSTextAlignmentLeft;
        [self addSubview:view];
        view;
    }));
}
- (QMUITextField *)feeTextField
{
    return SW_LAZY(_feeTextField, ({
        QMUITextField *textField = [[QMUITextField alloc] init];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.delegate = self;
        textField.maximumTextLength  = 50;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = SetFont(@"PingFang-SC-Regular", 12);
        textField.placeholder = NSLocalizedString(@"2.0_LeaveDes", nil);
        textField.textColor = SetColor(51, 51, 51);
        textField.returnKeyType = UIReturnKeyDone;
        [self addSubview:textField];
        textField;
    }));
}

@end
