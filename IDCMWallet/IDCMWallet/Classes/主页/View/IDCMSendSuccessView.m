//
//  IDCMSendSuccessView.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMSendSuccessView.h"


@interface IDCMSendSuccessView ()

/**
 *  提示语
 */
@property (strong, nonatomic) UILabel *hintlable;
/**
 *  提示语
 */
@property (strong, nonatomic) UILabel *titlelable;
/**
 *  立即返回按钮
 */
@property (strong, nonatomic) UIButton *doneButton;
/**
 *  提示语
 */
@property (strong, nonatomic) UILabel *rememberlable;
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoView;
/**
 *   倒计时完成回调
 */
@property (copy, nonatomic) IDCMSendSuccessFinish finish;
/**
 *   币种
 */
@property (copy, nonatomic) NSString *currency;

@end

@implementation IDCMSendSuccessView

+ (instancetype)bondSendSuccessViewWithCurrency:(NSString *)currency
                                   sureBtnInput:(CommandInputBlock)sureBtnInput
                                    finishBlock:(IDCMSendSuccessFinish)finish
{
    IDCMSendSuccessView *View = [[IDCMSendSuccessView alloc] init];
    View.backgroundColor = UIColorWhite;
    View.currency = currency;
    View.doneButton.rac_command = RACCommand.emptyCommand(sureBtnInput);
    View.finish = finish;
    return View;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(55);
        make.centerX.equalTo(self.mas_centerX);
        make.height.width.equalTo(@60);
    }];
    
    [self.titlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).offset(25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@25);
        make.width.equalTo(@(SCREEN_WIDTH));
        
    }];
    
    [self.hintlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titlelable.mas_bottom).offset(18);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@20);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [self.rememberlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hintlable.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@20);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rememberlable.mas_bottom).offset(70);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
        make.width.equalTo(@(240));
    }];
}

#pragma mark - bind
- (void)bindTimerSignalToHintLabel
{

    
    RACSignal *(^counterSigner)(NSNumber *count) = ^RACSignal *(NSNumber *count){
        
        RACSignal *timerSignal=[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler];
        RACSignal *counterSignal=[[timerSignal scanWithStart:count reduce:^id(NSNumber *running, id next) {
            return @(running.integerValue -1);
        }] takeUntilBlock:^BOOL(NSNumber *x) {
            return x.integerValue<0;
        }];
        
        return [counterSignal startWith:count];
    };
    
    RACSignal *hintSignal = counterSigner(@3);
    
    @weakify(self);
    [hintSignal subscribeNext:^(NSNumber *count) {
        @strongify(self);
        [self configHintLabel:[count integerValue]];
        if ([count integerValue] <= 0) {
            if (self.finish) {
                self.finish();
            }
        }
    }];
    
}
- (void)configHintLabel:(NSInteger)second
{
    NSString *langue = [IDCMUtilsMethod getPreferredLanguage];
    if ([langue isEqualToString:@"zh-Hans"]) {
        self.hintlable.text = [NSString idcw_stringWithFormat:@"%zd%@%@%@",second,NSLocalizedString(@"2.0_AutoBack", nil),self.currency,NSLocalizedString(@"2.0_AmountView", nil)];
    }else if ([langue isEqualToString:@"en"]){
        self.hintlable.text = [NSString idcw_stringWithFormat:@"%zd seconds later auto redirect to %@ page",second,self.currency];
    }else if ([langue isEqualToString:@"ja"]){
        self.hintlable.text = [NSString idcw_stringWithFormat:@"%zd秒後自動的に戻る %@ 資産ページ",second,self.currency];
    }else if ([langue isEqualToString:@"ko"]){
        self.hintlable.text = [NSString idcw_stringWithFormat:@"%zd초후 자동으로 돌아가기 %@ 산 화면",second,self.currency];
    }else if ([langue isEqualToString:@"vi"]){
        self.hintlable.text = [NSString idcw_stringWithFormat:@"%zd giây sau tự động trở lại trang tài sản %@",second,self.currency];
    }else if ([langue isEqualToString:@"fr"]){
        self.hintlable.text = [NSString idcw_stringWithFormat:@"%zd secondes plus tard retour automatique à la page des actifs %@",second,self.currency];
    }else if ([langue isEqualToString:@"nl"]){
        self.hintlable.text = [NSString idcw_stringWithFormat:@"%zd seconden later keert het automatisch terug naar de %@ activapagina",second,self.currency];
    }else if ([langue isEqualToString:@"es"]){
        self.hintlable.text = [NSString idcw_stringWithFormat:@"%zd segundos más tarde regresa automáticamente a la página de activos de %@",second,self.currency];
    }else{
        self.hintlable.text = [NSString idcw_stringWithFormat:@"%zd seconds later auto redirect to %@ page",second,self.currency];
    }
}

#pragma mark  - 懒加载

- (UILabel *)rememberlable
{
    return SW_LAZY(_rememberlable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(153, 153, 153);
        view.font = SetFont(@"PingFang-SC-Regular", 13);
        view.textAlignment = NSTextAlignmentCenter;
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)hintlable
{
    return SW_LAZY(_hintlable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Regular", 14);
        view.textAlignment = NSTextAlignmentCenter;
        [self addSubview:view];
        view;
    }));
}
- (UIButton *)doneButton
{
    return SW_LAZY(_doneButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        [button setBackgroundColor:kThemeColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:NSLocalizedString(@"2.0_ImmediatelyBack", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:button];
        button;
    }));
}
- (UIImageView *)logoView
{
    return SW_LAZY(_logoView, ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"2.0_success"];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)titlelable
{
    return SW_LAZY(_titlelable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(41, 104, 185);
        view.font = SetFont(@"PingFang-SC-Regular", 18);
        view.textAlignment = NSTextAlignmentCenter;
        view.text = NSLocalizedString(@"2.0_SendSuccess", nil);
        [self addSubview:view];
        view;
    }));
}

@end
