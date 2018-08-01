//
//  IDCMCountryView.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMCountryView.h"

@implementation IDCMCountryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _countryLabel = ({
            
            UITextField *textField = [[UITextField alloc] init];
            textField.borderStyle = UITextBorderStyleNone;
            textField.textAlignment = NSTextAlignmentLeft;
            textField.font = SetFont(@"PingFang-SC-Regular", 14);
            textField.textColor = SetColor(51, 51, 51);
            [self addSubview:textField];
            textField;
        });
        _logoImageView = ({
            UIImageView *view = [UIImageView new];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
            [self addSubview:view];
            view;
        });
//        self.titleLabel = ({
//
//            UILabel *lable = [[UILabel alloc]init];
//            lable.font = SetFont(@"PingFang-SC-Regular", 16);
//            lable.textAlignment = NSTextAlignmentLeft;
//            lable.textColor = SetColor(102, 102, 102);
//            [self addSubview:lable];
//            lable;
//        });
        _downButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.adjustsImageWhenHighlighted = NO;
            [button setImage:[UIImage imageNamed:@"2.0_youjiantou"] forState:UIControlStateNormal];
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
    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(self.mas_top);
//        make.left.equalTo(self.mas_left).offset(10);
//        make.height.equalTo(@(22));
//        make.width.equalTo(@80);
//    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(2);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.height.equalTo(@18);
    }];
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.height.width.equalTo(@(22));
    }];
    [self.countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.logoImageView.mas_right).offset(10);
        make.right.equalTo(self.downButton.mas_left).offset(-5);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(22));
        
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
}


@end
