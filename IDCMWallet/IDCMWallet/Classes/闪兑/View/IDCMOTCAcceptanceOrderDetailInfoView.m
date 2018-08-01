//
//  IDCMOTCAcceptanceOrderDetailInfoView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCAcceptanceOrderDetailInfoView.h"

@implementation IDCMOTCAcceptanceOrderDetailInfoModel
@end

@interface IDCMOTCAcceptanceOrderDetailSellOrBuyView : UIView
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  内容
 */
@property (strong, nonatomic) UILabel *contentLabel;
@end

@implementation IDCMOTCAcceptanceOrderDetailSellOrBuyView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}
- (void)initUI{
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.width.lessThanOrEqualTo(@200);
        make.top.bottom.equalTo(self);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.lessThanOrEqualTo(@200);
        make.top.bottom.equalTo(self);
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
- (UILabel *)contentLabel{
    return SW_LAZY(_contentLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontHelveticaLightFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = textColor666666;
        label;
    }));
}
@end


@interface IDCMOTCAcceptanceOrderDetailInfoView ()
/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *bgImageView;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  用户名
 */
@property (strong, nonatomic) UILabel *userLabel;
/**
 *  银行卡
 */
@property (strong, nonatomic) UIImageView *bankImageView;
/**
 *  支付宝
 */
@property (strong, nonatomic) UIImageView *alipayImageView;
/**
 *  申诉次数
 */
@property (strong, nonatomic) IDCMOTCAcceptanceOrderDetailSellOrBuyView *countView;
/**
 *  支付时间
 */
@property (strong, nonatomic) IDCMOTCAcceptanceOrderDetailSellOrBuyView *payView;
/**
 *  买入时间
 */
@property (strong, nonatomic) IDCMOTCAcceptanceOrderDetailSellOrBuyView *buyView;
@end

@implementation IDCMOTCAcceptanceOrderDetailInfoView

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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(8);
        make.left.right.equalTo(self);
        make.height.equalTo(@22);
    }];
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.width.lessThanOrEqualTo(@200);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.height.equalTo(@20);
    }];
    [self.bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.userLabel.mas_centerY);
    }];
    [self.alipayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.right.equalTo(self.bankImageView.mas_left).offset(-6);
        make.centerY.equalTo(self.userLabel.mas_centerY);
    }];
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.userLabel.mas_bottom).offset(8);
        make.height.equalTo(@18);
    }];
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.countView.mas_bottom).offset(5);
        make.height.equalTo(@18);
    }];
    [self.buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.payView.mas_bottom).offset(5);
        make.height.equalTo(@18);
    }];
}

#pragma mark - Privater Methods
- (void)initUI{
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.userLabel];
    [self addSubview:self.bankImageView];
    [self addSubview:self.alipayImageView];
    [self addSubview:self.countView];
    [self addSubview:self.payView];
    [self addSubview:self.buyView];
    
}

#pragma mark - Action
- (void)bindData{
    
    self.dataSubject = [RACSubject subject];
    
    @weakify(self);
    [[self.dataSubject deliverOnMainThread]
     subscribeNext:^(IDCMOTCAcceptanceOrderDetailInfoModel *model) {
         @strongify(self);
         
         if (model.type == kIDCMOTCAcceptanceOrderBuyType) {
             
             self.payView.titleLabel.text = SWLocaloziString(@"3.0_Bin_PaymentTime");
             self.buyView.titleLabel.text = SWLocaloziString(@"3.0_Bin_BuyingTime");
             self.titleLabel.textColor = SetColor(41, 104, 185);
         }else{
             
             self.payView.titleLabel.text = SWLocaloziString(@"3.0_Bin_ResponseTime");
             self.buyView.titleLabel.text = SWLocaloziString(@"3.0_Bin_CollectionTime");
             self.titleLabel.textColor = SetColor(248, 134, 51);
         }
         self.titleLabel.text = model.title;
         self.userLabel.text = model.user;
         self.countView.contentLabel.text = model.countNum;
         self.payView.contentLabel.text = model.payResponeTime;
         self.buyView.contentLabel.text = model.buyColeectionTime;
         [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:model.payLogo] placeholderImage:nil options:SDWebImageRefreshCached];
     }];
}

#pragma mark - Getter & Setter
- (UIImageView *)bgImageView{
    return SW_LAZY(_bgImageView, ({
        
        UIImageView *view = [UIImageView new];
        view.image = UIImageMake(@"3.2_Bin_AcceptanceDetailBG");
//        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    }));
}
- (UILabel *)userLabel{
    return SW_LAZY(_userLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangMediumFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentLeft;
        label;
    }));
}
- (UIImageView *)bankImageView{
    return SW_LAZY(_bankImageView, ({
        
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 10;
        view;
    }));
}
- (UIImageView *)alipayImageView{
    return SW_LAZY(_alipayImageView, ({
        
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    }));
}
- (UILabel *)titleLabel{
    return SW_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangMediumFont(16);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    }));
}
- (IDCMOTCAcceptanceOrderDetailSellOrBuyView *)countView{
    return SW_LAZY(_countView, ({
        IDCMOTCAcceptanceOrderDetailSellOrBuyView *view = [IDCMOTCAcceptanceOrderDetailSellOrBuyView new];
        view.titleLabel.text = SWLocaloziString(@"3.0_Bin_NumberComplaints");
        view;
    }));
}
- (IDCMOTCAcceptanceOrderDetailSellOrBuyView *)payView{
    return SW_LAZY(_payView, ({
        IDCMOTCAcceptanceOrderDetailSellOrBuyView *view = [IDCMOTCAcceptanceOrderDetailSellOrBuyView new];
        view;
    }));
}
- (IDCMOTCAcceptanceOrderDetailSellOrBuyView *)buyView{
    return SW_LAZY(_buyView, ({
        IDCMOTCAcceptanceOrderDetailSellOrBuyView *view = [IDCMOTCAcceptanceOrderDetailSellOrBuyView new];
        view;
    }));
}
@end
