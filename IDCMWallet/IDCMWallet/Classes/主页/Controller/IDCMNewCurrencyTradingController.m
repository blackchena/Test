//
//  IDCMNewCurrencyTradingController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/28.
//  Copyright © 2018年 IDCM. All rights reserved.
//


#import "IDCMNewCurrencyTradingHeaderView.h"
#import "IDCMNewCurrencyTradingController.h"
#import "IDCMNewCurrencyTradingViewModel.h"
#import "IDCMNewCurrencyTradingModel.h"
#import "IDCMNewCurrencyTradingCell.h"
#import "IDCMBlockBaseTableView.h"
#import "IDCMBlockScrollView.h"


@interface IDCMNewCurrencyTradingController ()
@property (nonatomic,assign) BOOL isAppeared;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) IDCMBlockBaseTableView *tableView;
@property (nonatomic,strong) IDCMNewCurrencyTradingViewModel *viewModel;
@property (nonatomic,strong) IDCMNewCurrencyTradingHeaderView *headerView;
@end


@implementation IDCMNewCurrencyTradingController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.headerView.top = 0;
    [self.tableView setContentOffset:CGPointMake(0, - headerViewTopHeight)];
    [self.headerView recoveryUI];
}

- (void)handleBackGestureViewDidAppear {
    [super handleBackGestureViewDidAppear];
    if (self.isAppeared) {
        [self.tableView.headRefreshControl beginRefreshing];
    }
    self.isAppeared = YES;
}

#pragma mark — supper method
- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    void (^reloadTableViewB)(void) = ^{
        @strongify(self);
        self.headerView.userInteractionEnabled = NO;
        [self.tableView reloadData];
        self.headerView.userInteractionEnabled = YES;
    };
    
    [RACObserve(self.viewModel, marketModel) subscribeNext:^(IDCMCurrencyMarketModel *marketModel) {
        @strongify(self);
        if (marketModel) {
            if (self.title.length &&
                ![self.title isEqualToString:marketModel.currencyName]) {
                [self.viewModel.sectionModels removeAllObjects];
                reloadTableViewB();
            }
            [self.tableView endRefreshWithTitle:nil];
            self.title = marketModel.currencyName;
        }
    }];
    
    [[RACObserve(self.viewModel, tradeType) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView endRefreshWithTitle:nil];
        [self.viewModel.sectionModels removeAllObjects];
        reloadTableViewB();
    }];
    [self.viewModel.tableViewExecuteCommand(0) execute:nil];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    self.view.backgroundColor = viewBackgroundColor;
    UIView *topColorView = [[UIView alloc] initWithFrame:CGRectMake(0, -30, self.view.width, 50)];
    topColorView.backgroundColor = UIColorFromRGB(0x2E406B);
    [self.view addSubview:topColorView];
    [self.view addSubview:self.contentScrollView];
}

#pragma mark - getters and setters
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView){
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - kStatusBarDifferHeight);
        _contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
        [_contentScrollView addSubview:self.tableView];
        
        NSMutableArray *list = [NSMutableArray arrayWithArray:_contentScrollView.gestureRecognizers];
        for (UIGestureRecognizer *gestureRecognizer in list) {
            [_contentScrollView removeGestureRecognizer:gestureRecognizer];
        }
        for (UIGestureRecognizer *gestureRecognizer in self.tableView.gestureRecognizers) {
            [_contentScrollView addGestureRecognizer:gestureRecognizer];
        };
        [_contentScrollView addSubview:self.headerView];
    }
    return _contentScrollView;
}

- (IDCMNewCurrencyTradingHeaderView *)headerView {
    return SW_LAZY(_headerView, ({
        [IDCMNewCurrencyTradingHeaderView headerViewWithViewModel:self.viewModel];
    }));
}

- (IDCMBlockBaseTableView *)tableView {
    return SW_LAZY(_tableView, ({
        CGRect rect = CGRectMake(0, headerViewBottomHeight,SCREEN_WIDTH, _contentScrollView.height - headerViewBottomHeight);
        IDCMBlockBaseTableView *tableView =
        [IDCMBlockBaseTableView tableViewWithFrame:rect
                                             style:UITableViewStylePlain
                                       refreshType:IDCMRefreshTypePullDownAndUp
                                     refreshAction:nil
                                         viewModel:self.viewModel
                                         configure:[self tableViewConfigure]];
        tableView.rowHeight = 130;
        tableView.backgroundColor = viewBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(headerViewTopHeight, 0, kSafeAreaBottom, 0);
        tableView;
    }));
}

- (IDCMBlockBaseTableViewConfigure *)tableViewConfigure {
    @weakify(self);
    @weakify(_tableView);
    IDCMBlockBaseTableViewConfigure *configure = [[IDCMBlockBaseTableViewConfigure alloc] init];
    [[[[[[configure scrollViewDidScroll:^(UIScrollView *scrollView) {
        @strongify(self);
        [self configHeaderViewPostionWithScrollView:scrollView];
    }] configRegisterCellClasses:@[[IDCMNewCurrencyTradingCell class]]] 
           configCellClassForRow:^Class(IDCMBaseTableCellModel *cellViewModel, NSIndexPath *indexPath) {
        return [IDCMNewCurrencyTradingCell class];
    }] configDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
        @strongify(self);
        IDCMNewCurrencyTradingModel *model = (IDCMNewCurrencyTradingModel*)
        [self.viewModel getCellViewModelAtIndexPath:indexPath];
        [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMTradingDeatailController"
                                                           withViewModelName:@"IDCMTradingDeatailViewModel"
                                                                  withParams:@{@"dealModel":model}];
    }] scrollViewDidEndDecelerating:^(UIScrollView *scrollView) {
        if (scrollView.contentOffset.y < - headerViewTopHeight &&
            scrollView.headRefreshControl.refreshState == KafkaRefreshStateNone) {
            [scrollView setContentOffset:CGPointMake(0, - headerViewTopHeight) animated:YES];
        }
    }] configEmptyViewConfigure:^(IDCMHUDConfigure *configure) {
        @strongify(_tableView);
        configure
        .subTitle(SWLocaloziString(@"2.0_NoRecordData"))
        .image(@"2.0_wushuju")
        .backgroundImage([UIImage imageWithColor:viewBackgroundColor])
        .positionConfigure(RACTuplePack(@(1), @(0)))
        .contentFrame(@(CGRectMake(0, 0, _tableView.width, _tableView.height - _tableView.contentInset.top - kSafeAreaBottom)));
    }];
    return configure;
}

- (void)configHeaderViewPostionWithScrollView:(UIScrollView *)scrollView {
    @weakify(self);
    void (^animationBlock)(NSInteger) = ^(NSInteger distance){
        [UIView animateWithDuration:0.25 animations:^{
            @strongify(self);
            self.headerView.top = distance;
        }];
    };
    CGPoint point = scrollView.contentOffset;
    if (point.y <= - headerViewTopHeight) {
        if (self.headerView.top) {animationBlock(0);}
    } else if (point.y >= 0) {
        if (self.headerView.top != - headerViewTopHeight) {
            animationBlock(- headerViewTopHeight);
        }
    } else {
        self.headerView.top = - headerViewTopHeight - point.y;
    }
}

- (void)dealloc {
    [self.viewModel cancelAllRequest];
}

@end






















