//
//  IDCMOTCExchangeRecordController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//


#import "IDCMOTCExchangeRecordController.h"
#import "IDCMOTCExchangeRecordViewModel.h"
#import "IDCMNowTimeExhangeRecordView.h"
#import "IDCMOTCExchangeRecordCell.h"
#import "IDCMOTCExchangeController.h"
#import "IDCMFlashRecordEmtyCell.h"
#import "IDCMOTCExchangeSellCurrencyViewModel.h"
#import "IDCMOTCSignalRTool.h"
#import "IDCMOTCExchangeRecordModel.h"
#import "IDCMPTCConfirmQuoteOrderModel.h"
#import "IDCMBlockBaseTableView.h"
#import "IDCMCountDotView.h"
#import "IDCMConfigBaseNavigationController.h"
#import "IDCMTradingPageViewController.h"


@interface IDCMOTCExchangeRecordController ()
@property (nonatomic, assign) RACDisposable *orderStatusChangeDisposable;
@property (nonatomic, assign) RACDisposable *confirmQuoteOrderDisposable;
@property (nonatomic,strong) IDCMOTCExchangeRecordViewModel *viewModel;
@property (nonatomic,weak)   IDCMOTCExchangeController *exchangeVx;
@property (nonatomic,strong) IDCMBlockBaseTableView *tableView;
@property (nonatomic,strong) UIView *sectionHeaderView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,assign) BOOL isFetch;
@end


@implementation IDCMOTCExchangeRecordController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
    [self.viewModel.tableViewExecuteCommand(0) execute:nil];
}

-(void)dealloc {
    [self.orderStatusChangeDisposable dispose];
    [self.confirmQuoteOrderDisposable dispose];
}

- (void)refreshRecord {
    [[RACScheduler mainThreadScheduler] afterDelay:.1 schedule:^{
        [self.tableView setContentOffset:CGPointZero animated:NO];
        [self.tableView.headRefreshControl beginRefreshing];
    }];
}

#pragma mark — supper methods
- (void)bindViewModel {
    [super bindViewModel]; 
    @weakify(self);
    self.exchangeVx.subject = [RACSubject subject];
    [self.exchangeVx.subject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.viewModel.tableViewExecuteCommand(1) execute:nil];
    }];
    
    //订单状态变更通知到承兑商
    self.orderStatusChangeDisposable = [[[IDCMOTCSignalRTool sharedOTCSignal].otcOrderStatusChangeSubject deliverOnMainThread] subscribeNext:^(NSDictionary *response) {
        @strongify(self);
        [self.viewModel.tableViewExecuteCommand(1) execute:nil];
    }];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
    [self configPushService];
}

#pragma mark — 承兑商和用户的推送服务
-(void)configPushService {
    
    UIView *superView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    IDCMNowTimeExhangeRecordView *view = [superView viewWithTag:77888];
    if(view){
        [self configAcceptant];
        return;
    }
    
    @weakify(self);
    [[self.viewModel.commandGetState.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary * response) {
        
        NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            NSString *statusCode = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"Status"]];
            if ([statusCode integerValue] ==  3) { //是承兑商
                UIView *superView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
                IDCMNowTimeExhangeRecordView *view = [[IDCMNowTimeExhangeRecordView alloc]init];
                view.tag = 77888;
                view.frame = [UIScreen mainScreen].bounds;
                [superView addSubview:view];
//                [[view.countSignal  deliverOnMainThread] subscribeNext:^(NSString *text) {
//                    @strongify(self);
//                    if ([self cyl_tabBarController].viewControllers.count > 2) {
//                        IDCMConfigBaseNavigationController *vc = (IDCMConfigBaseNavigationController *)[self cyl_tabBarController].viewControllers[1];
//                        if([vc.qmui_rootViewController isKindOfClass:[IDCMTradingPageViewController class]]){
//                            IDCMTradingPageViewController *vcPage = (IDCMTradingPageViewController *)vc.qmui_rootViewController;
//                            if ([text isEqualToString:@"0"]) {
//                                [vcPage cyl_removeTabBadgePoint];
//                                [vcPage.idcw_navigationBar removeTabBadgePoint];
//                            }
//                            else {
//                                [vcPage cyl_showTabBadgePoint];
//                                [vcPage.idcw_navigationBar showTabBadgePoint];
//                            }
//                        }
//                    }
//                }];
                @strongify(self);
                [self configAcceptant];
                return ;
            }
        }
        
        return ;
    }];
    
    [self.viewModel.commandGetState execute:nil];
}

- (void)configAcceptant{
    UIView *superView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    IDCMNowTimeExhangeRecordView *view = [superView viewWithTag:77888];
    if(!view){
        return;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 75, 0);
    
    @weakify(self);
    [[view.countSignal  deliverOnMainThread] subscribeNext:^(NSString *text) {
        @strongify(self);
        if ([self cyl_tabBarController].viewControllers.count > 2) {
            IDCMConfigBaseNavigationController *vc = (IDCMConfigBaseNavigationController *)[self cyl_tabBarController].viewControllers[1];
            if([vc.qmui_rootViewController isKindOfClass:[IDCMTradingPageViewController class]]){
                IDCMTradingPageViewController *vcPage = (IDCMTradingPageViewController *)vc.qmui_rootViewController;
                if ([text isEqualToString:@"0"]) {
                    [vcPage cyl_removeTabBadgePoint];
                    [vcPage.idcw_navigationBar removeTabBadgePoint];
                }
                else {
                    [vcPage cyl_showTabBadgePoint];
                    [vcPage.idcw_navigationBar showTabBadgePoint];
                }
            }
        }
    }];
    IDCMConfigBaseNavigationController *vc = (IDCMConfigBaseNavigationController *)[self cyl_tabBarController].viewControllers[1];
    if([vc.qmui_rootViewController isKindOfClass:[IDCMTradingPageViewController class]]){
        IDCMTradingPageViewController *vcPage = (IDCMTradingPageViewController *)vc.qmui_rootViewController;
        if ([[view getCountString] isEqualToString:@"0"]) {
            [vcPage cyl_removeTabBadgePoint];
            [vcPage.idcw_navigationBar removeTabBadgePoint];
        }
        else {
            [vcPage cyl_showTabBadgePoint];
            [vcPage.idcw_navigationBar showTabBadgePoint];
        }
    }
    
    //(用户确认报价推送到承兑商) 需要刷新自己是承兑商  是自己的单
   self.confirmQuoteOrderDisposable = [[[IDCMOTCSignalRTool sharedOTCSignal].confirmQuoteOrderSubject deliverOnMainThread] subscribeNext:^(NSDictionary *response) {
//        {
//            OrderId = 973;
//            AcceptantUserId = 4284;
//            QuoteOrderId = 4590
//        }
        @strongify(self);
        @synchronized(self) {
            IDCMPTCConfirmQuoteOrderModel *model = [IDCMPTCConfirmQuoteOrderModel yy_modelWithJSON:response];
            if (!model) {
                return ;
            }
            NSInteger acceptantUserId = model.AcceptantUserId;
            if(acceptantUserId == 0){
                return;
            }
            if ([[IDCMDataManager sharedDataManager].userID integerValue] == acceptantUserId) {
                [self.tableView.headRefreshControl beginRefreshing];
            }
        }
    }];
    
    @weakify(view);
    CGPoint point = CGPointMake(SCREEN_WIDTH - 66 - 12, SCREEN_HEIGHT- kSafeAreaTop - kNavigationBarHeight - 6 - 49 - kSafeAreaBottom - 68);
    IDCMCountDotView *dotView =
    [IDCMCountDotView countDotViewWithOrigin:point
                                 imageRadius:33
                                   dotRadius:9
                                   dotMargin:-12
                                    dotAngle:45
                                       image:UIImageMake(@"3.2_Bin_AcceptanceButton")
                                    countStr:[view getCountString]
                                   countFont:nil
                                  countColor:nil
                                dotBackColor:nil
                               clickCallback:^(id input) {
                                   if(self.isFetch){
                                       return;
                                   }
                                   @strongify(view);
                                   if ([view isEmpty]) {
                                       NSString *title = SWLocaloziString(@"3.0_JWRecord_NoUserBuySell");
                                       [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                                           [configure.getBtnsConfig removeFirstObject];
                                           configure
                                           .image(@"3.2_操作台-零承兑商")
                                           .title(title)
                                           .subTitle(nil)
                                           .getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_JWRecord_IKown")).btnCallback(^{
                                               @strongify(self);
                                               [self.navigationController popViewControllerAnimated:YES];
                                           });
                                       }];
                                       return ;
                                   }
                                   self.isFetch = YES;
                                   [view fetchHisCallback:^{
                                       self.isFetch = NO;
                                       if ([view isEmpty]) {
                                           NSString *title = SWLocaloziString(@"3.0_JWRecord_NoUserBuySell");
                                           //  NSString *subTitle = self.datas.count == 0 ? @"很遗憾没有承兑商报价" : @"很遗憾你未做出选择";
                                           [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                                               [configure.getBtnsConfig removeFirstObject];
                                               configure
                                               .image(@"3.2_操作台-零承兑商")
                                               .title(title)
                                               .subTitle(nil)
                                               .getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_JWRecord_IKown")).btnCallback(^{
                                                   @strongify(self);
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               });
                                           }];
                                           return ;
                                       }
                                       [view showWithDismissCallback:nil];
                                   }];
                               }];
    [dotView bindCountSignal:view.countSignal];
    [self.view addSubview:dotView];
}

#pragma mark — 配置UI相关
- (void)configUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - getters and setters
- (IDCMBlockBaseTableView *)tableView {
    return SW_LAZY(_tableView, ({
        
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - kStatusBarDifferHeight - 49 - kSafeAreaBottom);
        IDCMBlockBaseTableView *tableView =
        [IDCMBlockBaseTableView tableViewWithFrame:rect
                                             style:UITableViewStylePlain
                                       refreshType:IDCMRefreshTypePullDownAndUp
                                     refreshAction:nil
                                         viewModel:self.viewModel
                                         configure:[self tableViewConfigure]];
        tableView.backgroundColor = viewBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
        tableView.tableHeaderView = self.headerView;
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
    }]configRegisterCellClasses:@[[IDCMOTCExchangeRecordCell class], [IDCMFlashRecordEmtyCell class]]]
           configCellClassForRow:^Class(IDCMBaseTableCellModel *cellViewModel, NSIndexPath *indexPath) {
        @strongify(self);
        return self.viewModel.sectionModels.count ? [IDCMOTCExchangeRecordCell class] : [IDCMFlashRecordEmtyCell class];
    }] configHeightForRowAtIndexPath:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        @strongify(self);
        return  self.viewModel.sectionModels.count ?
        (indexPath.row ? 64 : (64 + 8)) : (tableView.height - 40 - tableView.contentInset.bottom);
    }] configHeightForHeaderInSection:^CGFloat(UITableView *tableView, NSInteger section) {
        return 40;
    }] configHeaderFooterViewClassAtSection:^id (IDCMBaseTableSectionModel *sectionViewModel, IDCMSeactionViewKinds seactionViewKinds, NSUInteger section) {
        @strongify(self);
        return seactionViewKinds == SeactionHeaderView ? self.sectionHeaderView : nil;
    }] configDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
        @strongify(self);
        if (self.viewModel.sectionModels.count) {
            IDCMOTCExchangeRecordModel *model = (IDCMOTCExchangeRecordModel *)
            [self.viewModel getCellViewModelAtIndexPath:indexPath];
            [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMOTCExchangeDetailController"
                                                   withViewModelName:@"IDCMOTCExchangeDetailViewModel"
                                                          withParams:@{@"orderId" : [IDCMUtilsMethod valueString:model.ID]}
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
        
        IDCMOTCExchangeSellCurrencyViewModel * viewModel = [[IDCMOTCExchangeSellCurrencyViewModel alloc] initWithParams:nil];
        IDCMOTCExchangeController *exchangeVx = [[IDCMOTCExchangeController alloc] initWithViewModel:viewModel];
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
        label.text = NSLocalizedString(@"3.0_OTCExchangeRecord", nil);
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



