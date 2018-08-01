//
//  IDCMBindEmailController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMBindEmailController
// @abstract <#类的描述#>
// @discussion <#类的功能#>
//
#import "IDCMBindEmailController.h"
#import "IDCMBindEmailViewModel.h"
#import "IDCMInputNoTitleView.h"
#import "IDCMAuthCodeView.h"
#import "IDCMUserInfoModel.h"

@interface IDCMBindEmailController ()<UITextFieldDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMBindEmailViewModel *viewModel;
/**
 *  邮箱
 */
@property (strong, nonatomic) IDCMInputNoTitleView *emailNumView;
/**
 *  邮箱验证码
 */
@property (strong, nonatomic) IDCMAuthCodeView *emailCodeView;
/**
 *  绑定按钮
 */
@property (strong, nonatomic) UIButton *nextButton;
@end

@implementation IDCMBindEmailController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    

    [self.emailNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.top.equalTo(self.view.mas_top).offset(50);
        make.height.equalTo(@28);
    }];
    [self.emailCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.top.equalTo(self.emailNumView.mas_bottom).offset(22);
        make.height.equalTo(@28);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.top.equalTo(self.emailCodeView.mas_bottom).offset(50);
        make.height.equalTo(@40);
    }];
}
#pragma mark - InitUI
- (void)configView
{
    self.view.backgroundColor = UIColorWhite;
    NSString *title = @"";
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[self class]];
    
    if ([self.viewModel.type isEqualToNumber:@(0)]) {
        title = SWLocaloziString(@"2.2.3_Bind");
        self.title = SWLocaloziString(@"2.2.3_BindEmail");
    }else{
        title = SWLocaloziString(@"2.2.3_Modification");
        self.title = SWLocaloziString(@"2.2.3_ModifyEmail");
    }
    
    [self.nextButton setTitle:title forState:UIControlStateNormal];
}
#pragma mark - Bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    
    RAC(self.viewModel,eamil) = [RACObserve(self.emailNumView.textField, text) merge:self.emailNumView.textField.rac_textSignal];
    RAC(self.viewModel,emailVaeifyCode) = [RACObserve(self.emailCodeView.textField, text) merge:self.emailCodeView.textField.rac_textSignal];
    
    
    // 验证码按钮事件
    self.emailCodeView.authButton.rac_command = self.viewModel.authButtonCommand;
    
    // 监听邮箱验证码
    [[[self.viewModel.sendEmailCommand.executionSignals switchToLatest] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         
         NSInteger status= [response[@"status"] integerValue];
         if (status == 1) {
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_VerificationCodeSendEmail", nil) withPosition:QMUIToastViewPositionBottom];
             
         }else{
             [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.0_VerificationCodeSendEmailFail") withPosition:QMUIToastViewPositionBottom];
         }
     }];
    
    [[self.viewModel.sendEmailCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        
        @strongify(self);
        [self.emailCodeView.textField becomeFirstResponder];
    }];
    
    
    // 点击绑定按钮
    self.nextButton.rac_command = self.viewModel.bindEmailCommand;
    
    // 监听绑定信号
    [[[self.viewModel.bindEmailCommand.executionSignals switchToLatest] deliverOnMainThread]
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
             userModel.email = [NSString stringWithFormat:@"%@",self.viewModel.eamil];
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
    
    [[self.viewModel.bindEmailCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        
        @strongify(self);
        [self.view endEditing:YES];
        
    }];
}


#pragma mark - Public Methods


#pragma mark - Privater Methods


#pragma mark - Action


#pragma mark - NetWork


#pragma mark - Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqual: @" "]) {
        return NO;
    }
    return YES;
}

#pragma mark - Getter & Setter
- (IDCMInputNoTitleView *)emailNumView
{
    return SW_LAZY(_emailNumView, ({
        IDCMInputNoTitleView *view = [IDCMInputNoTitleView new];
        view.textField.placeholder = NSLocalizedString(@"2.0_EnterRegidterEmail", nil);
        view.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        view.textField.keyboardType = UIKeyboardTypeEmailAddress;
        view.textField.delegate = self;
        view.logoImageView.image = UIImageMake(@"2.2_yonghulogo");
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMAuthCodeView *)emailCodeView
{
    return SW_LAZY(_emailCodeView, ({
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
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.enabled = NO;
        [self.view addSubview:button];
        button;
    }));
}
@end
