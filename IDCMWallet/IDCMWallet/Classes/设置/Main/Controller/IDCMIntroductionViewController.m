//
//  IDCMIntroductionViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMIntroductionViewController.h"
#import "IDCMIntroductionViewModel.h"
#import "IDCMIntroductionModel.h"

@interface IDCMIntroductionViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMIntroductionViewModel *viewModel;
/**
 *  消息列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 *  数据源
 */
@property (strong, nonatomic) NSMutableArray *dataArr;
/**
 *  当前的页码数量
 */
@property (nonatomic,assign) NSInteger currentPageIndex;
/**
 *  是否下拉刷新
 */
@property (assign, nonatomic) BOOL isHeaderRefesh;
@end

static NSString *identifier = @"IDCMIntroductionCell";

@implementation IDCMIntroductionViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    self.title = SWLocaloziString(@"2.1_Introduction");
    

}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    self.currentPageIndex = 1;
    
    @weakify(self);
    // 获取最新消息
    [[[self.viewModel.requestDataCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         if (self.isHeaderRefesh) {
             [self.dataArr removeAllObjects];
         }
         if ([response[@"data"][@"mobileVersionList"] isKindOfClass:[NSArray class]]) {
             
             [response[@"data"][@"mobileVersionList"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 @strongify(self);
                 IDCMIntroductionModel *model = [IDCMIntroductionModel yy_modelWithDictionary:obj];
                 [self.dataArr addObject:model];
             }];
             [self.tableView reloadData];
         }
         
     }];
    
    [self.viewModel.requestDataCommand execute:[self.viewModel getRequsetParmaWithIndex:self.currentPageIndex]];
    
    //增加上下拉刷新
    [self.tableView addRefreshForTableViewHeaderWithKaKaHeaderBlock:^{
        @strongify(self);
        
        self.isHeaderRefesh = YES;
        self.currentPageIndex = 1;
        [self.viewModel.requestDataCommand execute:[self.viewModel getRequsetParmaWithIndex:self.currentPageIndex]];
    } footerWithKaKaFooterBlock:^{
        @strongify(self);
        self.isHeaderRefesh = NO;
        self.currentPageIndex ++;
        [self.viewModel.requestDataCommand execute:[self.viewModel getRequsetParmaWithIndex:self.currentPageIndex]];
    }];
    // 监听上下拉刷新是否结束
    [[self.viewModel.requestDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self.tableView endRefreshWithTitle:SWLocaloziString(@"2.1_DidLoadSuccess")];
        }
    }];
    
    [[RACObserve(self.viewModel, totalPage) deliverOnMainThread]
     subscribeNext:^(id  _Nullable x) {
         //如果全部数据已经请求完成
         @strongify(self);
         if (self.viewModel.totalPage.integerValue <= self.currentPageIndex) {
             [self.tableView.footRefreshControl endRefreshingAndNoLongerRefreshingWithAlertText:SWLocaloziString(@"2.1_MJRefreshBackFooterNoMoreDataText")];
         }else{
             [self.tableView.footRefreshControl resumeRefreshAvailable];
         }
     }];
}
#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDCMIntroductionModel *model = self.dataArr[indexPath.row];
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell= [[QMUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = model.version_name;
    cell.textLabel.textColor = textColor333333;
    cell.textLabel.font = textFontPingFangRegularFont(14);
    cell.detailTextLabel.text = model.customerTime;
    cell.detailTextLabel.textColor = textColor999999;
    cell.detailTextLabel.font = textFontPingFangRegularFont(12);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IDCMIntroductionModel *model = self.dataArr[indexPath.row];
    if ([model.version_introduction_url isNotBlank]) {

        [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMWebViewController" withViewModelName:@"IDCMWebViewModel" withParams:@{@"requestURL":model.version_introduction_url,@"title":[model.version_name isNotBlank] ? model.version_name : @""}];
    }
}
#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = SWLocaloziString(@"2.1_NoIntroduction");
    UIFont *font = textFontPingFangRegularFont(14);
    UIColor *textColor = textColor333333;
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return UIImageMake(@"2.1_NoDataImage");
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -120;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.dataArr.count == 0) ? YES : NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
#pragma mark - getter
- (IDCMTableView *)tableView
{
    return SW_LAZY(_tableView, ({
        
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight-kSafeAreaTop) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.emptyDataSetSource = self;
        tableView.rowHeight = 60.0f;
        tableView.backgroundColor = UIColorWhite;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (NSMutableArray *)dataArr
{
    return SW_LAZY(_dataArr, @[].mutableCopy);
}

@end
