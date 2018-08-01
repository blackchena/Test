//
//  IDCMAcceptantBondWaterController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantBondWaterController.h"
#import "IDCMAcceptantBondWaterViewModel.h"
#import "IDCMAcceptantBondWaterCell.h"
#import "UINavigationController+Extensions.h"
#import "IDCMAcceptantViewController.h"
#import "IDCMCheckAcceptantStateController.h"

@interface IDCMAcceptantBondWaterController () <UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) IDCMAcceptantBondWaterViewModel *viewModel;
@property (nonatomic,strong) IDCMTableView *tableView;
@end


@implementation IDCMAcceptantBondWaterController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
    self.fd_interactivePopDisabled = YES;
}

#pragma mark — supper method
- (void)bindViewModel {
    [super bindViewModel];
    
    [self.viewModel.requestDataCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id  _Nullable x) {
        
    }];
    [self.viewModel.requestDataCommand.errors subscribeNext:^(NSError * _Nullable x) {
        
    }];
    [self.viewModel.requestDataCommand execute:nil];
    @weakify(self);
    [RACObserve(self.viewModel, dataList) subscribeNext:^(NSArray *x) {
        @strongify(self);
        if (x.count > 0) {
            [self.tableView reloadData];
        }
    }];
    
    //增加上下拉刷新
    [self.tableView addRefreshForTableViewHeaderWithKaKaHeaderBlock:^{
        @strongify(self);
        self.viewModel.PageIndex = @1;
        [self.viewModel.requestDataCommand execute:nil];

    } footerWithKaKaFooterBlock:^{
        @strongify(self);
        NSInteger currentPageIndex = self.viewModel.PageIndex.integerValue;
        currentPageIndex ++;
        self.viewModel.PageIndex = [NSNumber numberWithInteger:currentPageIndex];
        [self.viewModel.requestDataCommand execute:nil];

    }];
    // 监听上下拉刷新是否结束
    [[self.viewModel.requestDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [IDCMHUD dismiss];
            [self.tableView endRefreshWithTitle:SWLocaloziString(@"2.1_DidLoadSuccess")];
        }
    }];
    
    [[RACObserve(self.viewModel, totalPage) deliverOnMainThread]
     subscribeNext:^(id  _Nullable x) {
         //如果全部数据已经请求完成
         @strongify(self);
         if (self.viewModel.totalPage.integerValue <= self.self.viewModel.PageIndex.integerValue) {
             [self.tableView.footRefreshControl endRefreshingAndNoLongerRefreshingWithAlertText:SWLocaloziString(@"2.1_MJRefreshBackFooterNoMoreDataText")];
         }else{
             [self.tableView.footRefreshControl resumeRefreshAvailable];
         }
     }];
}
- (BOOL)shouldHoldBackButtonEvent{
    if ([self.viewModel.JumpType isEqualToString:@"0"]) {
        return YES;
    }
    return NO;
}
- (BOOL)canPopViewController{
    
   IDCMCheckAcceptantStateController * stateVC = ( IDCMCheckAcceptantStateController * ) [self.navigationController getViewControllerByname:@"IDCMCheckAcceptantStateController"];
    NSArray * childs = stateVC.childViewControllers;
    
    if (childs.count>0  &&  [childs.firstObject isKindOfClass:[IDCMAcceptantViewController class]]) {
        IDCMAcceptantViewController * vc = (IDCMAcceptantViewController *)  childs.firstObject;
        vc.isNeedRefresh = YES;
    }
    [self.navigationController popBackViewController:@"IDCMCheckAcceptantStateController"];
    return NO;
}
#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    NSString *title = [SWLocaloziString(@"3.0_AcceptantOTCWater") stringByReplacingOccurrencesOfString:@"[IDCW]" withString:self.viewModel.CoinCode.uppercaseString];
    self.navigationItem.title = title;
    self.view.backgroundColor = viewBackgroundColor;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.dataList.count > 0) {
        IDCMAcceptantBondWaterModel *model = [self.viewModel.dataList objectAtIndex:indexPath.row];
        return [IDCMAcceptantBondWaterCell cellWithTableView:tableView
                                                   indexPath:indexPath
                                                       model:model];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(IDCMAcceptantBondWaterCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell reloadCellData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCMAcceptantBondWaterModel *model = [self.viewModel.dataList objectAtIndex:indexPath.row];
    return [IDCMAcceptantBondWaterCell heightForCell:model];
}


#pragma mark - getters and setters

- (IDCMTableView *)tableView {
    return SW_LAZY(_tableView, ({

        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - kStatusBarDifferHeight);
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.backgroundColor = viewBackgroundColor;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [tableView registerCellWithCellClass:[IDCMAcceptantBondWaterCell class]];
        tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
        tableView;
    }));
}
#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = SWLocaloziString(@"2.1_No_Acceptantce_water");
    UIFont *font = textFontPingFangRegularFont(14);
    UIColor *textColor = textColor333333;
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return UIImageMake(@"2.0_wushuju");
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -120;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.viewModel.dataList.count == 0) ? YES : NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
@end
