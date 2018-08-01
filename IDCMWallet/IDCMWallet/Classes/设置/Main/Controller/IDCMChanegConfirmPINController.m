//
//  IDCMChanegConfirmPINController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/28.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChanegConfirmPINController.h"
#import "IDCMPINNewCircleView.h"
#import "IDCMPINPasswordNumberView.h"
#import "IDCMUserInfoModel.h"


@interface IDCMChanegConfirmPINController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMChangeConfirmViewModel *viewModel;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *hintlable;

/**
 *  原点view
 */
@property (strong, nonatomic) IDCMPINNewCircleView *circleView;
/**
 *  输入框
 */
@property (strong, nonatomic) IDCMPINPasswordNumberView *pwInputView;

/**
 *  下一步按钮
 */
@property (strong, nonatomic) UIButton *nextButton;
/**
 *  顶部蓝条
 */
@property (strong, nonatomic) UIView *blueOneView;

@end

@implementation IDCMChanegConfirmPINController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseData];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.blueOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.height.equalTo(@4);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [self.hintlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@25);
        make.top.equalTo(self.view.mas_top).offset(55);
    }];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@55);
        make.top.equalTo(self.hintlable.mas_bottom).offset(20);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@40);
        make.top.equalTo(self.circleView.mas_bottom).offset(40);
    }];
    [self.pwInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@225);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20-kSafeAreaBottom);
    }];
}
#pragma mark - Config
- (void)configBaseData
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"2.0_ChangePayPassWord", nil);
}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];

    @weakify(self);
    
    self.pwInputView.PINNumberBlock = ^(NSInteger number, IDCMPINNumberType type) {
        @strongify(self);
        if (type == IDCMPINNumberAdd) {
            if (self.viewModel.confirmPassword.length < 6) {
                self.viewModel.confirmPassword = [NSString stringWithFormat:@"%@%zd",self.viewModel.confirmPassword,number];
                self.circleView.Password = self.viewModel.confirmPassword;
            }
        }else{
            if (self.viewModel.confirmPassword.length > 0) {
                self.viewModel.confirmPassword = [self.viewModel.confirmPassword substringToIndex:([self.viewModel.confirmPassword length]-1)];
                self.circleView.Password = self.viewModel.confirmPassword;
            }
        }
    };
    
    // 监听密码长度
    [[[RACObserve(self.viewModel, confirmPassword) deliverOnMainThread] distinctUntilChanged]
     subscribeNext:^(NSString *password) {
         @strongify(self);
         if (password.length == 6) {
             self.nextButton.enabled = YES;
             self.nextButton.backgroundColor = kThemeColor;
             
         }else{
             self.nextButton.enabled = NO;
             self.nextButton.backgroundColor = SetColor(153, 159, 165);
             
         }
     }];
    
    // 监听下一步按钮
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         if (self.viewModel.confirmPassword.length == 6) {
             
             if (![self.viewModel.confirmPassword isEqualToString:self.viewModel.newpassword]) {
                 [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.0_PayPasswordMismatch")];
                 [self.navigationController popViewControllerAnimated:YES];
                 return ;
             }
             [self.viewModel.setPayPassWordCommand execute:nil];
             
         }
     }];
    // 重新设置密码
    [[[self.viewModel.setPayPassWordCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSInteger status= [response[@"status"] integerValue];
         if (status == 1) {
             
             // 如果设置Face ID或Touch ID，更新支付密码
             IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
             NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:FaceIDOrTouchIDKey];
             if ([dataDic count]>0 && dataDic) {
                 [dataDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                     @strongify(self);
                     if ([model.user_name isEqualToString:key]) {
                         // 加密PIN
                         NSString *PIN = aesEncryptString(self.viewModel.confirmPassword, AESLockPINKey);
                         [dataDic setObject:PIN forKey:model.user_name];
                         [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:FaceIDOrTouchIDKey];
                     }
                 }];
                 
             }
             
             [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMSetPayPassWordSuccessController" withViewModelName:@"IDCMSetPayPassWordSuccessViewModel" withParams:@{@"titleVC":NSLocalizedString(@"2.0_ChangePayPassWord", nil),@"hint":NSLocalizedString(@"2.0_ChangePaySuccess", nil),@"remember":NSLocalizedString(@"2.0_RememberChangePayWord", nil)}];
         }else if (status == 114){
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_NewPayPWNotOldPW", nil)];
             [self.navigationController popViewControllerAnimated:YES];
         }else if (status == 109){
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_payPasswordError", nil)];
         }
     }];
}
#pragma mark - getter
- (UILabel *)hintlable
{
    return SW_LAZY(_hintlable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Regular", 16);
        view.textAlignment = NSTextAlignmentCenter;
        view.text = NSLocalizedString(@"2.0_EnterAgainNewPayPW", nil);
        [self.view addSubview:view];
        view;
    }));
}

- (UIButton *)nextButton
{
    return SW_LAZY(_nextButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        [button setBackgroundColor:SetColor(153, 159, 165)];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:NSLocalizedString(@"2.0_Done", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.enabled = NO;
        [self.view addSubview:button];
        button;
    }));
}
- (UIView *)blueOneView
{
    return SW_LAZY(_blueOneView, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(41, 104, 185);
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMPINNewCircleView *)circleView
{
    return SW_LAZY(_circleView, ({
        IDCMPINNewCircleView *view = [IDCMPINNewCircleView new];
        [self.view addSubview:view];
        view;
    }));
}

- (IDCMPINPasswordNumberView *)pwInputView
{
    return SW_LAZY(_pwInputView, ({
        IDCMPINPasswordNumberView *view = [IDCMPINPasswordNumberView new];
        [self.view addSubview:view];
        view;
    }));
}
@end
