//
//  UINavigationController+Extensions.h
//  IDCMWallet
//
//  Created by IDCM on 2018/5/21.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extensions)



/**
 返回对应控制器 根据类名
 
 @param vcClassName 根据类名返回vc
 */
- (UIViewController *)getViewControllerByname:(NSString *)vcClassName;

/**
 返回对应控制器 根据index
 
 @param index 根据index返回vc
 */
- (UIViewController *)getViewControllerByIndex:(NSInteger )index;

/**
 返回对应的层 从前往后

 @param index 从前往后第几个 如果超过childs长度则返回root
 */
- (void)popBackViewControllerToIndex:(NSInteger)index;

/**
 返回对应的层 从后往前
 
 @param index 从后往前第几个 如果超过childs长度则返回root
 */
- (void)popBackViewControllerFromIndex:(NSInteger)index;

/**
 返回对应的层 根据类名
 
 @param vcClassName 根据类名返回到对应页面
 */
- (void)popBackViewController:(NSString *)vcClassName;
@end
