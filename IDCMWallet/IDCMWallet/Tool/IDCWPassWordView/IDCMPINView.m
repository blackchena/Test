//
//  IDCMPINView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPINView.h"
#import "IDCMPINNewCircleView.h"
#import "IDCMPINPasswordNumberView.h"

@interface IDCMPINView ()
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  关闭按钮
 */
@property (strong, nonatomic) UIButton *closeButton;
/**
 *  原点view
 */
@property (strong, nonatomic) IDCMPINNewCircleView *circleView;
/**
 *  输入框
 */
@property (strong, nonatomic) IDCMPINPasswordNumberView *pwInputView;
/**
 *  PIN
 */
@property (copy, nonatomic) NSString *password;
/**
 *  viewType
 */
@property (assign, nonatomic) IDCMPINButtonImageType type;
/**
 *   PIN输入完成回调
 */
@property (copy, nonatomic) IDCMPayFinish PINFinish;

@end

@implementation IDCMPINView

+ (instancetype)bindPINViewType:(IDCMPINButtonImageType)buttonType
                  closeBtnInput:(CommandInputBlock)closeBtnInput
                 PINFinishBlock:(IDCMPayFinish)PINFinish
{
    IDCMPINView *PINView = [[IDCMPINView alloc] init];
    PINView.backgroundColor = UIColorWhite;
    PINView.type = buttonType;
    PINView.closeButton.rac_command = RACCommand.emptyCommand(closeBtnInput);
    PINView.PINFinish = PINFinish;
    [PINView bindAction];
    
    return PINView;
}
#pragma mark - InitView
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat space = SCREEN_WIDTH*40/375;
    
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.height.equalTo(@48);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@48);
        make.left.equalTo(self.closeButton.mas_right);
        make.right.equalTo(self.mas_right).offset(-48);
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(space);
        make.right.equalTo(self.mas_right).offset(-space);
        make.height.equalTo(@55);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
    
    [self.pwInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@240);
        make.bottom.equalTo(self.mas_bottom).offset(-20-kSafeAreaBottom);
    }];
}

#pragma mark - Action
- (void)bindAction
{
    self.password = @"";
    
    if (self.type == IDCMPINButtonImageBackType) {
        [self.closeButton setImage:UIImageMake(@"2.2.1_PINFanHui") forState:UIControlStateNormal];
    }else if (self.type == IDCMPINButtonImageCloseType){
        [self.closeButton setImage:UIImageMake(@"2.0_closehui") forState:UIControlStateNormal];
    }
    
    
    @weakify(self);
    self.pwInputView.PINNumberBlock = ^(NSInteger number, IDCMPINNumberType type) {
        @strongify(self);
        if (type == IDCMPINNumberAdd) {
            if (self.password.length < 6) {
                self.password = [NSString stringWithFormat:@"%@%ld",self.password,(long)number];
                self.circleView.Password = self.password;
            }
        }else{
            if (self.password.length > 0) {
                self.password = [self.password substringToIndex:([self.password length]-1)];
                self.circleView.Password = self.password;
            }
        }
    };
    // 监听是否完成
    [[RACObserve(self, password) filter:^BOOL(NSString *passWord) {
        if (passWord.length == 6) {
            return YES;
        }else{
            return NO;
        }
    }]
     subscribeNext:^(NSString *passWord) {
       @strongify(self);
         if (self.PINFinish) {
             self.PINFinish(passWord);
         }
    }];

}
- (void)removePasseword:(BOOL)isShake
{
    if (isShake) {
        [self.circleView showShakingMobilePhoneVibrate];
    }
    
    // 清除原有的Password
    self.password = @"";
    self.circleView.Password = self.password;
}

#pragma mark - getter

- (UILabel *)titleLabel
{
    return SW_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.text = SWLocaloziString(@"2.0_PleaseEnterPayWord");
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFontPingFangRegularFont(16);
        [self addSubview:label];
        label;
    }));
}
- (UIButton *)closeButton
{
   return  SW_LAZY(_closeButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        button;
    }));
}
- (IDCMPINNewCircleView *)circleView
{
    return SW_LAZY(_circleView, ({
        IDCMPINNewCircleView *view = [IDCMPINNewCircleView new];
        [self addSubview:view];
        view;
    }));
}

- (IDCMPINPasswordNumberView *)pwInputView
{
    return SW_LAZY(_pwInputView, ({
        IDCMPINPasswordNumberView *view = [IDCMPINPasswordNumberView new];
        [self addSubview:view];
        view;
    }));
}
@end
