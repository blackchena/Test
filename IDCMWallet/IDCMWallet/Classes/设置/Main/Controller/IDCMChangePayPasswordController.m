//
//  IDCMChangePayPasswordController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChangePayPasswordController.h"
#import "IDCMChangePayPasswordViewModel.h"
#import "IDCMPINNewCircleView.h"
#import "IDCMPINPasswordNumberView.h"

@interface IDCMChangePayPasswordController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMChangePayPasswordViewModel *viewModel;

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

@implementation IDCMChangePayPasswordController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 清空数据
    self.circleView.Password = @"";
    self.viewModel.originalPayPwd = @"";
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self.blueOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.height.equalTo(@4);
        make.width.equalTo(@(SCREEN_WIDTH/3));
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
            if (self.viewModel.originalPayPwd.length < 6) {
                self.viewModel.originalPayPwd = [NSString stringWithFormat:@"%@%ld",self.viewModel.originalPayPwd,(long)number];
                self.circleView.Password = self.viewModel.originalPayPwd;
            }
        }else{
            if (self.viewModel.originalPayPwd.length > 0) {
                self.viewModel.originalPayPwd = [self.viewModel.originalPayPwd substringToIndex:([self.viewModel.originalPayPwd length]-1)];
                self.circleView.Password = self.viewModel.originalPayPwd;
            }
        }
    };
    
    // 监听密码长度
    [[[RACObserve(self.viewModel, originalPayPwd) deliverOnMainThread] distinctUntilChanged]
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

         if (self.viewModel.originalPayPwd.length == 6) {
             // 检查原始密码
             [self.viewModel.verifyOldCommand execute:nil];
         }
     }];
    
    // 检查原密码
    [[[self.viewModel.verifyOldCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSInteger status = [response[@"status"] integerValue];
         if (status == 1) {

             [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMChangeSetPINController" withViewModelName:@"IDCMChangeSetPINViewModel" withParams:@{@"originalPayPwd":self.viewModel.originalPayPwd}];
         }else{

             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_EnterPWError", nil)];
             [self showShakingMobilePhoneVibrate];
         }
     }];


}

- (void)showShakingMobilePhoneVibrate
{
    [self.circleView showShakingMobilePhoneVibrate];
    
    // 清除原有的Password
    self.viewModel.originalPayPwd = @"";
    self.circleView.Password = @"";
}
#pragma mark - getter
- (UILabel *)hintlable
{
    return SW_LAZY(_hintlable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Regular", 16);
        view.textAlignment = NSTextAlignmentCenter;
        view.text = NSLocalizedString(@"2.0_EnterOldPayPW", nil);
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
        [button setTitle:NSLocalizedString(@"2.0_NextStep", nil) forState:UIControlStateNormal];
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
