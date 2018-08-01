//
//  IDCMTradingPageViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/4/27.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMTradingPageViewController.h"

#import "IDCMFlashExchangeRecordController.h"
#import "IDCMFlashExchangeRecordViewModel.h"
#import "IDCMOTCExchangeRecordController.h"
#import "IDCMOTCExchangeRecordViewModel.h"



@interface IDCMTradingPageViewController ()


@end


@implementation IDCMTradingPageViewController
- (instancetype)initWithViewModel:(IDCMBaseViewModel *)viewModel
{
    if (self == [super initWithViewModel:viewModel]) {
        
        self.fd_prefersNavigationBarHidden = YES;
        self.selectIndex = 0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleFontName = @"PingFang-SC-Medium";
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
        self.titleColorNormal = viewBackgroundColor;
        self.titleColorSelected = viewBackgroundColor;
        self.progressColor = viewBackgroundColor;
        self.progressViewBottomSpace = 5;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.automaticallyCalculatesItemWidths = YES;
        self.progressViewIsNaughty = YES;
        self.menuView.hidden = YES;
        self.preloadPolicy = WMPageControllerPreloadPolicyNeighbour;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.idcw_navigationBar.swapButton.selected = YES;
    self.idcw_navigationBar.OTCLine.hidden = YES;
    
    @weakify(self);
    [[[self.idcw_navigationBar.swapButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self selectSwap];
     }];
    [[[self.idcw_navigationBar.OTCButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self selectOTC];
     }];

}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.idcw_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
    }];
}

#pragma mark - Prevete Method
- (void)selectSwap
{
    self.idcw_navigationBar.swapButton.selected = YES;
    self.idcw_navigationBar.OTCLine.hidden = YES;
    self.idcw_navigationBar.OTCButton.selected = NO;
    self.idcw_navigationBar.swapLine.hidden = NO;
    self.selectIndex = 0;
    
}
- (void)selectOTC
{
    self.idcw_navigationBar.swapButton.selected = NO;
    self.idcw_navigationBar.OTCLine.hidden = NO;
    self.idcw_navigationBar.OTCButton.selected = YES;
    self.idcw_navigationBar.swapLine.hidden = YES;
    self.selectIndex = 1;
    
}
#pragma mark
#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    if (index == 0) {
        return SWLocaloziString(@"3.0_FlashExchange");
    }else{
        return SWLocaloziString(@"3.0_OTCExchange");
    }
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
 
    if (index) {
        IDCMOTCExchangeRecordViewModel *otcviewModel = [[IDCMOTCExchangeRecordViewModel alloc] initWithParams:nil];
        IDCMOTCExchangeRecordController *otcVC = [[IDCMOTCExchangeRecordController alloc] initWithViewModel:otcviewModel];
        return otcVC;
    } else {
        IDCMFlashExchangeRecordViewModel *flashviewModel = [[IDCMFlashExchangeRecordViewModel alloc] initWithParams:nil];
        IDCMFlashExchangeRecordController *flashVC = [[IDCMFlashExchangeRecordController alloc] initWithViewModel:flashviewModel];
        return flashVC;
    }
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    
    menuView.hidden = YES;
    return CGRectMake(0, 0, self.view.frame.size.width, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, kSafeAreaTop+kNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height);
}
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    if ([viewController isKindOfClass:[IDCMFlashExchangeRecordController class]]) {
        [self selectSwap];
    }else{
        [self selectOTC];
    }
}
#pragma mark - getter
- (IDCMTradingPageNavigationBar *)idcw_navigationBar
{
    return SW_LAZY(_idcw_navigationBar, ({
        IDCMTradingPageNavigationBar *bar = [[IDCMTradingPageNavigationBar alloc] init];
        [self.view addSubview:bar];
        bar;
    }));
}

@end




