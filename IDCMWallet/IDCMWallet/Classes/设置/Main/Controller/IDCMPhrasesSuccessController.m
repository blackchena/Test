//
//  IDCMViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/27.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMPhrasesSuccessController.h"
#import "IDCMBackupMemorizingWordsController.h"
#import "IDCMWhiteNavigationBar.h"
#import "IDCMNowBackupMemorizingWordsController.h"

@interface IDCMPhrasesSuccessController ()
/**
 *  导航栏
 */
@property (strong, nonatomic) IDCMWhiteNavigationBar *navigationBar;
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoView;
/**
 *  备份成功
 */
@property (strong, nonatomic) UILabel *successLable;
/**
 *  提示语
 */
@property (strong, nonatomic) UILabel *hintLabel;
/**
 *  再次备份按钮
 */
@property (strong, nonatomic) UIButton *backupButton;
/**
 *  完成按钮
 */
@property (strong, nonatomic) UIButton *doneButton;
@end

@implementation IDCMPhrasesSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWhite;
    self.fd_interactivePopDisabled = YES;
    self.fd_prefersNavigationBarHidden = YES;

    [self actionBlock];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
    }];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.navigationBar.mas_bottom).offset(67);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.width.equalTo(@80);
    }];
    [self.successLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.logoView.mas_bottom).offset(20);
        make.height.equalTo(@25);
        make.left.right.equalTo(self.view);
    }];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.successLable.mas_bottom).offset(35);
        make.height.equalTo(@80);
        make.left.right.equalTo(self.view);
    }];
    [self.backupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hintLabel.mas_bottom).offset(60);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@260);
    }];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backupButton.mas_bottom).offset(20);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@260);
    }];
}
#pragma mark - action
- (void)actionBlock
{
    @weakify(self);
    // 再次备份
    [self.backupButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            // IDCMBackupMemorizingWordsController
            if ([controller isKindOfClass:[IDCMNowBackupMemorizingWordsController class]]) {
                IDCMNowBackupMemorizingWordsController *phraseVC =(IDCMNowBackupMemorizingWordsController *)controller;
                [self.navigationController popToViewController:phraseVC animated:YES];
            } 
        }
    }];
    // 完成
    [self.doneButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {

        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
#pragma mark - getter
- (IDCMWhiteNavigationBar *)navigationBar
{
    return SW_LAZY(_navigationBar, ({
        IDCMWhiteNavigationBar *view = [IDCMWhiteNavigationBar new];
        view.titlelable.text = SWLocaloziString(@"2.2.3_BackupMemorizingWordsSuccessTitle");
        view.backButton.hidden = YES;
        [self.view addSubview:view];
        view;
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
- (UILabel *)successLable
{
    return SW_LAZY(_successLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Regular", 16);
        view.text = NSLocalizedString(@"2.0_BackupSuccess", nil);
        view.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:view];
        view;
    }));
}
- (UILabel *)hintLabel
{
    return SW_LAZY(_hintLabel, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(102, 102, 102);
        view.font = SetFont(@"PingFang-SC-Regular", 14);
        view.text = NSLocalizedString(@"2.0_HintLabel", nil);
        view.textAlignment = NSTextAlignmentCenter;
        view.numberOfLines = 0;
        [self.view addSubview:view];
        view;
    }));
}
- (UIButton *)backupButton
{
    return SW_LAZY(_backupButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = kThemeColor.CGColor;
        button.layer.borderWidth = 1;
        [button setTitle:NSLocalizedString(@"2.0_AaginBackup", nil) forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:button];
        button;
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
#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
