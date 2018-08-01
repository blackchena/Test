//
//  IDCMFlashExchangeViewController.m
//  IDCMWallet
//
//  Created by wangpu on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFlashExchangeController.h"
#import "IDCMChooseBTypeView.h"
#import "IDCMBBChangeResultController.h"
#import "IDCMConfigBaseNavigationController.h"
#import "IDCMAlertWindow.h"
#import "IDCMBBHelpView.h"
#import "IDCMTapView.h"
#import "IDCMFlashExchangeViewModel.h"
#import "IDCMCoinListModel.h"
#import "IDCMFlashExchangeRecordController.h"
@interface IDCMFlashExchangeController ()<IconWindowDelegate,UITextFieldDelegate>
{
    IDCMTapView * tapeBViewLeft;//左侧币种选择
    IDCMTapView * tapeBViewRight;//右侧币种选择
    UIButton *clickBtnLeft;
    UIButton *clickBtnRight;
    NSTimer * timer;//输入框延时 计时器
    UILabel * exchangeOutLabel;
    UILabel * exchangeInLabel;
    UIButton *middleButton ;
    
}

@property (strong, nonatomic, readonly) IDCMFlashExchangeViewModel *viewModel;
@property (nonatomic,strong)  IDCMAlertWindow * showWindow;

@property (nonatomic,assign)  BOOL exchangeBtnEnable;
@property (nonatomic, strong) dispatch_source_t requestCoinListTimer;
@property (nonatomic, strong) IDCMCoinModel * currentSelectCoinModelLeft;//当前左边选择的币种
@property (nonatomic, strong) IDCMCoinModel * currentSelectCoinModelRight;//当前右边选择的币种
@property (nonatomic, strong) NSMutableArray < IDCMCoinModel *> * currentShowChooseArr;//当前需要展示选择的币种
@property (nonatomic,assign)  BOOL  exchangeLeftRight;//当前是否交换
@property (nonatomic,strong)  NSMutableArray *  supportExchangeArr;
@property (nonatomic,strong)  UILabel * realRateLabel;//实时兑汇率
@property (nonatomic,strong)  UILabel * minMountLabel;//最小可兑换额
@property (nonatomic,strong)  UILabel * maxMountLabel;//最大可兑换额
@property (nonatomic,strong)  UILabel * balanceLabel;//余额label
@property (nonatomic,assign)  BOOL netError;
@property (nonatomic,strong)  UIView *  backGroundScrollView;
@property (nonatomic,assign)  BOOL   isFirst;
@property (nonatomic,assign)  BOOL   isRrefreshing;
@property (nonatomic,strong)   UIActivityIndicatorView  * loadingView;
@property (nonatomic,strong)   UIButton * exchangeButton;//兑换按键
@end

@implementation IDCMFlashExchangeController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackgroundColor;
    self.isRrefreshing = NO;
    //设置页面
    [self setUpView];
    //刷新数据
    [self loadInitData];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //监听后台切换
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshBalance:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)handleBackGestureViewWillAppear {
    if (self.isFirst) {
        [self requestBalanceAndCoinList];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //
    [self resetTextfieldState];
    
    [self invalidateTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat heigth = [NSLocalizedString(@"3.0_BottomTips", nil) heightForFont:SetFont(@"PingFangSC-Regular", 14)
                                                                        width:(SCREEN_WIDTH - 24)];
    self.view.size = CGSizeMake(SCREEN_WIDTH, 376 + 14 + heigth + 8);
}
- (void)resetTextfieldState
{
    [self rightTextField].text = @"";
    [self leftTextField].text = @"";
    [self setExchangeBtnEnable:NO];
    [self.view endEditing:YES];
}
#pragma mark -
-(void)loadInitData
{
    // 开始币列表
    [IDCMHUD show];
    self.netRequestDone = NO;
    [self.viewModel.commandGetCoinList execute:nil];
}
- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    // ============  请求币列表  ============//
    [[self.viewModel.commandGetCoinList.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(RACTuple *  _Nullable tuple) {
        @strongify(self);

        if (!self.isFirst) {
            self.isFirst = YES;
            if ([[self.viewModel.defaultCoinListModel.toCoinModel.coinLabel  lowercaseString] isEqualToString:@"btc"]) {
                self.currentSelectCoinModelLeft = self.viewModel.defaultCoinListModel.toCoinModel;
                self.currentSelectCoinModelRight = self.viewModel.defaultCoinListModel.fromCoinModel;
            }else{
                self.currentSelectCoinModelLeft = self.viewModel.defaultCoinListModel.fromCoinModel;
                self.currentSelectCoinModelRight = self.viewModel.defaultCoinListModel.toCoinModel;
            }
            //获取余额 开启轮询
            [self requestBalanceAndCoinList];
        }else{
            //重设输入框的值
            self.isRrefreshing = YES;
            [self refreshExchangeParams];
            //没有默认的交易对
            if(![self currentPairCoinModel]){
                
                self.currentSelectCoinModelLeft = self.viewModel.defaultCoinListModel.fromCoinModel;
                self.currentSelectCoinModelRight = self.viewModel.defaultCoinListModel.toCoinModel;
                [self leftTextField].text =@"";
                [self  rightTextField].text = @"";
                [self setExchangeBtnEnable:NO];
                [self refreshBalance:YES];
            };
        }
        //重设汇率和最大最小可兑
        [self loadRate];
        //隐藏
        [self hiddenLoading];
        //自动刷新错误界面
        [self refreshDataLoad];
        //隐藏错误页面
        [self dismissMaskWrongView];
    }];
    //获取币列表 失败处理
    [self.viewModel.commandGetCoinList.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);

        [self currentPageNetError];
    }];
    // ============  兑币 ============//
    [[self.viewModel.commandExchangeIn.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {

        if (!executing.boolValue) {
            [IDCMHUD dismiss];
        }
    }];
//    //请求兑币结果处理
    [[self.viewModel.commandExchangeIn.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  _Nullable response) {

        @strongify(self);
        NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        if ([response[@"data"] isKindOfClass:[NSDictionary class]] && [status isEqualToString:@"1"] && ![response[@"data"][@"statusCode"] isKindOfClass:[NSNull class]]) {
            NSString *errorCode = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"statusCode"]];
            if ([errorCode integerValue] == 0) { //  成功
                //销毁定时器及移除监听
                [self invalidateTimer];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                //跳转到成功界面
                NSDictionary *  dict = @{
                                         @"exchangeOut":[NSString stringWithFormat:@"%@ %@",[self leftTextField].text,[self exCurrenLeftSelectCoinModel].coinLabelUppercaseString],
                                         @"exchangeIn" :[NSString stringWithFormat:@"%@ %@",[self rightTextField].text,[self exCurrenRightSelectCoinModel].coinLabelUppercaseString],
                                         @"leftLogo" : [self exCurrenLeftSelectCoinModel].coinUrl,
                                         @"rightLogo" :[self exCurrenRightSelectCoinModel].coinUrl,
                                         @"leftText" : [self exCurrenLeftSelectCoinModel].coinLabelUppercaseString,
                                         @"rightText" :[self exCurrenRightSelectCoinModel].coinLabelUppercaseString,
                                         };
                
                
                IDCMBBChangeResultController * resultVC= [IDCMBBChangeResultController new];
                resultVC.infoDict = dict;

                IDCMConfigBaseNavigationController * nav = [[IDCMConfigBaseNavigationController alloc] initWithRootViewController:resultVC];
                [self presentViewController:nav animated:YES completion:^{
                    [self resetTextfieldState];
                }];

            }else if ([errorCode integerValue] == 3 || [errorCode integerValue] == 102 | [errorCode integerValue] == 107 || [errorCode integerValue] == 108 || [errorCode integerValue] == 106){  // 余额不足

                [IDCMViewTools ToastView:self.view info:[NSString stringWithFormat:@"%@",SWLocaloziString(@"3.0_BalanceInsuff")] position:QMUIToastViewPositionBottom];


            }else if ([errorCode integerValue] == 1){  // 代币的ETH不足，无法支付矿工费

                [IDCMViewTools ToastView:self.view info:[NSString stringWithFormat:@"ETH %@",SWLocaloziString(@"3.0_TokenWalletInsuff")] position:QMUIToastViewPositionBottom];

            }else if ([errorCode integerValue] == 9){ // 最小兑换金额
                
                NSString *minAmount = @"";
                if ([[self exCurrenLeftSelectCoinModel].coinLabelUppercaseString isEqualToString:@"LTC"]) {
                    minAmount = @"0.0006";
                }else{
                    minAmount = @"0.00006";
                }
                [IDCMViewTools ToastView:self.view info:[NSString stringWithFormat:@"%@%@",SWLocaloziString(@"3.0_MinNum"),minAmount] position:QMUIToastViewPositionBottom];
                
            }else if ([errorCode integerValue] == 800){  // 在pending状态
                
    
                [IDCMViewTools ToastView:self.view info:SWLocaloziString(@"2.2.1_IsPending") position:QMUIToastViewPositionBottom];
                
            }else if ([errorCode integerValue] == 802){ // 有OTC订单
                [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_OngoingOTCOrders")];
            }else{// 其他code码(801代币交易失败)
                
                [IDCMViewTools ToastView:self.view info:SWLocaloziString(@"3.0_SwapFail") position:QMUIToastViewPositionBottom];
            }
        }else{ // 兑换失败

            [IDCMViewTools ToastView:self.view info:SWLocaloziString(@"3.0_SwapFail") position:QMUIToastViewPositionBottom];
        }
    }];
    //兑币失败处理
    [self.viewModel.commandExchangeIn.errors subscribeNext:^(NSError * _Nullable x) {

        [IDCMHUD dismiss];
    }];
//
    //============  更新 可兑余额    ============//
    [[self.viewModel.commandGetBalance.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(RACTuple *tupe) {

        @strongify(self);
        
        self.balanceLabel.text = [NSString idcw_stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"3.0_CanExchangeOutBalance", nil),self.viewModel.realityBalanceString,[self exCurrenLeftSelectCoinModel].coinLabelUppercaseString];
        //隐藏错误页面
        [self dismissMaskWrongView];

    }];

    [[self.viewModel.commandGetBalance.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
    
        if (!executing.boolValue) {
            
            self.netRequestDone = YES;
            
            IDCMFlashExchangeRecordController *parent = (IDCMFlashExchangeRecordController *)self.parentViewController;
            if (parent.netRequestDone) {
                [IDCMHUD dismiss];
            }

        }
    }];
    // 可兑余额 失败
    [self.viewModel.commandGetBalance.errors subscribeNext:^(NSError * _Nullable x) {

        @strongify(self);
        [self currentPageNetError];

    }];
}

//当前页面出错
-(void)currentPageNetError{
    
    [self hiddenLoading];
    self.netError = YES;
    [self.view endEditing:YES];
    [IDCMHUD dismiss];
    self.netRequestDone = YES;
    [self showMaskWrongView];
}

-(void)showMaskWrongView{
    
    IDCMFlashExchangeRecordController *parent = (IDCMFlashExchangeRecordController *)self.parentViewController;
    UIView * parentView = parent.view;
    [IDCMHUD showEmptyViewToView:parentView configure:^(IDCMHUDConfigure *configure) {
        configure.title(NSLocalizedString(@"3.0_NetWorkBusy", nil))
        .image(UIImageMake(@"2.1_NoDataImage"))
        .backgroundImage([UIImage imageWithColor:[UIColor whiteColor]]);
        
    } reloadCallback:^{
        [self refreshDataLoad];
    }];
}

-(void)dismissMaskWrongView{
    IDCMFlashExchangeRecordController *parent = (IDCMFlashExchangeRecordController *)self.parentViewController;
    UIView * parentView = parent.view;
    [IDCMHUD dismissEmptyViewForView:parentView];
}
//
////给页面 载入输入
-(void)loadRate{

    //获取当前的交易对
    IDCMCoinModel * currentPair =[self currentPairCoinModel];
    self.realRateLabel.text = [NSString idcw_stringWithFormat:@"1 %@ = %@ %@",currentPair.coinLabelUppercaseString,currentPair.exchangeRateString,currentPair.pairCoinLabelUppercaseString];
    self.minMountLabel.text = [NSString idcw_stringWithFormat:@"%@ %@",currentPair.exchangeMinString,currentPair.coinLabelUppercaseString];
    self.maxMountLabel.text = [NSString idcw_stringWithFormat:@"%@ %@",currentPair.exchangeMaxString,currentPair.coinLabelUppercaseString];
}
//重新请求
-(void)requestBalanceAndCoinList{
    self.netRequestDone = NO;
    [self refreshBalance:YES];
    [self requestCoinListCycle];
}
//#pragma mark  -View
//
-(void)setUpView{
    
    CGFloat heigth = [NSLocalizedString(@"3.0_BottomTips", nil) heightForFont:SetFont(@"PingFangSC-Regular", 14)
                                                                       width:(SCREEN_WIDTH - 30)];
    
    self.view.size = CGSizeMake(SCREEN_WIDTH, 376 + 14 + heigth + 8);
    
    [self.view addSubview:self.backGroundScrollView];
    [self.backGroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(self.view.height - 8));
    }];

    UIView * contentView=[UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.backGroundScrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(self.backGroundScrollView).with.insets(UIEdgeInsetsZero);
        make.width.equalTo(self.backGroundScrollView.mas_width);
    }];
    
    //头部View
    UIView  * headRealExchangeRate = [UIView new];
    [contentView addSubview:headRealExchangeRate];
    [headRealExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.mas_equalTo(80);
    }];
 
   //背景
    UIImageView *  backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.0_SwapBG"]];
    backImageView.contentMode = UIViewContentModeScaleToFill;
    [headRealExchangeRate addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headRealExchangeRate).insets(UIEdgeInsetsMake(12, 10, 10,10));
    }];
    
    //实时汇率
    UILabel * realExchangeLabel = [UILabel new];
    realExchangeLabel.text = NSLocalizedString(@"3.0_RealTimeExchangRate", nil);
    realExchangeLabel.font = SetFont(@"PingFangSC-Medium", 14);
    realExchangeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    realExchangeLabel.textAlignment = NSTextAlignmentCenter;
    [headRealExchangeRate addSubview:realExchangeLabel];

    [realExchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(6);
        make.centerX.equalTo(headRealExchangeRate.mas_centerX);
    }];
    
    // 图标
    UIImageView *  icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.0_flashExchangeHelp"]];
    icon.contentMode = UIViewContentModeScaleToFill;
    icon.userInteractionEnabled = YES;
    [headRealExchangeRate addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(realExchangeLabel);
        make.right.equalTo(backImageView.mas_right).offset(-12);
    }];
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        [self showHelpTip:nil];
    }];
    [icon addGestureRecognizer:tap];

    //汇率
    self.realRateLabel = [UILabel new];
    self.realRateLabel.font = SetFont(@"PingFangSC-Regular", 16);
    self.realRateLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.realRateLabel.textAlignment = NSTextAlignmentCenter;
    [headRealExchangeRate addSubview:self.realRateLabel];
    [self.realRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(realExchangeLabel.mas_bottom).offset(4);
        make.centerX.equalTo(headRealExchangeRate.mas_centerX);
    }];
//
    [headRealExchangeRate addSubview:self.loadingView];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.realRateLabel);
        make.centerX.equalTo(self.view);
    }];
//    //中间的View
    UIView  * middleExchangeView = [UIView new];
    [contentView addSubview:middleExchangeView];

    [middleExchangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headRealExchangeRate.mas_bottom);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.mas_equalTo(235);
    }];
    //背景2
    UIImageView *  backImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.1_midback_phrases_bg_image_box"]];
    backImageView2.contentMode = UIViewContentModeScaleToFill;
    [middleExchangeView addSubview:backImageView2];

    [backImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleExchangeView.mas_top);
        make.bottom.equalTo(middleExchangeView.mas_bottom).offset(-5);
        make.left.equalTo(middleExchangeView.mas_left).offset(10);
        make.right.equalTo(middleExchangeView.mas_right).offset(-10);
    }];
    //兑出币种label
    exchangeOutLabel = [UILabel new];
    exchangeOutLabel.text = NSLocalizedString(@"3.0_ExchangeOutType", nil);
    exchangeOutLabel.font = SetFont(@"PingFangSC-Medium", 14);
    exchangeOutLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    exchangeOutLabel.textAlignment = NSTextAlignmentLeft;
    [middleExchangeView addSubview:exchangeOutLabel];

    [exchangeOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView2.mas_top).offset(12);
        make.left.equalTo(backImageView2.mas_left).offset(18);
        make.width.lessThanOrEqualTo(@100);
    }];
    //兑入币种label
    exchangeInLabel = [UILabel new];
    exchangeInLabel.text = NSLocalizedString(@"3.0_ExchangeInType", nil);
    exchangeInLabel.font = SetFont(@"PingFangSC-Medium", 14);
    exchangeInLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    exchangeInLabel.textAlignment = NSTextAlignmentRight;
    [middleExchangeView addSubview:exchangeInLabel];

    [exchangeInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView2.mas_top).offset(12);
        make.right.equalTo(backImageView2.mas_right).offset(-18);
        make.width.lessThanOrEqualTo(@100);
    }];

    //logo
    UIImageView *  logoImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_exchagne"]];
    logoImageView.contentMode = UIViewContentModeScaleToFill;
    [middleExchangeView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleExchangeView.mas_top).offset(10);
        make.centerX.equalTo(middleExchangeView);
        make.size.mas_equalTo(CGSizeMake(47, 22));
    }];

    //中间的按钮
    middleButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [middleButton addTarget:self action:@selector(exchangeBTypeArr:) forControlEvents:UIControlEventTouchUpInside];
    [middleButton setImage:[UIImage imageNamed:@"3.0_bluebexchange"] forState:UIControlStateNormal];
    [middleExchangeView addSubview:middleButton];

    [middleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleExchangeView.mas_top).offset(AdjustWidth(42));
        make.centerX.equalTo(backImageView2.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];

    //__weak typeof(self) weakSelf = self;
    //左边的按钮

    tapeBViewLeft = [[IDCMTapView alloc] initWithFrame:CGRectZero];
    [middleExchangeView addSubview:tapeBViewLeft];
    [tapeBViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(exchangeOutLabel.mas_left);
        make.height.mas_equalTo(AdjustWidth(24));
        make.centerY.equalTo(middleButton.mas_centerY);

    }];

    //右边的按钮
    tapeBViewRight = [[IDCMTapView alloc] initWithFrame:CGRectZero];
    [middleExchangeView addSubview:tapeBViewRight];
    [tapeBViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(exchangeInLabel.mas_right);
        make.height.mas_equalTo(AdjustWidth(24));
        make.centerY.equalTo(middleButton.mas_centerY);

    }];

    //线 2
    UIView * lineLeft = [UIView new];
    lineLeft.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [middleExchangeView addSubview:lineLeft];

    [lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(exchangeOutLabel.mas_left);
        make.top.equalTo(tapeBViewLeft.mas_bottom).offset(8);
        make.right.equalTo(middleButton.mas_left).offset(-15);

    }];

    UIView * lineRight = [UIView new];
    lineRight.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [middleExchangeView addSubview:lineRight];
    [lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.right.equalTo(exchangeInLabel.mas_right);
        make.centerY.equalTo(lineLeft.mas_centerY);
        make.left.equalTo(middleButton.mas_right).offset(15);

    }];

    clickBtnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtnLeft.backgroundColor =
    clickBtnRight.backgroundColor = [UIColor clearColor];
    [middleExchangeView addSubview:clickBtnLeft];
    [middleExchangeView addSubview:clickBtnRight];
    [clickBtnLeft addTarget:self
                     action:@selector(leftBtnAction)
           forControlEvents:UIControlEventTouchUpInside];
    [clickBtnRight addTarget:self
                      action:@selector(rightBtnAction)
       forControlEvents:UIControlEventTouchUpInside];

    [clickBtnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(exchangeOutLabel.mas_bottom);
        make.left.right.equalTo(lineLeft);
    }];
    [clickBtnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clickBtnLeft);
        make.left.right.equalTo(lineRight);
    }];
//

//    // 两个输入框
    UIView * leftInPutView = [self inputView:SWLocaloziString(@"3.0_InputExchangOut") position:@"left"];
    [middleExchangeView addSubview:leftInPutView];

    [leftInPutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(exchangeOutLabel.mas_left);
        make.top.equalTo(lineLeft.mas_bottom).offset(15);
        make.right.equalTo(lineLeft.mas_right);
        make.height.mas_equalTo(30);
    }];
//
    UIView * rightInPutView = [self inputView:SWLocaloziString(@"3.0_InputExchangIn") position:@"right"];
    [middleExchangeView addSubview:rightInPutView];
    [rightInPutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineRight.mas_right);
        make.centerY.equalTo(leftInPutView.mas_centerY);
        make.left.equalTo(lineRight.mas_left);
        make.height.mas_equalTo(30);
    }];

//    //余额
    self.balanceLabel = [UILabel new];
    self.balanceLabel.textAlignment = NSTextAlignmentLeft;
    self.balanceLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"3.0_CanExchangeOutBalance", nil)];
    self.balanceLabel.font = textFontHelveticaLightFont(12);
    self.balanceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [middleExchangeView addSubview: self.balanceLabel];

    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(exchangeOutLabel.mas_left);
        make.top.equalTo(leftInPutView.mas_bottom).offset(15);
        make.right.equalTo(exchangeInLabel.mas_right);
    }];
//    //line
//
    UIView * lastLine = [UIView new];
    lastLine.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [middleExchangeView addSubview:lastLine];

    [lastLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(exchangeOutLabel.mas_left);
        make.top.equalTo(self.balanceLabel.mas_bottom).offset(10);
        make.right.equalTo(exchangeInLabel.mas_right);

    }];
//
    //最小 可兑label
    UILabel * minLabel = [UILabel new];
    minLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    minLabel.font = textFontHelveticaLightFont(12);
    minLabel.textAlignment = NSTextAlignmentCenter;
    minLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"3.0_MinCanExchangBalance", nil)];
    [middleExchangeView addSubview:minLabel];

    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastLine.mas_bottom).offset(12);
        make.left.equalTo(exchangeOutLabel.mas_left);
    }];
    // 值
    self.minMountLabel = [UILabel new];
    self.minMountLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.minMountLabel.font = textFontHelveticaLightFont(12);
    self.minMountLabel.textAlignment = NSTextAlignmentLeft;
    [middleExchangeView addSubview:self.minMountLabel];

    [self.minMountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(minLabel.mas_centerY);
        make.height.equalTo(minLabel.mas_height);
        make.left.equalTo(minLabel.mas_right).offset(3);
    }];

    //最大 可兑label
    UILabel * maxLabel = [UILabel new];
    maxLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    maxLabel.font = textFontHelveticaLightFont(12);
    maxLabel.textAlignment = NSTextAlignmentLeft;
    maxLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"3.0_MaxCanExchangeBalance", nil)];
    [middleExchangeView addSubview:maxLabel];

    [maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minLabel.mas_bottom).offset(6);
        make.left.equalTo(exchangeOutLabel.mas_left);
    }];
    // 值
    self.maxMountLabel = [UILabel new];
    self.maxMountLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.maxMountLabel.font = textFontHelveticaLightFont(12);
    [middleExchangeView addSubview:self.maxMountLabel];

    [self.maxMountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(maxLabel.mas_centerY);
        make.height.equalTo(maxLabel.mas_height);
        make.left.equalTo(maxLabel.mas_right).offset(3);
    }];

    //底部View
    UIView * bottomView = [UIView new];
    [contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleExchangeView.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.bottom.equalTo(contentView.mas_bottom);

    }];

    //设置
    [bottomView addSubview:self.exchangeButton];

    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(7);
        make.left.equalTo(bottomView.mas_left).offset(13);
        make.right.equalTo(bottomView.mas_right).offset(-13);
        make.height.mas_equalTo(40);
    }];
//
//    //提示语
    UILabel * tipsLabel = [UILabel new];
    tipsLabel.numberOfLines = 0;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = SetFont(@"PingFangSC-Regular", 14);
    tipsLabel.textColor = [UIColor colorWithHexString:@"#FB3030"];
    tipsLabel.text = NSLocalizedString(@"3.0_BottomTips", nil);
    
    [bottomView addSubview:tipsLabel];

    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(12);
        make.top.equalTo(self.exchangeButton.mas_bottom).offset(14);
        make.right.equalTo(bottomView.mas_right).offset(-12);
    }];

    //底部
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_bottom);
    }];
}
//
//#pragma mark — 点击弹框左边按钮
- (void)leftBtnAction {
    [self currentActiveShow:401];
}
//#pragma mark — 点击弹框右边按钮
- (void)rightBtnAction {
    [self currentActiveShow:402];
}
//当前要展示的数组
-(void)currentActiveShow:(NSInteger ) tag{
   
    NSString * leftLabel = [self exCurrenLeftSelectCoinModel].coinLabel;
    NSString * rightLabel = [self exCurrenRightSelectCoinModel].coinLabel;
    NSMutableArray< IDCMCoinModel *> * showArr = [[NSMutableArray alloc] init];
    NSMutableArray<IDCMCoinModel *> * coinArr = nil;
    NSString * coinLabel = nil;
    IDCMCoinModel  * lastModel = nil;
    if (tag == 402) {

        if (self.exchangeLeftRight) {
            coinArr = self.viewModel.allCoinModelArr;
//            coinArr= self.viewModel.allKeyCoinDataDict[rightLabel];
//            lastModel = [self exCurrenRightSelectCoinModel].mutableCopy;
            coinLabel = leftLabel;
        }else{
        
            coinArr= [NSMutableArray arrayWithArray:self.viewModel.allKeyCoinDataDict[leftLabel]];
            lastModel = [self exCurrenLeftSelectCoinModel].mutableCopy;
            coinLabel = rightLabel;
        }
    }else{
        
        if (self.exchangeLeftRight) {
            coinArr= [NSMutableArray arrayWithArray:self.viewModel.allKeyCoinDataDict[leftLabel]];
            lastModel = [self exCurrenLeftSelectCoinModel].mutableCopy;
            coinLabel = rightLabel;
        }else{
        
            coinArr= self.viewModel.allCoinModelArr;
//            lastModel = [self exCurrenRightSelectCoinModel].mutableCopy;
            coinLabel = leftLabel;
        }
    }
    NSArray * newCoinArr = nil;
    if( lastModel ){

        NSMutableArray  * temp = [[NSMutableArray alloc] init];
        [coinArr addObject:lastModel];
        for (NSInteger i = 0; i<self.viewModel.sortListArray.count; i++) {
            NSDictionary * keyDic = self.viewModel.sortListArray[i];
            NSString * keyStr = keyDic[@"Coin"];
          
            for (NSInteger j = 0; j<coinArr.count; j++) {
                if ([coinArr[j].coinLabel isEqualToString:[keyStr lowercaseString]]) {
                    [temp addObject:coinArr[j]];
                }
            }
        }
        newCoinArr = temp;
    }else{
        
        newCoinArr =coinArr;
    }
    [newCoinArr enumerateObjectsUsingBlock:^(IDCMCoinModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IDCMCoinModel * model = obj.mutableCopy;
        if ([model.coinLabel isEqualToString:coinLabel]) {
            model.isSelect = YES;
        }else{
            model.isSelect = NO;
        }
        model.arrIndex = idx;
        [showArr addObject:model];
    }];
    
    self.currentShowChooseArr = showArr;
    [self showTypeViewWithArray:showArr tag:tag];
}
- (void)showTypeViewWithArray:(NSArray *)array tag:(NSInteger)tag {

    NSInteger totalRow = ((array.count - 1) / 4 + 1);
    CGFloat bottomMargin =  totalRow < 5 ? 10 : 0;
    if (totalRow > 4) {totalRow = 4;}
    CGFloat totalHeight =  totalRow * (70 + 20) + 52 + bottomMargin;
    IDCMChooseBTypeView * chooseIconView =
    [[IDCMChooseBTypeView alloc] initWithFrame:CGRectMake(12, 200, SCREEN_WIDTH-24, totalHeight) bTypes:array position:tag exchange:self.exchangeLeftRight];
    chooseIconView.tag = tag;
    IDCMTapView *view = (tag == 401) ? tapeBViewLeft : tapeBViewRight;
    chooseIconView.converImageView = view.iconImageView;
    chooseIconView.delegate = self ;
    [self.showWindow show:chooseIconView];
}

-(UIView *)inputView:(NSString * )placeHolder position:(NSString *) positon{

    if (placeHolder.length>20) {
        placeHolder =[NSString stringWithFormat:@"%@...",[placeHolder substringToIndex:20]] ;
        
    }
    UIView * inPutView = [UIView new];
    inPutView.layer.borderWidth=0.5;
    inPutView.layer.cornerRadius = 2;
    inPutView.clipsToBounds = YES;
    inPutView.layer.borderColor=[UIColor colorWithHexString:@"999999"].CGColor;
    UILabel * rightViewLabel = [UILabel new];
    rightViewLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    rightViewLabel.textAlignment = NSTextAlignmentCenter;
    rightViewLabel.font = SetFont(@"PingFangSC-Regular", 12);
    [inPutView addSubview:rightViewLabel];
    [rightViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inPutView.mas_top);
        make.bottom.equalTo(inPutView.mas_bottom);
        make.right.equalTo(inPutView.mas_right).offset(52);
        make.width.equalTo(@50);
    }];

    UITextField * textField = [[UITextField alloc] init];;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleNone;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.delegate = self;
    textField.font = SetFont(@"PingFangSC-Regular", 12);
    textField.textColor = [UIColor colorWithHexString:@"#333333"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField addTarget:self action:@selector(changeValues:) forControlEvents:UIControlEventEditingChanged];
    textField.returnKeyType  =  UIReturnKeyDone;
    [inPutView addSubview:textField];

    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inPutView.mas_centerY);
        make.left.equalTo(inPutView.mas_left).offset(5);
        make.height.mas_equalTo(inPutView.mas_height);
        make.right.equalTo(inPutView.mas_right).offset(7);
    }];

    if ([positon isEqualToString:@"left"]) {
        textField.tag =301;
        rightViewLabel.tag = 302;
        rightViewLabel.hidden = YES;
    }else{
        textField.tag =304;
        rightViewLabel.tag = 305;
        rightViewLabel.hidden = YES;
    }
    return inPutView;
}

//#pragma mark - selector
////底部的兑换按钮
-(void)exchangeBB:(UIButton *)sender{

    [self.view endEditing:YES];
    IDCMCoinModel * currentModel = [self currentPairCoinModel];
    if (currentModel.exchangeMin.floatValue == 0.0 && currentModel.exchangeMax.floatValue == 0.0) {

        [IDCMViewTools ToastView:self.view info:[NSString stringWithFormat:@"%@",SWLocaloziString(@"3.0_WrongPair")] position:QMUIToastViewPositionBottom];
        return;
    }
    if ([self.viewModel.realityBalance compare:currentModel.exchangeMin] == NSOrderedAscending){
        [IDCMViewTools ToastView:self.view info:[NSString stringWithFormat:@"%@",SWLocaloziString(@"3.0_BalanceInsuff")] position:QMUIToastViewPositionBottom];
        return;
    }

    //  弹出鉴权框
    NSDecimalNumber * amount = [NSDecimalNumber  decimalNumberWithString:self.leftTextField.text];
    NSDecimalNumber * toAmount = [NSDecimalNumber  decimalNumberWithString:self.rightTextField.text];
    if ([toAmount doubleValue] == 0.0 || [amount doubleValue] == 0.0) {
        [IDCMViewTools ToastView:self.view info:SWLocaloziString(@"3.0_ExchangeAlert_1") position:QMUIToastViewPositionBottom];
        return;
    }
    NSNumber * digit = [NSNumber numberWithInteger:[self leftDigit]] ;
    NSNumber * todigit = [NSNumber numberWithInteger:[self rightDigit]] ;
    NSNumber * ratedigit = [NSNumber numberWithInteger:[self rateDigit]];
    NSString * direction = [self currentPairCoinModel].isDirection;
    NSString * toCurrency = [self exCurrenRightSelectCoinModel].coinLabel;
    NSString * currency = [self exCurrenLeftSelectCoinModel].coinLabel;
    NSString * password = self.viewModel.pinPassWord;
    NSDecimalNumber * rate = [self currentPairCoinModel].exchangeRateDecimalNumber;
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSDictionary * changeDict = @{
                                  @"toCurrency": toCurrency ?:@"",
                                  @"toAmount": toAmount,
                                  @"rate":rate,
                                  @"payPassword":password?:@"",
                                  @"toAddress": @"",
                                  @"amount": amount,
                                  @"Digit":digit,
                                  @"ToDigit":todigit,
                                  @"RateDigit":ratedigit,
                                  @"Direction":direction,
                                  @"currency":currency ? :@"",
                                  @"comment": @"",
                                  @"device_id":model.device_id ?:@"",
                                  };

    [self.viewModel.commandExchangeIn execute:changeDict];
    [IDCMHUD show];
}

//导航栏右边的按钮

-(void)showHelpTip:(UIBarButtonItem *)sender{

    [self.view endEditing:YES];
    NSString * str=NSLocalizedString(@"3.0_RightHeadTips", nil);
    CGFloat height = [IDCMViewTools  boundsWithFontSize:SetFont(@"PingFangSC-Regular", 14) text:str size:CGSizeMake(self.view.frame.size.width-24 -30, MAXFLOAT)].size.height+64+15;
    IDCMBBHelpView * help = [[IDCMBBHelpView alloc ] initWithFrame:CGRectMake(12, 145, self.view.frame.size.width-24, height) contentStr:str];
    [self.showWindow show:help];
}

// 交换兑换的按钮
-(void)exchangeBTypeArr:(UIButton *) sender{

    sender.selected = !sender.selected;
    sender.superview.userInteractionEnabled = NO;
    if (sender.selected) {
        CGFloat btnDistance = clickBtnRight.left - clickBtnLeft.left;
        CGFloat  distance = tapeBViewRight.origin.x -tapeBViewLeft.right;
        CGFloat  widthLeft = tapeBViewLeft.frame.size.width;
        CGFloat  widthRight = tapeBViewRight.frame.size.width;
        CGFloat  leftDistance = distance + widthRight;;
        CGFloat  rightDistance= distance + widthLeft;
        CGFloat  leftToCenter =middleButton.left-tapeBViewLeft.right;
        CGFloat  rightToCenter =tapeBViewRight.left - middleButton.right;
        [UIView animateWithDuration:0.5 animations:^{
            clickBtnLeft.transform = CGAffineTransformMakeTranslation(btnDistance, 0);
            clickBtnRight.transform = CGAffineTransformMakeTranslation(-btnDistance, 0);
            tapeBViewLeft.transform = CGAffineTransformMakeTranslation(leftDistance, 0);
            tapeBViewRight.transform = CGAffineTransformMakeTranslation(-rightDistance, 0);
            sender.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished){

            //右边的按钮
            [tapeBViewLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(middleButton.mas_left).offset(-leftToCenter);
                make.height.mas_equalTo(AdjustWidth(24));
                make.centerY.equalTo(middleButton.mas_centerY);

            }];
            [tapeBViewRight mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(middleButton.mas_right).offset(rightToCenter);
                make.height.mas_equalTo(AdjustWidth(24));
                make.centerY.equalTo(middleButton.mas_centerY);
            }];

            sender.superview.userInteractionEnabled = YES;
        }];
    }else{

        [UIView animateWithDuration:0.5 animations:^{
            clickBtnLeft.transform = CGAffineTransformIdentity;
            clickBtnRight.transform = CGAffineTransformIdentity;
            tapeBViewLeft.transform = CGAffineTransformIdentity;
            tapeBViewRight.transform = CGAffineTransformIdentity;
            sender.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){

            //右边的按钮
            [tapeBViewLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(exchangeOutLabel.mas_left);
                make.height.mas_equalTo(AdjustWidth(24));
                make.centerY.equalTo(middleButton.mas_centerY);

            }];
            [tapeBViewRight mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(exchangeInLabel.mas_right);
                make.height.mas_equalTo(AdjustWidth(24));
                make.centerY.equalTo(middleButton.mas_centerY);
            }];
            sender.superview.userInteractionEnabled = YES;
        }];
    }
    //
    self.exchangeLeftRight = sender.selected;
    //跟新可兑余额
    [self loadRate];
    [self refreshBalance:YES];
    [self resetTextFieldAndExchangeBtn];
    self.balanceLabel.text = [NSString idcw_stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"3.0_CanExchangeOutBalance", nil),@"0",[self exCurrenLeftSelectCoinModel].coinLabelUppercaseString];
    [self resizeTextFieldAndLabel:NO];
}

-(void)resetTextFieldAndExchangeBtn{

    [[self leftTextField]  resignFirstResponder];
    [[self  rightTextField] resignFirstResponder];
    [self leftTextField].text = nil;
    [self  rightTextField].text = nil;
    self.exchangeBtnEnable = NO;
}
//
-(void)refreshDataLoad{

    if (self.netError) {
        self.netError = NO;
        [IDCMHUD show];
        [self.viewModel.commandGetCoinList execute:nil];
        [self refreshBalance:YES];
    }
}
//
//value变化
-(void)changeValues:(UITextField *) textField {
    [self setExchangeBtnEnable:NO];
    BOOL should = textField.text.length>0 ? YES : NO;
    [self resizeTextFieldAndLabel:should];
    NSDecimalNumber *rate = [self currentPairCoinModel].exchangeRateDecimalNumber;
    //没有兑换率 就直接报错返回
    UITextField * rightTextField = [self rightTextField];
    UITextField * leftTextfield  = [self leftTextField];
    //没有兑换率 就直接报错返回
    if (!rate)  {
        rightTextField.text = nil;
        leftTextfield.text = nil;
        return;
    }
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:textField.text];

    if ([textField.text isEqualToString:@""]) {
        leftTextfield.text = @"";
        rightTextField.text = @"";
    } else {
        if (textField.tag == 304) {
            NSString * numStr = [NSString stringFromNumber:[price decimalNumberByDividingBy:rate] fractionDigits:[self leftDigit]];
            leftTextfield.text = numStr;
        }
        if (textField.tag == 301 ) {
            NSString * numStr =  [NSString stringFromNumber:[price decimalNumberByMultiplyingBy:rate] fractionDigits:[self rightDigit]];
            rightTextField.text = numStr;
        }
    }
    [timer invalidate];
    timer = nil;
    NSDictionary * dict = @{@"text":textField.text ,@"tag":[NSNumber numberWithInteger:textField.tag]};
    timer= [NSTimer scheduledTimerWithTimeInterval:1.30f target:self selector:@selector(executeAction:) userInfo:dict repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
//重新布局 textfield 和左边的 label

-(void)resizeTextFieldAndLabel :(BOOL) should{
    [self remakeLayout:[self leftTextField].superview leftView:[self leftViewLabel] rightView:[self leftTextField] should:should];
    [self remakeLayout:[self rightTextField].superview leftView:[self rightViewLabel] rightView:[self rightTextField] should:should];
}

-(void)remakeLayout:(UIView *) superView leftView:(UIView *) leftViewLabel rightView:(UIView *) rightTextField  should:(BOOL) should{

    UIView * inPutView = superView;
    UIView * labelView = leftViewLabel;
    UIView * textField = rightTextField;

    if(should) {

        labelView.hidden = NO;

        [labelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@50);
            make.top.equalTo(inPutView.mas_top);
            make.bottom.equalTo(inPutView.mas_bottom);
            make.right.equalTo(inPutView.mas_right);

        }];
        [textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(inPutView.mas_centerY);
            make.left.equalTo(inPutView.mas_left).offset(5);
            make.height.equalTo(inPutView.mas_height);
            make.right.equalTo(labelView.mas_left).offset(10);
        }];

    }else{
        labelView.hidden = YES;
        [textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(inPutView.mas_centerY);
            make.left.equalTo(inPutView.mas_left).offset(5);
            make.height.mas_equalTo(inPutView.mas_height);
            make.right.equalTo(inPutView.mas_right).offset(7);
        }];
    }
}
//#pragma mark -  网络请求
////轮询 兑换率
-(void)requestCoinListCycle{
    //停掉定时器
    if (self.requestCoinListTimer) {
        dispatch_source_cancel(self.requestCoinListTimer);
        self.requestCoinListTimer = NULL;
    }
    //开始轮训
    self.requestCoinListTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.requestCoinListTimer, DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.requestCoinListTimer, ^{@autoreleasepool{
        //[weakSelf showLoading];
        [weakSelf.viewModel.commandGetCoinList execute:nil];
    }});
    dispatch_resume(self.requestCoinListTimer);
}

-(void)showLoading{
    self.realRateLabel.hidden = YES;
    [self.loadingView startAnimating];
}

-(void)hiddenLoading{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //放开
        self.exchangeButton.userInteractionEnabled = YES;
        tapeBViewLeft.userInteractionEnabled = YES;
        tapeBViewRight.userInteractionEnabled = YES;
        clickBtnLeft.userInteractionEnabled = YES;
        clickBtnRight.userInteractionEnabled = YES;
        middleButton.userInteractionEnabled =YES ;
        self.realRateLabel.hidden = NO;
        [self.loadingView stopAnimating];
        //允许输入
        self.isRrefreshing = NO;
    });
}
//
////刷新 可用余额
-(void)refreshBalance:(BOOL)isHUD{
    //初始化请求

    if ([[self exCurrenLeftSelectCoinModel].coinLabel isNotBlank]) {
        if (![IDCMHUD isShow]) {
            if (isHUD) {
                [IDCMHUD show];
            }else{
                [self resetTextfieldState];
            }
        }
        [self.viewModel.commandGetBalance execute:[self exCurrenLeftSelectCoinModel].coinLabel];
    }else{
       
        [self currentPageNetError];
    }
}
#pragma mark - 处理数据
//更新最大 最小 左右输入值
-(void)refreshExchangeParams{
    self.exchangeButton.userInteractionEnabled = NO;
    tapeBViewLeft.userInteractionEnabled = NO;
    tapeBViewRight.userInteractionEnabled = NO;
    clickBtnLeft.userInteractionEnabled = NO;
    clickBtnRight.userInteractionEnabled = NO;
    middleButton.userInteractionEnabled =NO ;
    UITextField * rightTextField = [self rightTextField];
    UITextField * leftTextfield  = [self leftTextField];
    NSString  * rightText = rightTextField.text;
    NSString  * leftText = leftTextfield.text;
    if ([leftText isEqualToString:@""] || [rightText isEqualToString:@""]) {
        leftTextfield.text = @"";
        rightTextField.text = @"";
        return;
    }
    NSString * tag = nil;
    NSString * text = nil;
    if (rightTextField.editing) {
        tag = @"304";
        text = rightText;
    }else{
        tag = @"301";
        text =leftText;
    }
    [self calculateLeftAndRightValue:text withTag:tag];
}
//延时执行
-(void)executeAction:(NSTimer *)value{

    [self calculateLeftAndRightValue:value.userInfo[@"text"] withTag:value.userInfo[@"tag"]];
}
//计算左右的值
-(void)calculateLeftAndRightValue:(NSString * )text withTag:(NSString *)tag{
    
    UITextField * rightTextField = [self rightTextField];
    UITextField * leftTextfield  = [self leftTextField];
    if ([text isEqualToString:@""]) {
        leftTextfield.text = @"";
        rightTextField.text = @"";
        return;
    }
    //
    IDCMCoinModel * currentPairModel = [self currentPairCoinModel];
    NSDecimalNumber * leftPrice =nil;
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:text];
    NSDecimalNumber *rate = currentPairModel.exchangeRateDecimalNumber;
    if (!rate)  return;
    //左边的textfield
    if (tag.integerValue == 301) {
        leftPrice =price;
    }else if(tag.integerValue == 304){
        leftPrice = [price  decimalNumberByDividingBy:rate];
    }
    if (self.viewModel.realityBalance.floatValue<=currentPairModel.exchangeMin.floatValue) {
        
        NSDecimalNumber *leftNum = currentPairModel.exchangeMinDecimalNumber;
        leftTextfield.text = currentPairModel.exchangeMinString;
        NSString *rightRealNum = [NSString stringFromNumber:[leftNum  decimalNumberByMultiplyingBy:rate] fractionDigits:[self rightDigit]];
        rightTextField.text = rightRealNum ;
        [self setExchangeBtnEnable:YES];
        
        return;
    }
    if (leftPrice.floatValue>=MIN(self.viewModel.realityBalance.floatValue, currentPairModel.exchangeMax.floatValue)) {
        //超过特定值
        if (self.viewModel.realityBalance.floatValue>currentPairModel.exchangeMax.floatValue) {
            
            if (leftPrice.floatValue>=currentPairModel.exchangeMax.floatValue) {
                NSDecimalNumber *leftNum = [currentPairModel exchangeMaxDecimalNumber];
                leftTextfield.text = currentPairModel.exchangeMaxString ;
                NSString *rightRealNum = [NSString stringFromNumber:[leftNum  decimalNumberByMultiplyingBy:rate] fractionDigits:[self rightDigit]];
                rightTextField.text = rightRealNum;
                [self setExchangeBtnEnable:YES];
                return;
            }
        }else{
            if (leftPrice.floatValue>=self.viewModel.realityBalance.floatValue) {

                NSString * realityBalance = [NSString stringFromNumber:self.viewModel.realityBalance fractionDigits:[self leftDigit]];
                leftTextfield.text =  realityBalance ;
                NSString *rightRealNum = [NSString stringFromNumber:[self.viewModel.realityBalance  decimalNumberByMultiplyingBy:rate] fractionDigits:[self rightDigit]];
                rightTextField.text = rightRealNum;
                [self setExchangeBtnEnable:YES];
                
                return;
            }
        }
    }else{
        if([leftPrice  floatValue]<currentPairModel.exchangeMin.floatValue){
            
            if ([leftPrice  floatValue] != 0) {
                NSDecimalNumber *leftNum = [currentPairModel exchangeMinDecimalNumber];
                leftTextfield.text = currentPairModel.exchangeMinString;
                NSString *rightRealNum = [NSString stringFromNumber:[leftNum  decimalNumberByMultiplyingBy:rate] fractionDigits:[self rightDigit]];
                rightTextField.text = rightRealNum;
                [self setExchangeBtnEnable:YES];
                
                return;
            }
        }else{
            if (tag.integerValue == 304) {
                NSString * numStr = [NSString stringFromNumber:leftPrice fractionDigits:[self leftDigit]];
                leftTextfield.text = numStr;
            }
            if (tag.integerValue == 301 ) {
                NSString *realNum = [NSString stringFromNumber:[leftPrice decimalNumberByMultiplyingBy:rate] fractionDigits:[self rightDigit]];
                rightTextField.text = realNum;
            }
            [self setExchangeBtnEnable:YES];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (self.isRrefreshing) {
        return NO;
    }
    // . ,
    if (textField.text.length == 0 ) {
        if ([string isEqualToString:@","] || [string isEqualToString:@"."]) {
            return NO;
        }
    }
    //删除到空
    NSInteger dotNum= 0;
    if (textField.tag == 301) {

       dotNum= [self leftDigit] +1 ;
    }else if (textField.tag == 304){

        dotNum = [self rightDigit] + 1;
    }
    if (dotNum == 1 &&([string isEqualToString:@","] ||[string isEqualToString:@"."] )) {
        return NO;
    }
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //处理越南语的情况
    if ([textField.text containsString:@","]&&[string isEqualToString:@","]) {
        return NO;
    }
    if ([textField.text isEqualToString:@""]&&[string isEqualToString:@","]) {
        return NO;
    }
    if ([textField.text containsString:@"."] &&[string isEqualToString:@","]) {
        return NO;
    }
    if ([textField.text containsString:@"."]&&[string isEqualToString:@"."]) {
        return NO;
    }
    if ([textField.text isEqualToString:@""]&&[string isEqualToString:@"."]) {
        return NO;
    }
    if ([string isEqualToString:@","]) {

        textField.text = [text stringByReplacingOccurrencesOfString:@"," withString:@"."];
        return NO;
    }
    if ([textField.text containsString:@"."]) {
        if ([string isEqualToString:@"."]) {
            return NO ;
        }else{
            if (![string isEqualToString:@""]) { //輸入
                NSRange range = [text rangeOfString:@"."];
                NSString * substr;
                if (range.location!= NSNotFound) {
                    substr = [text substringFromIndex:range.location];
                }
                if (substr.length>dotNum) {
                    return NO;
                }else{
                    return YES;
                }
                return YES;

            }else{ //刪除
                return YES;
            }
        }
    }else{
        return YES;
    }
}
#pragma mark - 选择币种兑换的view代理

-(void)iconWindow:(IDCMChooseBTypeView *)iconView clickedButtonAtIndex:(NSIndexPath *)index selectIndex:(NSIndexPath *)select
{
    [self resizeTextFieldAndLabel:NO];
    NSInteger  tag = iconView.tag;
    if (tag == 401) {    //左边
        [self judgeLeftAndRight: YES clickedButtonAtIndex:index selectIndex:select];
    }else if(tag == 402 ){//右边

        [self judgeLeftAndRight: NO clickedButtonAtIndex:index selectIndex:select];
    }
    IDCMCoinModel * currentPair = [self currentPairCoinModel];
    NSString * text =self.balanceLabel.text;
    if(text.length>0 && ![text containsString:currentPair.coinLabelUppercaseString]){
        self.balanceLabel.text = [NSString idcw_stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"3.0_CanExchangeOutBalance", nil),@"0",[self exCurrenLeftSelectCoinModel].coinLabelUppercaseString];
        [self refreshBalance:YES];
    }
    //
    
    //置空
    [self resetTextFieldAndExchangeBtn];
    //更新界面
    //去请求 可用余额
    [self loadRate];

}

-(void)judgeLeftAndRight:(BOOL) left clickedButtonAtIndex:(NSIndexPath *)index selectIndex:(NSIndexPath *)select {

    NSMutableArray<IDCMCoinModel *> * arr = self.currentShowChooseArr;
    IDCMCoinModel * lastSelectModel = arr[select.row];
    lastSelectModel.isSelect = NO;
    IDCMCoinModel *  selectModel = arr[index.row];
    selectModel.isSelect = YES;

    if (left) {
        
        if (!self.exchangeLeftRight) {
            
            if ([selectModel.coinLabel isEqualToString: self.currentSelectCoinModelRight.coinLabel]) {
            
                self.currentSelectCoinModelRight = lastSelectModel.mutableCopy;
                
            }else{
                
                if (![self.viewModel getCurrentCoinPair:selectModel.coinLabel withRight:self.currentSelectCoinModelRight.coinLabel]) {
                    IDCMCoinModel * defaultModel = [[self.viewModel.defaultCoinListModel.fromCoinModel.coinLabel lowercaseString] isEqualToString:@"btc"] ? self.viewModel.defaultCoinListModel.fromCoinModel.mutableCopy :self.viewModel.defaultCoinListModel.toCoinModel.mutableCopy;
                    self.currentSelectCoinModelRight = defaultModel;
                }
            }
        }else{
            if ([selectModel.coinLabel isEqualToString: self.currentSelectCoinModelRight.coinLabel]) {
                
                self.currentSelectCoinModelRight = lastSelectModel.mutableCopy;
            }
            
        }
        self.currentSelectCoinModelLeft = selectModel;
  
    }else{
        
        if (!self.exchangeLeftRight) {
            
            if ([selectModel.coinLabel isEqualToString:self.currentSelectCoinModelLeft.coinLabel]) {
                self.currentSelectCoinModelLeft = lastSelectModel.mutableCopy;
            }
            self.currentSelectCoinModelRight = selectModel;

        }else{
            
            if ([selectModel.coinLabel isEqualToString:self.currentSelectCoinModelLeft.coinLabel]) {
                self.currentSelectCoinModelLeft = lastSelectModel.mutableCopy;
            }else{
                
                if (![self.viewModel getCurrentCoinPair:selectModel.coinLabel withRight:self.currentSelectCoinModelLeft.coinLabel]) {
                    IDCMCoinModel * defaultModel = [[self.viewModel.defaultCoinListModel.fromCoinModel.coinLabel lowercaseString] isEqualToString:@"btc"] ? self.viewModel.defaultCoinListModel.fromCoinModel.mutableCopy :self.viewModel.defaultCoinListModel.toCoinModel.mutableCopy;
                    self.currentSelectCoinModelLeft = defaultModel;
                }
            }
            self.currentSelectCoinModelRight = selectModel;
        }
    }
}
#pragma mark - getter

//左边
-(UITextField *)leftTextField{
    return [self.view viewWithTag:301];
}
//右边
-(UITextField *)rightTextField{
    return [self.view viewWithTag:304];
}
-(UILabel *)leftViewLabel{
    return [self.view viewWithTag:302];
}
-(UILabel *)rightViewLabel {
   return  [self.view viewWithTag:305];
}
////取左边当前选中的币
-(IDCMCoinModel *)exCurrenLeftSelectCoinModel {

    if (self.exchangeLeftRight) {
        return self.currentSelectCoinModelRight;
    }
    return self.currentSelectCoinModelLeft;
}
//
//取右边边当前选中的币
-(IDCMCoinModel *)exCurrenRightSelectCoinModel {

    if (self.exchangeLeftRight) {
        return self.currentSelectCoinModelLeft;
    }
    return self.currentSelectCoinModelRight;
}
//
//当前的弹出框

-(IDCMAlertWindow *)showWindow {

    if (!_showWindow) {
        _showWindow = [[IDCMAlertWindow alloc] init];
    }
    return _showWindow;
}

-(void)setExchangeBtnEnable:(BOOL)exchangeBtnEnable
{
    _exchangeBtnEnable=exchangeBtnEnable;
    if (_exchangeBtnEnable) {
        self.exchangeButton.enabled = _exchangeBtnEnable;
        self.exchangeButton.backgroundColor = [UIColor colorWithHexString:@"#2E406B"];
        self.exchangeButton.titleLabel.alpha = 1;
    }else{

        self.exchangeButton.enabled = _exchangeBtnEnable;
        self.exchangeButton.backgroundColor = [UIColor colorWithHexString:@"#999FA5"];
        self.exchangeButton.titleLabel.alpha = 0.5;
    }
}
////
-(void)setCurrentSelectCoinModelLeft:(IDCMCoinModel *)currentSelectCoinModelLeft{

    _currentSelectCoinModelLeft = currentSelectCoinModelLeft;
    [tapeBViewLeft setCurrentModel:currentSelectCoinModelLeft];
    [self changeLabelStr:self.exchangeLeftRight];
}
////
-(void)setCurrentSelectCoinModelRight:(IDCMCoinModel *)coinModelRight{
    _currentSelectCoinModelRight = coinModelRight;
    [tapeBViewRight setCurrentModel:coinModelRight];
    [self changeLabelStr:self.exchangeLeftRight];
}
////是否交换
-(void)setExchangeLeftRight:(BOOL)change
{
    _exchangeLeftRight = change;
    [self changeLabelStr:change];
}

//换了位置
-(void)changeLabelStr:(BOOL) change{
    UILabel *  rightLabel = [self.view viewWithTag:305];
    UILabel *  leftLabel = [self.view viewWithTag:302];
    if (change) {
        leftLabel.text =self.currentSelectCoinModelRight.coinLabelUppercaseString;
        rightLabel.text = self.currentSelectCoinModelLeft.coinLabelUppercaseString;
    }else{
        leftLabel.text = self.currentSelectCoinModelLeft.coinLabelUppercaseString;
        rightLabel.text =  self.currentSelectCoinModelRight.coinLabelUppercaseString;
    }
}

//获取当前的交易对
-(IDCMCoinModel *)currentPairCoinModel{
    
    NSString * leftCoinLabel = [self exCurrenLeftSelectCoinModel].coinLabel;
    NSString * rightCoinLabel = [self exCurrenRightSelectCoinModel].coinLabel;
    IDCMCoinModel * currentPair = [self.viewModel getCurrentCoinPair:leftCoinLabel withRight:rightCoinLabel];
    return currentPair;
}
//当前的交易对 左边的精度
-(NSInteger )leftDigit{
    
    return [self currentPairCoinModel].digit;
}
//当前的交易对 右边的精度
-(NSInteger )rightDigit{
    
    return [self currentPairCoinModel].pairDigit;
}
//当前的交易对 左边兑右边兑率的精度
-(NSInteger )rateDigit{
    return [self currentPairCoinModel].rateDigit;
}

#pragma  mark - 懒加载
-(NSMutableArray *)supportExchangeArr{
    if (!_supportExchangeArr) {
        _supportExchangeArr = [NSMutableArray new];
    }
    return _supportExchangeArr;
}

-(UIView *)backGroundScrollView{
    if (!_backGroundScrollView) {
        _backGroundScrollView = [[UIView alloc] init];
        _backGroundScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _backGroundScrollView;
}

-(UIActivityIndicatorView * )loadingView{
    if(!_loadingView){
        
       UIActivityIndicatorView * view =  [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.color = kThemeColor;
        view.hidesWhenStopped = YES;
        _loadingView = view;
    }
    return _loadingView;
}

-(UIButton *)exchangeButton{
    if (!_exchangeButton) {
        _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exchangeButton setTitle:NSLocalizedString(@"3.0_Exchange", nil) forState:UIControlStateNormal];
        [_exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _exchangeButton.titleLabel.font = SetFont(@"PingFangSC-Regular", 16);
        _exchangeButton.layer.cornerRadius = 5;
        _exchangeButton.titleLabel.alpha = 0.5;
        _exchangeButton.clipsToBounds = YES;
        _exchangeButton.enabled = NO;
        _exchangeButton.backgroundColor = [UIColor colorWithHexString:@"#999FA5"];
        [_exchangeButton addTarget:self action:@selector(exchangeBB:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeButton;
}

-(void)invalidateTimer{
    if (self.requestCoinListTimer) {
        dispatch_source_cancel(self.requestCoinListTimer);
        self.requestCoinListTimer = NULL;
    }
}

-(void)dealloc{
    DDLogDebug(@"%@___dealloc",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self invalidateTimer];
}

@end
