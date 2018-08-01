//
//  IDCMTradDetailInfoView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/25.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMTradDetailInfoView.h"

@implementation IDCMTradDetailInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = ({
            
            UILabel *lable = [[UILabel alloc]init];
            lable.font = SetFont(@"PingFang-SC-Regular", 12);
            lable.textAlignment = NSTextAlignmentLeft;
            lable.textColor = SetColor(102, 102, 102);
            [self addSubview:lable];
            lable;
        });
        self.textTitleLabel = ({
            
            UILabel *lable = [[UILabel alloc]init];
            lable.font = SetFont(@"PingFang-SC-Regular", 12);
            lable.textAlignment = NSTextAlignmentLeft;
            lable.textColor = SetColor(102, 102, 102);
            [self addSubview:lable];
            lable;
        });
        self.contentLabel = ({
            
            UILabel *lable = [[UILabel alloc]init];
            lable.font = SetFont(@"PingFang-SC-Regular", 12);
            lable.textAlignment = NSTextAlignmentRight;
            lable.textColor = SetColor(51, 51, 51);
            lable.numberOfLines = 0;
            [self addSubview:lable];
            lable;
        });
        self.textField = ({
            
            QMUITextView *textField = [[QMUITextView alloc] init];
            textField.textAlignment = NSTextAlignmentRight;
            textField.maximumTextLength = 50;
            textField.returnKeyType = UIReturnKeyDone;
            textField.font = SetFont(@"PingFang-SC-Regular", 12);
            textField.textColor = SetColor(51, 51, 51);
            [self addSubview:textField];
            textField;
        });
        self.lineView = ({
            
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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@(22));
        make.width.equalTo(@125);
    }];
    [self.textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.mas_top).offset(12);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@(22));
        make.width.equalTo(@125);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(8);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
}

@end
