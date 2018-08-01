//
//  IDCMAcountSafeController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/27.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMAcountSafeController
// @abstract 账户与安全
// @discussion 账户安全
//
#import "IDCMAcountSafeController.h"
#import "IDCMAcountSafeViewModel.h"
#import "IDCMLogOutCell.h"
#import "IDCMAcountSafeViewCell.h"
@interface IDCMAcountSafeController ()<UITableViewDelegate, UITableViewDataSource>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMAcountSafeViewModel *viewModel;
/**
 *  消息列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;

@end

@implementation IDCMAcountSafeController
@dynamic viewModel;


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    self.navigationItem.title = SWLocaloziString(@"2.2.3_AcountSafe");
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
#pragma mark - Bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    
}

#pragma mark - Public Methods


#pragma mark - Privater Methods


#pragma mark - Action


#pragma mark - NetWork


#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        
        IDCMLogOutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCMLogOutCell"];
        return cell;
    }else{
        IDCMAcountSafeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCMAcountSafeViewCell"];
        if ((indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 1 && indexPath.row == 1)) {
            cell.line.hidden = YES;
            
        }else{
            cell.line.hidden = NO;
        }
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.arrow.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.arrow.hidden = NO;
        }
        cell.acountModel = [self.viewModel getSettingListArray][indexPath.section][indexPath.row];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        
        [IDCMUtilsMethod logoutWallet];
        
    }else{
        
        IDCMAcountSafeListModel *model = [self.viewModel getSettingListArray][indexPath.section][indexPath.row];
        [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:model.classString withViewModelName:model.viewModel withParams:@{@"type":model.status,@"backupType":@(1)}];
    }
    
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    view.backgroundColor = viewBackgroundColor;
    return view;
    
}

#pragma mark - Getter & Setter
- (IDCMTableView *)tableView
{
    return SW_LAZY(_tableView, ({
        
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight-kSafeAreaTop) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 44.0f;
        tableView.sectionFooterHeight = 0;
        tableView.sectionHeaderHeight = 15;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = viewBackgroundColor;
        [tableView registerClass:[IDCMAcountSafeViewCell class] forCellReuseIdentifier:@"IDCMAcountSafeViewCell"];
        [tableView registerClass:[IDCMLogOutCell class] forCellReuseIdentifier:@"IDCMLogOutCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:tableView];
        tableView;
    }));
}
@end
