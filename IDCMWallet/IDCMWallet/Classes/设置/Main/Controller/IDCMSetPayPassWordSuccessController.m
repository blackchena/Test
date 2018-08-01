//
//  IDCMSetPayPassWordSuccessController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMSetPayPassWordSuccessController.h"
#import "IDCMSetPayPassWordSuccessViewModel.h"



@interface IDCMSetPayPassWordSuccessController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMSetPayPassWordSuccessViewModel *viewModel;
/**
 *  完成按钮
 */
@property (strong, nonatomic) UIButton *doneButton;
/**
 *  提示语
 */
@property (strong, nonatomic) UILabel *hintlable;
/**
 *  提示语
 */
@property (strong, nonatomic) UILabel *rememberlable;
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoView;
@end

@implementation IDCMSetPayPassWordSuccessController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseData];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(70);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.width.equalTo(@80);
    }];
    [self.hintlable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.logoView.mas_bottom).offset(25);
        make.height.equalTo(@25);
        make.left.right.equalTo(self.view);
    }];
    [self.rememberlable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.hintlable.mas_bottom).offset(15);
        make.height.equalTo(@20);
        make.left.right.equalTo(self.view);
    }];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.rememberlable.mas_bottom).offset(50);
        make.height.equalTo(@40);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-50);
    }];
}
#pragma mark - Config
- (void)configBaseData
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setHidesBackButton:YES];
    self.fd_interactivePopDisabled = YES;
    self.title = self.viewModel.titleVC;
}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    
    
    @weakify(self);
    [[self.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self.navigationController popToRootViewControllerAnimated:YES];
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
        view.text = self.viewModel.hint;
        [self.view addSubview:view];
        view;
    }));
}
- (UILabel *)rememberlable
{
    return SW_LAZY(_rememberlable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(102, 102, 102);
        view.font = SetFont(@"PingFang-SC-Regular", 14);
        view.textAlignment = NSTextAlignmentCenter;
        view.text = self.viewModel.remember;
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
        [button setTitle:NSLocalizedString(@"2.0_Complete", nil) forState:UIControlStateNormal];
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
@end
