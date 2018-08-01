//
//  IDCMOTCAcceptanceOrderDetailController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//  承兑商订单详情

#import "IDCMOTCAcceptanceOrderDetailController.h"
#import "IDCMOTCACceptanceOrederDetailViewModel.h"
#import "IDCMOTCAcceptanceOrderDetailHeaderView.h"
#import "IDCMOTCAcceptanceOrderDetailInfoView.h"
#import "IDCMOTCAcceptanceOrderDetailPriceView.h"
#import "IDCMOTCAcceptanceOrderDetailTipsView.h"
#import "IDCMOTCAcceptanceOrderDetailOfferView.h"
#import "IDCMPTCConfirmQuoteOrderModel.h"

@interface IDCMOTCAcceptanceOrderDetailController ()<UITextFieldDelegate>
/**
 *  viewModel
 */
@property (strong, nonatomic) IDCMOTCACceptanceOrederDetailViewModel *viewModel;
/**
 *  头部剩余时间
 */
@property (strong, nonatomic) IDCMOTCAcceptanceOrderDetailHeaderView *headerView;
/**
 *  中间买卖家信息
 */
@property (strong, nonatomic) IDCMOTCAcceptanceOrderDetailInfoView *infoVIew;
/**
 *  价格view
 */
@property (strong, nonatomic) IDCMOTCAcceptanceOrderDetailPriceView *priceView;
/**
 *  市场价格
 */
@property (strong, nonatomic) IDCMOTCAcceptanceOrderDetailTipsView *lastPriceView;
/**
 *  总价
 */
@property (strong, nonatomic) IDCMOTCAcceptanceOrderDetailTipsView *totalPriceView;
/**
 *  报价
 */
@property (strong, nonatomic) IDCMOTCAcceptanceOrderDetailOfferView *offerView;
/**
 *  买卖按钮
 */
@property (strong, nonatomic) UIButton *buyOrSellButton;
/**
 *  订单确认Disposable
 */
@property (strong, nonatomic) RACDisposable *confirmQuoteDisposable;
/**
 *  状态变换Disposable
 */
@property (strong, nonatomic) RACDisposable *statusDisposable;
/**
 *  倒计时
 */
@property (assign, nonatomic) NSInteger restTime;
/**
 *  是否已经报价
 */
@property (assign, nonatomic) BOOL isQute;
@end

@implementation IDCMOTCAcceptanceOrderDetailController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [IDCMCenterTipView dismissWithCompletion:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self.confirmQuoteDisposable dispose];
    [self.statusDisposable dispose];

}
- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    CGFloat height;
    if ([[IDCMUtilsMethod getPreferredLanguage] isEqualToString:@"zh-Hans"] || [[IDCMUtilsMethod getPreferredLanguage] isEqualToString:@"zh-Hant"]) {
        height = 80+kSafeAreaTop;
    }else{
        height = 90+kSafeAreaTop;
    }
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(height);
    }];
    [self.infoVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
        make.height.mas_equalTo(138);
    }];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(14);
        make.right.equalTo(self.view.mas_right).offset(-14);
        make.top.equalTo(self.infoVIew.mas_bottom).offset(10);
        make.height.mas_equalTo(95);
    }];
    [self.lastPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(24);
        make.right.equalTo(self.view.mas_right).offset(-24);
        make.top.equalTo(self.infoVIew.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
    }];
    [self.offerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(14);
        make.right.equalTo(self.view.mas_right).offset(-14);
        make.top.equalTo(self.lastPriceView.mas_bottom).offset(10);
        make.height.mas_equalTo(70);
    }];
    [self.totalPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.right.equalTo(self.view.mas_right).offset(-24);
        make.top.equalTo(self.offerView.mas_bottom).offset(10);
        make.height.mas_equalTo(28);
    }];
    [self.buyOrSellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(14);
        make.right.equalTo(self.view.mas_right).offset(-14);
        make.top.equalTo(self.totalPriceView.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

}

#pragma mark - Bind
- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    [self configData];
    
    // 单价
    RAC(self.viewModel,unitPrice) = [[self.offerView.numTextField.rac_textSignal merge:RACObserve(self.offerView.numTextField, text)] map:^id _Nullable(NSString *value) {
        @strongify(self);
        NSDecimalNumber *unit = [IDCMUtilsMethod getStringDecimalNumber:value];
        NSDecimalNumber *total = [unit decimalNumberByMultiplyingBy:self.viewModel.model.Num];
        NSString *totalStr = [NSString stringFromNumber:total fractionDigits:4];
        self.viewModel.totalPrice = [NSDecimalNumber decimalNumberWithString:totalStr];
        self.totalPriceView.contentLabel.text = [NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod separateNumberUseCommaWith:totalStr]];
        return unit;
    }];

    
    [[self.viewModel.validPriceSignal deliverOnMainThread]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         if ([value integerValue] == 0) {
             self.buyOrSellButton.enabled = NO;
             [self.buyOrSellButton setBackgroundColor:kSubtopicGrayColor];
         }else{
             self.buyOrSellButton.enabled = YES;
             [self.buyOrSellButton setBackgroundColor:kThemeColor];
         }
     }];
    
    // 点击买卖按钮
    [[[self.buyOrSellButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         
         @strongify(self);
         [self.view endEditing:YES];
         
         if ([self.viewModel.totalPrice isEqualToNumber:@(0)]) {
             [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_TotalPriceNotZeor")];
             return ;
         }
         
         NSString *title = @"";
         if (self.viewModel.model.Direction == 1) { // 用户下买单
             title = SWLocaloziString(@"3.0_Bin_ConfirmSell");
         }else{  // 用户下卖单
             title = SWLocaloziString(@"3.0_Bin_ConfirmBuy");
         }
         [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
             
             configure.getBtnsConfig.firstObject.btnTitle(SWLocaloziString(@"3.0_Bin_CancelSellOrBuy"));
             configure.getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_Bin_ConfirmSellOrBuy")).btnCallback(^{
                 @strongify(self);
                 NSDictionary *dic = @{@"OrderId":@(self.viewModel.model.OrderID),
                                       @"QuotePrice": self.viewModel.totalPrice
                                       };
                 [self.viewModel.quotePriceCommand execute:dic];
                 
             });
             configure.title(title);
         }];
     }];
    
    // 监听承兑商报价
    [[self.viewModel.quotePriceCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(NSDictionary *value) {
         
         @strongify(self);
         NSString *status = [NSString idcw_stringWithFormat:@"%@",value[@"status"]];

         if ([status isEqualToString:@"1"] && [value[@"data"] isKindOfClass:[NSDictionary class]]) {
             
             
             [self didOffer];
             
             RACTuple *tupe = RACTuplePack(self.viewModel.model.CurrencyName,self.viewModel.unitPrice,self.viewModel.totalPrice);
             [self.priceView.dataSubject sendNext:tupe];
             
             if (self.completion) {
                 NSDictionary *para = @{@"OrderID":@(self.viewModel.model.OrderID)};
                 self.completion(para);
             }
             NSString *tips = @"";
             if (self.viewModel.model.Direction == 1) {
                 tips = SWLocaloziString(@"3.0_Bin_TheBuyer");
             }else{
                 tips = SWLocaloziString(@"3.0_Bin_TheSeller");
             }
             RACTuple *timeTupe = RACTuplePack(tips);
             [self.headerView.dataSubject sendNext:timeTupe];
             
         }else if ([status isEqualToString:@"611"]){
             [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_TokenWalletInsuff")];
         }else{
             [IDCMShowMessageView showMessageWithCode:status];
         }
     }];
    
    //订单确认通知到承兑商
    self.confirmQuoteDisposable = [[IDCMOTCSignalRTool sharedOTCSignal].confirmQuoteOrderSubject subscribeNext:^(NSDictionary *response) {
        @strongify(self);
        IDCMPTCConfirmQuoteOrderModel *model = [IDCMPTCConfirmQuoteOrderModel yy_modelWithJSON:response];
        if (!model) {
            return ;
        }
        if(model.OrderId != self.viewModel.model.OrderID){
            return;
        }
        NSInteger acceptantUserId = model.AcceptantUserId;
        if (self.viewModel.model.AcceptantId == acceptantUserId) {
            
            NSMutableArray *arr = self.navigationController.viewControllers.mutableCopy;
            [arr removeLastObject];
            [self.navigationController setViewControllers:arr.copy];
            NSDictionary *dict = @{@"orderId" :@(self.viewModel.model.OrderID)};
            [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMOTCExchangeDetailController"
                                                   withViewModelName:@"IDCMOTCExchangeDetailViewModel"
                                                          withParams:dict
                                                            animated:YES];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    //订单状态变更通知到承兑商
    self.statusDisposable = [[[RACSignal merge: @[[IDCMOTCSignalRTool sharedOTCSignal].otcOrderStatusChangeSubject,
                                                    [IDCMDataManager sharedDataManager].oneSecondSubject]]
                                bufferWithTime:0 onScheduler: [RACScheduler mainThreadScheduler]]
                               subscribeNext: ^(RACTuple *tupe) {
                                   @strongify(self);
                                   NSUInteger count = tupe.count;
                                   if (count == 1) {
                                       if ([tupe.first isKindOfClass:[NSNumber class]]) {
                                           
                                           if (self.restTime < 0) {
                                               return;
                                           }
                                           if (self.restTime == 0) {
                                               
                                               if (self.isQute) {
                                                   [self showTimeOutTipView:SWLocaloziString(@"3.0_Bin_NotChosse")];
                                               }else{
                                                   [self showTimeOutTipView:@""];
                                               }
                                               
                                           }
                                           if (self.restTime > 0) {
                                               
                                           }
                                           RACTuple *timeTupe = RACTuplePack(@(self.restTime));
                                           [self.headerView.dataSubject sendNext:timeTupe];
                                           self.restTime -= 1;
                                           
                                       }else if([tupe.first isKindOfClass:[NSDictionary class]]){
                                           
                                           NSDictionary *dic = tupe.first;
                                           NSString *OrderID = [NSString idcw_stringWithFormat:@"%@",dic[@"OrderID"]];
                                           if (self.restTime > 0 && [OrderID integerValue] == self.viewModel.model.OrderID) {
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }
                                           
                                       }
                                       
                                   }
                                   
                               }];
    
    self.offerView.numTextField.delegate = self;
    
}

#pragma mark - Public Methods
- (void)showTimeOutTipView:(NSString *)subTitle{
    @weakify(self);
    [self.view endEditing:YES];
    NSString *title = SWLocaloziString(@"3.0_Bin_RestTimeOver");
    [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
        [configure.getBtnsConfig removeFirstObject];
        configure
        .image(@"3.2_时间到")
        .title(title)
        .subTitle(subTitle)
        .getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"2.0_gongxiButton")).btnCallback(^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark - Privater Methods
- (void)configUI{
    
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = UIColorWhite;
    
}
- (void)configData{
    
    // 头部
    NSString *tips = [SWLocaloziString(@"3.0_Bin_RestTimeTips") stringByReplacingOccurrencesOfString:@"[IDCW]" withString:[NSString idcw_stringWithFormat:@"%ld",(long)self.viewModel.model.defDeadLineSeconds]];
    RACTuple *timeTupe = RACTuplePack(@(self.viewModel.model.DeadLineSeconds),tips);
    self.restTime = MAX(0, self.viewModel.model.DeadLineSeconds);
    [self.headerView.dataSubject sendNext:timeTupe];
    
    NSString *title = @"";
    NSString *responeTime = @"";
    NSString *coleectionTime = @"";
    NSDecimalNumber *coinNum = [NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:self.viewModel.model.Num]];
    NSString *num = [NSString stringFromNumber:coinNum fractionDigits:4];
    if (self.viewModel.model.Direction == 1) {
        [self.buyOrSellButton setTitle:SWLocaloziString(@"3.0_Bin_SellHe") forState:UIControlStateNormal];
        title = [NSString idcw_stringWithFormat:@"%@ %@ %@",SWLocaloziString(@"3.0_Bin_Buy"),[IDCMUtilsMethod separateNumberUseCommaWith:num],[self.viewModel.model.CoinCode uppercaseString]];
        responeTime = [IDCMUtilsMethod getTimeWithSeconds:self.viewModel.model.UserAvgPayTime];
        coleectionTime = [IDCMUtilsMethod getTimeWithSeconds:self.viewModel.model.UserAvgBuyinTime];
    }else{
        [self.buyOrSellButton setTitle:SWLocaloziString(@"3.0_Bin_BuyHe") forState:UIControlStateNormal];
        title = [NSString idcw_stringWithFormat:@"%@ %@ %@",SWLocaloziString(@"3.0_Bin_Sell"),[IDCMUtilsMethod separateNumberUseCommaWith:num],[self.viewModel.model.CoinCode uppercaseString]];
        responeTime = [IDCMUtilsMethod getTimeWithSeconds:self.viewModel.model.UserAvgConfirmReceiveTime];
        coleectionTime = [IDCMUtilsMethod getTimeWithSeconds:self.viewModel.model.UserAvgSelloutTime];
    }
    
    // 买卖家信息
    IDCMOTCAcceptanceOrderDetailInfoModel *model = [IDCMOTCAcceptanceOrderDetailInfoModel new];
    model.type = self.viewModel.model.Direction;
    model.title = title;
    model.user = self.viewModel.model.UserName;
    model.countNum = [NSString stringWithFormat:@"%ld",(long)self.viewModel.model.UserAppealCount];
    model.payResponeTime = responeTime;
    model.buyColeectionTime = coleectionTime;
    model.payLogo = self.viewModel.model.PayLogo;
    [self.infoVIew.dataSubject sendNext:model];
    
    
    // 市场价格信息
    NSString *lastPrice = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:self.viewModel.model.LastPrice]] fractionDigits:4];
    self.lastPriceView.contentLabel.text = [NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod separateNumberUseCommaWith:lastPrice]];
    self.lastPriceView.currencyLabel.text = self.viewModel.model.CurrencyName;
    
    // 报价信息
    NSString *p = [IDCMUtilsMethod precisionControl:self.viewModel.model.Premium];
    NSDecimalNumber *premium = [[NSDecimalNumber decimalNumberWithString:p] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    NSDecimalNumber *calculatePremium = [self.viewModel.model.Premium decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]];
    NSDecimalNumber *offerPirce = [calculatePremium decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:lastPrice]];
    NSString *premiumStr = @"";
    if ([premium compare:@(0)] == NSOrderedSame) { // 溢价为0
        premiumStr = @"0%";
    }else if ([premium compare:@(0)] == NSOrderedAscending){  // 溢价为负数
        premiumStr = [NSString idcw_stringWithFormat:@"%@%%",premium];
    }else{ // 溢价为正数
        premiumStr = [NSString idcw_stringWithFormat:@"+%@%%",premium];
    }
    NSString *premiumText = [SWLocaloziString(@"3.0_BinBear_PremiumPrice") stringByReplacingOccurrencesOfString:@"[IDCW]" withString:[NSString idcw_stringWithFormat:@"%@",premiumStr]];
    self.offerView.subTitleLabel.text = premiumText;
    self.offerView.contentLabel.text = self.viewModel.model.CurrencyName;
    self.offerView.numTextField.text = [NSString stringFromNumber:offerPirce fractionDigits:4];
    
    // 总价
    NSDecimalNumber *total = [offerPirce decimalNumberByMultiplyingBy:coinNum];
    self.viewModel.totalPrice = total;
    NSString *totalPrice = [NSString stringFromNumber:total fractionDigits:4];
    self.totalPriceView.contentLabel.text = [NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod separateNumberUseCommaWith:totalPrice]];
    self.totalPriceView.currencyLabel.text = self.viewModel.model.CurrencyName;
    

    if (self.viewModel.model.didOffer) {
        [self didOffer];
    }else{
        self.isQute = NO;
        self.priceView.hidden = YES;
    }
    [self.offerView.numTextField becomeFirstResponder];
}
- (void)didOffer{
    self.isQute = YES;
    self.priceView.hidden = NO;
    self.buyOrSellButton.hidden = YES;
    self.lastPriceView.hidden = YES;
    self.totalPriceView.hidden = YES;
    self.offerView.hidden = YES;
}
#pragma mark - Action


#pragma mark - NetWork


#pragma mark - Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
        
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField.text containsString:@","] && [string isEqualToString:@","]) {
        
        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_Bin_InputPriceorrect", nil)];
        
        return NO;
    }
    if ([textField.text isEqualToString:@""] && [string isEqualToString:@","]) {
        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_Bin_InputPriceorrect", nil)];
        return NO;
    }
    if ([textField.text containsString:@"."] && [string isEqualToString:@","]) {
        
        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_Bin_InputPriceorrect", nil)];
        return NO;
    }
    
    
    if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_Bin_InputPriceorrect", nil)];
        return NO;
    }
    if ([textField.text isEqualToString:@""] && [string isEqualToString:@"."]) {
        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_Bin_InputPriceorrect", nil)];
        return NO;
    }
    if ([string isEqualToString:@","]) {
        
        textField.text = [toBeString stringByReplacingOccurrencesOfString:@"," withString:@"."];
        return NO;
    }
    
    //保留精度位数，两位
    NSInteger dotNum= 3;
    
    if (dotNum == 1 && ([string isEqualToString:@","] ||[string isEqualToString:@"."] )) {
        return NO;
    }
    if ([textField.text containsString:@"."]) {
        if ([string isEqualToString:@"."]) {
            return NO ;
        }else{
            if (![string isEqualToString:@""]) { //輸入
                NSRange range = [toBeString rangeOfString:@"."];
                NSString * substr;
                if (range.location!= NSNotFound) {
                    substr = [toBeString substringFromIndex:range.location];
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

#pragma mark - Getter & Setter
- (IDCMOTCAcceptanceOrderDetailHeaderView *)headerView{
    
    return SW_LAZY(_headerView, ({
        IDCMOTCAcceptanceOrderDetailHeaderView *view = [IDCMOTCAcceptanceOrderDetailHeaderView new];
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMOTCAcceptanceOrderDetailInfoView *)infoVIew{
    
    return SW_LAZY(_infoVIew, ({
        IDCMOTCAcceptanceOrderDetailInfoView *view = [IDCMOTCAcceptanceOrderDetailInfoView new];
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMOTCAcceptanceOrderDetailPriceView *)priceView{
    
    return SW_LAZY(_priceView, ({
        IDCMOTCAcceptanceOrderDetailPriceView *view = [IDCMOTCAcceptanceOrderDetailPriceView new];
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMOTCAcceptanceOrderDetailTipsView *)lastPriceView{
    
    return SW_LAZY(_lastPriceView, ({
        IDCMOTCAcceptanceOrderDetailTipsView *view = [IDCMOTCAcceptanceOrderDetailTipsView new];
        view.titleLabel.text = SWLocaloziString(@"3.0_BinBear_LastPrice");
        view.subTitleLabel.text = SWLocaloziString(@"3.0_BinBear_Price");
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMOTCAcceptanceOrderDetailTipsView *)totalPriceView{
    
    return SW_LAZY(_totalPriceView, ({
        IDCMOTCAcceptanceOrderDetailTipsView *view = [IDCMOTCAcceptanceOrderDetailTipsView new];
        view.titleLabel.text = SWLocaloziString(@"3.0_BinBear_TotalPrice");
        view.subTitleLabel.text = SWLocaloziString(@"3.0_BinBear_PriceNum");
        view.contentLabel.font = textFontPingFangMediumFont(20);
        view.currencyLabel.font = textFontPingFangMediumFont(12);
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMOTCAcceptanceOrderDetailOfferView *)offerView{
    
    return SW_LAZY(_offerView, ({
        IDCMOTCAcceptanceOrderDetailOfferView *view = [IDCMOTCAcceptanceOrderDetailOfferView new];
        view.titleLabel.text = SWLocaloziString(@"3.0_BinBear_YouOffer");
        [self.view addSubview:view];
        view;
    }));
}
- (UIButton *)buyOrSellButton
{
    return SW_LAZY(_buyOrSellButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = textFontPingFangRegularFont(16);
        [button setBackgroundColor:kThemeColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.enabled = NO;
        [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}
@end
