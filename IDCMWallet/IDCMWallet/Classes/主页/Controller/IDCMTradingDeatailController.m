//
//  IDCMTradingDeatailController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/21.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMTradingDeatailController.h"
#import "IDCMTradDetailHeaderView.h"
#import "IDCMTradingDeatailViewModel.h"

#import "IDCMTradDetailDescriptionViewCell.h"
#import "IDCMTradDetailInfoCell.h"

@interface IDCMTradingDeatailController ()<QMUITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMTradingDeatailViewModel *viewModel;
/**
 *  列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;

/**
 *  headerView
 */
@property (strong, nonatomic) IDCMTradDetailHeaderView *detailHeaderView;
/**
 *  数据
 */
@property (strong, nonatomic) NSMutableArray *dataArr;
/**
 *  cell的噶度
 */
@property (strong, nonatomic) NSArray *arrHeight;
/**
 *  交易详情Disposable
 */
@property (strong, nonatomic) RACDisposable *requestDisposable;
@end

static NSString *infoIdentifier = @"IDCMTradDetailInfoCell";
static NSString *descriptionIdentifier = @"IDCMTradDetailDescriptionViewCell";

@implementation IDCMTradingDeatailController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self configBaseData];
}

#pragma mark - configBase
- (void)configBaseData
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"2.0_TradDetailVC", nil);
    
    self.arrHeight = @[@(43),@(58),@(43),@(43),@(78)];
    [self tableView];
}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    // 监听交易详情
    @weakify(self);
    self.requestDisposable = [[[self.viewModel.requestDataCommand.executionSignals switchToLatest]
                               deliverOnMainThread]
                              subscribeNext:^(NSDictionary *response) {
                                  @strongify(self);
                                  NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                                  if ([status isEqualToString:@"1"] && ![response[@"data"] isKindOfClass:[NSNull class]] && response[@"data"] != nil) {
                                      [self.dataArr removeAllObjects];
                                      IDCMNewCurrencyTradingModel *model = [IDCMNewCurrencyTradingModel yy_modelWithDictionary:response[@"data"]];
                                      [self.dataArr addObject:model];
                                      self.viewModel.dealModel = model;
                                      [self.tableView reloadData];
                                      
                                  }else{
                                      [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_TradingDeatailFail", nil)];
                                  }
                                  
                              }];
    
    RAC(self.detailHeaderView,dealModel) = RACObserve(self.viewModel, dealModel);
    
    // 开始交易详情信号
    [self.viewModel.requestDataCommand execute:nil];
    
    // 下拉刷新
    [self.tableView addRefreshForTableViewHeaderWithKaKaHeaderBlock:^{
        @strongify(self);
        [self.viewModel.requestDataCommand execute:nil];
    } footerWithKaKaFooterBlock:nil];
    
    [[self.viewModel.requestDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self.tableView endRefreshWithTitle:SWLocaloziString(@"2.1_DidLoadSuccess")];
        }
    }];
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

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IDCMNewCurrencyTradingModel *model = [IDCMNewCurrencyTradingModel new];
    if (self.dataArr.count > 0) {
        model = self.dataArr[0];
    }
    
    if (indexPath.row == 4) {
        IDCMTradDetailDescriptionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:descriptionIdentifier];
        cell.textView.delegate = self;
        cell.model = model;
        return cell;
        
    }else{
        IDCMTradDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:infoIdentifier];
        [cell setDealModel:model WithRow:indexPath.row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrHeight[indexPath.row] floatValue];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - <QMUITextViewDelegate>

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    
    [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.1_Maximum")];
}
- (BOOL)textViewShouldReturn:(QMUITextView *)textView {
    [self.view endEditing:YES];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (![textView.text isNotBlank] && ![self.viewModel.dealModel.remark isNotBlank]) {
        return;
    }else{
        if (!self.viewModel.isGestuerEdit) {
            NSDictionary *dic = @{@"id":self.viewModel.dealModel.ID,
                                  @"tradeType":self.viewModel.dealModel.trade_type,
                                  @"content":[textView.text isNotBlank] ? textView.text : @"",
                                  @"currency":[self.viewModel.dealModel.currency lowercaseString]
                                  };
            [self.viewModel.editeCommand execute:dic];
        }
    }
    [self.view endEditing:YES];
}
#pragma mark - getter
- (IDCMTableView *)tableView
{
    return SW_LAZY(_tableView, ({
        
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTabBarHeight  - kSafeAreaBottom) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = self.detailHeaderView;
        tableView.backgroundColor = viewBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [tableView registerClass:[IDCMTradDetailInfoCell class] forCellReuseIdentifier:infoIdentifier];
        [tableView registerClass:[IDCMTradDetailDescriptionViewCell class] forCellReuseIdentifier:descriptionIdentifier];
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (IDCMTradDetailHeaderView *)detailHeaderView
{
    return SW_LAZY(_detailHeaderView, ({
        IDCMTradDetailHeaderView *view = [[IDCMTradDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 310)];
        view;
    }));
}
- (NSMutableArray *)dataArr
{
    return SW_LAZY(_dataArr, @[].mutableCopy);
}

- (void)dealloc{
    
    [self.requestDisposable dispose];
}
@end
