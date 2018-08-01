//
//  IDCMHomeViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMHomeViewController.h"
#import "IDCMCurrencyCell.h"
#import "IDCMAlertView.h"
#import "IDCMHomeHeaderView.h"
#import "IDCMHomeViewModel.h"
#import "IDCMAmountModel.h"
#import "IDCMCurrencyMarketModel.h"
#import "IDCMUserInfoModel.h"
#import "IDCMUserStateModel.h"
#import "IDCMNewsModel.h"
#import "IDCMHomeAmountView.h"

#import "IDCMBackupMemorizingWordsViewModel.h"
#import "IDCMBackupMemorizingWordsController.h"
#import "IDCMScanLoginQrCodeController.h"
#import "IDCMPCLoginViewController.h"


@interface IDCMHomeViewController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMHomeViewModel *viewModel;
/**
 *  设置
 */
@property (strong, nonatomic) UIButton *settingImageView;
/**
 *  信箱
 */
@property (strong, nonatomic) UIButton *messageButton;
/**
 *  扫一扫
 */
@property (strong, nonatomic) UIButton *scanButton;
/**
 *  币种列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 *  tableViewBindHelper
 */
@property (strong, nonatomic) IDCMTableViewBindHelper *tableViewBindHelper;
/**
 *  资产view
 */
@property (strong, nonatomic) IDCMHomeAmountView *amountView;
/**
 *  tableView的顶部视图
 */
@property (strong, nonatomic) IDCMHomeHeaderView *homeHederView;
/**
 *  amount字典
 */
@property (strong, nonatomic) NSDictionary *amountDic;
@end

static NSString *identifier = @"IDCMCurrencyCell";

@implementation IDCMHomeViewController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseView];
    [self setNavigationBar];
    [self creatLayoutSubviews];
    
    [IDCMHUD show];
    // 获取币种精度
    [self.viewModel.getCurrencyPrecisionCommand execute:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 刷新用户状态
    [self.viewModel.getUserSateCommand execute:nil];
    // 开始请求
    [self requestWalletListAndSevenDay];
}
- (void)creatLayoutSubviews
{
    [self.view addSubview:self.amountView];
    [self.amountView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(37);
    }];
    self.homeHederView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 260);
}

#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    
    // 绑定TableView
    self.tableViewBindHelper = [IDCMTableViewBindHelper bindingHelperForTableView:self.tableView
                                                                     sourceSignal:RACObserve(self.viewModel, walletListData)
                                                                 selectionCommand:self.viewModel.selectCommand
                                                                     templateCell:@"IDCMCurrencyCell"
                                                             tableviewConfigBlock:^(IDCMTableViewBindHelperConfig *configure) {

                                                                 configure.tableViewAnimationType(XSTableViewAnimationTypeAlpha);
                                                             }];
    // 绑定amountview
    self.amountView = [IDCMHomeAmountView bondSureViewWithAmountInput:RACObserve(self, amountDic)
                                                       addCoinCommand:^(id input) {
                                                           
                                                           [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMCurrencyPageController"
                                                                                                              withViewModelName:@"IDCMCurrencyPageViewModel"
                                                                                                                     withParams:nil];
                                                       }];

    // 消息内容
    [[[self.messageButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         
         [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMMessageViewController"
                                                            withViewModelName:@"IDCMMessageViewModel"
                                                                   withParams:nil];
     }];
    
    // 扫描二维码
    [[[self.scanButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self gotoSCanVc];
     }];

    // 监听七天金额数据以及行情走势数据
    [[self.viewModel.trendDataCommand.executionSignals.switchToLatest  deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         self.amountDic = response;
         self.homeHederView.data = response;
     }];
    // 钱包列表信号，行情走势信号都结束，结束刷新
    [[[[[RACSignal
         combineLatest:@[
                         self.viewModel.trendDataCommand.executing,
                         self.viewModel.walletListCommand.executing
                         ]]
        or]
       skipWhileBlock:^BOOL(NSNumber *loading) {
           return ![loading boolValue];
       }]
      distinctUntilChanged]
     subscribeNext:^(NSNumber *loading) {
         @strongify(self);
         if (!loading.boolValue) {
             [IDCMHUD dismiss];
             [self.tableView.headRefreshControl endRefreshing];
         }
     }];
    // 下拉刷新
    [self.tableView bindRefreshStyle:KafkaRefreshStyleReplicatorCircle
                           fillColor:UIColorWhite
             animatedBackgroundColor:UIColorClear
                          atPosition:KafkaRefreshPositionHeader refreshHanler:^{
                              
                              dispatch_main_async_safe(^{
                                  @strongify(self);
                                  // 开始钱包列表信号请求&&七天金额数据信号请求
                                  [self.viewModel cancelRefreshRequest];
                                  [self.viewModel.walletListCommand execute:nil];
                                  [self.viewModel.trendDataCommand execute:nil];
                              });
                          }];
  
    // 监听用户状态信号
    [[[self.viewModel.getUserSateCommand.executionSignals switchToLatest] deliverOnMainThread]
     subscribeNext:^(IDCMUserStateModel *model) {
         
         [IDCMUtilsMethod keyedArchiverWithObject:model withKey:UserStatusInfokey];
         if ([model.wallet_phrase isEqualToString:@"0"]) {
             // 未备份
             NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:UnlockKey];
             IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];

             IDCMAlertView *backupView = [IDCMAlertView sharedCheckManager];
             backupView.alertViewBlock = ^{
                 // 去备份
                 if ([dataDic count]>0) {
                     [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                         if ([userModel.user_name isEqualToString:key]) {
                             [dataDic setObject:@(0) forKey:userModel.user_name];
                             [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:UnlockKey];
                         }else{
                             [dataDic setObject:@(0) forKey:key];
                             [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:UnlockKey];
                         }
                     }];
                 }else{
                     NSMutableDictionary *dic = @{}.mutableCopy;
                     [dic setObject:@(0) forKey:userModel.user_name];
                     [IDCMUtilsMethod keyedArchiverWithObject:dic withKey:UnlockKey];
                 }
                 
                 @strongify(self);
                 IDCMBackupMemorizingWordsViewModel *viewModel = [[IDCMBackupMemorizingWordsViewModel alloc] initWithParams:@{@"backupType":@(1)}];
                 IDCMBackupMemorizingWordsController *vc = [[IDCMBackupMemorizingWordsController alloc] initWithViewModel:viewModel];
                 [self.navigationController pushViewController:vc animated:YES];
             };
             backupView.dismissBlock = ^{
                 // 下次再说
                 if ([dataDic count]>0) {
                     [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                         if ([userModel.user_name isEqualToString:key]) {
                             [dataDic setObject:@(0) forKey:userModel.user_name];
                             [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:UnlockKey];
                         }else{
                             [dataDic setObject:@(0) forKey:key];
                             [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:UnlockKey];
                         }
                     }];
                 }else{
                     NSMutableDictionary *dic = @{}.mutableCopy;
                     [dic setObject:@(0) forKey:userModel.user_name];
                     [IDCMUtilsMethod keyedArchiverWithObject:dic withKey:UnlockKey];
                 }
             };
             
             if ([dataDic count]>0) {
                 BOOL __block isHaveUser = NO;
                 // 判断是否存储了这个用户
                 [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                     if ([userModel.user_name isEqualToString:key]) {
                         isHaveUser = YES;
                     }
                 }];
                 if (!isHaveUser) {
                     [dataDic setObject:@(0) forKey:userModel.user_name];
                     [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:UnlockKey];
                     [backupView showViewWithType:IDCMShowNotBackups];
                 }else{
                     [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                         
                         if ([userModel.user_name isEqualToString:key]) {
                             if ([obj isEqualToNumber:@(10)]) {
                                 [backupView showViewWithType:IDCMShowNotBackups];
                                 [dataDic setObject:@(0) forKey:userModel.user_name];
                                 [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:UnlockKey];
                             }
                         }else{
                             [dataDic setObject:@(0) forKey:key];
                             [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:UnlockKey];
                         }
                     }];
                 }
                 
             }else{
                 NSMutableDictionary *dic = @{}.mutableCopy;
                 [dic setObject:@(0) forKey:userModel.user_name];
                 [IDCMUtilsMethod keyedArchiverWithObject:dic withKey:UnlockKey];
                 [backupView showViewWithType:IDCMShowNotBackups];
             }
         }
     }];
    
    // 获取最新消息
    [[[self.viewModel.getNewMessageCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         IDCMNewsModel *model = [IDCMNewsModel yy_modelWithDictionary:response[@"data"]];
         @strongify(self);
         switch ([model.msgType integerValue]) {
             case 1:
             case 2:
             {
                 if (!self.viewModel.isActive) {
                     self.viewModel.isActive = YES;
                     [self updateHomeHeadrViewConstraints:YES];
                     self.homeHederView.marqueeDismissBlock = ^(IDCMMarqueeDismissType type) {
                         @strongify(self);
                         if ([model.contentUrl isNotBlank]) { // 有跳转URL
                             
                             if (type == IDCMMarqueeDismissClose) { // 点击关闭按钮
                                 
                                 [self.viewModel.confirmReadCommand execute:model.ID];
                                 
                             }else if (type == IDCMSMarqueeDismissPush){ // 点击横幅
                                 
                                 [self.viewModel.confirmReadCommand execute:model.ID];
                                 
                                 [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMWebViewController" withViewModelName:@"IDCMWebViewModel" withParams: @{@"requestURL":model.contentUrl}];
                             }
                             self.viewModel.isActive = NO;
                             [self updateHomeHeadrViewConstraints:NO];
                             
                         }else{ // 没有跳转URL
                             
                             if (type == IDCMMarqueeDismissClose) { // 点击关闭按钮
                                 [self.viewModel.confirmReadCommand execute:model.ID];
                                 self.viewModel.isActive = NO;
                                 [self updateHomeHeadrViewConstraints:NO];
                             }
                         }
                         
                     };
                 }
                 self.homeHederView.newsModel = model;
             }
                 break;
             case 3:
             {
                 if (!self.viewModel.isActive) {
                     self.viewModel.isActive = YES;
                     [IDCMActionTipsView showWithConfigure:^(IDCMActionTipViewConfigure *configure) {
                         
                         configure.title(model.msgTitle).subTitle(model.msgContent);
                         // 点击取消
                         configure
                         .getBtnsConfig
                         .firstObject
                         .btnTitle(model.leftButtonTxt)
                         .btnCallback(^{
                             @strongify(self);
                             [self.viewModel.confirmReadCommand execute:model.ID];
                             if ([model.leftButtonJump isEqualToString:@"1"]) {
                                 
                                 [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMWebViewController" withViewModelName:@"IDCMWebViewModel" withParams: @{@"requestURL":model.contentUrl,@"title":[model.msgTitle isNotBlank] ? model.msgTitle : @""}];
                             }
                             self.viewModel.isActive = NO;
                         });
                         // 点击确定
                         configure
                         .getBtnsConfig
                         .lastObject
                         .btnTitle(model.rightButtonTxt)
                         .btnCallback(^{
                             @strongify(self);
                             [self.viewModel.confirmReadCommand execute:model.ID];
                             NSDictionary *para = @{@"msgId":model.ID,@"origCurrency":model.origCurrency,@"receiveCurrency":model.receiveCurrency};
                             [self.viewModel.getCoinCommand execute:para];
                             self.viewModel.isActive = NO;
                         });
                     }];
                 }
             }
                 break;
             default:
                 break;
         }
     }];
    
    // 开始最新消息请求
    [self.viewModel.getNewMessageCommand execute:nil];
    // 五分钟轮询一次
    [[[RACSignal interval:300 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        [self.viewModel.getNewMessageCommand execute:nil];
    }];
    
    // 监听领币
    [[[self.viewModel.getCoinCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         
         [IDCMActionTipsView showWithConfigure:^(IDCMActionTipViewConfigure *configure) {
             
             [configure.getBtnsConfig removeFirstObject];
             configure.title(SWLocaloziString(@"2.0_gongxi")).subTitle(SWLocaloziString(@"2.0_gongxiContent"));
             configure
             .getBtnsConfig
             .lastObject
             .btnTitle(SWLocaloziString(@"2.0_gongxiButton"));
         }];
     }];
    
    // 监听scorllview滑动距离
    [[RACObserve(self.tableView, contentOffset) distinctUntilChanged] subscribeNext:^(id x) {
        
        @strongify(self);
        CGFloat offsetY = self.tableView.contentOffset.y;
        if (offsetY <= 0.0) {
            //下拉
            self.amountView.alpha = 0.0;
            self.homeHederView.addCoin.alpha = 1;
        }else{
            
            if(fabs(offsetY) > 30){
                self.amountView.alpha = 1;
                self.homeHederView.addCoin.alpha = 0.0;
            }else{
                self.amountView.alpha = 0.0;
                self.homeHederView.addCoin.alpha = 1;
            }
        }
    }];
}

- (void)gotoSCanVc {
    @weakify(self);
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        @strongify(self);
        if (granted) {
            IDCMScanLoginQrCodeController *scanVC= [IDCMScanLoginQrCodeController new];
            scanVC.libraryType = SLT_Native;
            scanVC.scanCodeType = SCT_QRCode;
            CGFloat offset = ((SCREEN_HEIGHT - (kSafeAreaTop + kNavigationBarHeight)) / 2) - (80 + 130);
            scanVC.style = [IDCMUtilsMethod  scanStyleWith:offset andWithBorderColor:UIColorMakeWithHex(@"3B9BFC")];
            scanVC.isNeedScanImage = NO;
            scanVC.scanQRCodeBlock = ^(NSString *clientId) {
                
                [[IDCMMediatorAction sharedInstance] presentViewControllerWithClassName:@"IDCMPCLoginViewController" withViewModelName:@"IDCMPCLoginViewModel" withParams:@{@"clientId" : clientId} animated:YES];
            };
            [self.navigationController pushViewController:scanVC animated:YES];
            
        }else if(!firstTime){
            [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.1_OpenCamerPermissions") message:SWLocaloziString(@"2.1_SetCamerPermissionsTips") buttonArray:@[SWLocaloziString(@"2.1_SetCamerPermissions"),SWLocaloziString(@"2.0_Cancel")] actionBlock:^(NSInteger clickIndex) {
                if (clickIndex ==0) {
                    // 跳转至设置界面
                    [LBXPermissionSetting displayAppPrivacySettings];
                }
            }];
            
        }
    }];
}
- (void)requestWalletListAndSevenDay
{
    // 开始钱包列表信号请求 && 七天金额数据信号请求
    [self.viewModel.walletListCommand execute:nil];
    [self.viewModel.trendDataCommand execute:nil];
}
#pragma mark - setView
- (void)configBaseView
{
    self.view.backgroundColor = UIColorWhite;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self tableView];
    }
    
    [self.view bringSubviewToFront:self.amountView];
}
- (void)setNavigationBar
{
    
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    self.navigationItem.title = model.user_name;
    
    UIView *rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    [rightBarView addSubview:self.messageButton];
    [rightBarView addSubview:self.scanButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarView];
    
    UIView *leftBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65, 16)];
    [leftBarView addSubview:self.settingImageView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)updateHomeHeadrViewConstraints:(BOOL)isShow
{
    self.homeHederView.isShowLabel = isShow;
    if (isShow) {
        self.homeHederView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
    }else{
        self.homeHederView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 260);
    }
    [self.tableView layoutIfNeeded];
    [self.tableView setTableHeaderView:self.homeHederView];
}

#pragma mark - getter
- (UIButton *)settingImageView
{
    return SW_LAZY(_settingImageView, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIImageMake(@"2.1_HomeLogo") forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.frame = CGRectMake(0, 0, 65, 16);
        button;
    }));
}
- (UIButton *)messageButton
{
    return SW_LAZY(_messageButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIImageMake(@"2.1_xinxiang") forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.frame = CGRectMake(35, 0, 22, 22);
        button;
    }));
}
- (UIButton *)scanButton
{
    return SW_LAZY(_scanButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIImageMake(@"2.2.3_ScanLogo") forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.frame = CGRectMake(0, 0, 22, 22);
        button;
    }));
}
- (IDCMHomeHeaderView *)homeHederView
{
    return SW_LAZY(_homeHederView, ({
        IDCMHomeHeaderView *view = [[IDCMHomeHeaderView alloc] init];
        view;
    }));
}
- (IDCMTableView *)tableView
{
    return SW_LAZY(_tableView, ({
        
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTabBarHeight  - kSafeAreaBottom-kNavigationBarHeight-kSafeAreaTop) style:UITableViewStylePlain];
        tableView.rowHeight = 60.0f;
        tableView.tableHeaderView = self.homeHederView;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.backgroundColor = kThemeColor;
        [tableView insertSubview:view atIndex:0];
        tableView;
    }));
}

#pragma mark - statyle
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
