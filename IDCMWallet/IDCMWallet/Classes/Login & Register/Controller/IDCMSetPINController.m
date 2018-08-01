//
//  IDCMSetPINController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/26.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSetPINController.h"

#import "IDCMUserInfoModel.h"
#import "IDCMPINNewCircleView.h"
#import "IDCMPINPasswordNumberView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "IDCMWhiteNavigationBar.h"

#define space  (SCREEN_WIDTH*40)/375

#define PINBigModeHeightRate (isiPhone6Big ? 0.80 : 1)
#define PINBigModeSpaceRate (isiPhone6Big ? 0.45 : 1)


@interface IDCMSetPINController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMSetPINViewModel *viewModel;
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logo;
/**
 *  tip
 */
@property (strong, nonatomic) UILabel *tipsLabel;
/**
 *  忘记PIN按钮
 */
@property (strong, nonatomic) UIButton *nextStepButton;
/**
 *  设置PIN原点View
 */
@property (strong, nonatomic) IDCMPINNewCircleView *circleSetView;
/**
 *  确认PIN原点view
 */
@property (strong, nonatomic) IDCMPINNewCircleView *circleConfirmView;
/**
 *  输入框
 */
@property (strong, nonatomic) IDCMPINPasswordNumberView *pwInputView;
/**
 *  是否确认PIN
 */
@property (assign, nonatomic) BOOL isConfirmPIN;
@property (strong, nonatomic) IDCMWhiteNavigationBar *navigationBar;
@end

@implementation IDCMSetPINController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    
    
    if ([self.viewModel.setPINType isEqualToNumber:@(1)]) {
        @weakify(self);
        self.navigationBar.backBtnCallbak = ^(){
            @strongify(self);
            self.circleConfirmView.hidden = YES;
            self.circleSetView.hidden = YES;
        };
    }
    
    [self layoutSubView];
}

- (void)layoutSubView{
    
    if ([self.viewModel.setPINType isEqualToNumber:@(0)]) {
        
        [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset((55+kSafeAreaTop)*PINBigModeSpaceRate);
            make.width.equalTo(@(175*PINBigModeHeightRate));
            make.height.equalTo(@(100*PINBigModeHeightRate));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }else{
        [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
        }];
        [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navigationBar.mas_bottom).offset(8);
            make.width.equalTo(@(175*PINBigModeHeightRate));
            make.height.equalTo(@(100*PINBigModeHeightRate));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    
    
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@25);
        make.top.equalTo(self.logo.mas_bottom).offset(40*PINBigModeSpaceRate);
    }];
    [self.circleSetView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-space*2);
        make.height.equalTo(@(55*PINBigModeHeightRate));
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(20*PINBigModeSpaceRate);
    }];
    [self.circleConfirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH-space*2);
        make.height.equalTo(@(55*PINBigModeHeightRate));
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(20*PINBigModeSpaceRate);
    }];
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(space);
        make.right.equalTo(self.view.mas_right).offset(-space);
        make.height.equalTo(@40);
        make.top.equalTo(self.circleSetView.mas_bottom).offset(40*PINBigModeSpaceRate);
    }];
    [self.pwInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@240);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20-kSafeAreaBottom);
    }];
}
#pragma mark  -- Bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    self.isConfirmPIN = NO;
    
    // 点击按钮
    @weakify(self);
    [[[self.nextStepButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         if (self.viewModel.newpassword.length == 6 && ![self.viewModel.confirmPassword isNotBlank]) {
             [self setShowConfirmPINViewAnimation];
             return ;
         }
         if (self.viewModel.newpassword.length == 6 && self.viewModel.confirmPassword.length == 6 && ![self.viewModel.newpassword isEqualToString:self.viewModel.confirmPassword]) {
             AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
             [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.0_PayPasswordMismatch") withPosition:QMUIToastViewPositionTop];
             [self setShowPINViewAnimation];
             return;
         }
         
         if (self.viewModel.newpassword.length == 6 && self.viewModel.confirmPassword.length == 6 && [self.viewModel.newpassword isEqualToString:self.viewModel.confirmPassword]) {
             
             [self.viewModel.setPayPassWordCommand execute:nil];
         }
         
         
     }];
    
    self.pwInputView.PINNumberBlock = ^(NSInteger number, IDCMPINNumberType type) {
        @strongify(self);
        if (self.isConfirmPIN) { // 确认密码页面
            if (type == IDCMPINNumberAdd) {
                if (self.viewModel.confirmPassword.length < 6) {
                    self.viewModel.confirmPassword = [NSString stringWithFormat:@"%@%ld",self.viewModel.confirmPassword,(long)number];
                    self.circleConfirmView.Password = self.viewModel.confirmPassword;
                }
            }else{
                if (self.viewModel.confirmPassword.length > 0) {
                    self.viewModel.confirmPassword = [self.viewModel.confirmPassword substringToIndex:([self.viewModel.confirmPassword length]-1)];
                    self.circleConfirmView.Password = self.viewModel.confirmPassword;
                }
            }
        }else{ // 设置密码页面
            if (type == IDCMPINNumberAdd) {
                if (self.viewModel.newpassword.length < 6) {
                    self.viewModel.newpassword = [NSString stringWithFormat:@"%@%ld",self.viewModel.newpassword,(long)number];
                    self.circleSetView.Password = self.viewModel.newpassword;
                }
            }else{
                if (self.viewModel.newpassword.length > 0) {
                    self.viewModel.newpassword = [self.viewModel.newpassword substringToIndex:([self.viewModel.newpassword length]-1)];
                    self.circleSetView.Password = self.viewModel.newpassword;
                }
            }
        }
        
    };
    
    [[self.viewModel.validNextSignal deliverOnMainThread]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         if ([value boolValue]) {
             self.nextStepButton.enabled = YES;
             self.nextStepButton.backgroundColor = kThemeColor;
         }else{
             self.nextStepButton.enabled = NO;
             self.nextStepButton.backgroundColor = SetColor(153, 159, 165);
         }
     }];
    
    [[[self.viewModel.setPayPassWordCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         if ([status isEqualToString:@"0"]) {
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SetPayWordFail", nil)];
             
             [self setShowPINViewAnimation];
             
         }else if ([status isEqualToString:@"1"] && ![response[@"data"] isKindOfClass:[NSNull class]] && response[@"data"] != nil){
             
             IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
             model.payPasswordFlag = @(1);
             [IDCMUtilsMethod keyedArchiverWithObject:model withKey:UserModelArchiverkey];
             [IDCMDataManager sharedDataManager].userID = model.userID;
             if (IDCM_APPDelegate.threeType == kIDCMThreePartiesPay) { // 第三方支付
                 
                 [IDCM_APPDelegate setThirdPayController];
                 
             }else if (IDCM_APPDelegate.threeType == kIDCMThreePartiesWithdrawl){  // 第三方提现
                 
                 [IDCM_APPDelegate setWithdrawalController];
                 
             }else{
            
                 [IDCM_APPDelegate setTabBarViewController];
             }
         }
     }];
    
    
}

// 展示确认PIN
-(void)setShowConfirmPINViewAnimation
{
    self.isConfirmPIN = YES;
    self.tipsLabel.text = SWLocaloziString(@"2.1_ForgetPINPleaseConfirmPW");
    self.nextStepButton.enabled = NO;
    self.nextStepButton.backgroundColor = SetColor(153, 159, 165);
    [self.nextStepButton setTitle:SWLocaloziString(@"2.0_Done") forState:UIControlStateNormal];
    
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.circleSetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.view.mas_left);
            make.width.mas_equalTo(SCREEN_WIDTH-80);
            make.height.equalTo(@(55*PINBigModeHeightRate));
            make.top.equalTo(self.tipsLabel.mas_bottom).offset(20*PINBigModeSpaceRate);
        }];
        [self.circleConfirmView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(SCREEN_WIDTH-80);
            make.height.equalTo(@(55*PINBigModeHeightRate));
            make.top.equalTo(self.tipsLabel.mas_bottom).offset(20*PINBigModeSpaceRate);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
// 展示设置PIN
-(void)setShowPINViewAnimation
{
    self.isConfirmPIN = NO;
    self.tipsLabel.text = SWLocaloziString(@"2.0_PleaseSetPayWord");
    self.nextStepButton.enabled = NO;
    self.nextStepButton.backgroundColor = SetColor(153, 159, 165);
    [self.nextStepButton setTitle:SWLocaloziString(@"2.0_NextStep") forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.circleSetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(SCREEN_WIDTH-space*2);
            make.height.equalTo(@(55*PINBigModeHeightRate));
            make.top.equalTo(self.tipsLabel.mas_bottom).offset(20*PINBigModeSpaceRate);
        }];
        [self.circleConfirmView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_right);
            make.width.mas_equalTo(SCREEN_WIDTH-space*2);
            make.height.equalTo(@(55*PINBigModeHeightRate));
            make.top.equalTo(self.tipsLabel.mas_bottom).offset(20*PINBigModeSpaceRate);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    // 清空数据
    self.viewModel.newpassword = @"";
    self.viewModel.confirmPassword = @"";
    self.circleSetView.Password = @"";
    self.circleConfirmView.Password = @"";
}

#pragma mark - getter
- (UIImageView *)logo
{
    return SW_LAZY(_logo, ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        view.image = UIImageMake(@"2.2.1_SetPINLogo");
        [self.view addSubview:view];
        view;
    }));
}
- (UILabel *)tipsLabel
{
    return SW_LAZY(_tipsLabel, ({
        UILabel *label = [UILabel new];
        label.text = SWLocaloziString(@"2.0_PleaseSetPayWord");
        label.textColor = textColor666666;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFontPingFangRegularFont(16);
        [self.view addSubview:label];
        label;
    }));
}
- (IDCMPINNewCircleView *)circleSetView
{
    return SW_LAZY(_circleSetView, ({
        IDCMPINNewCircleView *view = [IDCMPINNewCircleView new];
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMPINNewCircleView *)circleConfirmView
{
    return SW_LAZY(_circleConfirmView, ({
        IDCMPINNewCircleView *view = [IDCMPINNewCircleView new];
        [self.view addSubview:view];
        view;
    }));
}
- (UIButton *)nextStepButton
{
    return SW_LAZY(_nextStepButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = textFontPingFangRegularFont(16);
        [button setBackgroundColor:SetColor(153, 159, 165)];
        button.enabled = NO;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:SWLocaloziString(@"2.0_NextStep") forState:UIControlStateNormal];
        [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
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
- (IDCMWhiteNavigationBar *)navigationBar {
    return SW_LAZY(_navigationBar, ({
        
        IDCMWhiteNavigationBar *view = [IDCMWhiteNavigationBar new];
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
