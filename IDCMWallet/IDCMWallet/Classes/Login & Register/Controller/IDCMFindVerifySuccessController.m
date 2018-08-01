//
//  IDCMFindVerifySuccessController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/26.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFindVerifySuccessController.h"
#import "IDCMWhiteNavigationBar.h"

@interface IDCMFindVerifySuccessController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMFindVerifySuccessViewModel *viewModel;
/**
 *  导航栏
 */
@property (strong, nonatomic) IDCMWhiteNavigationBar *navigationBar;
/**
 *  完成按钮
 */
@property (strong, nonatomic) UIButton *doneButton;
/**
 *  提示语
 */
@property (strong, nonatomic) UILabel *hintlable;

/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoView;
@end

@implementation IDCMFindVerifySuccessController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseData];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
    }];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.navigationBar.mas_bottom).offset(73);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.width.equalTo(@80);
    }];
    [self.hintlable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.logoView.mas_bottom).offset(18);
        make.height.equalTo(@25);
        make.left.right.equalTo(self.view);
    }];

    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.hintlable.mas_bottom).offset(100);
        make.height.equalTo(@40);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-50);
    }];
}
#pragma mark - Config
- (void)configBaseData
{
    self.view.backgroundColor = UIColorWhite;
    self.fd_interactivePopDisabled = YES;
    self.fd_prefersNavigationBarHidden = YES;
}
- (void)bindViewModel
{
    [super bindViewModel];
    
    
    [[self.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         
         [[IDCMMediatorAction sharedInstance]
          pushViewControllerWithClassName:@"IDCMSetPINController"
          withViewModelName:@"IDCMSetPINViewModel" withParams:@{@"setPINType":@(0)}];
     }];
}

#pragma mark - getter
- (IDCMWhiteNavigationBar *)navigationBar
{
    return SW_LAZY(_navigationBar, ({
        IDCMWhiteNavigationBar *view = [IDCMWhiteNavigationBar new];
        view.titlelable.text = SWLocaloziString(@"2.0_FindWalletPW");
        view.backButton.hidden = YES;
        [self.view addSubview:view];
        view;
    }));
}
- (UILabel *)hintlable
{
    return SW_LAZY(_hintlable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(102, 102, 102);
        view.font = SetFont(@"PingFang-SC-Regular", 16);
        view.textAlignment = NSTextAlignmentCenter;
        view.text = SWLocaloziString(@"2.1_FindWalletSuccess");
        [self.view addSubview:view];
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
        [button setTitle:SWLocaloziString(@"2.1_IntoWallet") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
}
- (UIImageView *)logoView
{
    return SW_LAZY(_logoView, ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"2.0_success"];
        view.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:view];
        view;
    }));
}
#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
