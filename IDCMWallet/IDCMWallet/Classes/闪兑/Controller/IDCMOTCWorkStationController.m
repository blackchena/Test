//
//  IDCMOTCWorkStationController.m
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/4.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOTCWorkStationController.h"
#import "IDCMOTCWorkStationViewModel.h"
#import "IDCMOTCWorkStationTopView.h"
#import "IDCMOTCWorkStationCell.h"
#import "IDCMDataManager.h"

#import "IDCMOTCExchangeDetailViewModel.h"
#import "IDCMOTCExchangeDetailController.h"

@interface IDCMOTCWorkStationController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) IDCMOTCWorkStationViewModel *viewModel;

@property (nonatomic, strong) IDCMOTCWorkStationTopView *topView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, assign) NSInteger time;

//按时间排序
@property (nonatomic, assign) BOOL sortByTime;

@property (nonatomic, assign) RACDisposable *timeDisposable;
@property (nonatomic, assign) RACDisposable *pushDisposable;
@end

@implementation IDCMOTCWorkStationController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled  = YES;
    
    UIView *view = self.view;
    [view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(view.mas_safeAreaLayoutGuideTop);
        }else{
            make.top.equalTo(view).offset(20);
        }
    }];
    
    [view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(view);
    }];
    
    self.topView.topLabel.attributedText = [self attributedStringByTime:self.time];
    
    BOOL isSell = [self.viewModel.type integerValue] == 2;
    
    
    NSString *amount = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:self.viewModel.amount] fractionDigits:4]];
    NSString *str = [NSString stringWithFormat:@"%@: %@ %@",isSell?SWLocaloziString(@"3.0_WorkStation_Sell"):SWLocaloziString(@"3.0_WorkStation_Buy"), amount, self.viewModel.otcCoinModel.CoinCode.uppercaseString];
    self.topView.bottomLabel.text = str;
    
    [self.topView.leftButton setTitle:SWLocaloziString(@"3.0_WorkStation_PriceSort") forState:UIControlStateNormal];
    [self.topView.rightButton setTitle:isSell ? SWLocaloziString(@"3.0_WorkStation_AvgResTimeSort") : SWLocaloziString(@"3.0_WorkStation_AvgPayTimeSort") forState:UIControlStateNormal];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timeDisposable dispose];
    [self.pushDisposable dispose];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)bindViewModel {
    [super bindViewModel];
    NSInteger time =  self.viewModel.orderModel.QuoteOrderSeconds;
    self.time = MAX(0, time);
    self.datas = @[];
    
//    NSMutableArray *arr = @[].mutableCopy;
//    for (NSInteger i = 0; i < 5; i ++) {
//        IDCMOTCWorkStationModel *model = [[IDCMOTCWorkStationModel alloc]init];
//        model.Amount = @(i);
//        model.AvgResponseTime = i;
//        model.AvgPayTime = i;
//        [arr addObject:model];
//    }
//    self.datas = arr.copy;
    
    @weakify(self);
    //关闭按钮
    [[self.topView.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self showCancelTipView];
    }];
    
    //选择排序方式
    [[RACObserve(self.topView.rightButton, selected) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.sortByTime = [x boolValue];
        if(self.datas.count > 1){
            self.datas = [self.datas sortedArrayUsingComparator:^NSComparisonResult(IDCMOTCWorkStationModel* obj1, IDCMOTCWorkStationModel* obj2) {
                BOOL isSell = [self.viewModel.type integerValue] == 2;
                if (self.sortByTime){
                    if (isSell) {
                        return obj1.AvgPayTime > obj2.AvgPayTime;
                    }
                    return obj1.AvgPayTime > obj2.AvgPayTime;
                }
                return isSell ? [obj2.Amount compare:obj1.Amount] : [obj1.Amount compare:obj2.Amount];
            }];
            [self.tableView reloadData];
        }
    }];
    
    //取消订单
    [[self.viewModel.cancelOrderCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSArray * datas) {
        @strongify(self);
        [IDCMHUD dismiss];
        if (self.popBackBlock) {
            self.popBackBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [[self.viewModel.cancelOrderCommand.errors deliverOnMainThread] subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [IDCMHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //确认订单
    [[self.viewModel.confirmOfferOrderCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSArray * datas) {
        @strongify(self);
        if (self.completion) {
            self.completion(nil);
        }
        [IDCMHUD dismiss];
        NSMutableArray *arr = self.navigationController.viewControllers.mutableCopy;
        [arr removeLastObject];
        [self.navigationController setViewControllers:arr.copy];
        NSDictionary *dict = @{@"orderId" :@(self.viewModel.orderModel.OrderId)};
        [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMOTCExchangeDetailController"
                                               withViewModelName:@"IDCMOTCExchangeDetailViewModel"
                                                      withParams:dict
                                                        animated:YES];
    }];
    [[self.viewModel.confirmOfferOrderCommand.errors deliverOnMainThread] subscribeNext:^(NSError * _Nullable x) {
//        @strongify(self);
        [IDCMHUD dismiss];
    }];
    
    // 推送
    self.pushDisposable = [[[IDCMOTCSignalRTool sharedOTCSignal].quotePriceNotificationSubject deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        IDCMOTCWorkStationModel *model = [IDCMOTCWorkStationModel yy_modelWithJSON:x];
        if (!model) {
            return ;
        }
        //过滤 怕服务器乱推送
        if(model.OrderId == 0){
            return;
        }
        if(model.OrderId != self.viewModel.orderModel.OrderId){
            return;
        }
        BOOL isSell = [self.viewModel.type integerValue] == 2;
        model.isSell = isSell;
        model.CurrencyCode = self.viewModel.otcCurrencyModel.Name;
        
        NSMutableArray *arr = self.datas.mutableCopy;
        [arr addObject:model];
        self.datas = arr.copy;
        if (self.datas.count > 1) {
            self.datas = [self.datas sortedArrayUsingComparator:^NSComparisonResult(IDCMOTCWorkStationModel* obj1, IDCMOTCWorkStationModel* obj2) {
                BOOL isSell = model.isSell; //[self.viewModel.type integerValue] == 2;
                if (self.sortByTime){
                    if (isSell) {
                        return obj1.AvgResponseTime > obj2.AvgResponseTime;
                    }
                    return obj1.AvgPayTime > obj2.AvgPayTime;
                }
                return isSell ? [obj2.Amount compare:obj1.Amount] : [obj1.Amount compare:obj2.Amount];
            }];
        }
        [self.tableView reloadData];
    }];
    
    //定时
    self.timeDisposable = [[[IDCMDataManager sharedDataManager].oneSecondSubject deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.time < 0) {
            return;
        }
        if (self.time >= 0) {
            self.topView.topLabel.attributedText = [self attributedStringByTime:self.time];
            if (self.time == 0) {
                [self showTimeOutTipView];
            }
        }
        self.time -= 1;
    }];
}

#pragma mark - func

- (NSAttributedString *)attributedStringByTime:(NSInteger)time {
    NSString *timeStr = [NSString stringWithFormat:@"%lds",(long)time];
    NSString *rest = SWLocaloziString(@"3.0_WorkStation_RestTime");
    NSString *allStr = [NSString stringWithFormat:@"%@: %@",rest ,timeStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:30];
    UIColor *color = time > 30 ? [UIColor colorWithRed:59/255.0 green:153/255.0 blue:251/255.0 alpha:1/1.0] :  [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [attStr addAttributes:@{NSForegroundColorAttributeName:color,
                            NSFontAttributeName:font
                            }
                    range:[allStr rangeOfString:timeStr]];
    return attStr.copy;
}

- (void)showCancelTipView{
    IDCMSysSettingModel *set = [IDCMDataManager sharedDataManager].settingModel;
    NSString *title = SWLocaloziString(@"3.0_WorkStation_CancelOrder");
    NSString *str1 = [NSString stringWithFormat:@"%zd",[IDCMDataManager sharedDataManager].cancelCount];
    NSString * language = [IDCMUtilsMethod getPreferredLanguage];
    if ([language isEqualToString:@"en"]) {
        NSInteger index = MAX(1, [IDCMDataManager sharedDataManager].cancelCount);
        if(index < 4){
           str1 = @[@"1st",@"2nd",@"3rd"][index-1];
        }
        else{
            str1 = [NSString stringWithFormat:@"%zdth",index];
        }
    }
    NSString *str2 = [NSString stringWithFormat:@"%zd",set.AllowCancelOrderDuration];
    NSString *str3 = [NSString stringWithFormat:@"%zd",set.AllowCancelOrderCount];
    NSString *str4 = [NSString stringWithFormat:@"%zd",set.CancelOrderForbidTradeDuration];
    NSString *subTitle = [[[[[NSString stringWithFormat:SWLocaloziString(@"3.0_WorkStation_CancelOrderTip")]
                             stringByReplacingOccurrencesOfString:@"[IDC1]" withString:str1]
                            stringByReplacingOccurrencesOfString:@"[IDC2]" withString:str2]
                           stringByReplacingOccurrencesOfString:@"[IDC3]" withString:str3]
                          stringByReplacingOccurrencesOfString:@"[IDC4]" withString:str4] ;
    [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
        configure.getBtnsConfig.firstObject.btnTitle(SWLocaloziString(@"3.0_jw_No"));
        configure
        .title(title)
        .subTitle(subTitle)
        .getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_jw_Yes")).btnCallback(^{
            [IDCMHUD show];
            [self.viewModel.cancelOrderCommand execute:nil ];
        });
    }];
}

- (void)showTimeOutTipView{
    NSString *title = SWLocaloziString(@"3.0_WorkStation_TimeOut");
    NSString *subTitle = self.datas.count == 0 ? SWLocaloziString(@"3.0_WorkStation_TimeOutTip1") : SWLocaloziString(@"3.0_WorkStation_TimeOutTip2");
    [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
        [configure.getBtnsConfig removeFirstObject];
        configure
        .image(UIImageMake(@"3.2_时间到"))
        .title(title)
        .subTitle(subTitle)
        .getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_WorkStation_IKown")).btnCallback(^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)showConfirmTipView:(IDCMOTCWorkStationModel *)model{
    ;
    NSString *title = SWLocaloziString(@"3.0_WorkStation_ConfirmOrder");
    NSString *amount = [IDCMUtilsMethod precisionControl:model.Amount];
    NSString *str1 = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:amount] fractionDigits:2]];
    NSString *str2 = [NSString stringWithFormat:@"%@",model.CurrencyCode?:@""];
    NSString *str3 = [NSString stringWithFormat:@"%@",model.AcceptantName?:@""];
    NSString *subTitle = [[[[NSString stringWithFormat:SWLocaloziString(@"3.0_WorkStation_ConfirmOrderTip")]
                            stringByReplacingOccurrencesOfString:@"[IDC1]" withString:str1]
                           stringByReplacingOccurrencesOfString:@"[IDC2]" withString:str2]
                          stringByReplacingOccurrencesOfString:@"[IDC3]" withString:str3];
    [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
        configure
        .title(title)
        .subTitle(subTitle)
        .getBtnsConfig.lastObject.btnCallback(^{
            [IDCMHUD show];
            [self.viewModel.confirmOfferOrderCommand execute:@{@"orderId" : @(self.viewModel.orderModel.OrderId),
                                                               @"quoteOrderId" : @(model.QuoteId),
                                                               }];
        });
    }];
}

#pragma mark - UItablView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCMOTCWorkStationModel * model = self.datas[indexPath.section];
    NSString *cellID = NSStringFromClass([IDCMOTCWorkStationCell class]);
    IDCMOTCWorkStationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    cell.backgroundColor = tableView.backgroundColor;
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 8;
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCMOTCWorkStationModel * model = self.datas[indexPath.section];
    [self showConfirmTipView:model];
}

#pragma mark DZEmptyTableview

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = SWLocaloziString(@"3.0_WorkStation_Wait");
    UIFont *font = textFontPingFangRegularFont(14);
    UIColor *textColor = textColor333333;
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return UIImageMake(@"3.2_操作台-零承兑商");
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -120;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - Get/Set

- (IDCMOTCWorkStationTopView *)topView {
    return SW_LAZY(_topView , ({
        IDCMOTCWorkStationTopView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([IDCMOTCWorkStationTopView class]) owner:nil options:nil].firstObject;
        view.backgroundColor = self.view.backgroundColor;
        
        view;
    }));
}

-(UITableView *)tableView {
    return SW_LAZY(_tableView , ({
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        view.rowHeight = UITableViewAutomaticDimension;
        view.estimatedRowHeight = 100;
        view.estimatedSectionHeaderHeight = 30;
        view.estimatedSectionFooterHeight = 30;
        NSString *cellID = NSStringFromClass([IDCMOTCWorkStationCell class]);
        [view registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        view.dataSource = self;
        view.delegate = self;
        view.emptyDataSetSource = self;
        view.emptyDataSetDelegate = self;
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.showsVerticalScrollIndicator = NO;
//        view.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
        view.tableFooterView = [UIView new];
        view;
    }));
}
@end
