//
//  IDCMBindMobileController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMBindMobileController
// @abstract 绑定手机号和更改手机号
// @discussion <#类的功能#>
//
#import "IDCMBindMobileController.h"
#import "IDCMBindMobileViewModel.h"
#import "IDCMEnterView.h"
#import "IDCMCountryView.h"
#import "IDCMAuthCodeView.h"
#import "IDCMSelectCountryController.h"
#import "IDCMCountryListModel.h"
#import "IDCMUserInfoModel.h"


@interface IDCMBindMobileController ()<IDCMSelectCountryControllerDelegate,UITextFieldDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMBindMobileViewModel *viewModel;
/**
 *  国家
 */
@property (strong, nonatomic) IDCMCountryView *countryView;
/**
 *  手机号
 */
@property (strong, nonatomic) IDCMEnterView *mobileNumView;
/**
 *  手机验证码
 */
@property (strong, nonatomic) IDCMAuthCodeView *mobileCodeView;
/**
 *  绑定按钮
 */
@property (strong, nonatomic) UIButton *nextButton;
@end

@implementation IDCMBindMobileController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.countryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.top.equalTo(self.view.mas_top).offset(50);
        make.height.equalTo(@28);
    }];
    [self.mobileNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.top.equalTo(self.countryView.mas_bottom).offset(22);
        make.height.equalTo(@28);
    }];
    [self.mobileCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.top.equalTo(self.mobileNumView.mas_bottom).offset(22);
        make.height.equalTo(@28);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.top.equalTo(self.mobileCodeView.mas_bottom).offset(50);
        make.height.equalTo(@40);
    }];
}
#pragma mark - InitUI
- (void)configView
{
    self.view.backgroundColor = UIColorWhite;
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[self class]];
    NSString *title = @"";
    if ([self.viewModel.type isEqualToNumber:@(0)]) {
        title = SWLocaloziString(@"2.2.3_Bind");
        self.title = SWLocaloziString(@"2.2.3_BindMobile");
    }else{
        title = SWLocaloziString(@"2.2.3_Modification");
        self.title = SWLocaloziString(@"2.2.3_ModifyMobile");
    }
    
    [self.nextButton setTitle:title forState:UIControlStateNormal];
    
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
#pragma mark - Bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
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
    
    // 绑定手机跟邮箱
    RAC(self.viewModel,countryName) = [RACObserve(self.countryView.countryLabel, text) merge:self.countryView.countryLabel.rac_textSignal];
    RAC(self.viewModel,moblie) = [RACObserve(self.mobileNumView.textField, text) merge:self.mobileNumView.textField.rac_textSignal];
    RAC(self.viewModel,moblieCode) = RACObserve(self.mobileNumView.titleLabel, text);
    RAC(self.viewModel,moblieVaeifyCode) = [RACObserve(self.mobileCodeView.textField, text) merge:self.mobileCodeView.textField.rac_textSignal];
    

    // 验证码按钮事件
    self.mobileCodeView.authButton.rac_command = self.viewModel.authButtonCommand;
    
    // 监听手机验证码
    [[[self.viewModel.sendSmsCommand.executionSignals switchToLatest] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         
         NSInteger status= [response[@"status"] integerValue];
         if (status == 1) {
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_VerificationCodeSend", nil) withPosition:QMUIToastViewPositionBottom];
             
         }else{
             [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.0_VerificationCodeSendEmailFail") withPosition:QMUIToastViewPositionBottom];
         }
     }];
    
    [[self.viewModel.sendSmsCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        
        @strongify(self);
        [self.mobileCodeView.textField becomeFirstResponder];
    }];
    
    // 点击绑定按钮
    self.nextButton.rac_command = self.viewModel.bindMobileCommand;
    
    // 监听绑定信号
    [[[self.viewModel.bindMobileCommand.executionSignals switchToLatest] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSInteger status= [response[@"status"] integerValue];
         if (status == 102){
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_VerificationCodeError", nil) withPosition:QMUIToastViewPositionBottom];
         }else if (status == 1 && ![response[@"data"] isKindOfClass:[NSNull class]] && response[@"data"] != nil){
             
             if ([self.viewModel.type isEqualToNumber:@(0)]) {
                 [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.3_BindSuccess", nil) withPosition:QMUIToastViewPositionBottom];
             }else{
                 [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.3_ModificationSuccess", nil) withPosition:QMUIToastViewPositionBottom];
             }
             // 保存修改成功的信息
             IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
             NSString *code = [self.viewModel.moblieCode substringFromIndex:1];
             userModel.mobile = [NSString stringWithFormat:@"%@%@",code,self.viewModel.moblie];
             [IDCMUtilsMethod keyedArchiverWithObject:userModel withKey:UserModelArchiverkey];
             
             [self.navigationController popViewControllerAnimated:YES];
         }else{
             if ([self.viewModel.type isEqualToNumber:@(0)]) {
                 [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.3_BindFail", nil) withPosition:QMUIToastViewPositionBottom];
             }else{
                 [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.3_ModificationFail", nil) withPosition:QMUIToastViewPositionBottom];
             }
         }
     }];
    
    [[self.viewModel.bindMobileCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        
        @strongify(self);
        [self.view endEditing:YES];
        
    }];
}
#pragma mark - Privater Methods
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

#pragma mark - Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqual: @" "]) {
        return NO;
    }
    return YES;
}

#pragma mark - Getter & Setter
- (IDCMCountryView *)countryView
{
    return SW_LAZY(_countryView, ({
        IDCMCountryView *view = [IDCMCountryView new];
        view.titleLabel.text = NSLocalizedString(@"2.0_Country", nil);
        view.countryLabel.placeholder = NSLocalizedString(@"2.0_SelectCountry", nil);
        view.countryLabel.enabled = NO;
        view.logoImageView.image = UIImageMake(@"2.2_guojialogo");
        [self.view addSubview:view];
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
        view.titleLabel.text = NSLocalizedString(@"2.0_Mobile", nil);
        view.titleLabel.text = @"+000";
        view.textField.delegate = self;
        view.logoImageView.image = UIImageMake(@"2.2_shoujihaologo");
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMAuthCodeView *)mobileCodeView
{
    return SW_LAZY(_mobileCodeView, ({
        IDCMAuthCodeView *view = [IDCMAuthCodeView new];
        view.textField.placeholder = NSLocalizedString(@"2.0_EnterVerificationCode", nil);
        view.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        view.textField.keyboardType = UIKeyboardTypeNumberPad;
        view.textField.delegate = self;
        [view.authButton setTitleColor:SetColor(153, 159, 165) forState:UIControlStateDisabled];
        [view.authButton setTitleColor:SetColor(41, 104, 185) forState:UIControlStateNormal];
        [self.view addSubview:view];
        view;
    }));
}
- (UIButton *)nextButton
{
    return SW_LAZY(_nextButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        [button setBackgroundImage:[UIImage imageWithColor:SetColor(153, 159, 165)] forState:UIControlStateDisabled];
        [button setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
        button.enabled = NO;
        [self.view addSubview:button];
        button;
    }));
}
@end
