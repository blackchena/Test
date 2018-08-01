//
//  IDCMAcceptantMarginManageController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/4/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantMarginManageController.h"
#import "IDCMAcceptantMarginManageViewModel.h"
#import "IDCMAcceptantMarginManageCell.h"

@interface IDCMAcceptantMarginManageController ()<UITableViewDataSource, UITableViewDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMAcceptantMarginManageViewModel *viewModel;
/**
 *  币种列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 *  提取保证金按钮
 */
@property (strong, nonatomic) UIButton *pickUpButton;
/**
 *  数据源
 */
@property (strong, nonatomic) NSMutableArray *dataArr;
@end

static NSString *identifier = @"IDCMAcceptantMarginManageCell";

@implementation IDCMAcceptantMarginManageController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
}
#pragma mark - Bind
- (void)bindViewModel{
    [super bindViewModel];

    [self initView];
    @weakify(self);
    // 提取保证金
    [[[self.pickUpButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
        [self.viewModel.CheckWithdrawCommand execute:nil];

     }];
    
    
    [self.viewModel.GetOtcAcceptantInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id  _Nullable x) {
        
    }];
    

    
    [[RACObserve(self.viewModel, DepositList) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.viewModel.SetPaySequenceCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id  _Nullable x) {
        
    }];

    
    [self.viewModel.CheckWithdrawCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSNumber * x) {
        if (x.boolValue == YES) {
            [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMAcceptantPickupBondController"
                                                   withViewModelName:@"IDCMAcceptantPickupBondViewModel"
                                                          withParams:nil
                                                            animated:YES];
        }
        else{
            [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                [configure.getBtnsConfig removeFirstObject];
                configure.
                title(SWLocaloziString(@"3.0_AcceptantCashDepositOutTips")).
                getBtnsConfig.
                lastObject.
                btnTitle(SWLocaloziString(@"2.0_gongxiButton"));
            }];
        }
    }];
}

#pragma mark - Public Methods
- (void)initData
{
    self.view.backgroundColor = viewBackgroundColor;
    self.navigationItem.title = SWLocaloziString(@"3.0_AcceptantCashDepositManage");
    [self.viewModel.GetOtcAcceptantInfoCommand execute:nil];
}
- (void)initView
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.pickUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottom-65);
        make.height.equalTo(@40);
    }];
}
#pragma mark - Privater Methods


#pragma mark - Action


#pragma mark - NetWork


#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.DepositList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IDCMAcceptantMarginManageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (self.viewModel.DepositList.count > 0 ) {
        IDCMAcceptMarginManageModel *model = [self.viewModel.DepositList objectAtIndex:indexPath.row];
        cell.marginModel = model;

        if (indexPath.row == self.viewModel.DepositList.count - 1) {
            cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
        }
        else{
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IDCMAcceptMarginManageModel *model = [self.viewModel.DepositList objectAtIndex:indexPath.row];
    NSString *coinId = [model.CoinId isNotBlank] ? model.CoinId : @"";
    NSString *coinCode = [model.CoinCode isNotBlank] ? model.CoinCode : @"";

    [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMAcceptantBondWaterController"
                                           withViewModelName:@"IDCMAcceptantBondWaterViewModel"
                                                  withParams:@{@"CoinId":coinId,
                                                               @"CoinCode":coinCode,
                                                               @"JumpType":@"1"}
                                                    animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGRect labelHeight  = [SWLocaloziString(@"3.0_AcceptantCashDepositManageTips") boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFontPingFangRegularFont(12)} context:nil];
    CGFloat diff = labelHeight.size.height -17;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f + diff)];
    view.backgroundColor = viewBackgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f + diff)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor999999;
    label.numberOfLines = 0;
    label.font = textFontPingFangRegularFont(12);
    label.text = SWLocaloziString(@"3.0_AcceptantCashDepositManageTips");
    [view addSubview:label];
    return view;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGRect labelHeight  = [SWLocaloziString(@"3.0_AcceptantCashDepositManageTips") boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFontPingFangRegularFont(12)} context:nil];
    CGFloat diff = labelHeight.size.height -17;
    return 40 + diff;
    
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return self.viewModel.DepositList.count > 1;
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.row == destinationIndexPath.row && sourceIndexPath.section== destinationIndexPath.section ) {
        return;
    }
    
    NSMutableArray *tableMArr = [[NSMutableArray alloc] initWithArray:self.viewModel.DepositList];
    IDCMAcceptMarginManageModel *model = self.viewModel.DepositList[sourceIndexPath.row];
    [tableMArr removeObjectAtIndex:sourceIndexPath.row];
    [tableMArr insertObject:model atIndex:destinationIndexPath.row];
    
    self.viewModel.DepositList = tableMArr;
    
    [self.viewModel.SetPaySequenceCommand execute:nil];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleNone;
}

#pragma mark - Getter & Setter
- (IDCMTableView *)tableView
{
    return SW_LAZY(_tableView, ({
        
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight - kSafeAreaTop) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundColor = viewBackgroundColor;
        tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
        tableView.rowHeight = 60.0f;
        [tableView setEditing:YES animated:NO];
        tableView.allowsSelectionDuringEditing = YES;
        [tableView registerClass:[IDCMAcceptantMarginManageCell class] forCellReuseIdentifier:identifier];
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (UIButton *)pickUpButton
{
    return SW_LAZY(_pickUpButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = textFontPingFangRegularFont(16);
        [button setBackgroundColor:kThemeColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:SWLocaloziString(@"3.0_AcceptantPickUpBond") forState:UIControlStateNormal];
        [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
}
- (NSMutableArray *)dataArr
{
    return SW_LAZY(_dataArr, @[].mutableCopy);
}


@end
