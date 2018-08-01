//
//  IDCMConfigBaseNavigationController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMConfigBaseNavigationController.h"
#import "IDCMBaseViewController.h"


@interface IDCMConfigBaseNavigationController ()
/// 即将要被pop的controller
@property(nonatomic, weak) UIViewController *poppingViewController;
@end

@implementation IDCMConfigBaseNavigationController

#pragma mark - Life CyCle
- (void)didInitialize
{
    [super didInitialize];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = kThemeColor;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [[self.fd_fullscreenPopGestureRecognizer rac_gestureSignal]
     subscribeNext:^(UIPanGestureRecognizer *gestureRecognizer) {
        @strongify(self);
        
         UIGestureRecognizerState state = gestureRecognizer.state;
         UIViewController *poppingViewController = self.poppingViewController;
         UIViewController *popToViewController = self.topViewController;

         switch (state) {
             case UIGestureRecognizerStateBegan:{
                 
                 self.poppingViewController =
                 poppingViewController = self.topViewController;
                 popToViewController = self.viewControllers[[self.viewControllers indexOfObject:self.topViewController] - 1];
                 
                 [self handleBackGestureWithController:poppingViewController
                                                 state:ControllerBackGestureState_Begin];
                 [self handleBackGestureWithController:popToViewController
                                                 state:ControllerBackGestureState_Begin];
             }break;
             case UIGestureRecognizerStateChanged:{
                 [self handleBackGestureWithController:poppingViewController
                                                 state:ControllerBackGestureState_Change];
                 [self handleBackGestureWithController:popToViewController
                                                 state:ControllerBackGestureState_Change];
             }break;
             case UIGestureRecognizerStateEnded:
             case UIGestureRecognizerStateCancelled:
             case UIGestureRecognizerStateFailed: {

                 CGPoint velocity = [gestureRecognizer translationInView:gestureRecognizer.view];
                 ControllerBackGestureState state =
                 (velocity.x >= ([UIScreen mainScreen].bounds.size.width) / 2) ?
                 ControllerBackGestureState_SuccessPop :
                 ControllerBackGestureState_FailPop;
                 
                 void(^handleGestureCompletion)(IDCMBaseViewController *vc) = ^(IDCMBaseViewController *vc){
                     self.poppingViewController = nil;
                     [[RACScheduler mainThreadScheduler] afterDelay:.25 schedule:^{
                         vc.backGestureState = ControllerBackGestureState_No;
                     }];
                 };
                 [self handleBackGestureWithController:poppingViewController
                                                 state:state];
                 [self handleBackGestureWithController:popToViewController
                                                 state:state];
                 
                 if ([poppingViewController isKindOfClass:[IDCMBaseViewController class]]) {
                     handleGestureCompletion(((IDCMBaseViewController *)poppingViewController));
                 }
                 if ([popToViewController isKindOfClass:[IDCMBaseViewController class]]) {
                     handleGestureCompletion(((IDCMBaseViewController *)popToViewController));
                 }
             }break;
             default:
             break;
         }
    }];
}

- (void)handleBackGestureWithController:(UIViewController *)controller
                                  state:(ControllerBackGestureState)state {
    
    void (^handleBlock)(IDCMBaseViewController *) = ^(IDCMBaseViewController *vc){
        vc.backGestureState = state;
        if ([vc respondsToSelector:@selector(hookControllerBackGestureWithState:)]) {
            [vc hookControllerBackGestureWithState:state];
        }
    };
    
    if ([controller isKindOfClass:[IDCMBaseViewController class]]) {
         handleBlock((IDCMBaseViewController *)controller);
    }
  
    [controller.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *obj,
                                                                             NSUInteger idx,
                                                                             BOOL *stop) {
        if ([obj isKindOfClass:[IDCMBaseViewController class]]) {
            handleBlock((IDCMBaseViewController *)obj);
        }
        [obj.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *objSub,
                                                               NSUInteger idx,
                                                               BOOL *stop) {
            if ([objSub isKindOfClass:[IDCMBaseViewController class]]) {
                handleBlock((IDCMBaseViewController *)objSub);
            }
        }];
    }];
}

#pragma mark - Public Method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self setUpNavigationBarAppearance];
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = CGRectGetWidth([UIScreen mainScreen].bounds)/5;
    }
    [super pushViewController:viewController animated:YES];
}

#pragma mark - 设置全局的导航栏属性
- (void)setUpNavigationBarAppearance
{
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *textAttributes = @{NSFontAttributeName:SetFont(@"PingFang-SC-Medium", 18),
                                     NSForegroundColorAttributeName: [UIColor whiteColor]
                                     };
    
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    [navigationBarAppearance setTranslucent:NO];
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-MAXFLOAT, 0) forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
