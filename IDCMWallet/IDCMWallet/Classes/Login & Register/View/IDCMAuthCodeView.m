//
//  IDCMAuthCodeView.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMAuthCodeView.h"

@interface IDCMAuthCodeView ()
/**
 *  线
 */
@property (strong, nonatomic) UIView *lineView;
/**
 *  线
 */
@property (strong, nonatomic) UIView *shuLineView;
@end

@implementation IDCMAuthCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        _textField = ({
            
            UITextField *textField = [[UITextField alloc] init];
            textField.borderStyle = UITextBorderStyleNone;
            textField.textAlignment = NSTextAlignmentLeft;
            textField.font = SetFont(@"PingFang-SC-Regular", 14);
            textField.textColor = SetColor(51, 51, 51);
            [self addSubview:textField];
            textField;
        });
        _authButton = ({
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 14);
            [button setTitle:NSLocalizedString(@"2.0_GetVerificationCode", nil) forState:UIControlStateNormal];
            [button setTitleColor:SetColor(153, 159, 165) forState:UIControlStateNormal];
            [self addSubview:button];
            button;
        });
        
        _lineView = ({
            
            UIView *view = [UIView new];
            view.backgroundColor = SetColor(160, 165, 171);
            [self addSubview:view];
            view;
        });

    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@0.5);
        
    }];
  
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.authButton.mas_left);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.equalTo(@(22));
        
    }];
    
    [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.equalTo(self);
        make.width.equalTo(@(100));
        make.height.equalTo(@(20));
        make.centerY.equalTo(self.textField.mas_centerY);
    }];

}

@end
