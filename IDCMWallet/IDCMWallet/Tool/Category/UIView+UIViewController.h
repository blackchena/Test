//
//  UIView+UIViewController.h
//  Installment
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 熊彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIView (UIViewController)

/**
 *  获取当前控制器
 *
 *  @return 当前控制器
 */
- (UIViewController *)viewController;

/**
 *  获取当前navigationController
 *
 *  @return 当前navigationController
 */
- (UINavigationController *)navigationController;
/**
 *  获取当前tabBarController
 *
 *  @return 当前tabBarController
 */
- (UITabBarController *)tabBarController;
@end
NS_ASSUME_NONNULL_END
