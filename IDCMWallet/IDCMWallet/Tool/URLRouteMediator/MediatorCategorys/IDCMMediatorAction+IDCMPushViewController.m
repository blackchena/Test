//
//  IDCMMediatorAction+IDCMPushViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMMediatorAction+IDCMPushViewController.h"
#import "IDCMBaseViewController.h"
#import <objc/runtime.h>

@implementation IDCMMediatorAction (IDCMPushViewController)

- (void)pushViewControllerWithClassName:(NSString *)className
                      withViewModelName:(NSString *)viewModelName
                             withParams:(NSDictionary *)para {
    
    [self pushViewControllerWithClassName:className
                        withViewModelName:viewModelName
                               withParams:para
                                 animated:YES];
}


- (void)pushViewControllerWithClassName:(NSString *)className
                      withViewModelName:(NSString *)viewModelName
                             withParams:(NSDictionary *)para
                               animated:(BOOL)flag {
    
    if (!objc_getClass([className cStringUsingEncoding:NSASCIIStringEncoding])) {
        DDLogDebug(@"项目无此控制器！");
        return;
    }
    
    id viewModel;
    if ([viewModelName isNotBlank]) {
        if (!objc_getClass([viewModelName cStringUsingEncoding:NSASCIIStringEncoding])) {
            DDLogDebug(@"项目无此ViewModel！");
            return;
        }
        viewModel = [viewModelName VKCallClassAllocInitSelectorName:@"initWithParams:" error:nil,para];
    }else{
        viewModel = [@"IDCMBaseViewModel" VKCallClassAllocInitSelectorName:@"initWithParams:" error:nil,para];
    }
    
    id vc = [className VKCallClassAllocInitSelectorName:@"initWithViewModel:" error:nil,viewModel];
    UIViewController *currentVC = [self performTarget:nil action:nil];
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        [currentVC.navigationController pushViewController:vc animated:flag];
    }
}


- (void)presentViewControllerWithClassName:(NSString *)className
                         withViewModelName:(NSString *)viewModelName
                                withParams:(NSDictionary *)para {
    
    [self presentViewControllerWithClassName:className
                           withViewModelName:viewModelName
                                  withParams:para
                                    animated:YES];
}


- (void)presentViewControllerWithClassName:(NSString *)className
                         withViewModelName:(NSString *)viewModelName
                                withParams:(NSDictionary *)para
                                  animated: (BOOL)flag {
    
    if (!objc_getClass([className cStringUsingEncoding:NSASCIIStringEncoding])) {
        DDLogDebug(@"项目无此控制器！");
        return;
    }
    id viewModel;
    if ([viewModelName isNotBlank]) {
        if (!objc_getClass([viewModelName cStringUsingEncoding:NSASCIIStringEncoding])) {
            DDLogDebug(@"项目无此ViewModel！");
            return;
        }
        viewModel = [viewModelName VKCallClassAllocInitSelectorName:@"initWithParams:" error:nil,para];
    }else{
        viewModel = [@"IDCMBaseViewModel" VKCallClassAllocInitSelectorName:@"initWithParams:" error:nil,para];
    }
    
    id vc = [className VKCallClassAllocInitSelectorName:@"initWithViewModel:" error:nil,viewModel];
    UIViewController *currentVC = [self performTarget:nil action:nil];
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        [currentVC presentViewController:vc animated:flag completion:nil];
    }
}



#pragma mark — 下面是自动解析的路由方法
+ (void)idcm_pushViewControllerWithClassName:(NSString *)className
                           withViewModelName:(NSString *)viewModelName
                                  withParams:(NSDictionary *)para
                                    animated:(BOOL)flag   {
    
    [self handleViewControllerJumpWithClassName:className
                              withViewModelName:viewModelName
                                     withParams:para
                                       animated:flag
                                     completion:nil
                                         isPush:YES];
}
+ (void)idcm_pushViewControllerWithClassName:(NSString *)className
                           withViewModelName:(NSString *)viewModelName
                                  withParams:(NSDictionary *)para
                                    animated:(BOOL)flag
                                  completion:(void (^)(NSDictionary *para))completion{
    
    [self handleViewControllerJumpWithClassName:className
                              withViewModelName:viewModelName
                                     withParams:para
                                       animated:flag
                                     completion:completion
                                         isPush:YES];
}

+ (void)idcm_presentViewControllerWithClassName:(NSString *)className
                              withViewModelName:(NSString *)viewModelName
                                     withParams:(NSDictionary *)para
                                       animated:(BOOL)flag
                                     completion:(void (^)(NSDictionary *para))completion {
    
    [self handleViewControllerJumpWithClassName:className
                              withViewModelName:viewModelName
                                     withParams:para
                                       animated:flag
                                     completion:completion
                                         isPush:NO];
}


+ (void)handleViewControllerJumpWithClassName:(NSString *)className
                            withViewModelName:(NSString *)viewModelName
                                   withParams:(NSDictionary *)para
                                      animated:(BOOL)flag
                                    completion:(void (^)(NSDictionary *para))completion
                                        isPush:(BOOL)push {
    
    if (!objc_getClass([className cStringUsingEncoding:NSASCIIStringEncoding])) {
        DDLogDebug(@"项目无此控制器！");
        return;
    }
    
    id viewModel;
    if ([viewModelName isNotBlank]) {
        if (!objc_getClass([viewModelName cStringUsingEncoding:NSASCIIStringEncoding])) {
            DDLogDebug(@"项目无此ViewModel！");
            return;
        }
        if (para) {
            viewModel = [NSClassFromString(viewModelName) yy_modelWithDictionary:para];
        } else {
            viewModel = [[NSClassFromString(viewModelName) alloc] init];
        }
    }
   
    id vc = [className VKCallClassAllocInitSelectorName:@"initWithViewModel:" error:nil,viewModel];
    UIViewController *currentVC = [IDCMUtilsMethod currentViewController];
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        if (push) {
            if ([vc isKindOfClass:[IDCMBaseViewController class]]){
                IDCMBaseViewController *basevc = (IDCMBaseViewController *)vc;
                basevc.completion = completion;
                [currentVC.navigationController pushViewController:basevc animated:YES];
            }
            else{
                [currentVC.navigationController pushViewController:vc animated:YES];
            }

        } else {
            [currentVC presentViewController:vc animated:flag completion:nil];
        }
    }
}


#pragma mark — Pop的路由方法
+ (void)idcm_popViewControllerWithClassName:(NSString *)className
                                 withParams:(NSDictionary *)para
                                   animated:(BOOL)flag {
    
    if (!objc_getClass([className cStringUsingEncoding:NSASCIIStringEncoding])) {
        DDLogDebug(@"项目无此控制器！");
        return;
    }

    
    UIViewController *currentVC = [IDCMUtilsMethod currentViewController];
    [currentVC.navigationController popViewControllerAnimated:flag];
    
    
    [className VKCallClassSelectorName:@"popCallBack:" error:nil,para];
}

@end





