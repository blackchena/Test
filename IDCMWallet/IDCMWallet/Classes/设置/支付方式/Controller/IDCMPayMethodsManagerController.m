//
//  IDCMPayMethodsManagerControllerl.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPayMethodsManagerController.h"
#import "IDCMPayMethodsManagerViewModel.h"
#import "IDCMPayMethodCell.h"


@interface IDCMPayMethodsManagerController () <UITableViewDataSource,
                                                UITableViewDelegate,
                                               MGSwipeTableCellDelegate,
                                                DZNEmptyDataSetSource,
                                                DZNEmptyDataSetDelegate>
@property (nonatomic,strong) IDCMPayMethodsManagerViewModel *viewModel;
@property (nonatomic,strong) IDCMTableView *tableView;
@property (nonatomic,assign) NSInteger cellCount;
@end


@implementation IDCMPayMethodsManagerController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
    [self.viewModel.requestDataCommand execute:nil];

}

#pragma mark — supper method
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    [[[[self.viewModel.requestDataCommand executionSignals] switchToLatest] deliverOnMainThread] subscribeNext:^(NSDictionary *respose) {
        @strongify(self);
        NSString *status = [NSString idcw_stringWithFormat:@"%@",respose[@"status"]];

        if ([status isEqualToString:@"1"]) {
            if ([respose[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *array = respose[@"data"];
                [self.viewModel.dataArray removeAllObjects];
                for (NSDictionary *dic in array) {
                    IDCMPaymentListModel *model = [IDCMPaymentListModel yy_modelWithDictionary:dic];
                    [self.viewModel.dataArray addObject:model];
                }
                [self.tableView reloadData];
            }
        }
        else{
            [IDCMShowMessageView showMessageWithCode:status];
        }
    }];
    [[[[self.viewModel.payMethodsDeleteCommand executionSignals] switchToLatest] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        NSString *inputID = (NSString *)tuple.first;
        NSDictionary *respose = (NSDictionary *)tuple.second;
        @strongify(self);
        NSString *status = [NSString idcw_stringWithFormat:@"%@",respose[@"status"]];

        if ([status isEqualToString:@"1"]) {
            if ([respose[@"data"] isKindOfClass:[NSNumber class]]) {
                NSInteger delIndex = -1;
                NSInteger index = 0;
                for (IDCMPaymentListModel *model in self.viewModel.dataArray) {
                    if ([model.ID isEqualToString:inputID]) {
                        delIndex = index;
                    }
                    index++;
                }
                if (delIndex != -1) {
                    [self.viewModel.dataArray removeObjectAtIndex:delIndex];
                    [self.tableView reloadData];
                    [IDCMShowMessageView showMessage:SWLocaloziString(@"3.0_del_PayMethods_Success_msg") withPosition:QMUIToastViewPositionBottom];
                }
            }
        }
        else{
            [IDCMShowMessageView showMessageWithCode:status];
        }
    }];
    
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    self.cellCount = 0;
    [self configUI];
}

- (void)showNoDataView {
    [IDCMHUD showEmptyViewToView:self.tableView
                       configure:^ (IDCMHUDConfigure *configure) {
                           configure.title(nil)
                                    .subTitle(NSLocalizedString(@"3.0_PleseAddPayMethods", nil))
                                    .backgroundImage([UIImage imageWithColor:viewBackgroundColor]);
                       }
                  reloadCallback:nil];
}

- (void)dismissNoDataView {
    [IDCMHUD dismissEmptyViewForView:self.tableView];
}

#pragma mark — 配置UI相关
- (void)configUI {
    
    self.navigationItem.title = NSLocalizedString(@"3.0_PayMethodsManager", nil);
    self.view.backgroundColor = viewBackgroundColor;
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[self class]];
    self.navigationItem.rightBarButtonItem =
    [self createRightBarButtonItem:nil
                            target:self
                          selector:@selector(rigthItemAction)
                         ImageName:@"3.0_addPayMethods"];
    [self.view addSubview:self.tableView];
}

- (void)rigthItemAction {
    @weakify(self);
    [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMPayMethodController"
                                           withViewModelName:@"IDCMPayMethodViewModel"
                                                  withParams:@{@"viewType" : @0 }
                                                    animated:YES
                                                  completion:^(NSDictionary *para) {
                                                      @strongify(self);
                                                      [self.viewModel.requestDataCommand execute:nil];
                                                  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCMPaymentListModel *model = [self.viewModel.dataArray objectAtIndex:indexPath.section];
    
    IDCMPayMethodCell *cell =
    [IDCMPayMethodCell cellWithTableView:tableView
                               indexPath:indexPath
                                   model:model];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(IDCMPayMethodCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell reloadCellData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCMPaymentListModel *model = [self.viewModel.dataArray objectAtIndex:indexPath.section];
    @weakify(self);
    [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMPayMethodController"
                                           withViewModelName:@"IDCMPayMethodViewModel"
                                                  withParams:@{@"viewType":@1,
                                                               @"editPaymentModel":model
                                                               }
                                                    animated:YES
                                                  completion:^(NSDictionary *para) {
                                                      @strongify(self);
                                                      [self.viewModel.requestDataCommand execute:nil];
                                                  }];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerSction = [[UIView alloc] init];
    headerSction.backgroundColor = viewBackgroundColor;
    return headerSction;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    else{
        return 4;
    }
}
#pragma mark Swipe Delegate
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction {
    cell.backgroundColor = viewBackgroundColor;
    return direction == MGSwipeDirectionRightToLeft;
}

-(NSArray*)swipeTableCell:(MGSwipeTableCell*) cell
 swipeButtonsForDirection:(MGSwipeDirection)direction
            swipeSettings:(MGSwipeSettings*) swipeSettings
        expansionSettings:(MGSwipeExpansionSettings*) expansionSettings {
    
    if (direction == MGSwipeDirectionRightToLeft) {
        swipeSettings.transition = MGSwipeTransitionRotate3D;
        @weakify(self);
        IDCMDeleteCellBtn * deleteBtn =
        [IDCMDeleteCellBtn buttonWithTitle:NSLocalizedString(@"2.1_Delete", nil)
                                      icon:[UIImage imageNamed:@"3.0_deletePayMethods"]
                           backgroundColor:viewBackgroundColor
                                  callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
                                        @strongify(self);
                                        [self deletePayMethodsWithIndexPath:[self.tableView indexPathForCell:cell]];
                                        return NO;
                                    }];
        deleteBtn.buttonWidth = 82;

        deleteBtn.titleLabel.font = textFontPingFangRegularFont(14);
        [deleteBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        return @[deleteBtn];
    }
    return nil;
}

- (void)deletePayMethodsWithIndexPath:(NSIndexPath *)indexPath {
    IDCMPaymentListModel *model = [self.viewModel.dataArray objectAtIndex:indexPath.section];
    @weakify(self);
    [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
        configure.title(NSLocalizedString(@"3.0_DeletePayMethodsSure", nil)).getBtnsConfig.lastObject.btnCallback(^{
            @strongify(self);
            [self.viewModel.payMethodsDeleteCommand execute:model.ID];
        });
        configure.getBtnsConfig.firstObject.btnCallback(^{
            @strongify(self);
            MGSwipeTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell hideSwipeAnimated:YES];
        });
    }];
}
#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = SWLocaloziString(@"3.0_PleseAddPayMethods");
    UIFont *font = textFontPingFangRegularFont(14);
    UIColor *textColor = textColor999999;
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
    return (self.viewModel.dataArray.count == 0) ? YES : NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
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
        [tableView registerCellWithCellClass:[IDCMPayMethodCell class]];
        tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];

        tableView.rowHeight = 86.0f;
        tableView;
    }));
}

@end

