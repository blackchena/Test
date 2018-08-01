//
//  UINavigationController+Extensions.m
//  IDCMWallet
//
//  Created by IDCM on 2018/5/21.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "UINavigationController+Extensions.h"

@implementation UINavigationController (Extensions)
- (void)popBackViewController:(NSString *)vcClassName{
    UIViewController *vc;
    for (UIViewController *childVC in self.childViewControllers) {
        if ([childVC.className isEqualToString:vcClassName]) {
            vc = childVC;
            break;
        }
    }
    
    if (vc) {
        [self popToViewController:vc animated:true];
    }
}
- (void)popBackViewControllerToIndex:(NSInteger)index{
    if (index > self.childViewControllers.count) {
        return;
    }
    UIViewController *vc = [self.childViewControllers objectAtIndex:index];
    [self popToViewController:vc animated:true];
}

- (void)popBackViewControllerFromIndex:(NSInteger)index{
    if (index > self.childViewControllers.count) {
        return;
    }
    UIViewController *vc = [self.childViewControllers objectAtIndex:self.childViewControllers.count - index - 1];
    [self popToViewController:vc animated:true];
}

- (UIViewController *)getViewControllerByname:(NSString *)vcClassName{
    UIViewController *vc;
    for (UIViewController *childVC in self.childViewControllers) {
        if ([childVC.className isEqualToString:vcClassName]) {
            vc = childVC;
            break;
        }
    }
    
    if (vc) {
        return vc;
    }
    return nil;
}

- (UIViewController *)getViewControllerByIndex:(NSInteger)index{
    if (index > self.childViewControllers.count) {
        return nil;
    }
    UIViewController *vc = [self.childViewControllers objectAtIndex:index];
    return vc;
}

@end
