//
//  IDCMTabBarControllerConfig.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMTabBarControllerConfig.h"
#import "IDCMConfigBaseNavigationController.h"

// 主页
#import "IDCMHomeViewController.h"
#import "IDCMHomeViewModel.h"

// 交易
#import "IDCMTradingPageViewController.h"

// 发现
#import "IDCMFoundViewController.h"
#import "IDCMFoundViewModel.h"

// 设置
#import "IDCMSettingsViewModel.h"
#import "IDCMSettingController.h"

@interface IDCMTabBarControllerConfig()
@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;
@end

@implementation IDCMTabBarControllerConfig

#pragma mark - Privater Methods
- (NSArray *)viewControllersForController {
    
    // 主页
    IDCMHomeViewModel *homeViewModel = [[IDCMHomeViewModel alloc] initWithParams:nil];
    IDCMHomeViewController *homeVC = [[IDCMHomeViewController alloc] initWithViewModel:homeViewModel];
    
    IDCMConfigBaseNavigationController *firstNavigationController = [[IDCMConfigBaseNavigationController alloc]
                                                   initWithRootViewController:homeVC];
    

    // 行情
    IDCMBaseViewModel *marketViewModel = [[IDCMBaseViewModel alloc] initWithParams:nil];
    IDCMTradingPageViewController *marketVC = [[IDCMTradingPageViewController alloc] initWithViewModel:marketViewModel];
    
    IDCMConfigBaseNavigationController *secondNavigationController = [[IDCMConfigBaseNavigationController alloc]
                                                    initWithRootViewController:marketVC];
    
    // 发现
    IDCMFoundViewModel *foundViewModel = [[IDCMFoundViewModel alloc] initWithParams:nil];
    IDCMFoundViewController *foundVC = [[IDCMFoundViewController alloc] initWithViewModel:foundViewModel];
    
    IDCMConfigBaseNavigationController *threeNavigationController = [[IDCMConfigBaseNavigationController alloc]
                                                                     initWithRootViewController:foundVC];

    // 设置
    IDCMSettingsViewModel *settingViewModel = [[IDCMSettingsViewModel alloc] initWithParams:nil];
    IDCMSettingController *setVC = [[IDCMSettingController alloc] initWithViewModel:settingViewModel];
    
    IDCMConfigBaseNavigationController *fourNavigationController = [[IDCMConfigBaseNavigationController alloc]
                                                  initWithRootViewController:setVC];

    NSArray *viewControllers;
    if ([[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey]) {  // 企业分发
        
        viewControllers = @[
                            firstNavigationController,
                            secondNavigationController,
                            threeNavigationController,
                            fourNavigationController
                            ];
        
    }else{  // App Store
        
        
        if ([CommonUtils getBoolValueInUDWithKey:ControlHiddenKey]) {  // 交易、DApp模块隐藏
            
            viewControllers = @[
                                firstNavigationController,
                                fourNavigationController
                                ];
            
        }else{ // 交易、DApp模块开启
            
            viewControllers = @[
                                firstNavigationController,
                                secondNavigationController,
                                threeNavigationController,
                                fourNavigationController
                                ];
        }
        
    }
    
    return viewControllers;
}


/**
 *  设置TabBarItem的属性，包括 title、Image、selectedImage。
 */
- (NSArray *)tabBarItemsAttributesForController{
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : NSLocalizedString(@"2.1_Home", nil),
                            CYLTabBarItemImage : @"2.1_zhuyeUnSelect",
                            CYLTabBarItemSelectedImage : @"2.1_zhuyeSelect",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : NSLocalizedString(@"2.1_Market", nil),
                            CYLTabBarItemImage : @"2.1_shanduiUnSelect",
                            CYLTabBarItemSelectedImage : @"2.1_shanduiSelect",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : NSLocalizedString(@"2.1_Found", nil),
                            CYLTabBarItemImage : @"3.0_Found_Nomal",
                            CYLTabBarItemSelectedImage : @"3.0_Found_select",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : NSLocalizedString(@"2.1_Settings", nil),
                            CYLTabBarItemImage : @"2.2.3_MeUnselect",
                            CYLTabBarItemSelectedImage : @"2.2.3_MeSelect",
                            };
    
    NSArray *tabBarItemsAttributes;
    if ([[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey]) {  // 企业分发
        
        tabBarItemsAttributes = @[
                                  dict1,
                                  dict2,
                                  dict3,
                                  dict4
                                  ];
        
    }else{  // App Store
        
        
        if ([CommonUtils getBoolValueInUDWithKey:ControlHiddenKey]) {  // 交易、DApp模块隐藏
            
            tabBarItemsAttributes = @[
                                      dict1,
                                      dict4
                                      ];
            
        }else{ // 交易、DApp模块开启
            
            tabBarItemsAttributes = @[
                                      dict1,
                                      dict2,
                                      dict3,
                                      dict4
                                      ];
        }
        
    }

    return tabBarItemsAttributes;
}
/**
 *  tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性的设置
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    
     // 普通状态下的文字属性
     NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
     normalAttrs[NSForegroundColorAttributeName] = kThemeGrayColor;
     normalAttrs[NSFontAttributeName] = textFontPingFangMediumFont(10);
     
     // 选中状态下的文字属性
     NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
     selectedAttrs[NSForegroundColorAttributeName] = kThemeColor;
     selectedAttrs[NSFontAttributeName] = textFontPingFangMediumFont(10);
     
     // 设置文字属性
     UITabBarItem *tabBarItem = [UITabBarItem appearance];
     [tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
     [tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
     [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];

    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:UIColorWhite];
    [[UITabBar appearance] setBarTintColor:UIColorWhite];
    [UITabBar appearance].translucent = NO;
}
#pragma mark - getter
/**
 *  懒加载tabBarController
 *
 */
- (CYLTabBarController *)tabBarController
{
    return SW_LAZY(_tabBarController, ({
        
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllersForController tabBarItemsAttributes:self.tabBarItemsAttributesForController];
        // tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
        [self customizeTabBarAppearance:tabBarController];
        tabBarController;
    }));
    
}
@end
