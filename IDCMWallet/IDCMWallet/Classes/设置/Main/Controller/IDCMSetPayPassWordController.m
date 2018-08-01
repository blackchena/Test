//
//  IDCMSetPayPassWordController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/28.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMSetPayPassWordController.h"
#import "IDCMUserStateModel.h"
#import "IDCMBioMetricAuthenticator.h"
#import "IDCMUserInfoModel.h"
#import "LBXPermissionSetting.h"
#import "IDCMPINView.h"

@interface IDCMSetPayPassWordController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMSetPayPassWordViewModel *viewModel;

/**
 *  paimanager
 */
@property (strong, nonatomic) UIView *paymanngerView;
/**
 *  管理支付标题
 */
@property (strong, nonatomic) UILabel *payTitlelable;

/**
 *  设置支付密码按钮
 */
@property (strong, nonatomic) UIButton *setButton;



/**
 *  touchView
 */
@property (strong, nonatomic) UIView *touchView;
/**
 *  touch标题
 */
@property (strong, nonatomic) UILabel *touchTitlelable;
/**
 *  touch标题
 */
@property (strong, nonatomic) UILabel *touchLable;
/**
 *  开关
 */
@property (strong, nonatomic) UISwitch *payTouch;
/**
 *  支付密码
 */
@property (copy, nonatomic) NSString *passWordStr;

/**
 *  密码输入框
 */
@property (strong, nonatomic) IDCMPINView *passwordView;
@end

@implementation IDCMSetPayPassWordController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = viewBackgroundColor;

    self.title = NSLocalizedString(@"2.2.3_AcountPINManagment", nil);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configBaseData];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
 
    
    [self.paymanngerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(12);
        make.height.equalTo(@50);
    }];
    [self.payTitlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.paymanngerView.mas_left).offset(15);
        make.centerY.equalTo(self.paymanngerView.mas_centerY);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@150);
    }];

    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.paymanngerView.mas_right).offset(-15);
        make.centerY.equalTo(self.paymanngerView.mas_centerY);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@60);
    }];
  
    
    [self.touchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.paymanngerView.mas_bottom).offset(15);
        make.height.equalTo(@55);
    }];
    [self.payTouch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.touchView.mas_right).offset(-15);
        make.centerY.equalTo(self.touchView.mas_centerY);
    }];
    [self.touchLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payTouch.mas_left).offset(-15);
        make.centerY.equalTo(self.touchView.mas_centerY);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@60);
    }];
    [self.touchTitlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.touchView.mas_left).offset(15);
        make.centerY.equalTo(self.touchView.mas_centerY);
        make.height.equalTo(@20);
        make.right.equalTo(self.touchLable.mas_left).offset(-5);
    }];
}
#pragma mark - Config
- (void)configBaseData
{
    
    self.touchLable.text = isiPhoneX ? @"Face ID" : @"Touch ID";
    [self.payTouch setOn:NO];
    IDCMUserInfoModel *userInfomodel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:FaceIDOrTouchIDKey];
    
    @weakify(self);
    if ([IDCMBioMetricAuthenticator canAuthenticate]) { // 开启了权限

        if ([dataDic count]>0 && dataDic) {
            [dataDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                @strongify(self);
                if ([userInfomodel.user_name isEqualToString:key]) {
                    [self.payTouch setOn:YES];
                }
            }];
        }
    }else{ // 关闭了权限
        
        if ([dataDic count]>0 && dataDic) {
            [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([userInfomodel.user_name isEqualToString:key]) {
                    [dataDic removeObjectForKey:key];
                }
            }];
            [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:FaceIDOrTouchIDKey];
        }
        [self.payTouch setOn:NO];
    }
    
    // 创建PINView
    self.passwordView = [IDCMPINView bindPINViewType:IDCMPINButtonImageCloseType closeBtnInput:^(id input) {
        
        [IDCMBaseBottomTipView dismissWithCompletion:^{
            @strongify(self);
            [self.payTouch setOn:NO];
            [self.passwordView removePasseword:NO];
        }];
        
    } PINFinishBlock:^(NSString *password) {
        
        @strongify(self);
        self.passWordStr = password;
        [self.viewModel.verifyOldCommand execute:password];
    }];
}
#pragma mark - bind
- (void)bindViewModel
{
    
    [super bindViewModel];
    
    @weakify(self);

    [[self.setButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {

         [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMChangePayPasswordController" withViewModelName:@"IDCMChangePayPasswordViewModel" withParams:nil];
     }];

    
    [[self.payTouch rac_newOnChannel] subscribeNext:^(id x) {
        
        @strongify(self);
        
        if ([x boolValue]) {
     
            [IDCMBaseBottomTipView showTipViewToView:nil size:CGSizeMake(SCREEN_WIDTH, 440+kSafeAreaBottom) contentView:self.passwordView tipViewStatusCallback:nil];
 
        }else{
            
            IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
            NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:FaceIDOrTouchIDKey];
            if ([dataDic count]>0 && dataDic) {
                [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([model.user_name isEqualToString:key]) {
                        [dataDic removeObjectForKey:key];
                    }
                }];
                [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:FaceIDOrTouchIDKey];
            }
        }
    }];
    
    // 验证支付密码
    [[[self.viewModel.verifyOldCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSInteger status= [response[@"status"] integerValue];
         if (status == 1) {
             
             [self bioMetricAuthenticator];
         }else{
             [self.payTouch setOn:NO];
             
             [IDCMActionTipsView showWithConfigure:^(IDCMActionTipViewConfigure *configure) {
                 
                 [configure.getBtnsConfig removeFirstObject];
                 
                 configure.subTitle(SWLocaloziString(@"2.2.1_PINError"));
                 
                 configure
                 .getBtnsConfig
                 .lastObject
                 .btnTitle(SWLocaloziString(@"2.2.1_AgainEnter"))
                 .btnCallback(^{
                     @strongify(self);
                     [self.passwordView removePasseword:NO];
                 });
             }];
         }
     }];
    // 验证支付密码出错了
    [self.viewModel.verifyOldCommand.errors subscribeNext:^(NSError * error) {
        
        [IDCMBaseBottomTipView dismissWithCompletion:^{
            @strongify(self);
            [self.payTouch setOn:NO];
            [self.passwordView removePasseword:NO];
        }];
    }];

}
- (void)bioMetricAuthenticator
{
    @weakify(self);
    [IDCMBioMetricAuthenticator authenticateWithBioMetricsOfReason:isiPhoneX ? NSLocalizedString(@"2.0_VerifyFaceID", nil) : NSLocalizedString(@"2.0_VerifyTouchID", nil) successBlock:^{
        @strongify(self);
        [self.payTouch setOn:YES];
        [self.passwordView removePasseword:NO];
        [IDCMBaseBottomTipView dismissWithCompletion:^{
            [IDCMShowMessageView showErrorWithMessage:[NSString stringWithFormat:@"%@ %@",isiPhoneX ? @"Face ID" : @"Touch ID",NSLocalizedString(@"2.0_SetTouchIDSuccess", nil)]];
        }];
        
        IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
        NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:FaceIDOrTouchIDKey];
        // 加密PIN
        NSString *PIN = aesEncryptString(self.passWordStr, AESLockPINKey);
        
        if ([dataDic count]>0 && dataDic) {
            
            [dataDic setObject:PIN forKey:model.user_name];
            [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:FaceIDOrTouchIDKey];
        }else{
            NSMutableDictionary *dic = @{}.mutableCopy;
            [dic setObject:PIN forKey:model.user_name];
            [IDCMUtilsMethod keyedArchiverWithObject:dic withKey:FaceIDOrTouchIDKey];
        }
        
    } failureBlock:^(IDCMAuthType authenticationType, NSString *errorMessage) {
        
        
        // 弹框消失
        [IDCMBaseBottomTipView dismissWithCompletion:^{
            @strongify(self);
            [self.payTouch setOn:NO];
            [self.passwordView removePasseword:NO];
        }];
        
        IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
        NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:FaceIDOrTouchIDKey];
        if ([dataDic count]>0 && dataDic) {
            [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([model.user_name isEqualToString:key]) {
                    [dataDic removeObjectForKey:key];
                }
            }];
            [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:FaceIDOrTouchIDKey];
        }
        
        if (authenticationType == IDCMAuthTypeNotEnrolled) { // 用户未设置指纹，删除保存的记录
            
            [IDCMShowMessageView showErrorWithMessage:isiPhoneX ? NSLocalizedString(@"2.0_NotSetFaceID", nil) : NSLocalizedString(@"2.0_NotSetTouchID", nil)];
            return ;
        }
        if (authenticationType == IDCMAuthTypeBiometryLockout) {
            [IDCMBioMetricAuthenticator authenticateWithPasscodeOfReason:errorMessage fallbackTitle:nil cancelTitle:nil successBlock:^{
                
            } failureBlock:^(IDCMAuthType authenticationType, NSString *errorMessage) {
                
            }];
            return;
        }
        if (![IDCMBioMetricAuthenticator canAuthenticate]) { // 关闭了权限
            NSString *title = @"";
            NSString *message = @"";
            if (isiPhoneX) {
                title = SWLocaloziString(@"2.1_OpenFaceIDPermissions");
                message = SWLocaloziString(@"2.1_SetFacePermissionsTips");
            }else{
                title = SWLocaloziString(@"2.1_OpenTouchIDPermissions");
                message = SWLocaloziString(@"2.1_SetTouchIDPermissionsTips");
            }
            [IDCMControllerTool showAlertViewWithTitle:title message:message buttonArray:@[SWLocaloziString(@"2.1_SetCamerPermissions"),SWLocaloziString(@"2.0_Cancel")] actionBlock:^(NSInteger clickIndex) {
                if (clickIndex ==0) {
                    // 跳转至设置界面
                    [LBXPermissionSetting displayAppPrivacySettings];
                }
            }];
            
        }
        
    }];
}
#pragma mark - getter
- (UIView *)paymanngerView
{
    return SW_LAZY(_paymanngerView, ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        view;
    }));
}
- (UILabel *)payTitlelable
{
    return SW_LAZY(_payTitlelable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Regular", 14);
        view.text = NSLocalizedString(@"2.0_PayPassWordMannger", nil);
        view.textAlignment = NSTextAlignmentLeft;
        [self.paymanngerView addSubview:view];
        view;
    }));
}

- (UIButton *)setButton
{
    return SW_LAZY(_setButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:SetColor(59, 155, 252) forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 14);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitle:NSLocalizedString(@"2.0_Change", nil) forState:UIControlStateNormal];
        [self.paymanngerView addSubview:button];
        button;
    }));
}

- (UIView *)touchView
{
    return SW_LAZY(_touchView, ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        view;
    }));
}
- (UILabel *)touchTitlelable
{
    return SW_LAZY(_touchTitlelable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Regular", 14);
        view.textAlignment = NSTextAlignmentLeft;
        view.text = NSLocalizedString(@"2.0_PayPWPreferences", nil);
        [self.touchView addSubview:view];
        view;
    }));
}
- (UILabel *)touchLable
{
    return SW_LAZY(_touchLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Medium", 14);
        view.textAlignment = NSTextAlignmentRight;
        [self.touchView addSubview:view];
        view;
    }));
}
- (UISwitch *)payTouch
{
    return SW_LAZY(_payTouch, ({
        UISwitch *view = [[UISwitch alloc] init];
        view.tintColor = SetColor(224, 224, 224);
        view.onTintColor = kThemeColor;
        [self.touchView addSubview:view];
        view;
    }));
}
@end




















