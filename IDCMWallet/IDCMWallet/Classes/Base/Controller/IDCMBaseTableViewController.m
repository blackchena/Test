//
//  IDCMBaseTableViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/19.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseTableViewController.h"
#import "IDCMBaseViewModel.h"
#import "IDCMConfigBaseNavigationController.h"
@interface IDCMBaseTableViewController ()
@property (strong, nonatomic, readwrite) IDCMBaseViewModel *viewModel;
@end

@implementation IDCMBaseTableViewController

- (instancetype)initWithViewModel:(IDCMBaseViewModel *)viewModel withStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.viewModel = viewModel;
        self.titleView.horizontalTitleFont = textFontPingFangMediumFont(18);
       
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
