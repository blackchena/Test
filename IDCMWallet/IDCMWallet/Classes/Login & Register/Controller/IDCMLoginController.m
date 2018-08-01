//
//  IDCMLoginController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/23.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMLoginController.h"
#import "IDCMEnterView.h"
#import "IDCMInputNoTitleView.h"
#import "IDCMCountryView.h"
#import "IDCMSelectCountryController.h"
#import "IDCMCountryListModel.h"
#import "IDCMLoginViewModel.h"
#import "IDCMUserInfoModel.h"
#import "IDCMPasswordInputView.h"
#import "IDCMEmailPasswordView.h"

@interface IDCMLoginController ()<IDCMSelectCountryControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong, readonly) IDCMLoginViewModel *viewModel;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titlelable;
/**
 *  登录view
 */
@property (strong, nonatomic) UIView *mobileView;
/**
 *  国家
 */
@property (strong, nonatomic) IDCMCountryView *countryView;
/**
 *  手机号
 */
@property (strong, nonatomic) IDCMEnterView *mobileNumView;
/**
 *  手机登录密码
 */
@property (strong, nonatomic) IDCMPasswordInputView *mobilePWView;


/**
 *  邮箱view
 */
@property (strong, nonatomic) UIView *emailView;
/**
 *  邮箱
 */
@property (strong, nonatomic) IDCMInputNoTitleView *emailNumView;
/**
 *  邮箱密码
 */
@property (strong, nonatomic) IDCMEmailPasswordView *emailPWView;

/**
 *  登录按钮
 */
@property (strong, nonatomic) UIButton *loginButton;
/**
 *  退出按钮
 */
@property (strong, nonatomic) UIButton *backButton;
/**
 *  登录类型
 */
@property (strong, nonatomic) UIButton *loginTypeButton;
/**
 *  提示文本
 */
@property (strong, nonatomic) UILabel *hintLabel;
@end

@implementation IDCMLoginController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseView];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(kSafeAreaTop+10);
        make.height.equalTo(@25);
        make.width.equalTo(@60);
    }];
    [self.titlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.backButton.mas_centerY);
        make.height.equalTo(@25);
        make.width.equalTo(@200);
    }];

    [self.mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(94+kSafeAreaTop);
        make.height.equalTo(@128);
    }];
    [self.countryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileView.mas_left).offset(35);
        make.right.equalTo(self.mobileView.mas_right).offset(-35);
        make.top.equalTo(self.mobileView.mas_top);
        make.height.equalTo(@28);
    }];
    [self.mobileNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileView.mas_left).offset(35);
        make.right.equalTo(self.mobileView.mas_right).offset(-35);
        make.top.equalTo(self.countryView.mas_bottom).offset(22);
        make.height.equalTo(@28);
    }];
    [self.mobilePWView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileView.mas_left).offset(35);
        make.right.equalTo(self.mobileView.mas_right).offset(-35);
        make.top.equalTo(self.mobileNumView.mas_bottom).offset(22);
        make.height.equalTo(@28);
    }];

    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.top.equalTo(self.mobilePWView.mas_bottom).offset(60);
        make.height.equalTo(@40);
    }];
    [self.loginTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@200);
        make.top.equalTo(self.loginButton.mas_bottom).offset(24);
        make.height.equalTo(@30);
    }];
    
    [self.emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(94+kSafeAreaTop);
        make.height.equalTo(@128);
    }];
    [self.emailNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.emailView.mas_left).offset(35);
        make.right.equalTo(self.emailView.mas_right).offset(-35);
        make.top.equalTo(self.emailView.mas_top).offset(50);
        make.height.equalTo(@28);
    }];
    [self.emailPWView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emailView.mas_left).offset(35);
        make.right.equalTo(self.emailView.mas_right).offset(-35);
        make.top.equalTo(self.emailNumView.mas_bottom).offset(22);
        make.height.equalTo(@28);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.loginTypeButton.mas_bottom).offset(40);
        make.height.greaterThanOrEqualTo(@50);
    }];
    
}

#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    // 关闭
    [self.backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);

        [self.navigationController popViewControllerAnimated:YES];

    }];
    // 手机登录密码是否可见
    [self.mobilePWView.iconButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        self.mobilePWView.iconButton.selected = !self.mobilePWView.iconButton.selected;
        if (self.mobilePWView.iconButton.selected) {
            self.mobilePWView.textField.secureTextEntry = NO;
            [self.mobilePWView.iconButton setImage:[UIImage imageNamed:@"2.0_kejian"] forState:UIControlStateSelected];
        }else{
            self.mobilePWView.textField.secureTextEntry = YES;
            [self.mobilePWView.iconButton setImage:[UIImage imageNamed:@"2.0_bukejian"] forState:UIControlStateSelected];
        }
    }];
    // 邮箱登录密码是否可见
    [self.emailPWView.iconButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        self.emailPWView.iconButton.selected = !self.emailPWView.iconButton.selected;
        if (self.emailPWView.iconButton.selected) {
            self.emailPWView.textField.secureTextEntry = NO;
            [self.emailPWView.iconButton setImage:[UIImage imageNamed:@"2.0_kejian"] forState:UIControlStateSelected];
        }else{
            self.emailPWView.textField.secureTextEntry = YES;
            [self.emailPWView.iconButton setImage:[UIImage imageNamed:@"2.0_bukejian"] forState:UIControlStateSelected];
        }
    }];

    // 选择国家
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        IDCMSelectCountryController *countryVC = [IDCMSelectCountryController new];
        [[self
          rac_signalForSelector:@selector(selectCountryController: didAddContact:)
          fromProtocol:@protocol(IDCMSelectCountryControllerDelegate)]
         subscribeNext:^(RACTuple *tuple) {
             @strongify(self)
             IDCMCountryListModel *model = tuple.second;
             self.countryView.countryLabel.text = model.Name;
             self.mobileNumView.titleLabel.text = model.Areacode;
             self.mobileNumView.titleLabel.textColor = textColor333333;
             [self.mobileNumView.textField becomeFirstResponder];
         }];
        countryVC.delegate = self;
        [self.navigationController pushViewController:countryVC animated:YES];
    }];
    [self.countryView addGestureRecognizer:tap];
    
    // 切换登录方式
    [self.loginTypeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        @strongify(self);
        self.loginTypeButton.selected = !self.loginTypeButton.selected;
        [self.view endEditing:YES];
        if (self.loginTypeButton.selected) {
            self.emailView.hidden = NO;
            self.mobileView.hidden = YES;
            self.countryView.countryLabel.text = @"";
            self.mobilePWView.textField.text = @"";
            self.mobileNumView.textField.text = @"";
            self.mobileNumView.titleLabel.text = @"+000";
            self.mobileNumView.titleLabel.textColor = textColor999999;
            [self.loginTypeButton setTitle:NSLocalizedString(@"2.0_MobileLogin", nil) forState:UIControlStateNormal];
        }else{
            self.emailView.hidden = YES;
            self.mobileView.hidden = NO;
            self.emailNumView.textField.text = @"";
            self.emailPWView.textField.text = @"";
            [self.loginTypeButton setTitle:NSLocalizedString(@"2.0_EmailLogin", nil) forState:UIControlStateNormal];
        }
    }];
    
    // 绑定手机跟邮箱
    RAC(self.viewModel,countryName) = [RACObserve(self.countryView.countryLabel, text) merge:self.countryView.countryLabel.rac_textSignal];
    RAC(self.viewModel,moblie) = [RACObserve(self.mobileNumView.textField, text) merge:self.mobileNumView.textField.rac_textSignal];
    RAC(self.viewModel,moblieCode) = RACObserve(self.mobileNumView.titleLabel, text);
    RAC(self.viewModel,mobliePassword) = [RACObserve(self.mobilePWView.textField, text) merge:self.mobilePWView.textField.rac_textSignal];
    RAC(self.viewModel,eamil) = [RACObserve(self.emailNumView.textField, text) merge:self.emailNumView.textField.rac_textSignal];
    RAC(self.viewModel,eamilPassword) = [RACObserve(self.emailPWView.textField, text) merge:self.emailPWView.textField.rac_textSignal];
    
    [[self.viewModel.validMobileLoginSignal deliverOnMainThread]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         if ([value integerValue] == 0) {
             self.loginButton.enabled = NO;
             [self.loginButton setBackgroundColor:SetColor(153, 159, 165)];
         }else{
             self.loginButton.enabled = YES;
             [self.loginButton setBackgroundColor:kThemeColor];
         }
     }];
    
    [[self.viewModel.validEmailLoginSignal deliverOnMainThread]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         if ([value integerValue] == 0) {
             self.loginButton.enabled = NO;
             [self.loginButton setBackgroundColor:SetColor(153, 159, 165)];
         }else{
             self.loginButton.enabled = YES;
             [self.loginButton setBackgroundColor:kThemeColor];
         }
     }];

    // 点击登录按钮
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self.view endEditing:YES];
         if (self.loginTypeButton.selected) {
             if ([self.viewModel.eamil rangeOfString:@" "].location != NSNotFound) {
                 [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_Space", nil)];
                 return ;
             }
             NSDictionary *para = @{@"walletId":self.viewModel.eamil,
                                    @"password":self.self.viewModel.eamilPassword,
                                    @"client":@"app",
                                    @"newVersion":@"false"
                                    };
             [self.viewModel.loginCommand execute:para];
         }else{
             NSString *code = [self.viewModel.moblieCode substringFromIndex:1];
             NSDictionary *para = @{@"walletId":[NSString stringWithFormat:@"%@%@",code,self.viewModel.moblie],
                                    @"password":self.viewModel.mobliePassword,
                                    @"client":@"app",
                                    @"newVersion":@"false"
                                    };
             [self.viewModel.loginCommand execute:para];
         }
         
     }];
    
    // 监听登录
    [[self.viewModel.loginCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
        
         NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         
         if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
             
             IDCMUserInfoModel *model = [IDCMUserInfoModel yy_modelWithDictionary:response[@"data"]];
             [IDCMUtilsMethod keyedArchiverWithObject:model withKey:UserModelArchiverkey];

             
             [[IDCMMediatorAction sharedInstance]
              pushViewControllerWithClassName:@"IDCMNowBackupMemorizingWordsController"
              withViewModelName:@"IDCMBackupMemorizingWordsViewModel" withParams:@{@"backupType":@(2)}];
             
         }else if ([status isEqualToString:@"130"]){
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.3_OldLogin", nil) withPosition:QMUIToastViewPositionBottom];
         }else {
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_UserNameError", nil) withPosition:QMUIToastViewPositionBottom];
         }

     }];

}
#pragma mark - config
- (void)configBaseView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    self.titlelable.text = SWLocaloziString(@"2.1_login");
    
    self.emailView.hidden = YES;
    self.mobileView.hidden = NO;
    
    NSString *appLanguage = [IDCMUtilsMethod getPreferredLanguage];
    if ([appLanguage isEqualToString:@"zh-Hans"]) {//中文简体
        [self configLanguageCode:appLanguage];
    }else if ([appLanguage isEqualToString:@"zh-Hant"]){//中文繁体
        [self configLanguageCode:appLanguage];
    }else if ([appLanguage isEqualToString:@"en"]){//英语
        [self configLanguageCode:appLanguage];
    }else if ([appLanguage isEqualToString:@"vi"]){//越南语
        [self configLanguageCode:appLanguage];
    }
}
- (void)configLanguageCode:(NSString *)code{
    
    
    NSString *country = @"";
    NSString *areaCode = @"";
    if ([code isEqualToString:@"zh-Hans"]) {//中文简体
        country = @"中国";
        areaCode = @"+86";
    }else if ([code isEqualToString:@"zh-Hant"]){//中文繁体
        country = @"中國香港特別行政區";
        areaCode = @"+852";
    }else if ([code isEqualToString:@"en"]){//英语
        country = @"United Kingdom";
        areaCode = @"+44";
    }else if ([code isEqualToString:@"vi"]){//越南语
        country = @"Việt Nam";
        areaCode = @"+84";
    }
    self.countryView.countryLabel.text = country;
    self.mobileNumView.titleLabel.text = areaCode;
    self.mobileNumView.titleLabel.textColor = textColor333333;
    [self.mobileNumView.textField becomeFirstResponder];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqual: @" "]) {
        return NO;
    }
    return YES;
}
#pragma mark - getter
- (UILabel *)titlelable
{
    return SW_LAZY(_titlelable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = textFontPingFangMediumFont(18);
        view.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:view];
        view;
    }));
}
- (UIView *)mobileView
{
    return SW_LAZY(_mobileView, ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMCountryView *)countryView
{
    return SW_LAZY(_countryView, ({
        IDCMCountryView *view = [IDCMCountryView new];
        view.titleLabel.text = NSLocalizedString(@"2.0_Country", nil);
        view.countryLabel.placeholder = NSLocalizedString(@"2.0_SelectCountry", nil);
        view.countryLabel.enabled = NO;
        view.logoImageView.image = UIImageMake(@"2.2_guojialogo");
        [self.mobileView addSubview:view];
        view;
    }));
}
- (IDCMEnterView *)mobileNumView
{
    return SW_LAZY(_mobileNumView, ({
        IDCMEnterView *view = [IDCMEnterView new];
        view.textField.placeholder = NSLocalizedString(@"2.0_EnterMobile", nil);
        view.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        view.textField.keyboardType = UIKeyboardTypeNumberPad;
        view.textField.delegate = self;
        view.titleLabel.text = @"+000";
        view.logoImageView.image = UIImageMake(@"2.2_shoujihaologo");
        [self.mobileView addSubview:view];
        view;
    }));
}
- (IDCMPasswordInputView *)mobilePWView
{
    return SW_LAZY(_mobilePWView, ({
        IDCMPasswordInputView *view = [IDCMPasswordInputView new];
        view.textField.placeholder = NSLocalizedString(@"2.0_EnterPassword", nil);
        view.titleLabel.text = NSLocalizedString(@"2.0_Password", nil);
        view.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        view.textField.secureTextEntry = YES;
        view.textField.delegate = self;
        [view.iconButton setImage:[UIImage imageNamed:@"2.0_bukejian"] forState:UIControlStateNormal];
        [view.iconButton setImage:[UIImage imageNamed:@"2.0_kejian"] forState:UIControlStateSelected];
        view.logoImageView.image = UIImageMake(@"2.2_querenmimalogo");
        [self.mobileView addSubview:view];
        view;
    }));
}

- (UIView *)emailView
{
    return SW_LAZY(_emailView, ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMInputNoTitleView *)emailNumView
{
    return SW_LAZY(_emailNumView, ({
        IDCMInputNoTitleView *view = [IDCMInputNoTitleView new];
        view.textField.placeholder = NSLocalizedString(@"2.0_EnterEmail", nil);
        view.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        view.textField.keyboardType = UIKeyboardTypeEmailAddress;
        view.textField.delegate = self;
        view.logoImageView.image = UIImageMake(@"2.2_yonghulogo");
        [self.emailView addSubview:view];
        view;
    }));
}
- (IDCMEmailPasswordView *)emailPWView
{
    return SW_LAZY(_emailPWView, ({
        IDCMEmailPasswordView *view = [IDCMEmailPasswordView new];
        view.textField.placeholder = NSLocalizedString(@"2.0_EnterPassword", nil);
        view.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        view.textField.secureTextEntry = YES;
        view.textField.delegate = self;
        [view.iconButton setImage:[UIImage imageNamed:@"2.0_bukejian"] forState:UIControlStateNormal];
        [view.iconButton setImage:[UIImage imageNamed:@"2.0_kejian"] forState:UIControlStateSelected];
        view.logoImageView.image = UIImageMake(@"2.2_querenmimalogo");
        [self.emailView addSubview:view];
        view;
    }));
}

- (UIButton *)loginButton
{
    return SW_LAZY(_loginButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 18);
        [button setBackgroundColor:SetColor(153, 159, 165)];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:NSLocalizedString(@"2.0_Login", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.enabled = NO;
        [self.view addSubview:button];
        button;
    }));
}
- (UIButton *)backButton
{
    return SW_LAZY(_backButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"2.0_fanhuihei"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"2.0_fanhuihei"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.view addSubview:button];
        button;
    }));
}

- (UIButton *)loginTypeButton
{
    return SW_LAZY(_loginTypeButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        [button setTitle:NSLocalizedString(@"2.0_EmailLogin", nil) forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
}
- (UILabel *)hintLabel {
    return SW_LAZY(_hintLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = NSLocalizedString(@"2.2.3_ContactIDCW", nil);
        [self.view addSubview:label];
        label;
    }));
}
#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end



























