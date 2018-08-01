//
//  IDCMSettingController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/13.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSettingController.h"
#import "IDCMSettingsViewModel.h"
#import "IDCMSettingMenueListCell.h"


@interface IDCMSettingController ()<UITableViewDelegate, UITableViewDataSource>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMSettingsViewModel *viewModel;
/**
 *  消息列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;

@property (nonatomic,strong) UIButton *checkUpdate;
@property (nonatomic,strong) UILabel *versionLabel;
@end

@implementation IDCMSettingController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    self.navigationItem.title = NSLocalizedString(@"2.2.3_Me", nil);

}
- (void)bindViewModel
{
    [super bindViewModel];
    
    [self configView];
    
    @weakify(self);
    [[[self.checkUpdate rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         self.checkUpdate.enabled = NO;
         [self.viewModel.checkUpdateCommand execute:nil];
     }];
    
    // 监听检查版本更新接口
    [[self.viewModel.checkUpdateCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         [IDCMUtilsMethod checkVersonWithResponse:response withType:@"1"];
     }];
    
    // 监听检查版本更新接口是否结束
    [[self.viewModel.checkUpdateCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            self.checkUpdate.enabled = YES;
        }
    }];
    
    //承兑商状态 支付方式
    [[self.viewModel.getStatecommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(id  _Nullable x) {
         @strongify(self);
         [self.tableView reloadData];
     }];
    
    // 邀请链配置
    [[self.viewModel.requestDataCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(id  _Nullable x) {
         @strongify(self);
         [self.tableView reloadData];
     }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![CommonUtils getBoolValueInUDWithKey:ControlHiddenKey]) { // 关闭交易、DApp模块时不请求承兑商状态
        [self.viewModel.getStatecommand execute:nil];
    }
    [self.viewModel.requestDataCommand execute:nil];
}

- (void)configView
{
    [self tableView];
    
    if ([[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey]) {  // 企业分发
        
        [self.checkUpdate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.equalTo(@25);
            make.width.greaterThanOrEqualTo(@120);
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        }];
        
        [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@17);
            make.bottom.equalTo(self.checkUpdate.mas_top).offset(-10);
        }];
        
    }else{  // App Store
        
    
        [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@17);
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        }];
    }
    
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel getSettingListArray].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *arr = [self.viewModel getSettingListArray][section];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDCMSettingMenueListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCMSettingMenueListCell"];
    
    NSArray *arr = [self.viewModel getSettingListArray][indexPath.section];
    if (indexPath.row == (arr.count-1)) {
        cell.line.hidden = YES;
    }else{
        cell.line.hidden = NO;
    }
    IDCMSettingListModel *model = [self.viewModel getSettingListArray][indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    
    if (indexPath.section == 1 && indexPath.row == 1 && ![userModel.mobile isNotBlank]) { // 承兑商未设置手机号
        
        
        [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
            
            configure.getBtnsConfig.firstObject.btnTitle(SWLocaloziString(@"3.0_DK_otcBindLater"));
            configure.getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_DK_otcGoBind")).btnCallback(^{
                
                [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMBindMobileController"
                                                                   withViewModelName:@"IDCMBindMobileViewModel"
                                                                          withParams:@{@"type":@0}
                                                                            animated:YES];
                
            });
            configure.title(SWLocaloziString(@"3.0_DK_otcGoBindTitle"));
        }];
        
        return;
    }
    
    IDCMSettingListModel *model = [self.viewModel getSettingListArray][indexPath.section][indexPath.row];
    [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:model.classString
                                                       withViewModelName:model.viewModel
                                                              withParams:@{@"WebLink":[self.viewModel.webLink isNotBlank] ? self.viewModel.webLink : @""}];
    

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    view.backgroundColor = viewBackgroundColor;
    return view;
    
}
#pragma mark - getter
- (IDCMTableView *)tableView
{
    return SW_LAZY(_tableView, ({
        
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight-kSafeAreaTop-kSafeAreaBottom-kTabBarHeight) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 44.0f;
        tableView.sectionFooterHeight = 0;
        tableView.sectionHeaderHeight = 15;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = viewBackgroundColor;
        [tableView registerClass:[IDCMSettingMenueListCell class] forCellReuseIdentifier:@"IDCMSettingMenueListCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (UIButton *)checkUpdate
{
    return SW_LAZY(_checkUpdate, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 12);
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = kThemeColor.CGColor;
        button.layer.borderWidth = 0.5;
        [button setTitle:SWLocaloziString(@"2.1_CheckUpdate") forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [button setTitleColor:UIColorWhite forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:kThemeColor size:CGSizeMake(120, 25)] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:viewBackgroundColor size:CGSizeMake(120, 25)] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
}
- (UILabel *)versionLabel
{
    return SW_LAZY(_versionLabel, ({
        UILabel *view = [UILabel new];
        view.backgroundColor = [UIColor clearColor];
        view.textColor = SetColor(153, 153, 153);
        view.textAlignment = NSTextAlignmentCenter;
        view.text = [NSString stringWithFormat:@"%@ %@",SWLocaloziString(@"2.1_app_version"),[CommonUtils getAppVersion]];
        view.font = SetFont(@"PingFang-SC-Regular", 12);
        [self.view addSubview:view];
        view;
    }));
}

@end
