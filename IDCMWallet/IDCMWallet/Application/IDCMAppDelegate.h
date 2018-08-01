//
//  IDCMAppDelegate.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMTabBarControllerConfig.h"
#import "Reachability.h"


typedef NS_ENUM(NSUInteger, IDCMThreePartiesType) {
    
    kIDCMThreePartiesNomal        = 1,   // 正常调起
    kIDCMThreePartiesPay          = 2,   // 支付
    kIDCMThreePartiesWithdrawl    = 3,   // 提现
};

@interface IDCMAppDelegate : UIResponder<UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
/**
 *  网络状态
 */
@property (nonatomic, assign, readonly) NetworkStatus networkStatus;

/*  是否是第三方支付请求调起  */
@property (assign, nonatomic) IDCMThreePartiesType  threeType;
/*  第三方支付请求参数  */
@property (strong, nonatomic) NSDictionary *payParams;

- (void)setRootViewController;
- (void)setMovieLoginController;
- (void)setTabBarViewController;
- (void)setPINViewController;
- (void)verifyPINViewController;
- (void)setThirdPayController;
- (void)setWithdrawalController;
- (void)setMaintenanceController:(NSString *)url;

@end
