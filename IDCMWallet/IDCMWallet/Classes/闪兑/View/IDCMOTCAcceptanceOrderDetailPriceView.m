//
//  IDCMOTCAcceptanceOrderDetailPriceView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCAcceptanceOrderDetailPriceView.h"


@implementation IDCMOTCAcceptancePriceView
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
//    [self addSubview:self.numTextField];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.width.greaterThanOrEqualTo(@25);
        make.top.bottom.equalTo(self);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(4);
        make.width.greaterThanOrEqualTo(@35);
        make.top.bottom.equalTo(self);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(@300);
        make.top.bottom.equalTo(self);
    }];
//    [self.numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentLabel.mas_left);
//        make.left.equalTo(self.titleLabel.mas_right).offset(5);
//        make.top.bottom.equalTo(self);
//    }];
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
- (IDCMBaseTextField *)numTextField{
    return SW_LAZY(_numTextField , ({
        IDCMBaseTextField *textField = [IDCMBaseTextField new];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = textFontPingFangRegularFont(12);
        textField.textColor = textColor333333;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField;
    }));
}
@end


@interface IDCMOTCAcceptanceOrderDetailPriceView ()
/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *bgImageView;
/**
 *  line
 */
@property (strong, nonatomic) UIView *line;

@end

@implementation IDCMOTCAcceptanceOrderDetailPriceView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
        
        [self bindData];
    }
    return self;
}


#pragma mark - Public Methods
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@0.5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.unitPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.line.mas_top).offset(-12);
        make.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    
    [self.totalPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(12);
        make.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
}

#pragma mark - Privater Methods
- (void)initUI{
    [self addSubview:self.bgImageView];
    [self addSubview:self.line];
    [self addSubview:self.unitPriceView];
    [self addSubview:self.totalPriceView];
}

#pragma mark - Action
- (void)bindData{
    
    self.dataSubject = [RACSubject subject];
    
    @weakify(self);
    [[self.dataSubject deliverOnMainThread]
     subscribeNext:^(RACTuple *tupe) {
         @strongify(self);
         
         if (![tupe.second isEqualToNumber:@(0)]) {
             NSString *unitPrice = [NSString stringFromNumber:tupe.second fractionDigits:4];
             NSString *price = [NSString idcw_stringWithFormat:@"%@ %@",unitPrice,tupe.first];
             self.unitPriceView.contentLabel.text = price;
         }
         if (![tupe.third isEqualToNumber:@(0)]) {
             NSString *totalPrice = [NSString stringFromNumber:tupe.third fractionDigits:4];
             NSString *price = [NSString idcw_stringWithFormat:@"%@ %@",totalPrice,tupe.first];
             self.totalPriceView.contentLabel.text = price;
         }
     }];
}

#pragma mark - Getter & Setter
- (UIImageView *)bgImageView{
    return SW_LAZY(_bgImageView, ({
        
        UIImageView *view = [UIImageView new];
        view.image = UIImageMake(@"3.2_Bin_AcceptanceDetailPriceBG");
        view.contentMode = UIViewContentModeScaleAspectFill;
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
- (IDCMOTCAcceptancePriceView *)unitPriceView{
    return SW_LAZY(_unitPriceView, ({
        IDCMOTCAcceptancePriceView *view = [IDCMOTCAcceptancePriceView new];
        view.titleLabel.text = SWLocaloziString(@"3.0_BinBear_YouOffer");
        view.subTitleLabel.text = SWLocaloziString(@"3.0_BinBear_Price");
        view;
    }));
}
- (IDCMOTCAcceptancePriceView *)totalPriceView{
    return SW_LAZY(_totalPriceView, ({
        IDCMOTCAcceptancePriceView *view = [IDCMOTCAcceptancePriceView new];
        view.titleLabel.text = SWLocaloziString(@"3.0_BinBear_TotalPrice");
        view.subTitleLabel.text = SWLocaloziString(@"3.0_BinBear_PriceNum");
        view;
    }));
}

@end
