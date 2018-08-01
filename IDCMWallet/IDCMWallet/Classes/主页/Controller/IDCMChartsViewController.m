//
//  IDCMChartsViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChartsViewController.h"
#import "IDCMChartsViewCell.h"
#import "IDCMChartsHeaderView.h"


@interface IDCMChartsViewController ()<UITableViewDataSource, UITableViewDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMChartsViewModel *viewModel;
/**
 *  币种列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 *  数据源model
 */
@property (strong, nonatomic) IDCMChartModel *chartModel;
/**
 *  tableView的顶部视图
 */
@property (strong, nonatomic) IDCMChartsHeaderView *chartHederView;
/**
 *  设置类型
 */
@property (assign, nonatomic) NSInteger showType;
/**
 *  数据源
 */
@property (strong, nonatomic) NSMutableArray *dataArr;
@end

static NSString *identifier = @"IDCMChartsViewCell";

@implementation IDCMChartsViewController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    [self tableView];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.viewModel.requestDataCommand execute:nil];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
   
    [self.chartHederView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    // 监听币种列表信号
    [[self.viewModel.requestDataCommand.executionSignals.switchToLatest  deliverOnMainThread]
     subscribeNext:^(IDCMChartModel *model) {
         @strongify(self);
         IDCMTrendChartModel *chartModel = [IDCMTrendChartModel new];
         chartModel.ID = @(0);
         chartModel.isDefault = YES;
         [model.currencyList enumerateObjectsUsingBlock:^(IDCMTrendChartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if (obj.isDefault) {
                 chartModel.isDefault = NO;
             }
         }];
         NSMutableArray *currencyList = [NSMutableArray arrayWithArray:model.currencyList];
         [currencyList insertObject:chartModel atIndex:0];
         self.dataArr = currencyList;
         self.chartModel = model;
         [self.tableView reloadData];
         [IDCMTableViewAnimationKit showWithAnimationType:XSTableViewAnimationTypeToTop tableView:self.tableView];
     }];
    
    // 监听配置信号
    [[[self.viewModel.configChartCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {

     }];
    
    [self.viewModel.requestDataCommand execute:nil];
}
- (void)configChartsType
{
    NSDictionary __block *dic = @{};
    @weakify(self);
    [self.dataArr enumerateObjectsUsingBlock:^(IDCMTrendChartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if (obj.isDefault) {
            dic = @{@"id":self.chartModel.ID,
                    @"showType":self.chartModel.showType,
                    @"currencyId":obj.ID
                    };
        }
    }];
    
    [self.viewModel.configChartCommand execute:dic];
}
#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IDCMChartsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setChartDataArr:_dataArr withIndex:indexPath.row withShowType:[_chartModel.showType integerValue]];
    
    @weakify(self);
    cell.didSelectChartsBlock = ^(IDCMDidSelectChartsType type) {
        
        @strongify(self);
        if (type == IDCMDidSelectAssets) { // 选择资产
            self.chartModel.showType = @(0);
        }else{ // 选择行情
            self.chartModel.showType = @(1);
        }
        [self.dataArr enumerateObjectsUsingBlock:^(IDCMTrendChartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == indexPath.row) {
                obj.isDefault = YES;
            }else{
                obj.isDefault = NO;
            }
        }];
        [tableView reloadData];
        
        [self configChartsType];
    };
    
    return cell;
}

#pragma mark - getter
- (IDCMTableView *)tableView
{
    return SW_LAZY(_tableView, ({
        
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight - kSafeAreaTop) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 60.0f;
        tableView.backgroundColor = UIColorWhite;
        tableView.tableHeaderView = self.chartHederView;
        tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
        [tableView registerClass:[IDCMChartsViewCell class] forCellReuseIdentifier:identifier];
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (IDCMChartsHeaderView *)chartHederView
{
    return SW_LAZY(_chartHederView, ({
        IDCMChartsHeaderView *view = [[IDCMChartsHeaderView alloc] init];
        view;
    }));
}
- (NSMutableArray *)dataArr
{
    return SW_LAZY(_dataArr, @[].mutableCopy);
}
@end
