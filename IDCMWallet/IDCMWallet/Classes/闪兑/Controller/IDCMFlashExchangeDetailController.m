
//
//  IDCMFlashRecordDetailController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//


#import "IDCMFlashExchangeDetailController.h"
#import "IDCMFlashExchangeDetailFooterView.h"
#import "IDCMFlashExchangeDetailViewModel.h"
#import "IDCMFlashExchangeDetailCell.h"
#import "IDCMBlockBaseTableView.h"


@interface IDCMFlashExchangeDetailController ()
@property (nonatomic,strong) IDCMFlashExchangeDetailFooterView *footerView;
@property (nonatomic,readonly) IDCMFlashExchangeDetailViewModel *viewModel;
@property (nonatomic,strong) IDCMBlockBaseTableView *tableView;
@end


@implementation IDCMFlashExchangeDetailController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
    [self.viewModel.tableViewExecuteCommand(0) execute:nil];
}

#pragma mark — hook 返回手势
- (void)hookControllerBackGestureWithState:(ControllerBackGestureState)state {
    if (state == ControllerBackGestureState_Begin) {
        self.viewModel.isGestuerEdit = YES;
        [self.view endEditing:YES];
    }else if(state == ControllerBackGestureState_FailPop){
        self.viewModel.isGestuerEdit = NO;
    }
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    self.navigationItem.title = NSLocalizedString(@"3.0_ExchangeDetail", nil);;
    self.view.backgroundColor = viewBackgroundColor;
    [self.view addSubview:self.tableView];
}

#pragma mark - getters and setters
- (IDCMBlockBaseTableView *)tableView {
    return SW_LAZY(_tableView, ({
        
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - kStatusBarDifferHeight);
        IDCMBlockBaseTableView *tableView =
        [IDCMBlockBaseTableView tableViewWithFrame:rect
                                             style:UITableViewStylePlain
                                       refreshType:IDCMRefreshTypePullDown
                                     refreshAction:nil
                                         viewModel:self.viewModel
                                         configure:[self tableViewConfigure]];
        @weakify(self);
        [tableView configCommandSignaleSub:^(id value) {
            @strongify(self);
            [self.tableView reloadData];
            self.footerView.viewModel = self.viewModel;
            [self.tableView endRefreshWithTitle:SWLocaloziString(@"2.1_DidLoadSuccess")];
        } erresSub:nil executingSub:nil];

        tableView.rowHeight = 188.0f;
        tableView.tableFooterView = self.footerView;
        tableView.backgroundColor = viewBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, kSafeAreaBottom, 0);
        tableView;
    }));
}

- (IDCMBlockBaseTableViewConfigure *)tableViewConfigure {
    IDCMBlockBaseTableViewConfigure *configure = [[IDCMBlockBaseTableViewConfigure alloc] init];
    [[[[configure configNumberOfSections:^NSInteger(UITableView *tableView) {
        return 1;
    }] configNumberOfRowsInSection:^NSInteger(UITableView *tableView, NSInteger section) {
        return 2;
    }] configRegisterCellClasses:@[[IDCMFlashExchangeDetailCell class]]]
       configCellClassForRow:^Class(IDCMBaseTableCellModel *cellViewModel, NSIndexPath *indexPath) {
        return [IDCMFlashExchangeDetailCell class];
    }];
    return configure;
}

- (IDCMFlashExchangeDetailFooterView *)footerView {
    return SW_LAZY(_footerView, ({
        IDCMFlashExchangeDetailFooterView *footerView = [[IDCMFlashExchangeDetailFooterView alloc] init];
        footerView.size = CGSizeMake(SCREEN_WIDTH, 42 * 3 + 60);
        footerView.viewModel = self.viewModel;
        footerView;
    }));
}

@end





