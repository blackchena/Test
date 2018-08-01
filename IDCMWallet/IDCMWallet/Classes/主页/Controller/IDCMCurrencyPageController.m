//
//  IDCMCurrencyPageController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMCurrencyPageController.h"
#import "IDCMCurrencyPageViewModel.h"

#import "IDCMOptionalCoinController.h"
#import "IDCMAddCoinController.h"
#import "IDCMChartsViewController.h"
#import "IDCMOptionalCoinViewModel.h"

@interface IDCMCurrencyPageController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMCurrencyPageViewModel *viewModel;
@end

@implementation IDCMCurrencyPageController
@dynamic viewModel;

- (instancetype)initWithViewModel:(IDCMBaseViewModel *)viewModel
{
    self = [super initWithViewModel:viewModel];
    if (self) {
        
        self.selectIndex = 0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleFontName = @"PingFang-SC-Medium";
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
        self.titleColorNormal = SetAColor(255, 255, 255, 0.6);
        self.titleColorSelected = UIColorWhite;
        self.progressColor = UIColorWhite;
        self.progressViewBottomSpace = 5;
        self.showOnNavigationBar = YES;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.automaticallyCalculatesItemWidths = YES;
        self.progressViewIsNaughty = YES;
        self.progressViewCornerRadius = 1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark
#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index == 0) {
        return SWLocaloziString(@"3.0_Hy_OptionalCoinTitle");
    }else if (index == 1){
        return SWLocaloziString(@"2.0_AddCoinVC");
    }else{
        return SWLocaloziString(@"2.1_Chart");
    }
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index == 0) {
        IDCMOptionalCoinViewModel *viewModel = [[IDCMOptionalCoinViewModel alloc] initWithParams:nil];
        IDCMOptionalCoinController *addVC = [[IDCMOptionalCoinController alloc] initWithViewModel:viewModel];
        return addVC;
    }else if (index == 1){
        IDCMAddCoinViewModel *viewModel = [[IDCMAddCoinViewModel alloc] initWithParams:nil];
        IDCMAddCoinController *addVC = [[IDCMAddCoinController alloc] initWithViewModel:viewModel];
        return addVC;
    }else{
        IDCMChartsViewModel *viewModel = [[IDCMChartsViewModel alloc] initWithParams:nil];
        IDCMChartsViewController *chartVC = [[IDCMChartsViewController alloc] initWithViewModel:viewModel];
        return chartVC;
    }
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

//- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
//    if (![info[@"index"] integerValue]) {
//        [((IDCMOptionalCoinController *)viewController) refreshData];
//    }
//}
@end





