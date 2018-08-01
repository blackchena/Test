//
//  IDCMMediatorAction+IDCMPushViewController.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMMediatorAction.h"
@class IDCMBaseViewModel;
@interface IDCMMediatorAction (IDCMPushViewController)


/**
  根据viewModelName创建对应的viewMode并赋给 跳转到的className目标控制器(需要在ViewModel根据para自己复制)

 @param className 跳转到的目标控制器
 @param viewModelName 目标控制器 viewModelName
 @param para viewModel的属性参数 para
 */
- (void)pushViewControllerWithClassName:(NSString *)className
                      withViewModelName:(NSString *)viewModelName
                             withParams:(NSDictionary *)para;


/**
 根据viewModelName创建对应的viewMode并赋给 跳转到的className目标控制器(需要在ViewModel根据para自己复制)
 
 @param className 跳转到的目标控制器
 @param viewModelName 目标控制器 viewModelName
 @param para viewModel的属性参数 para
 @param flag 动画
 */
- (void)pushViewControllerWithClassName:(NSString *)className
                      withViewModelName:(NSString *)viewModelName
                             withParams:(NSDictionary *)para
                               animated:(BOOL)flag;

/**
 根据viewModelName创建对应的viewMode并赋给 跳转到的className目标控制器(需要在ViewModel根据para自己复制)

 @param className 跳转到的目标控制器
 @param viewModelName 目标控制器 viewModelName
 @param para viewModel的属性参数 para
 @param flag 动画
 @param completion 完成回调
 */
+ (void)idcm_pushViewControllerWithClassName:(NSString *)className
                           withViewModelName:(NSString *)viewModelName
                                  withParams:(NSDictionary *)para
                                    animated:(BOOL)flag
                                  completion:(void (^)(NSDictionary *para))completion;


/**
 根据viewModelName创建对应的viewMode并赋给 跳转到的className目标控制器(需要在ViewModel根据para自己复制)
 
 @param className 跳转到的目标控制器
 @param viewModelName 目标控制器 viewModelName
 @param para viewModel的属性参数 para
 */
- (void)presentViewControllerWithClassName:(NSString *)className
                         withViewModelName:(NSString *)viewModelName
                                withParams:(NSDictionary *)para;




/**
 根据viewModelName创建对应的viewMode并赋给 跳转到的className目标控制器(需要在ViewModel根据para自己复制)
 
 @param className 跳转到的目标控制器
 @param viewModelName 目标控制器 viewModelName
 @param para viewModel的属性参数 para
 @param flag 动画
 */
- (void)presentViewControllerWithClassName:(NSString *)className
                         withViewModelName:(NSString *)viewModelName
                                withParams:(NSDictionary *)para
                                  animated:(BOOL)flag;





/**
 自动根据para解析并创建viewModel赋值 跳转到className控制器

 @param className 跳转到的目标控制器
 @param viewModelName 目标控制器 viewModelName
 @param para viewModel的属性参数 para
 @param flag 动画
 */
+ (void)idcm_pushViewControllerWithClassName:(NSString *)className
                           withViewModelName:(NSString *)viewModelName
                                  withParams:(NSDictionary *)para
                                    animated:(BOOL)flag;




/**
 自动根据para解析并创建viewModel赋值 跳转到className控制器
 
 @param className 跳转到的目标控制器
 @param viewModelName 目标控制器 viewModelName
 @param para viewModel的属性参数 para
 @param flag 动画
 @param completion 完成回调
 */
+ (void)idcm_presentViewControllerWithClassName:(NSString *)className
                              withViewModelName:(NSString *)viewModelName
                                     withParams:(NSDictionary *)para
                                       animated:(BOOL)flag
                                     completion:(void (^)(NSDictionary *para))completion;

/**
 自动Pop跳转到className控制器
 
 @param className 跳转到的目标控制器
 @param para viewModel的属性参数 para
 @param flag 动画
 */
+ (void)idcm_popViewControllerWithClassName:(NSString *)className
                                 withParams:(NSDictionary *)para
                                   animated:(BOOL)flag;

@end




