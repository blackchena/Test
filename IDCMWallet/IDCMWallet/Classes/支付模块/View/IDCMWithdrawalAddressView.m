//
//  IDCMWithdrawalAddressView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/27.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMWithdrawalAddressView.h"


@interface IDCMWithdrawalAddressView ()
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UILabel *currencyCountLabel;

//@property (nonatomic,strong) UIButton *rechargeBtn;
@end

@implementation IDCMWithdrawalAddressView

+ (instancetype)bondSureViewWithCloseButtonType:(IDCMWithdrawCloseButtonImageType)buttontype
                                         Title:(NSString *)title
                                      subTitle:(NSString *)subTitle
                                  sureBtnTitle:(NSString *)btnTitle
                                 pasteBtnInput:(CommandInputBlock)pasteBtnInput
                                  scanBtnInput:(CommandInputBlock)scanBtnInput
                                 closeBtnInput:(CommandInputBlock)closeBtnInput
                                  sureBtnInput:(CommandInputBlock)sureBtnInput
                                  templeSignal:(RACSignal *)templeSignal
{
    
    IDCMWithdrawalAddressView *tipView = [[self alloc] init];
    CGSize size = CGSizeMake(SCREEN_WIDTH, 440+kSafeAreaBottom);
    tipView.size = size;
    tipView.backgroundColor = UIColorWhite;
    [tipView initTopViewWithTitle:title andSubTitle:subTitle andSureButtonTitle:btnTitle andButtonType:buttontype];
    tipView.closeBtn.rac_command = RACCommand.emptyCommand(closeBtnInput);
    tipView.rechargeBtn.rac_command = RACCommand.emptyEnabledCommand(templeSignal,sureBtnInput);
    tipView.reciveView.scanButton.rac_command = RACCommand.emptyCommand(scanBtnInput);
    tipView.reciveView.pasterButton.rac_command = RACCommand.emptyCommand(pasteBtnInput);
    return tipView;
}

#pragma mark - Private methods
- (void)initTopViewWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle andSureButtonTitle:(NSString *)btnTitle andButtonType:(IDCMWithdrawCloseButtonImageType)type{
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, self.width, 48);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (type == IDCMWithdrawCloseButtonImageBackType) {
        [btn setImage:UIImageMake(@"2.2.1_PINFanHui") forState:UIControlStateNormal];
    }else{
        [btn setImage:UIImageMake(@"2.0_closehui") forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.size = CGSizeMake(view.height, view.height);
    [view addSubview:btn];
    self.closeBtn = btn;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor333333;
    label.font = textFontPingFangRegularFont(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.width = view.width - btn.width * 2;
    label.height = view.height;
    label.centerX = view.width / 2;
    [view addSubview:label];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    line.width = view.width;
    line.height = 1;
    line.bottom = view.height;
    [view addSubview:line];
    
    [self addSubview:view];
    self.topView = view;
    
    [self addSubview:self.currencyCountLabel];
    self.currencyCountLabel.text = subTitle;
    
    [self addSubview:self.reciveView];
    self.reciveView.reciveAddressTitleLable.font = textFontPingFangRegularFont(14);
    self.reciveView.reciveAddressTextField.font = textFontPingFangRegularFont(12);
    
    [self addSubview:self.rechargeBtn];
    [self.rechargeBtn setTitle:btnTitle forState:UIControlStateNormal];
    
}
#pragma mark - getter
- (UILabel *)currencyCountLabel {
    return SW_LAZY(_currencyCountLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangMediumFont(20);
        label.textAlignment = NSTextAlignmentCenter;
        label.height = 28;
        label.width = self.width - 24;
        label.top = self.topView.bottom + 20;
        label.left = 12;
        label;
    }));
}
- (IDCMSendAddressView *)reciveView{
    
    return SW_LAZY(_reciveView, ({
        IDCMSendAddressView *view = [IDCMSendAddressView new];
        view.backgroundColor = [UIColor whiteColor];
        view.width = self.width;
        view.height = 70;
        view.top = self.currencyCountLabel.bottom + 30;
        view;
    }));
}
- (UIButton *)rechargeBtn {
    return SW_LAZY(_rechargeBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.width - 24;
        btn.height = 40;
        btn.bottom = self.height - 20 - kSafeAreaBottom;
        btn.left = 12;
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.adjustsImageWhenHighlighted = NO;
        btn.titleLabel.font = textFontPingFangRegularFont(16);
//        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
//        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setBackgroundColor:kThemeColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn;
    }));
}
@end
