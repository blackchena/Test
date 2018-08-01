//
//  IDCMBaseViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/22.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseViewController.h"
#import "IDCMBaseViewModel.h"
#import "IDCMConfigBaseNavigationController.h"


@interface IDCMBaseViewController ()
@property (strong, nonatomic, readwrite) IDCMBaseViewModel *viewModel;
@end

@implementation IDCMBaseViewController
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.backGestureState == ControllerBackGestureState_No) {
        [self handleBackGestureViewWillAppear];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.backGestureState == ControllerBackGestureState_No) {
        [self handleBackGestureViewDidAppear];
    }
}

- (void)hookControllerBackGestureWithState:(ControllerBackGestureState)state {
    if (state == ControllerBackGestureState_SuccessPop) {
        [self handleBackGestureViewWillAppear];
        [[RACScheduler mainThreadScheduler] afterDelay:.25 schedule:^{
            [self handleBackGestureViewDidAppear];
        }];
    }
}

- (void)handleBackGestureViewWillAppear {};
- (void)handleBackGestureViewDidAppear {};

- (void)setCompletion:(CompletionBlock)completion{
    _completion = completion;
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

#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//NavItem 右边的按钮
- (UIBarButtonItem *)createRightBarButtonItem:(NSString *)title target:(id)obj selector:(SEL)selector ImageName:(NSString*)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:image forState:UIControlStateNormal];
    if (title.length>0) {
        [rightButton setTitle:title forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateDisabled];
    }
    [rightButton addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    return item;
}
#pragma mark - delloc
- (void)dealloc {
    DDLogDebug(@"dealloc--------%@", NSStringFromClass([self class]));
}

@end
