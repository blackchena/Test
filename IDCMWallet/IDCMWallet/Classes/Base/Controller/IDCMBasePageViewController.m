//
//  IDCMBasePageViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBasePageViewController.h"
#import "IDCMBaseViewModel.h"
#import "IDCMConfigBaseNavigationController.h"
#import "IDCMWMScrollView.h"

@interface IDCMBasePageViewController ()
@property (strong, nonatomic, readwrite) IDCMBaseViewModel *viewModel;
@end

@implementation IDCMBasePageViewController

- (instancetype)initWithViewModel:(IDCMBaseViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindViewModel];
}

- (void)bindViewModel
{
    // 监听网络状态
//    [[RACObserve(IDCM_APPDelegate, networkStatus) deliverOnMainThread]
//     subscribeNext:^(id  _Nullable x) {
//         @strongify(self);
//         if ([x integerValue] == NotReachable) { // 无网络
//
//         }else{ // 有网络
//
//         }
//     }];
    
}
+ (void)popCallBack:(NSDictionary *)para{};
- (void)wm_addScrollView {
    IDCMWMScrollView *scrollView = [[IDCMWMScrollView alloc] init];
    scrollView.scrollsToTop = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = self.bounces;
    scrollView.scrollEnabled = self.scrollEnable;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    if (!self.navigationController) return;
    for (UIGestureRecognizer *gestureRecognizer in scrollView.gestureRecognizers) {
        [gestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
}
#pragma mark - QMUINavigationControllerDelegate

- (UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

- (UIColor *)titleViewTintColor {
    return [UIColor whiteColor];
}
#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - delloc

- (void)dealloc {
    DDLogDebug(@"dealloc--------%@", NSStringFromClass([self class]));
}
@end
