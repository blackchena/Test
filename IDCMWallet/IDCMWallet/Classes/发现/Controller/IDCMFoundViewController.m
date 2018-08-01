//
//  IDCMFoundViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/21.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMFoundViewController.h"
#import "IDCMFoundViewModel.h"
#import "IDCMFoundBannerView.h"
#import "IDCMFoundDappModel.h"

@interface IDCMFoundViewController ()
/**
 *  viewModel
 */
@property (strong, nonatomic) IDCMFoundViewModel *viewModel;
/**
 *  bannerView
 */
@property (strong, nonatomic) IDCMFoundBannerView *bannerView;
/**
 *  UITableView
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 *  tableViewBindHelper
 */
@property (strong, nonatomic) IDCMTableViewBindHelper *tableViewBindHelper;
/**
 *  提示语
 */
@property (strong, nonatomic) UILabel *tipsLabel;
@end

@implementation IDCMFoundViewController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.bannerView startTimerWhenAutoScroll];
    [self.bannerView adjustBannerViewWhenCardScreen];
    
    [self.viewModel.requestDataCommand execute:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.bannerView invalidateTimerWhenAutoScroll];
    [self cancelRequest];
}
- (void)initUI{
    
    self.view.backgroundColor = UIColorWhite;
    self.fd_prefersNavigationBarHidden = YES;
    
    NSNumber *width ;
    if ([[IDCMUtilsMethod getPreferredLanguage] isEqualToString:@"zh-Hans"] || [[IDCMUtilsMethod getPreferredLanguage] isEqualToString:@"zh-Hant"]) {
        width = @(200);
    }else{
        width = @(260);
    }
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-22);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@50);
        make.width.greaterThanOrEqualTo(width);
    }];
}
#pragma mark - Bind
- (void)bindViewModel{
    [super bindViewModel];
    
    // 绑定tableView
    self.tableViewBindHelper = [IDCMTableViewBindHelper bindingHelperForTableView:self.tableView
                                                                     sourceSignal:RACObserve(self.viewModel, dappList)
                                                                 selectionCommand:nil
                                                                     templateCell:@"IDCMFoundFeedCell"];
    // 绑定BannerView
    [self.bannerView bindingBannerViewForSourceSignal:RACObserve(self.viewModel, bannerList)
                                     selectionCommand:self.viewModel.bannerCommand];
    
}
#pragma mark - prevete method
- (void)cancelRequest{
    
    NSString *isReadURL = [NSString idcw_stringWithFormat:@"%@?dappId=",DappIsRead_URL];
    [IDCMNetWorking cancelRequestWithURL:isReadURL];
}
#pragma mark - Getter & Setter
- (IDCMFoundBannerView *)bannerView{
    
    return SW_LAZY(_bannerView, ({
        IDCMFoundBannerView *view = [[IDCMFoundBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMTableView *)tableView{
    
    return SW_LAZY(_tableView, ({
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, SCREEN_HEIGHT-kTabBarHeight-kSafeAreaBottom-190) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = UIColorWhite;
        tableView.rowHeight = 185;
        tableView.bounces = NO;
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (UILabel *)tipsLabel{
    
    return SW_LAZY(_tipsLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
        label.textColor = UIColorMake(168, 177, 198);
        label.text = SWLocaloziString(@"3.0_Bin_DappTips");
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.layer.borderColor = UIColorMake(168, 177, 198).CGColor;
        label.layer.borderWidth = 0.5;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [self.view addSubview:label];
        label;
    }));
}
@end
