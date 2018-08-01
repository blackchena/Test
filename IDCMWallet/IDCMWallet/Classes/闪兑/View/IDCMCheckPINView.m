//
//  IDCMCheckPINView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/15.
//  Copyright © 2018年 BinBear. All rights reserved.
//


#import "IDCMCheckPINView.h"
#import "IDCMPINNewCircleView.h"
#import "IDCMPINLoginViewModel.h"
#import "IDCMPINPasswordNumberView.h"


@interface IDCMCheckPINView ()
@property (nonatomic,strong)  UIButton *closeBtn;
@property (nonatomic,strong)  UILabel *titleLabel;
@property (nonatomic,strong)  UIImageView *logoImageView;
@property (nonatomic,copy)    void(^closeCallback)(void);
@property (nonatomic,copy)    void(^suceessCallback)(NSString *pinPassword);
@property (nonatomic,strong)  UIVisualEffectView *effectView;
@property (nonatomic,strong)  IDCMPINLoginViewModel *viewModel;
@property (nonatomic,copy)    NSString *password;
@property (strong, nonatomic) IDCMPINNewCircleView *circleView;
@property (strong, nonatomic) IDCMPINPasswordNumberView *pwInputView;
@property (nonatomic,copy) NSString *pinPassword;
@end


@implementation IDCMCheckPINView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfigure];
    }
    return self;
}

- (void)initConfigure {
    
    [self addSubview:self.effectView];
    [self pwInputView];
    [self circleView];
    [self addSubview:self.logoImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeBtn];
}

+ (void)showWithContentTitle:(NSString *)title
             suceessCallback:(void(^)(NSString *pinPassword))suceessCallback
               closeCallback:(void(^)(void))closeCallback {
    
    if ([self hasShow]) { return; }
    UIView *kewWindow =  [UIApplication sharedApplication].keyWindow;
    IDCMCheckPINView *view = [[self alloc] init];
    view.suceessCallback = [suceessCallback copy];
    view.closeCallback = [closeCallback copy];
    view.titleLabel.text = title;
    view.frame = kewWindow.bounds;
    [kewWindow addSubview:view];
    [view configSignal];
    [view show];
}

+ (void)dismissWithCompletion:(void(^)(void))completion {
    IDCMCheckPINView *pinView = [self getInstance];
    pinView ? [pinView dismissWithCompletion:completion] : nil;
}

+ (BOOL)hasShow {
    return [self getInstance] ? YES : NO;
}

+ (instancetype)getInstance {
    
    __block IDCMCheckPINView *pinView = nil;
    UIView *kewWindow =  [UIApplication sharedApplication].keyWindow;
    [kewWindow.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[self class]]) {
            pinView = (IDCMCheckPINView *)obj;
            *stop = YES;
        }
    }];
    return pinView;
}

- (void)configSignal {
    
    self.password = @"";
    @weakify(self);
    [[self.viewModel.verifyPIN.executionSignals.switchToLatest  deliverOnMainThread]
     subscribeNext:^(NSDictionary *responseObj) {
         @strongify(self)
         
         // 是否被锁定
         BOOL isLocked = [responseObj[@"data"][@"isLocked"] boolValue];
         // 密码是否验证通过
         BOOL isValid  = [responseObj[@"data"][@"isValid"] boolValue];
         
         if (isValid && !isLocked) { // 密码通过并且没有锁住
             
              typedef void(^completionBlock)(void);
              typedef void(^suceessBlock)(NSString *pw);
              completionBlock(^completion)(suceessBlock block) = ^(suceessBlock block){
                  return ^(void){
                      block ? block(self.pinPassword) : nil;
                  };
              };
              [self dismissWithCompletion:completion(self.suceessCallback)];
             
         }else if (!isLocked && !isValid){ // 密码没有通过并且没有锁住
             [self showUnvalidView:responseObj];
        }else if (isLocked){ // 密码被锁住
             [self showLockView:responseObj];
         }
         
     }];
    

    [[[[RACObserve(self, password) deliverOnMainThread] distinctUntilChanged]
      filter:^BOOL(NSString *value) {
        return value.length == 6;
    }] subscribeNext:^(NSString *password) {
         @strongify(self);
         self.pinPassword = password;
         [self.viewModel.verifyPIN execute:password];
     }];
    
    
    self.pwInputView.PINNumberBlock = ^(NSInteger number, IDCMPINNumberType type) {
        @strongify(self);
        if (type == IDCMPINNumberAdd) {
            if (self.password.length < 6) {
                self.password = [NSString stringWithFormat:@"%@%ld",self.password,(long)number];
                self.circleView.Password = self.password;
            }
        } else {
            if (self.password.length > 0) {
                self.password = [self.password substringToIndex:([self.password length] - 1)];
                self.circleView.Password = self.password;
            }
        }
    };
    
    
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self dismissWithCompletion:self.closeCallback];
     }];
}

// 展示PIN未通过
- (void)showUnvalidView:(NSDictionary *)responseObj
{
    [self showShakingMobilePhoneVibrate];
    
    NSString *residueCount = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"residueCount"]];
    NSInteger count = [responseObj[@"data"][@"residueCount"] integerValue];
    
    if (count <= 3) {
        
        NSString *tips = [SWLocaloziString(@"2.2.3_PINIsValid") stringByReplacingOccurrencesOfString:@"[IDCW]" withString:residueCount];
        [IDCMShowMessageView showErrorWithMessage:tips];
    }
}
// 展示PIN被锁定
- (void)showLockView:(NSDictionary *)responseObj
{
   
    [self showShakingMobilePhoneVibrate];
    
    NSInteger hours = [responseObj[@"data"][@"hours"] integerValue];
    NSInteger minutes = [responseObj[@"data"][@"minutes"] integerValue];
    
    NSString *hour = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"hours"]];
    NSString *minute = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"minutes"]];
    
    NSString *tips = @"";
    
    if (hours > 0 && minutes > 0) {
        tips = [SWLocaloziString(@"2.2.3_PINIsLock") stringByReplacingOccurrencesOfString:@"[IDCWH]" withString:hour];
        tips = [tips stringByReplacingOccurrencesOfString:@"[IDCWM]" withString:minute];
    }else if (hours > 0 && minutes == 0){
        tips = [SWLocaloziString(@"2.2.3_PINIsLockHours") stringByReplacingOccurrencesOfString:@"[IDCWH]" withString:hour];
    }else if (hours == 0 && minutes > 0){
        tips = [SWLocaloziString(@"2.2.3_PINIsLockMintues") stringByReplacingOccurrencesOfString:@"[IDCWH]" withString:minute];
    }
    
    
    [IDCMShowMessageView showErrorWithMessage:tips];
}

- (void)showShakingMobilePhoneVibrate {
    [self.circleView showShakingMobilePhoneVibrate];
    self.password = @"";
    self.circleView.Password = self.password;
}

- (void)show {
    
    self.alpha = .0;
    self.closeBtn.transform =
    self.circleView.transform =
    self.titleLabel.transform =
    self.pwInputView.transform =
    self.logoImageView.transform = CGAffineTransformMakeTranslation(0, 25);

    [UIView animateWithDuration: .25
                          delay: .03
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.alpha = 1.0;
                         self.closeBtn.transform =
                         self.circleView.transform =
                         self.titleLabel.transform =
                         self.pwInputView.transform =
                         self.logoImageView.transform = CGAffineTransformIdentity;

                     } completion:nil];
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.alpha = .0;
        self.closeBtn.transform =
        self.circleView.transform =
        self.titleLabel.transform =
        self.pwInputView.transform =
        self.logoImageView.transform = CGAffineTransformMakeTranslation(0, 25);
    } completion:^(BOOL finished) {

        completion ? completion() : nil;
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.effectView.frame = self.bounds;
    
    self.circleView.height = 55;
    self.circleView.width = self.width - 80;
    self.circleView.centerX = self.width / 2;
    self.circleView.centerY = self.height / 2;
    
    
    CGFloat heith = [self.titleLabel.text heightForFont:self.titleLabel.font width:(self.width - 30)];
    self.titleLabel.height = heith;
    self.titleLabel.width = self.width - 24;
    self.titleLabel.bottom = self.circleView.top - 36;
    self.titleLabel.centerX = self.circleView.centerX;
    
    self.logoImageView.size = CGSizeMake(60, 58);
    self.logoImageView.centerX = self.circleView.centerX;
    self.logoImageView.bottom = self.titleLabel.top - 30;
    
    
    [self.pwInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@225);
        make.bottom.equalTo(self.mas_bottom).offset(-20-kSafeAreaBottom);
    }];
}

- (UIImageView *)logoImageView {
    return SW_LAZY(_logoImageView, ({
        
        UIImageView *logo =
        [UIImageView createImageViewWithSuperView:self
                                      contentMode:UIViewContentModeScaleAspectFit
                                            image:[UIImage imageNamed:@"3.0_PINLogo"]
                                    clipsToBounds:YES]; logo;
    }));
}

- (UIButton *)closeBtn {
    return SW_LAZY(_closeBtn, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"3.0_closePIN"] forState:UIControlStateNormal];
        CGFloat y = kSafeAreaTop + 2;
        btn.frame = CGRectMake(0, y, 40, 40);
        btn;
    }));
}

- (UILabel *)titleLabel {
    return SW_LAZY(_titleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(14);
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    }));
}

- (UIVisualEffectView *)effectView {
    return SW_LAZY(_effectView, ({
        
        UIVisualEffectView *effectView =
        [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        effectView;
    }));
}

- (IDCMPINLoginViewModel *)viewModel {
    return SW_LAZY(_viewModel, ({
        
        IDCMPINLoginViewModel *viewModel = [[IDCMPINLoginViewModel alloc] initWithParams:nil];
        viewModel;
    }));
}

- (IDCMPINNewCircleView *)circleView {
    return SW_LAZY(_circleView, ({
        
        IDCMPINNewCircleView *view = [IDCMPINNewCircleView new];
        [self addSubview:view];
        view;
    }));
}

- (IDCMPINPasswordNumberView *)pwInputView {
    return SW_LAZY(_pwInputView, ({
        
        IDCMPINPasswordNumberView *view = [IDCMPINPasswordNumberView new];
        [self addSubview:view];
        view;
    }));
}

@end



