//
//  IDCMOptionalCoinController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/6/13.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOptionalCoinController.h"
#import "IDCMOptionalCoinViewModel.h"
#import "IDCMCurrencyMarketModel.h"
#import "IDCMAddCoinCell.h"


@interface IDCMOptionalCoinController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) IDCMTableView *tableView;
@property (nonatomic,strong) IDCMOptionalCoinViewModel *viewModel;
@end


@implementation IDCMOptionalCoinController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)refreshData {
    [self.viewModel.requestDataCommand execute:nil];
}

#pragma mark — supper method
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    // 监听币种列表信号
    [self.viewModel.requestDataCommand.executionSignals.switchToLatest
     subscribeNext:^(NSMutableArray *dataArr) {
         @strongify(self);
         [self.tableView reloadData];
         [IDCMTableViewAnimationKit
          showWithAnimationType:XSTableViewAnimationTypeToTop tableView:self.tableView];
     }];
}

- (void)addCoinRequest {
    NSMutableArray *array = @[].mutableCopy;
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(IDCMCurrencyMarketModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.sortIndex = @(idx+1);
        NSDictionary *dic = @{@"id":model.ID,
                              @"isShow":[NSNumber numberWithBool:model.isShow],
                              @"sortIndex":model.sortIndex};
        [array addObject:dic];
    }];
    [self.viewModel.addCoinCommand execute:array];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    self.view.backgroundColor = viewBackgroundColor;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return  self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    IDCMAddCoinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coinCell"
                                                            forIndexPath:indexPath];
    cell.makketModel = self.viewModel.dataArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.0f)];
    view.backgroundColor = viewBackgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-12, 30.0f)];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = SetColor(153, 153, 153);
    label.font = textFontPingFangRegularFont(12);
    label.text = SWLocaloziString(@"2.1_DragSort");
    [view addSubview:label];
    return view;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    IDCMCurrencyMarketModel *model = self.viewModel.dataArray[sourceIndexPath.row];
    [self.viewModel.dataArray removeObjectAtIndex:sourceIndexPath.row];
    [self.viewModel.dataArray insertObject:model atIndex:destinationIndexPath.row];
    
    [self addCoinRequest];
    [self.tableView reloadData];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - getters and setters
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
        [tableView setEditing:YES animated:NO];
        tableView.allowsSelectionDuringEditing = YES;
        [tableView registerClass:[IDCMAddCoinCell class] forCellReuseIdentifier:@"coinCell"];
        [self.view addSubview:tableView];
        tableView;
    }));
}
@end





