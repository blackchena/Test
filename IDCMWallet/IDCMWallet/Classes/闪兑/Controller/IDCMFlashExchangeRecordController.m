//
//  IDCMFlashExchangeRecordController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//


#import "IDCMFlashExchangeRecordController.h"
#import "IDCMFlashExchangeRecordViewModel.h"
#import "IDCMFlashExchangeRecordModel.h"
#import "IDCMFlashExchangeRecordCell.h"
#import "IDCMFlashExchangeController.h"
#import "IDCMFlashExchangeViewModel.h"
#import "IDCMFlashRecordEmtyCell.h"
#import "IDCMBlockBaseTableView.h"


@interface IDCMFlashExchangeRecordController ()
@property (nonatomic,strong) IDCMFlashExchangeRecordViewModel *viewModel;
@property (nonatomic,weak)   IDCMFlashExchangeController *exchangeVx;
@property (nonatomic,strong) UIView *sectionHeaderView;
@property (nonatomic,strong) UIView *headerView;
@end


@implementation IDCMFlashExchangeRecordController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

- (void)handleBackGestureViewWillAppear {
    [self refreshData];
}

- (void)refreshData{
    self.netRequestDone = NO;
    [self.viewModel.tableViewExecuteCommand(0) execute:nil];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - getters and setters
- (IDCMBlockBaseTableView *)tableView {
    return SW_LAZY(_tableView, ({
        
        @weakify(self);
        RefreshAction (^refreshBlock)(BOOL) = ^RefreshAction(BOOL isHeaderFresh){
            if (isHeaderFresh) {
                return ^{
                    @strongify(self);
                    [self.viewModel.tableViewExecuteCommand(1) execute:nil];
                    [self.exchangeVx refreshBalance:NO];
                };
            }
            return nil;
        };
        
        CGRect rect =
        CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - kStatusBarDifferHeight - 49 - kSafeAreaBottom);
        IDCMBlockBaseTableView *tableView =
        [IDCMBlockBaseTableView tableViewWithFrame:rect
                                             style:UITableViewStylePlain
                                       refreshType:IDCMRefreshTypePullDownAndUp
                                     refreshAction:refreshBlock
                                         viewModel:self.viewModel
                                         configure:[self tableViewConfigure]];
        tableView.backgroundColor = viewBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
        tableView.tableHeaderView = self.headerView;
        [tableView configCommandSignaleSub:nil erresSub:nil executingSub:^(NSNumber *value) {
            @strongify(self);
            if (!value.boolValue) {
                self.netRequestDone = YES;
                if (self.exchangeVx.netRequestDone) {
                    [IDCMHUD dismiss];
                }
            }
        }];
        tableView;
    }));
}

- (IDCMBlockBaseTableViewConfigure *)tableViewConfigure {
    @weakify(self);
    IDCMBlockBaseTableViewConfigure *configure = [[IDCMBlockBaseTableViewConfigure alloc] init];
    [[[[[[[[[[configure configNumberOfSections:^NSInteger(UITableView *tableView) {
        return 1;
    }] configNumberOfRowsInSection:^NSInteger(UITableView *tableView, NSInteger section) {
        @strongify(self);
        return [self.viewModel getSectionViewModelAtSection:0].cellModels.count ?: 1;
    }]configRegisterCellClasses:@[[IDCMFlashExchangeRecordCell class], [IDCMFlashRecordEmtyCell class]]]
           configCellClassForRow:^Class(IDCMBaseTableCellModel *cellViewModel, NSIndexPath *indexPath) {
        @strongify(self);
        return self.viewModel.sectionModels.count ?
        [IDCMFlashExchangeRecordCell class] : [IDCMFlashRecordEmtyCell class];
    }] configHeightForRowAtIndexPath:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        @strongify(self);
        return  self.viewModel.sectionModels.count ?
                (indexPath.row ? 114 : (114 + 8)) : (tableView.height - 40);
    }] configHeightForHeaderInSection:^CGFloat(UITableView *tableView, NSInteger section) {
        return 40;
    }] configHeaderFooterViewClassAtSection:^id (IDCMBaseTableSectionModel *sectionViewModel, IDCMSeactionViewKinds seactionViewKinds, NSUInteger section) {
        @strongify(self);
        return seactionViewKinds == SeactionHeaderView ? self.sectionHeaderView : nil;
    }] configDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
        @strongify(self);
        if (self.viewModel.sectionModels.count) {
            NSString *tempStr = ((IDCMFlashExchangeRecordModel *)
            [self.viewModel getCellViewModelAtIndexPath:indexPath]).ID;
            [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMFlashExchangeDetailController"
                                                   withViewModelName:@"IDCMFlashExchangeDetailViewModel"
                                                          withParams:@{@"ID": [IDCMUtilsMethod valueString:tempStr]}
                                                            animated:YES];
        }
    }] scrollViewDidEndDecelerating:^(UIScrollView *scrollView) {
        if (scrollView.contentOffset.y < 0 &&
            scrollView.headRefreshControl.refreshState == KafkaRefreshStateNone) {
            [scrollView setContentOffset:CGPointZero animated:YES];
        }
    }] scrollViewDidScroll:^(UIScrollView *scrollView) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    return configure;
}

- (UIView *)headerView {
    return SW_LAZY(_headerView, ({
        
        IDCMFlashExchangeViewModel *viewModel = [[IDCMFlashExchangeViewModel alloc] initWithParams:nil];
        IDCMFlashExchangeController *exchangeVx = [[IDCMFlashExchangeController alloc] initWithViewModel:viewModel];
        [self addChildViewController:exchangeVx];
        self.exchangeVx = exchangeVx;
        [self.view addSubview:exchangeVx.view];
        exchangeVx.view;
    }));
}

- (UIView *)sectionHeaderView {
    return SW_LAZY(_sectionHeaderView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorWhite;
        view.size = CGSizeMake(SCREEN_WIDTH, 40);
        
        UIView *leftLine = [[UIView alloc] init];
        leftLine.frame = CGRectMake(12, 12, 3, 14);
        leftLine.layer.cornerRadius = 2.0;
        leftLine.layer.masksToBounds = YES;
        leftLine.backgroundColor = kThemeColor;
        [view addSubview:leftLine];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(12);
        label.text = NSLocalizedString(@"3.0_FlashExchangeRecord", nil);
        label.width = SCREEN_WIDTH - (leftLine.right + 4) - 12;
        label.height = leftLine.height;
        label.left = leftLine.right + 4;
        label.centerY = leftLine.centerY;
        [view addSubview:label];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        line.size = CGSizeMake(SCREEN_WIDTH, .5);
        line.bottom = view.height;
        [view addSubview:line];
        
        view;
    }));
}

@end




