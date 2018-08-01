//
//  IDCMMovieLoginController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/13.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMMovieLoginController.h"
#import "FLAnimatedImage.h"
#import <MessageUI/MFMailComposeViewController.h>

#define LoginBigModeHeightRate (isiPhone6Big ? 0.80 : 1)
#define LoginBigModeSpaceRate (isiPhone6Big ? 0.45 : 1)

@interface IDCMMovieLoginController ()<MFMailComposeViewControllerDelegate>
/**
 *  登录按钮
 */
@property (strong, nonatomic) UIButton *loginButton;
/**
 *  注册按钮
 */
@property (strong, nonatomic) UIButton *registerButton;
/**
 *  联系按钮
 */
@property (strong, nonatomic) UIButton *supportButton;
/**
 *  旧版入口
 */
@property (strong, nonatomic) UIButton *oldVersionButton;
/**
 *  gif
 */
@property (strong, nonatomic) FLAnimatedImageView *gifView;
/**
 *  icon
 */
@property (strong, nonatomic) UIImageView *iconImageView;
@end

@implementation IDCMMovieLoginController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.oldVersionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kSafeAreaTop+20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@25);
        make.width.greaterThanOrEqualTo(@65);
    }];
    
    [self.supportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottom-30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@35);
        make.width.equalTo(@155);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@220);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.supportButton.mas_top).offset(-20);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@220);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.registerButton.mas_top).offset(-20);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loginButton.mas_top).offset(-(100*LoginBigModeSpaceRate));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(23));
        make.width.equalTo(@(175));
    }];
    
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_top).offset(-15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.equalTo(@(231*LoginBigModeHeightRate));
    }];
}
#pragma mark - bind
- (void)bindViewModel{
    
    [super bindViewModel];
    
    @weakify(self);
    // 登录
    [[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         
         [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMWalletIDSettingController"
                                                            withViewModelName:@"IDCMWalletIDSettingViewModel"
                                                                   withParams:nil];
     }];
    // 注册
    [[[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         
         [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMSettingMemorizingWordsController"
                                                            withViewModelName:@"IDCMSettingMemorizingWordsViewModel"
                                                                   withParams:nil];
     }];
    // 旧版本入口
    [[[self.oldVersionButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         
         [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMLoginController"
                                                            withViewModelName:@"IDCMLoginViewModel"
                                                                   withParams:nil];
     }];
    // 邮箱入口
    [[[self.supportButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self sendEmail];
     }];
    [[self
      rac_signalForSelector:@selector(mailComposeController:didFinishWithResult:error:)
      fromProtocol:@protocol(MFMailComposeViewControllerDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
}

#pragma mark — Private methods
- (void)sendEmail{
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    if (mailViewController && [MFMailComposeViewController canSendMail]) { // 邮件控制器不为空且邮箱已经绑定了账号
        
        mailViewController.mailComposeDelegate = self;
        //添加收件人
        NSArray *toRecipients = [NSArray arrayWithObject: @"support@idcw.io"];
        [mailViewController setToRecipients:toRecipients];
        [self presentViewController:mailViewController animated:YES completion:nil];
        
    }else{ // 邮件控制器为空或邮箱未绑定账号
        
        if (@available(iOS 10,*)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@idcw.io"] options:@{} completionHandler:^(BOOL success) {
            }];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@idcw.io"]];
        }
    }
}
#pragma mark - getter
- (UIButton *)supportButton{
    
    return SW_LAZY(_supportButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = textFontPingFangRegularFont(14);
        [button setTitle:@"support@idcw.io" forState:UIControlStateNormal];
        [button setTitleColor:textColor333333 forState:UIControlStateNormal];
        [button setBackgroundImage:UIImageMake(@"3.0_SupportBorder") forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
    
}
- (UIButton *)loginButton
{
    return SW_LAZY(_loginButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        [button setBackgroundColor:kThemeColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:NSLocalizedString(@"2.2.3_CreatWallet", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
}
- (UIButton *)registerButton
{
    return SW_LAZY(_registerButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = kThemeColor.CGColor;
        button.layer.borderWidth = 0.5;
        [button setTitle:NSLocalizedString(@"2.2.3_RecoverWallet", nil) forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:button];
        button;
    }));
}
- (UIButton *)oldVersionButton
{
    return SW_LAZY(_oldVersionButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        [button setTitle:NSLocalizedString(@"2.2.3_OldVersion", nil) forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.view addSubview:button];
        button;
    }));
}
- (FLAnimatedImageView *)gifView
{
    return SW_LAZY(_gifView, ({
        FLAnimatedImageView *view = [FLAnimatedImageView new];
        view.userInteractionEnabled = YES;
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"2.0_gif" withExtension:@"gif"];
        NSData *data1 = [NSData dataWithContentsOfURL:url1];
        FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
        view.animatedImage = animatedImage1;
        view.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:view];
        view;
    }));
}
- (UIImageView *)iconImageView
{
    return SW_LAZY(_iconImageView, ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"2.1_walletName"];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.userInteractionEnabled = YES;
        view.clipsToBounds = YES;
        [self.view addSubview:view];
        view;
    }));
}
- (void)dealloc
{
    [self.gifView removeFromSuperview];
}
#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
