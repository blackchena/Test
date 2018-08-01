//
//  IDCMPINViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/24.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPINViewController.h"
#import "IDCMPINLoginViewModel.h"
#import "IDCMPINLoginView.h"
#import "IDCMUserInfoModel.h"
#import "IDCMBioMetricAuthenticator.h"
#import "IDCMMaintenanceViewController.h"

@interface IDCMPINViewController ()
@property (nonatomic, strong, readonly) IDCMPINLoginViewModel *viewModel;
/**
 *  loginView
 */
@property (strong, nonatomic) IDCMPINLoginView *PINView;
/**
 *  是否开启FaceID
 */
@property (assign, nonatomic) BOOL isfaceID;
@end

@implementation IDCMPINViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (IDCM_APPDelegate.threeType != kIDCMThreePartiesWithdrawl || IDCM_APPDelegate.threeType != kIDCMThreePartiesPay) {
        [self validationIDTouch];
    }
    
}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    // 退出登录
    [[[self.PINView.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         
         [IDCMUtilsMethod logoutWallet];
     }];
    
    // 验证密码
    [[[self.viewModel.verifyPIN.executionSignals switchToLatest] deliverOnMainThread]
     subscribeNext:^(NSDictionary *responseObj) {
         @strongify(self);
         NSString *status = [NSString idcw_stringWithFormat:@"%@",responseObj[@"status"]];
         if ([status isEqualToString:@"1"] && [responseObj[@"data"] isKindOfClass:[NSDictionary class]] && [responseObj[@"data"][@"isLocked"] isKindOfClass:[NSNumber class]] && [responseObj[@"data"][@"isValid"] isKindOfClass:[NSNumber class]] && [responseObj[@"data"][@"isNewBackups"] isKindOfClass:[NSNumber class]]) {
             
             // 是否被锁定
             BOOL isLocked = [responseObj[@"data"][@"isLocked"] boolValue];
             // 密码是否验证通过
             BOOL isValid  = [responseObj[@"data"][@"isValid"] boolValue];
             // 是否备份新助记词
             BOOL isNewBackups  = [responseObj[@"data"][@"isNewBackups"] boolValue];
             
             if (isNewBackups) {  // 已经备份新助记词
                 
                 if (isValid && !isLocked) { // 密码通过并且没有锁住
                     NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:UnlockKey];
                     IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
                     if ([dataDic count]>0) {
                         [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                             if ([model.user_name isEqualToString:key]) {
                                 NSNumber *num = [NSNumber numberWithInteger:([obj integerValue] + 1)];
                                 [dataDic setObject:num forKey:model.user_name];
                                 [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:UnlockKey];
                             }
                         }];
                     }
                     [IDCM_APPDelegate setTabBarViewController];
                     [IDCMControllerTool bringToFront];
                     
                 }else if (!isLocked && !isValid){ // 密码没有通过并且没有锁住
                     
                     [self showUnvalidView:responseObj];

                 }else if (isLocked){ // 密码被锁住
                     
                     [self showLockView:responseObj];
                 }
             }else{ // 未备份新助记词
                 
                 [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMMaintenanceBackupController"
                                                                    withViewModelName:@"IDCMBackupMemorizingWordsViewModel"
                                                                           withParams:@{@"backupType":@(0)}];
             }
             
             
         }else{
             [self.PINView showShakingMobilePhoneVibrate];
         }
        
     }];
    
    [[[RACObserve(self.PINView, password) deliverOnMainThread] distinctUntilChanged]
     subscribeNext:^(NSString *password) {
         @strongify(self);
         if (password.length == 6) {
             [self.viewModel.verifyPIN execute:password];
         }
         
     }];
}

#pragma mark — private methods
//验证指纹
- (void)validationIDTouch
{
    @weakify(self)
    NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:FaceIDOrTouchIDKey];
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    __block NSString *passWord = @"";
    if ([IDCMBioMetricAuthenticator canAuthenticate]) { // 开启了权限
        if ([dataDic count]>0 && dataDic) {
            [dataDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                @strongify(self);
                if ([model.user_name isEqualToString:key]) {
                    
                    self.isfaceID  = YES;
                    NSString *PIN = obj;
                    passWord = aesDecryptString(PIN,AESLockPINKey);
                }
            }];
        }else{
            self.isfaceID = NO;
        }
        
    }else{ // 关闭了权限
        
        if ([dataDic count]>0 && dataDic) {
            [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([model.user_name isEqualToString:key]) {
                    [dataDic removeObjectForKey:key];
                }
            }];
            [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:FaceIDOrTouchIDKey];
        }
        self.isfaceID = NO;
    }
    
    
    if (self.isfaceID && [passWord isNotBlank]) {
        
        [IDCMBioMetricAuthenticator authenticateWithBioMetricsOfReason:isiPhoneX ? NSLocalizedString(@"2.0_VerifyFaceID", nil) : NSLocalizedString(@"2.0_VerifyTouchID", nil) successBlock:^{

            @strongify(self);
            UIViewController *vc = [IDCMUtilsMethod currentViewController];
            if (![vc isKindOfClass:[IDCMMaintenanceViewController class]]) {
                [self.viewModel.verifyPIN execute:passWord];
            }
        } failureBlock:^(IDCMAuthType authenticationType, NSString *errorMessage) {
            
            @strongify(self)
            if (authenticationType == IDCMAuthTypeFail || authenticationType == IDCMAuthTypeBiometryLockout || authenticationType == IDCMAuthTypeFallback) {
                
            }
            //抖动
            [self.PINView showShakingMobilePhoneVibrate];
        }];
    }
}
// 展示PIN未通过
- (void)showUnvalidView:(NSDictionary *)responseObj
{
    [self.PINView showShakingMobilePhoneVibrate];
    
    NSString *residueCount = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"residueCount"]];
    NSInteger count = [responseObj[@"data"][@"residueCount"] integerValue];
    
    if (count <= 3) {
        
        NSString *tips = [SWLocaloziString(@"2.2.3_PINIsValid") stringByReplacingOccurrencesOfString:@"[IDCW]" withString:residueCount];
        [IDCMShowMessageView showErrorWithMessage:tips];
    }
}
// 展示PIN被锁定
- (void)showLockView:(NSDictionary *)responseObj
{
    [self.PINView showShakingMobilePhoneVibrate];
    
    NSInteger hours = [responseObj[@"data"][@"hours"] integerValue];
    NSInteger minutes = [responseObj[@"data"][@"minutes"] integerValue];
    
    NSString *hour = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"hours"]];
    NSString *minute = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"minutes"]];
    
    NSString *tips = @"";
    
    if (hours > 0 && minutes > 0) {
        tips = [SWLocaloziString(@"2.2.3_PINIsLock") stringByReplacingOccurrencesOfString:@"[IDCWH]" withString:hour];
        tips = [tips stringByReplacingOccurrencesOfString:@"[IDCWM]" withString:minute];
    }else if (hours > 0 && minutes == 0){
        tips = [SWLocaloziString(@"2.2.3_PINIsLockHours") stringByReplacingOccurrencesOfString:@"[IDCWH]" withString:hour];
    }else if (hours == 0 && minutes > 0){
        tips = [SWLocaloziString(@"2.2.3_PINIsLockMintues") stringByReplacingOccurrencesOfString:@"[IDCWH]" withString:minute];
    }
    
    
    [IDCMShowMessageView showErrorWithMessage:tips];
}
#pragma mark - getter
- (IDCMPINLoginView *)PINView
{
    return SW_LAZY(_PINView, ({
        IDCMPINLoginView *view = [IDCMPINLoginView new];
        view.frame = self.view.bounds;
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
