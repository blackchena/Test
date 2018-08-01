//
//  IDCMOTCAcceptanceOrderDetailOfferView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/6/13.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOTCAcceptanceOrderDetailOfferView.h"

@interface IDCMOTCAcceptanceOrderDetailOfferView ()
/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *bgImageView;
/**
 *  line
 */
@property (strong, nonatomic) UIView *line;
@end

@implementation IDCMOTCAcceptanceOrderDetailOfferView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}
- (void)initUI{
    

    self.numTextField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:SWLocaloziString(@"3.0_Bin_InputUnitPrice") attributes:@{
                                                                                                                                                   NSFontAttributeName:textFontPingFangRegularFont(16),
                                                                                                                                                   NSForegroundColorAttributeName:UIColorMake(196, 200, 208)
                                                                                                                                                   
                                                                                                                                                   }];
    [self addSubview:self.bgImageView];
    [self addSubview:self.line];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.numTextField];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-2);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.width.greaterThanOrEqualTo(@25);
        make.height.equalTo(@17);
        make.top.equalTo(self.mas_top).offset(10);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(4);
        make.width.greaterThanOrEqualTo(@35);
        make.height.equalTo(@17);
        make.top.equalTo(self.titleLabel.mas_top);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.width.greaterThanOrEqualTo(@25);
        make.height.equalTo(@17);
        make.bottom.equalTo(self.line.mas_top).offset(-4);
    }];
    [self.numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_right).offset(6);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@28);
        make.bottom.equalTo(self.line.mas_top).offset(-2);
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
        label.font = textFontPingFangMediumFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = textColor333333;
        label;
    }));
}
- (IDCMOfferTextField *)numTextField{
    return SW_LAZY(_numTextField , ({
        IDCMOfferTextField *textField = [IDCMOfferTextField new];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.font = textFontPingFangMediumFont(20);
        textField.textColor = textColor333333;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = SWLocaloziString(@"3.0_Bin_InputUnitPrice");
        textField;
    }));
}
- (UIImageView *)bgImageView{
    return SW_LAZY(_bgImageView, ({
        
        UIImageView *view = [UIImageView new];
        view.image = UIImageMake(@"3.2_Bin_AcceptanceDetailPriceBG");
//        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    }));
}
- (UIView *)line{
    return SW_LAZY(_line, ({
        
        UIView *view = [UIView new];
        view.backgroundColor = KLineColor;
        view;
    }));
}
@end
