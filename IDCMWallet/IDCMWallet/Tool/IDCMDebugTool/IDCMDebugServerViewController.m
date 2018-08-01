//
//  IDCMDebugServerViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMDebugServerViewController.h"
#import "IDCMDebugServerViewModel.h"
#import "IDCMDebugServerViewCell.h"

@interface IDCMDebugServerViewController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMDebugServerViewModel *viewModel;
/**
 *  UITableView
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 *  tableViewBindHelper
 */
@property (strong, nonatomic) IDCMTableViewBindHelper *tableViewBindHelper;
/**
 *  提示语
 */
@property (nonatomic,strong) UILabel *tipLabel;
@end

@implementation IDCMDebugServerViewController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30-kSafeAreaBottom);
    }];
}
#pragma mark - Bind
- (void)bindViewModel{
    [super bindViewModel];
    
    // 绑定tableView
    self.tableViewBindHelper = [IDCMTableViewBindHelper bindingHelperForTableView:self.tableView
                                                                     sourceSignal:self.viewModel.dataSignal
                                                                 selectionCommand:self.viewModel.selectCommand
                                                                     templateCell:@"IDCMDebugServerViewCell"];
    
    // 点击事件
    [[self.viewModel.selectCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(RACTuple *tupe) {
         
         NSString *str = [CommonUtils getStrValueInUDWithKey:DebugSetServerAddKey];
         if (![str isEqualToString:tupe.third]) {
             // 清空保存的PIN
             [IDCMUtilsMethod keyedArchiverWithObject:@{}.mutableCopy withKey:FaceIDOrTouchIDKey];
             // 置为非登录
             [CommonUtils saveBoolValueInUD:NO forKey:IsLoginkey];
             // 清空用户信息
             IDCMUserInfoModel *userModel = [[IDCMUserInfoModel alloc] init];
             [IDCMUtilsMethod keyedArchiverWithObject:userModel withKey:UserModelArchiverkey];
             // 清空用户状态信息
             IDCMUserStateModel *statusModel = [[IDCMUserStateModel alloc] init];
             [IDCMUtilsMethod keyedArchiverWithObject:statusModel withKey:UserStatusInfokey];
             // 保存设置的环境
             [CommonUtils saveStrValueInUD:tupe.third forKey:DebugSetServerAddKey];
             // 重启APP
             assert(0);
         }
     }];
}
#pragma mark - Getter & Setter
- (IDCMTableView *)tableView{
    
    return SW_LAZY(_tableView, ({
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kSafeAreaTop-kNavigationBarHeight) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = UIColorWhite;
        tableView.rowHeight = 50;
        tableView.tableFooterView = [UIView new];
        [self.view addSubview:tableView];
        tableView;
    }));
}

- (UILabel *)tipLabel
{
    return SW_LAZY(_tipLabel, ({
        UILabel *view = [UILabel new];
        view.backgroundColor = [UIColor clearColor];
        view.textColor = SetColor(153, 153, 153);
        view.textAlignment = NSTextAlignmentCenter;
        view.text = @"切换环境需要重启APP，需要重新输入助记词";
        view.numberOfLines = 0;
        view.font = SetFont(@"PingFang-SC-Regular", 15);
        [self.view addSubview:view];
        view;
    }));
}
@end
