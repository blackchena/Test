//
//  IDCMQRCodeView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/3.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMQRCodeView.h"

@interface IDCMQRCodeView ()
/**
 *  取消按钮
 */
@property (strong, nonatomic) UIButton *cancelButton;
/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *bgView;
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoView;
/**
 *  二维码
 */
@property (strong, nonatomic) UIImageView *QRCodeView;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  副标题
 */
@property (strong, nonatomic) UILabel *subTitleLabel;
@end

@implementation IDCMQRCodeView

+ (instancetype)bondSureViewWithSureBtnTitle:(NSString *)btnTitle
                                  confidTupe:(RACTuple *)dataTupe
                                sureBtnInput:(CommandInputBlock)sureBtnInput{
    
    IDCMQRCodeView *view = [[self alloc] init];
    [view configUIWithBtnTitle:btnTitle tupe:dataTupe];
    view.cancelButton.rac_command = RACCommand.emptyCommand(sureBtnInput);
    return view;
}
- (void)configUIWithBtnTitle:(NSString *)title tupe:(RACTuple *)tupe{
    
    [self addSubview:self.bgView];
    [self addSubview:self.cancelButton];
    [self addSubview:self.logoView];
    [self addSubview:self.QRCodeView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    
    if ([title isKindOfClass:[NSString class]] && [title isNotBlank]) {
        [self.cancelButton setTitle:title forState:UIControlStateNormal];
    }else{
        [self.cancelButton setImage:UIImageMake(@"3.0_qrcodeClose") forState:UIControlStateNormal];
    }
    
    if ([tupe.first isKindOfClass:[NSString class]] && [tupe.first isNotBlank]) {
        self.titleLabel.text = tupe.first;
    }
    
    if ([tupe.second isKindOfClass:[NSString class]] && [tupe.second isNotBlank]) {
        UIImage *image = [LBXScanNative createQRWithString:tupe.second QRSize:CGSizeMake(160, 160)];
        self.QRCodeView.image = image;
    }
    
    if ([tupe.third isKindOfClass:[NSString class]] && [tupe.third isNotBlank]) {
        self.subTitleLabel.text = tupe.third;
    }
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.height.equalTo(@40);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(44);
        make.height.equalTo(@20);
        make.left.right.equalTo(self);
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
        make.width.equalTo(@220);
    }];
    [self.QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@160);
        make.top.equalTo(self.logoView.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QRCodeView.mas_bottom).offset(14);
        make.height.equalTo(@20);
        make.left.right.equalTo(self);
    }];
}
#pragma mark - getter
- (UIButton *)cancelButton{
    
    return SW_LAZY(_cancelButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:textColor333333 forState:UIControlStateNormal];
        button.titleLabel.font = textFontPingFangRegularFont(14);
        button;
    }));
}
- (UIImageView *)bgView{
    return SW_LAZY(_bgView,({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view.userInteractionEnabled = YES;
        view.image = UIImageMake(@"3.0_shareBG");
        view;
    }));
}
- (UIImageView *)logoView{
    return SW_LAZY(_logoView,({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.image = UIImageMake(@"3.0_qrcodeidcwlogo");
        view;
    }));
}
- (UIImageView *)QRCodeView{
    return SW_LAZY(_QRCodeView,({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view.userInteractionEnabled = YES;
        view;
    }));
}
- (UILabel *)titleLabel{
    return SW_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(18);
        label.textColor = UIColorWhite;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    }));
}
- (UILabel *)subTitleLabel{
    return SW_LAZY(_subTitleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = UIColorWhite;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    }));
}
@end
