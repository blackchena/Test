//
//  IDCMMessageViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/31.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMMessageViewController.h"
#import "IDCMMessageCell.h"

@interface IDCMMessageViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMMessageViewModel *viewModel;
/**
 *  消息列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 *  数据源
 */
@property (strong, nonatomic) NSMutableArray *dataArr;
/**
 *  NSIndexPath
 */
@property (strong, nonatomic) NSIndexPath *indexPath;
/**
 *  当前的页码数量
 */
@property (nonatomic,assign) NSInteger currentPageIndex;
/**
 *  是否下拉刷新
 */
@property (assign, nonatomic) BOOL isHeaderRefesh;
@end

static NSString *identifier = @"IDCMMessageCell";

@implementation IDCMMessageViewController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseData];
}
#pragma mark - configBase
- (void)configBaseData
{
    self.view.backgroundColor = UIColorWhite;
    self.navigationItem.title = NSLocalizedString(@"2.1_Notifications", nil);
    
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
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         if ([status isEqualToString:@"1"] && [response[@"data"][@"msgData"] isKindOfClass:[NSArray class]]) {
             [response[@"data"][@"msgData"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 @strongify(self);
                 IDCMNewsModel *model = [IDCMNewsModel yy_modelWithDictionary:obj];
                 [self.dataArr addObject:model];
             }];
         }

         [self.tableView reloadData];
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
    tableView.mj_footer.hidden = self.dataArr.count <= 0;
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDCMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.newsModel = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IDCMNewsModel *newsModel = self.dataArr[indexPath.row];
    if ([newsModel.contentUrl isNotBlank]) {
        
        [self.viewModel.confirmReadCommand execute:newsModel.msId];
        [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMWebViewController"
                                                           withViewModelName:@"IDCMWebViewModel"
                                                                  withParams:@{@"requestURL":newsModel.contentUrl}];
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SWLocaloziString(@"2.1_Delete");
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDCMNewsModel *newsModel = self.dataArr[indexPath.row];
    NSArray *arr = @[newsModel.msId];
    NSDictionary *deleteDic = @{@"type":@(1),@"uid":@(0),@"msgId":arr};
    [self.viewModel.deleteMessageCommand execute:deleteDic];
    
    self.indexPath = indexPath;
    [self.dataArr removeObjectAtIndex:indexPath.row];

    [tableView reloadData];
    
}
#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = SWLocaloziString(@"2.1_NoNotifications");
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
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = 68.0f;
        tableView.backgroundColor = UIColorWhite;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [tableView registerClass:[IDCMMessageCell class] forCellReuseIdentifier:identifier];
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (NSMutableArray *)dataArr
{
    return SW_LAZY(_dataArr, @[].mutableCopy);
}
@end
