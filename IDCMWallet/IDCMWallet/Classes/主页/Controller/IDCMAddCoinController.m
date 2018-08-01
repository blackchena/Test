//
//  IDCMAddCoinController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMAddCoinController.h"
#import "IDCMAddCoinCell.h"
#import "IDCMCurrencyMarketModel.h"
#import "IDCMSearchBar.h"

@interface IDCMAddCoinController ()<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMAddCoinViewModel *viewModel;
/**
 * 判断是搜索状态还是编辑状态
 */
@property (nonatomic, assign) BOOL isSearch;
/**
 * 搜索
 */
@property (nonatomic, strong) IDCMSearchBar *searchBar;
/**
 * 头部
 */
@property (nonatomic, strong) UIView  *headView;
/**
 *  币种列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 *  数据源
 */
@property (strong, nonatomic) NSMutableArray *dataArr;
/**
 *  选中数组
 */
@property (strong, nonatomic) NSMutableArray *selectArr;
/**
 *  搜索结果数组
 */
@property (strong, nonatomic) NSMutableArray *searchResults;

@end

static NSString *identifier = @"IDCMAddCoinCell";

@implementation IDCMAddCoinController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseData];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.headView);
        make.height.equalTo(@50.0);
    }];
}
#pragma mark - configBase
- (void)configBaseData
{
    self.view.backgroundColor = SetColor(245, 247, 249);
    self.navigationItem.title = NSLocalizedString(@"2.0_AddCoinVC", nil);
    self.fd_interactivePopDisabled = YES;
}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    // 监听币种列表信号
    [[[self.viewModel.requestDataCommand.executionSignals.switchToLatest filter:^BOOL(NSMutableArray *value) {
        return value.count > 0;
    }] deliverOnMainThread]
     subscribeNext:^(NSMutableArray *dataArr) {
         @strongify(self);
         self.dataArr = dataArr;
         [self.tableView reloadData];
         [IDCMTableViewAnimationKit showWithAnimationType:XSTableViewAnimationTypeToTop tableView:self.tableView];
         
     }];
    
    // 监听增加币种信号
    [[[self.viewModel.addCoinCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         
     }];
    
    // 数据请求
    [self.viewModel.requestDataCommand execute:nil];
}
- (void)addCoinRequest
{
    @weakify(self);
    [self.selectArr removeAllObjects];
    [self.dataArr enumerateObjectsUsingBlock:^(IDCMCurrencyMarketModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        model.sortIndex = @(idx+1);
        NSDictionary *dic = @{@"id":model.ID,@"isShow":[NSNumber numberWithBool:model.isShow],@"sortIndex":model.sortIndex};
        [self.selectArr addObject:dic];
        
    }];
    [self.viewModel.addCoinCommand execute:self.selectArr];
    
}
#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    NSInteger numberOfRows ;
    if (self.isSearch) {
        numberOfRows = self.searchResults.count;
    }else{
        numberOfRows = self.dataArr.count;
    }
    
    return numberOfRows;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    [self.dataArr enumerateObjectsUsingBlock:^(IDCMCurrencyMarketModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if (model.isShow && idx == indexPath.row) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
        }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IDCMAddCoinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    IDCMCurrencyMarketModel *model;
    if (self.isSearch) {
        model = self.searchResults[indexPath.row];
    }else{
        model = self.dataArr[indexPath.row];
    }
    
    cell.makketModel = model;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
    
    IDCMCurrencyMarketModel *model = self.dataArr[indexPath.row];
    model.isShow = !model.isShow;
    [self addCoinRequest];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IDCMCurrencyMarketModel *model = self.dataArr[indexPath.row];
    model.isShow = !model.isShow;
    [self addCoinRequest];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - UISearchBarDelegate

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length > 0) {
        self.isSearch = YES;
        
    }else{
        
        self.isSearch = NO;
        [searchBar resignFirstResponder];
    }
    [self.searchResults removeAllObjects];
    
    @weakify(self);
    [self.dataArr enumerateObjectsUsingBlock:^(IDCMCurrencyMarketModel  *model, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if ([model.currencyName containsString:searchText] || [model.currency containsString:[searchText uppercaseString]] || [model.currency containsString:[searchText lowercaseString]]) {
            [self.searchResults addObject:model];
        }
    }];
    
    [self.tableView reloadData];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.searchBar resignFirstResponder];
}

#pragma mark - getter
- (IDCMTableView *)tableView
{
    return SW_LAZY(_tableView, ({
        
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight - kSafeAreaTop) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionHeaderHeight = 30.0f;
        tableView.backgroundColor = UIColorWhite;
        tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
        tableView.tableHeaderView = self.headView;
        [tableView setEditing:YES animated:NO];
        tableView.editing = YES;
        tableView.allowsMultipleSelectionDuringEditing = YES;
        [tableView registerClass:[IDCMAddCoinCell class] forCellReuseIdentifier:identifier];
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (UIView *)headView
{
    return SW_LAZY(_headView, ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = viewBackgroundColor;
        view;
    }));
}
- (IDCMSearchBar *)searchBar
{
    return SW_LAZY(_searchBar, ({
        IDCMSearchBar *view = [[IDCMSearchBar alloc] init];
        view.placeholder = NSLocalizedString(@"2.0_Search", nil);
        view.delegate = self;
        UIImage* searchBarBg = [IDCMUtilsMethod GetImageWithColor:viewBackgroundColor andHeight:32.0f];
        [view setBackgroundImage:searchBarBg];
        [view setBackgroundColor:[UIColor clearColor]];
        view.layer.cornerRadius = 3;
        view.layer.masksToBounds = YES;
        [view.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.headView addSubview:view];
        view;
    }));
}
- (NSMutableArray *)dataArr
{
    return SW_LAZY(_dataArr, @[].mutableCopy);
}
- (NSMutableArray *)selectArr
{
    return SW_LAZY(_selectArr, @[].mutableCopy);
}
- (NSMutableArray *)searchResults
{
    return SW_LAZY(_searchResults, @[].mutableCopy);
}
@end

