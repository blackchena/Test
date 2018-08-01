//
//  IDCMAppDelegate.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMAppDelegate.h"
#import "IDCMMovieLoginController.h"
#import "IDCMPINViewController.h"
#import "IDCMPINLoginViewModel.h"
#import "IDCMSetPINController.h"
#import "IDCMBackupMemorizingWordsController.h"
#import "IDCMBackupMemorizingWordsViewModel.h"
#import "IDCMThirdPaymentController.h"
#import "IDCMThirdPaymentViewModel.h"
#import "IDCMThirdPayModel.h"
#import "IDCMWithdrawalController.h"
#import "IDCMwithdrawalViewModel.h"
#import "IDCMLogFormatter.h"
#import "IDCMNowTimeExhangeRecordView.h"
#import "IDCMMaintenanceViewController.h"
#import "IDCMMaintenanceViewModel.h"
#import "IDCMDebugTool.h"

@interface IDCMAppDelegate()<UITabBarControllerDelegate, CYLTabBarControllerDelegate>

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign, readwrite) NetworkStatus networkStatus;

@property(nonatomic,assign)NSInteger  Backtime;
@property(nonatomic,assign)NSInteger  Activetime;

@end

@implementation IDCMAppDelegate

#pragma mark -
#pragma mark - Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 配置DDLog
    [self configDDLog];
    // 配置QMUI
    [self configurationQMUI];
    // 配置Window
    [self configBaseWindow:launchOptions];
    // 设置语言
    [NSBundle setLanguage:[IDCMUtilsMethod getPreferredLanguage]];
    // 请求蜂窝网络权限，在app启动时调用
    [ZIKCellularAuthorization requestCellularAuthorization];
    // 监听网络状态
    [self configurationNetWorkStatus];
    // 配置服务器环境
    [self configServerEnvironmentTool];
    // 配置IQKeyboardManager
    [self configurationIQKeyboard];
    // 配置Bugly
    [self configurationBugly];
    // 配置分享各平台APPkey以及AppSecret
    [IDCMUMShareUtils configUMShareInfo];
    // 检查更新
    [self requestUpdateVersion];
    // 检查维护页面
    [self requestMaintenance];
    // 设置跟控制器
    [self setRootViewController];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    // 应用退到后台，移除弹出框
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:RemoveAlertKey object:self];
    
    [self configBackgroundTimeout];
    [IDCMManagerObjTool manager].startEnterBackgroundTime = [[NSDate dateWithCurrentTimestamp] integerValue];
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 检查更新
    [self requestUpdateVersion];
    // 检查维护页面
    [self requestMaintenance];
    
    
    [IDCMManagerObjTool manager].didEnterFontgroundTime = [[NSDate dateWithCurrentTimestamp] integerValue];
    
    // V2.2改版增加
    [IDCMControllerTool showInputPINNumberController];
}
// 第三方支付调起
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([url.scheme containsString:@"twitterkit"]) {
        return [[Twitter sharedInstance] application:app openURL:url options:options];
    }else{
        
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
        if (!result) {
            // 其他APP调起本地支付
            [self thirdPartyPaymentSourceOptions:url];
        }
        return result;
    }
    
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
// 禁止第三方键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier

{
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        
        return NO;
    }
    return YES;
    
}
#pragma mark -
#pragma mark - SetViewController
- (void)configBaseWindow:(NSDictionary *)launchOptions{
    
    if ([launchOptions count] > 0) {
        [self thirdPartyPaymentAdjustment:launchOptions];
    }
    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = UIColorWhite;
    [self.window makeKeyAndVisible];
    
    [UINavigationConfig shared].sx_disableFixSpace = NO;//默认为NO  可以修改
    [UINavigationConfig shared].sx_defaultFixSpace = 12;//默认为0 可以修改
}
- (void)setRootViewController
{
    if ([CommonUtils getBoolValueInUDWithKey:IsLoginkey]) {  // 已登录
        
        IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
        IDCMUserStateModel *statusModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserStatusInfokey];
        
        if ([model.payPasswordFlag isEqualToNumber:@(0)]) {  // 未设置PIN
            if (statusModel && [statusModel.wallet_phrase isEqualToString:@"1"]) {  // 用户备份过助记词
                [self setPINViewController];
            }else{  // 用户未备份过助记词
                [self setBackupPhraseViewController];
            }
            
        }else if([model.payPasswordFlag isEqualToNumber:@(1)]){  // 已设置PIN
            [self verifyPINViewController];
        }else{
            [self setTabBarViewController];
        }
        
    }else{ // 未登录
        [self setMovieLoginController];
    }
    
}
// 验证PIN页面
- (void)verifyPINViewController
{
    IDCMPINLoginViewModel *viewModel = [[IDCMPINLoginViewModel alloc] initWithParams:nil];
    IDCMPINViewController *vc = [[IDCMPINViewController alloc] initWithViewModel:viewModel];
    IDCMConfigBaseNavigationController *PINVC = [[IDCMConfigBaseNavigationController alloc]
                                                     initWithRootViewController:vc];
    [self.window setRootViewController:PINVC];
    
}
// 设置登录页面
- (void)setMovieLoginController
{
    IDCMMovieLoginController *movieVC = [IDCMMovieLoginController new];
    IDCMConfigBaseNavigationController *movieNaVC = [[IDCMConfigBaseNavigationController alloc]
                                                    initWithRootViewController:movieVC];
    [self.window setRootViewController:movieNaVC];
}
// 设置TabBar的主页
- (void)setTabBarViewController
{
    IDCMTabBarControllerConfig *tabBarControllerConfig = [[IDCMTabBarControllerConfig alloc] init];
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    tabBarControllerConfig.tabBarController.selectedIndex = 2;
    [self bindTabBadge:tabBarControllerConfig.tabBarController];
    [self configAcceptant];
}
// 设置PIN页面
- (void)setPINViewController
{
    IDCMSetPINViewModel *viewModel = [[IDCMSetPINViewModel alloc] initWithParams:@{@"setPINType":@(0)}];
    IDCMSetPINController *vc = [[IDCMSetPINController alloc] initWithViewModel:viewModel];
    [self.window setRootViewController:vc];
    
}
// 设置备份短语页面
- (void)setBackupPhraseViewController
{

    IDCMBackupMemorizingWordsViewModel *viewModel = [[IDCMBackupMemorizingWordsViewModel alloc] initWithParams:@{@"backupType":@(0),@"isSetRootViewController":@(YES)}];
    IDCMBackupMemorizingWordsController *vc = [[IDCMBackupMemorizingWordsController alloc] initWithViewModel:viewModel];
    IDCMConfigBaseNavigationController *backupVC = [[IDCMConfigBaseNavigationController alloc]
                                                 initWithRootViewController:vc];
    [self.window setRootViewController:backupVC];
}
// 设置维护页面
- (void)setMaintenanceController:(NSString *)url
{
    IDCMMaintenanceViewModel *viewModel = [[IDCMMaintenanceViewModel alloc] initWithParams:@{@"url":[url isNotBlank] ? url : @""}];
    IDCMMaintenanceViewController *maintenanceVC = [[IDCMMaintenanceViewController alloc] initWithViewModel:viewModel];
    IDCMConfigBaseNavigationController *maintenanceNaVC = [[IDCMConfigBaseNavigationController alloc]
                                                     initWithRootViewController:maintenanceVC];
    [self.window setRootViewController:maintenanceNaVC];
}
// 设置第三方支付页面
- (void)setThirdPayViewController:(NSDictionary *)dic
{
    
    if ([CommonUtils getBoolValueInUDWithKey:IsLoginkey]) {
        
        [self setThirdPayController];

    }else{
        
        self.threeType = kIDCMThreePartiesPay;
        [self setMovieLoginController];
    }

}
// 设置第三方提现页面
- (void)setThirdWithdrawalViewController:(NSDictionary *)dic
{
    
    if ([CommonUtils getBoolValueInUDWithKey:IsLoginkey]) {
        
        [self setWithdrawalController];
        
    }else{

        self.threeType = kIDCMThreePartiesWithdrawl;
        [self setMovieLoginController];
    }
    
}
- (void)setThirdPayController
{

    IDCMThirdPaymentViewModel *viewModel = [[IDCMThirdPaymentViewModel alloc] initWithParams:self.payParams];
    IDCMThirdPaymentController *vc = [[IDCMThirdPaymentController alloc] initWithViewModel:viewModel];
    IDCMConfigBaseNavigationController *PayVC = [[IDCMConfigBaseNavigationController alloc]
                                                 initWithRootViewController:vc];
    [self.window setRootViewController:PayVC];
}
- (void)setWithdrawalController{
    
    IDCMwithdrawalViewModel *viewModel = [[IDCMwithdrawalViewModel alloc] initWithParams:self.payParams];
    IDCMWithdrawalController *vc = [[IDCMWithdrawalController alloc] initWithViewModel:viewModel];
    IDCMConfigBaseNavigationController *withdrawalVC = [[IDCMConfigBaseNavigationController alloc]
                                                 initWithRootViewController:vc];
    [self.window setRootViewController:withdrawalVC];
}
#pragma mark -
#pragma mark - Config DataManager
// 配置服务器环境
- (void)configServerEnvironmentTool{
#ifdef DEBUG
    [[IDCMDebugTool sharedInstance] showDebugTool];
#else
    // 设置服务器环境 00: 测试环境, 01: 生产环境, 02: 预发布环境 03: 开发环境 04: 灰度发布环境  05: 测试环境的外网映射
    [IDCMServerConfig setHTConfigEnv:@"01"];
#endif
}
// 配置IQKeyboardManager
- (void)configurationIQKeyboard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
}
// 配置Bugly
- (void)configurationBugly
{
    NSString *key = [[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey] ? IDCWEnterpriseBuglyKey : IDCWAppStoreBuglyKey;
    [Bugly startWithAppId:key];
}
// 配置QMUI
- (void)configurationQMUI{
    QMUICMI.preventConcurrentNavigationControllerTransitions = NO;
    QMUICMI.shouldPrintInfoLog = NO;
    QMUICMI.shouldPrintDefaultLog = NO;
}
// 监听网络状态
- (void)configurationNetWorkStatus
{

    self.reachability = Reachability.reachabilityForInternetConnection;
    
    RAC(self, networkStatus) = [[[[[NSNotificationCenter defaultCenter]
                                   rac_addObserverForName:kReachabilityChangedNotification object:nil]
                                  map:^(NSNotification *notification) {
                                      return @([notification.object currentReachabilityStatus]);
                                  }]
                                 startWith:@(self.reachability.currentReachabilityStatus)]
                                distinctUntilChanged];
    
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self)
        [self.reachability startNotifier];
    });
    
}

- (void)configBackgroundTimeout
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    _Backtime = [dateComponent minute] ;
    
    
    UIApplication* app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)configDDLog{
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    
    NSString *document =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    NSString *path = [NSString stringWithFormat:@"%@/Logs",document];
    DDLogFileManagerDefault *file = [[DDLogFileManagerDefault alloc]initWithLogsDirectory:path];
    file.maximumNumberOfLogFiles = 7;
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:file]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24 * 7; // 24 hour rolling
    fileLogger.maximumFileSize = 1024 * 1024 * 1;//文件大小
    [DDLog addLogger:fileLogger];
    
    IDCMLogFormatter *formatter = [[IDCMLogFormatter alloc]init];
    for (id<DDLogger> log in [[DDLog sharedInstance] allLoggers]) {
        log.logFormatter = formatter;
    }
    
    DDLogDebug(@"=========DDLog=========");
}
//设置承兑商接单的View
-(void)configAcceptant{
    
    // 获取OTC的signalr推送地址
    [[IDCMOTCSignalRTool sharedOTCSignal] getSignalrUrl];
    
    [IDCMRequestList requestPostAuthNoHUD:OTCAcceptant_URL params:nil success:^(NSDictionary *response) {
        
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            NSString *statusCode = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"Status"]];
            if ([statusCode integerValue] ==  3) { //是承兑商
                UIView *superView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
                IDCMNowTimeExhangeRecordView *view = [[IDCMNowTimeExhangeRecordView alloc]init];
                view.tag = 77888;
                view.frame = [UIScreen mainScreen].bounds;
                [superView addSubview:view];
                @weakify(self);
                [[view.countSignal  deliverOnMainThread] subscribeNext:^(NSString *text) {
                    @strongify(self);
                    if ([self cyl_tabBarController].viewControllers.count > 2) {
                        UIViewController *vc = [self cyl_tabBarController].viewControllers[1];
                        if ([text isEqualToString:@"0"]) {
                            [vc cyl_removeTabBadgePoint];
                        }
                        else {
                            [vc cyl_showTabBadgePoint];
                        }
                    }
                }];
            }
        }
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
    }];
}

#pragma mark -
#pragma mark  -- Private Methods
// 检查更新
- (void)requestUpdateVersion{
    // 区分客户端类型   1:企业分发   3:App Store
    NSString *clientName = [[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey] ? @"1" : @"3";
    NSString *url = [NSString stringWithFormat:@"%@?clientName=%@",CheckVersion_URL,clientName];
    [[[RACSignal signalGetNotAuth:url serverName:nil params:nil handleSignal:nil] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         [IDCMUtilsMethod checkVersonWithResponse:response withType:@"0"];
     }];
}
// 检查是否维护
- (void)requestMaintenance{
    
    // 区分客户端类型   1:企业分发   3:App Store
    NSString *clientName = [[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey] ? @"1" : @"3";
    NSString *url = [NSString stringWithFormat:@"%@?client=%@&lang=%@",CheckServerMaintenance_URL,clientName,[IDCMUtilsMethod getServiceLanguage]];
    [[[RACSignal signalGetNotAuth:url serverName:MaintenanceServerName params:nil handleSignal:nil] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]] && [response[@"data"][@"isMaintenance"] isKindOfClass:[NSNumber class]]) {
             if ([response[@"data"][@"isMaintenance"] integerValue] == 1) {
                 NSString *url = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"url"]];
                 [self setMaintenanceController:url];
             }
         }
     }];
}
// 应用启动时，判断是否第三方支付调起
- (void)thirdPartyPaymentAdjustment:(NSDictionary *)launchOptions{
    NSURL *urlScheme = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (urlScheme) {
        
        if ([urlScheme.host isEqualToString:@"idcwpay"] || [urlScheme.host isEqualToString:@"idcwwithdraw"]) {
            NSDictionary *paraData = [urlScheme params];
            NSString *encodedUrl = paraData[@"data"];
            NSData *data = [NSData dataWithBase64EncodedString:encodedUrl];
            if (data) {
                self.threeType = kIDCMThreePartiesNomal;
            }
        }
    }
}
- (void)thirdPartyPaymentSourceOptions:(NSURL *)url{
    
    NSDictionary *paraData = [url params];
    NSString *encodedUrl = paraData[@"data"];
    NSData *data;
    if ([encodedUrl isNotBlank]) {
        
        data = [NSData dataWithBase64EncodedString:encodedUrl];
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (!dataDic) { // 兼容瑞时会版本
            NSString *base64Str = [encodedUrl stringByRemovingPercentEncoding];
            data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        }
    }
    if (data) {
        
        IDCMThirdPayModel *model = [IDCMThirdPayModel yy_modelWithJSON:data];
        
        if (!model) {
            
            [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_ParameterError")];
            return;
        }
        model.appId = [NSString idcw_stringWithFormat:@"%@",paraData[@"appId"]];
        self.payParams = @{@"payModel":model?:@{}};
    }
    
    if ([url.host isEqualToString:@"idcwpay"]) {
        
        [self setThirdPayViewController:self.payParams];
        
    }else if ([url.host isEqualToString:@"idcwwithdraw"]){
        
        [self setThirdWithdrawalViewController:self.payParams];
    }
}
- (void)bindTabBadge:(CYLTabBarController *)tabBarController{
    
    if (tabBarController.viewControllers.count > 2) {
    
        UIViewController *viewController = tabBarController.viewControllers[1];
        UIView *tabBadgePointView = [UIView cyl_tabBadgePointViewWithClolor:SetColor(255, 63, 63) radius:4.5];
        [viewController.tabBarItem.cyl_tabButton cyl_setTabBadgePointView:tabBadgePointView];

    }
    // 监听tabbarButton点击事件
    @weakify(self);
    [[self
      rac_signalForSelector:@selector(tabBarController:didSelectControl:)
      fromProtocol:@protocol(CYLTabBarControllerDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         UIControl *control = tuple.second;
         UIView *animationView = [control cyl_tabImageView];
         [self addRotateAnimationOnView:animationView withType:2];
     }];
    tabBarController.delegate = self;
}
// tabbarItem动画
- (void)addRotateAnimationOnView:(UIView *)animationView withType:(NSInteger)type{

    if (type == 1) { // 旋转动画
        animationView.layer.zPosition = 65.f / 2;
        [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        } completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
            } completion:nil];
        });
    }else{ // 缩放动画
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"transform.scale";
        animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
        animation.duration = 1;
        animation.repeatCount = 1;
        animation.calculationMode = kCAAnimationCubic;
        [animationView.layer addAnimation:animation forKey:nil];
    }
    
}

@end
