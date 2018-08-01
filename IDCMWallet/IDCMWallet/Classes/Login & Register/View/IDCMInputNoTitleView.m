//
//  IDCMInputNoTitleView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/25.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMInputNoTitleView.h"

@implementation IDCMInputNoTitleView

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
        _lineView = ({
            
            UIView *view = [UIView new];
            view.backgroundColor = SetColor(160, 165, 171);
            [self addSubview:view];
            view;
        });
        _logoImageView = ({
            UIImageView *view = [UIImageView new];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
            [self addSubview:view];
            view;
        });
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(2);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.height.equalTo(@18);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.logoImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(25));
        
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
}

@end
