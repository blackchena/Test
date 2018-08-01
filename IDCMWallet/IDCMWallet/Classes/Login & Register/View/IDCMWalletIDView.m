//
//  IDCMWalletIDView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/2.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMWalletIDView.h"

@implementation IDCMWalletIDView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorWhite;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textFiled.mas_bottom).offset(5);
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];

    
}
#pragma mark - getter
- (IDCMBaseTextField *)textFiled {
    return SW_LAZY(_textFiled, ({
        
        IDCMBaseTextField *textField = [[IDCMBaseTextField alloc] init];
        textField.font = textFontPingFangRegularFont(14);
        textField.textAlignment = NSTextAlignmentCenter;
        textField.textColor = textColor333333;
        [self addSubview:textField];
        textField;
    }));
}
- (UIView *)line {
    return SW_LAZY(_line, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorMake(160, 165, 171);
        [self addSubview:view];
        view;
    }));
}
@end
