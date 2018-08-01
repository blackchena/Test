//
//  IDCMAcceptantViewController.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantViewController.h"
#import "IDCMAcceptBuyCoinViewController.h"
#import "IDCMAcceptSellCoinViewController.h"
#import "IDCMAcceptantHeaderView.h"
#import "IDCMAcceptantApplyStepsEndViewModel.h"

@interface IDCMAcceptantViewController ()
@property (nonatomic,strong) IDCMAcceptantHeaderView * headerView ;
@end
@implementation IDCMAcceptantViewController

- (void)viewDidLoad {
    
    [self configPageController];
    [super viewDidLoad];
    self.view.backgroundColor = viewBackgroundColor;
    self.navigationItem.title = SWLocaloziString(@"3.0_Bin_AcceptanceTitle");
    [self.view addSubview:self.headerView];
    //更新列表
    [self.headerView requestWithdrawCoinList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNeedRefresh) {
        [self.headerView requestWithdrawCoinList];
        self.isNeedRefresh = NO;
    }
}

- (void)configPageController {
    
    self.selectIndex = 0;
    self.titleSizeNormal = 14;
    self.titleSizeSelected = 14;
    self.titleColorNormal = textColor333333;
    self.titleFontName = @"PingFangSC-Regular";
    self.titleColorSelected = [UIColor colorWithHexString:@"#2E406B"];
   
    CGFloat leftProgressWidth = [SWLocaloziString(@"3.0_Bin_AcceptSellCoin")
                                 widthForFont:textFontPingFangRegularFont(14)];
    leftProgressWidth = leftProgressWidth > (SCREEN_WIDTH / 2) ? (SCREEN_WIDTH / 2) : leftProgressWidth;

    CGFloat rightProgressWidth = [SWLocaloziString(@"3.0_Bin_AcceptBuyCoin")
                                  widthForFont:textFontPingFangRegularFont(14)];
    rightProgressWidth = rightProgressWidth > (SCREEN_WIDTH / 2) ? (SCREEN_WIDTH / 2) : rightProgressWidth;
    
    CGFloat itemWidth = MAX(130, MAX(leftProgressWidth, rightProgressWidth));
    
    self.progressViewWidths = @[@(leftProgressWidth ) , @(rightProgressWidth)];
    self.progressViewBottomSpace = 4;
    self.progressViewCornerRadius = 1;
    self.progressViewIsNaughty = YES;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.itemsWidths = @[@(itemWidth), @(itemWidth)];
    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    self.progressColor = [UIColor colorWithHexString:@"#2E406B"];
}


#pragma mark - WMPageControllerDataSource

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return index ?
    SWLocaloziString(@"3.0_Bin_AcceptBuyCoin"): SWLocaloziString(@"3.0_Bin_AcceptSellCoin");
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    IDCMAcceptantApplyStepsEndViewModel * buyModel = [[IDCMAcceptantApplyStepsEndViewModel alloc] initWithParams:nil];
    
    IDCMAcceptBuyCoinViewController *buyCoinVc =
    [[IDCMAcceptBuyCoinViewController alloc] initWithViewModel:buyModel];
    
    IDCMAcceptantApplyStepsEndViewModel * sellModel = [[IDCMAcceptantApplyStepsEndViewModel alloc] initWithParams:nil];
    
    IDCMAcceptSellCoinViewController *sellCoinVc =
    [[IDCMAcceptSellCoinViewController alloc] initWithViewModel:sellModel];
    if (index == 0) {
        return buyCoinVc;
    }else{
        return sellCoinVc;
    }

}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width =  [pageController.itemsWidths.firstObject floatValue];
    CGRect left  = [SWLocaloziString(@"3.0_Bin_AcceptSellCoin") boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 14)} context:nil];
    
     CGRect right  = [SWLocaloziString(@"3.0_Bin_AcceptBuyCoin") boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 14)} context:nil];
    
    CGFloat diff = MAX(left.size.height, right.size.height) -20;
    
    return CGRectMake(0, self.headerView.bottom + 10, self.view.width , 40 + diff);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat width =  [pageController.itemsWidths.firstObject floatValue];
    CGRect left  = [SWLocaloziString(@"3.0_Bin_AcceptSellCoin") boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 14)} context:nil];
    
    CGRect right  = [SWLocaloziString(@"3.0_Bin_AcceptBuyCoin") boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 14)} context:nil];
    
    CGFloat diff = MAX(left.size.height, right.size.height) -20;
    CGFloat y = self.headerView.bottom + 40 + diff + 10;

//    CGFloat y = pageController.menuView.bottom;
    return CGRectMake(0, y, self.view.width, self.view.height - y);
}


-(IDCMAcceptantHeaderView *)headerView{
    if (!_headerView) {
        
        _headerView = [[IDCMAcceptantHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185)];
        _headerView.leftCallBack = ^{
            
            [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMAcceptantPickInBondController"
                                                   withViewModelName:nil
                                                          withParams:nil
                                                            animated:YES];
        };
        _headerView.rightCallBack = ^{
            
            [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMAcceptantMarginManageController"
                                                   withViewModelName:@"IDCMAcceptantMarginManageViewModel"
                                                          withParams:nil
                                                            animated:YES];
        };
    }
    return _headerView;
}

@end
