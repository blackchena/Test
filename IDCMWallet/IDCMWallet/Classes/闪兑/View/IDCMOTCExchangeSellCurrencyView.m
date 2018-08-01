//
//  IDCMOTCExchangeSellCurrencyView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCExchangeSellCurrencyView.h"
#import "IDCMOTCExchangeSellCurrencyViewModel.h"
#import "IDCMChooseBTypeView.h"
#import "IDCMOrderResultModel.h"
#import "IDCMSysSettingModel.h"
#import "IDCMFlashExchangeViewModel.h"
#import "IDCMCoinListModel.h"
#import "IDCMSelectPayMethodsView.h"
#import "IDCMCustomerTextField.h"

@interface IDCMOTCExchangeSellCurrencyView ()<IconWindowDelegate,QMUITextFieldDelegate>
@property (nonatomic,strong) UIImageView *backImageView;

/**
 买、卖出币种
 */

@property (nonatomic,strong) UILabel *sellCurrencyLabel;
@property (nonatomic,strong) UILabel *sellCurrencyTextField;
/**
 买、卖出数量
 */

@property (nonatomic,strong) UILabel *sellCountLabel;
@property (nonatomic,strong) IDCMCustomerTextField *sellCountTextField;///< 数量
@property (nonatomic,strong) UILabel *sellCountCurrencyNameLabel; ///< 单位


/**
 买卖 法币
 */
@property (nonatomic,strong) UILabel *payCurrencyLabel;
@property (nonatomic,strong) UILabel *payCurrencyTextField;


/**
 支付方式
 */
@property (nonatomic,strong) UILabel *payMethodLabel;
@property (nonatomic,strong) UILabel *payMethodTextField;


/**
 协议 View
 */
@property (nonatomic,strong) UIView *ruleView;

@property (nonatomic,strong) UIButton *rulebtn;

/**
  买卖 按钮
 */
@property (nonatomic,strong) UIButton *sellBtn;

/**
 选中 index 
 */
@property (nonatomic,assign) NSInteger currentSelectViewIndex;


@property (nonatomic,strong) IDCMOTCExchangeSellCurrencyViewModel *viewModel;

@property (nonatomic,strong) IDCMFlashExchangeViewModel * bbViewModel;

/**
 币 数据
 */
@property (nonatomic,strong) NSArray * coinList;

/**
 法币数据
 */
@property (nonatomic,strong) NSArray * currencyList;

/**
  支付方式 数据
 */
@property(nonatomic,strong)NSArray * paymentList ;
/**
 配置信息 Model
 */
@property(nonatomic,strong)IDCMOTCSettingModel * settingModel ;


/**
 当前选择 的CoinModel
 */
@property(nonatomic,strong)IDCMOTCCionModel * otcCoinModel ;


/**
 当前选择 币Model
 */
@property(nonatomic,strong)IDCMOTCCurrencyModel * otcCurrencyModel ;

/**
 当前支付方式Model
 */
@property(nonatomic,strong)IDCMOTCPaymentModel * paymentModel ;


/**
 基本配置信息
 */
@property(nonatomic,strong)IDCMSysSettingModel * sysSettingModel ;

@property(nonatomic,strong)NSNumber * isAgreeProtocol ;

/**
 协议按钮
 */
@property(nonatomic,strong)UIButton * agreeBtn;

/**
 查看协议内容
 */
@property(nonatomic,strong)UIButton * protocolBtn ;

/**
 是否 是点击支付方式  请求的交易配置信息 default: 1 coin币 2 法币 3 支付方式
 */
@property(nonatomic,assign)NSInteger isRequestByPayMethond ;


/**
 最小输入
 */
@property(nonatomic,strong)NSNumber * min;
/**
 最大输入
 */
@property(nonatomic,strong)NSNumber * max;

/**
 倒计时
 */
@property (strong,nonatomic)NSTimer * timer;

/**
 是否在输入数字
 */
@property(nonatomic,assign)BOOL isBeginEndit ;
/**
 *  是否设置支付方式
 */
@property (assign, nonatomic) BOOL isSetPay;
@end



@implementation IDCMOTCExchangeSellCurrencyView

+ (instancetype)OTCSellCurrencyViewViewModel:(IDCMOTCExchangeSellCurrencyViewModel *)viewModel {
    
    IDCMOTCExchangeSellCurrencyView *view = [[self alloc] init];
    view.viewModel = viewModel;
    [view initConfigre];
    return view;
}

- (void)initConfigre {
    [self configUI];
    [self configSingnal];
    [self configViewModel];
}

- (void)configViewModel {
    
    [self.sellCountTextField addTarget:self action:@selector(changedTextFieldValue:) forControlEvents:UIControlEventEditingChanged];
  
}
-(void)resetNewData{
    
    self.otcCoinModel = nil;
    self.paymentModel = nil;
    self.otcCurrencyModel = nil;
    self.isRequestByPayMethond = -1;
}
-(void)setPurchaseType:(PurchaseType)purchaseType{
    _purchaseType = purchaseType;
    self.isBeginEndit = NO;//重置 是否输入状态时候
    if (!self.isSetPay) {  // 如果是从设置支付方式控制器pop回来，不需要清除数据
        
        //清除之前选择的 Model的选中状态 再置空
        self.sellCountTextField.text = @"";
        [self endEditing:YES];
        for (IDCMOTCCurrencyModel * currencyModel in self.settingModel.Currencies) { //先将原来model选中状态变为NO,再置空Model
            
            if (self.otcCurrencyModel&&currencyModel.Id == self.otcCurrencyModel.Id) {
                currencyModel.isSelect = NO;
                self.otcCurrencyModel = nil;
            }
        }
        for (IDCMOTCCionModel * coinModel in self.settingModel.CoinSettings) { //记录上次选中的虚拟币
            if (self.otcCoinModel&&coinModel.CoinId == self.otcCoinModel.CoinId) {
                coinModel.isSelect = NO;
                self.otcCoinModel = nil;
            }
        }
        for (IDCMOTCPaymentModel * payModel in self.settingModel.Payments) { //清除上次选中 支付方式
            if (self.paymentModel&&payModel.ID == self.paymentModel.ID) {
                payModel.isSelected = NO;
                self.paymentModel = nil;
            }
        }
        if (purchaseType == BUYTYPE) {
            self.sellCurrencyLabel.text  = SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyType");
            self.sellCurrencyTextField.attributedText = [[NSMutableAttributedString alloc] initWithString:SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyTypePlacehoder") attributes:@{
                                                                                                                                                                                     NSFontAttributeName:textFontPingFangRegularFont(12.0f),
                                                                                                                                                                                     NSForegroundColorAttributeName:textColor999999
                                                                                                                                                                                     }];
            
            
            self.sellCountLabel.text = SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyCount");
            self.sellCountTextField.placeholder = SWLocaloziString(@"3.0_DK_enterNum");
            if ([self.sellCountTextField.rightView isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)self.sellCountTextField.rightView;
                label.text = @"";
            }
            NSMutableAttributedString * attributer = [[NSMutableAttributedString alloc] initWithString:self.sellCountTextField.placeholder attributes:@{
                                                                                                                                                        NSFontAttributeName:textFontPingFangRegularFont(12.0f),
                                                                                                                                                        NSForegroundColorAttributeName:textColor999999
                                                                                                                                                        
                                                                                                                                                        }];
            self.sellCountTextField.attributedPlaceholder  = attributer ;
            
            self.payCurrencyLabel.text = SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyPay");
            
            self.payCurrencyTextField.attributedText = [[NSMutableAttributedString alloc] initWithString:SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyPayPlacehoder") attributes:@{
                                                                                                                                                                                   NSFontAttributeName:textFontPingFangRegularFont(12.0f),
                                                                                                                                                                                   NSForegroundColorAttributeName:textColor999999
                                                                                                                                                                                   }];
            
            self.payMethodLabel.text = SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyPayMthod");
            
            self.payMethodTextField.attributedText = [[NSMutableAttributedString alloc] initWithString:SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyPayMthodPlacehoder") attributes:@{
                                                                                                                                                                                      NSFontAttributeName:textFontPingFangRegularFont(12.0f),
                                                                                                                                                                                      NSForegroundColorAttributeName:textColor999999
                                                                                                                                                                                      }];
            [self.sellBtn setTitle:NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyBtn", nil)
                          forState:UIControlStateNormal];
        }else{
            self.sellCurrencyLabel.text  = SWLocaloziString(@"3.0_OTCExchangeSellCurrencyType");
            self.sellCurrencyTextField.attributedText = [[NSMutableAttributedString alloc] initWithString:SWLocaloziString(@"3.0_OTCExchangeSellCurrencyTypePlacehoder") attributes:@{
                                                                                                                                                                                      NSFontAttributeName:textFontPingFangRegularFont(12.0f),
                                                                                                                                                                                      NSForegroundColorAttributeName:textColor999999
                                                                                                                                                                                      }];
            
            self.sellCountLabel.text = SWLocaloziString(@"3.0_OTCExchangeSellCurrencyCount");
            self.sellCountTextField.text = @"";
            self.sellCountTextField.placeholder = SWLocaloziString(@"3.0_DK_enterNum");
            NSMutableAttributedString * attributer = [[NSMutableAttributedString alloc] initWithString:self.sellCountTextField.placeholder attributes:@{
                                                                                                                                                        NSFontAttributeName:textFontPingFangRegularFont(12.0f),
                                                                                                                                                        NSForegroundColorAttributeName:textColor999999
                                                                                                                                                        }];
            self.sellCountTextField.attributedPlaceholder  = attributer ;
            if ([self.sellCountTextField.rightView isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)self.sellCountTextField.rightView;
                label.text = @"";
            }
            self.payCurrencyLabel.text = SWLocaloziString(@"3.0_OTCExchangeSellCurrencyPay");
            self.payCurrencyTextField.attributedText = [[NSMutableAttributedString alloc] initWithString:SWLocaloziString(@"3.0_OTCExchangeSellCurrencyPayPlacehoder") attributes:@{
                                                                                                                                                                                    NSFontAttributeName:textFontPingFangRegularFont(12.0f),
                                                                                                                                                                                    NSForegroundColorAttributeName:textColor999999
                                                                                                                                                                                    }];
            
            self.payMethodLabel.text = SWLocaloziString(@"3.0_OTCExchangeSellCurrencyPayMthod");
            self.payMethodTextField.attributedText = [[NSMutableAttributedString alloc] initWithString:SWLocaloziString(@"3.0_OTCExchangeSellCurrencyPayMthodPlacehoder") attributes:@{
                                                                                                                                                                                       NSFontAttributeName:textFontPingFangRegularFont(12.0f),
                                                                                                                                                                                       NSForegroundColorAttributeName:textColor999999
                                                                                                                                                                                       }];
            [self.sellBtn setTitle:NSLocalizedString(@"3.0_OTCExchangeSellCurrencyBtn", nil)
                          forState:UIControlStateNormal];
        }
        
        self.sellCountCurrencyNameLabel.text = @"";
        [self.sellCountCurrencyNameLabel sizeToFit];
    }else{//isSetPay == YES 没支付方式Pop回来的 不清楚数据
        self.isSetPay = NO;
    }
    
}
#pragma mark - 延迟计算
-(void)changedTextFieldValue:(UITextField *)textField{
    [self.timer invalidate];
    if (self.isBeginEndit == YES) {
     self.timer = [NSTimer scheduledTimerWithTimeInterval:1.3f target:self selector:@selector(executeAction:) userInfo:textField.text repeats:NO];
    }
   
}
-(void)executeAction:(NSTimer *)value{
    
    NSString * valueString  = value.userInfo;
    NSDecimalNumber * decimer = [NSDecimalNumber decimalNumberWithString:valueString];
    if (self.min.floatValue == 0 && self.max.floatValue == 0) { //最大值最小值都为 0 显示 0
        self.sellCountTextField.text = @"0";
    }else{
        if ([decimer compare:self.min] == NSOrderedAscending) { //小
            self.sellCountTextField.text = [NSString stringWithFormat:@"%@",self.min];
        }
    }
    
}

- (void)configSingnal {
    @weakify(self);
    self.isAgreeProtocol = @(self.agreeBtn.selected);
    //买卖 按钮点击状态变化
    RACSignal * textSignal = [RACObserve(self.sellCurrencyTextField, text) merge:self.sellCountTextField.rac_textSignal];
    RACSignal * purchaseSignal =  [[RACSignal
                                        combineLatest:@[RACObserve(self.sellCurrencyTextField,attributedText),textSignal,RACObserve(self.payCurrencyTextField, attributedText),RACObserve(self.payMethodTextField, attributedText),RACObserve(self, isAgreeProtocol)]
                                        reduce:^(NSAttributedString * phoneNum, NSString * userName, NSAttributedString *code,NSAttributedString * pwd,NSNumber * isAgreeProtocol) {
                                            
                                           BOOL isOne = ![phoneNum.string isEqualToString:SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyTypePlacehoder")]&&![phoneNum.string isEqualToString:SWLocaloziString(@"3.0_OTCExchangeSellCurrencyTypePlacehoder")];
                                           BOOL isTwo = ![code.string isEqualToString:SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyPayPlacehoder")]&&![code.string isEqualToString:SWLocaloziString(@"3.0_OTCExchangeSellCurrencyPayPlacehoder")];
                                           BOOL isThree = ![pwd.string isEqualToString:SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyPayMthodPlacehoder")]&&![pwd.string isEqualToString:SWLocaloziString(@"3.0_OTCExchangeSellCurrencyPayMthodPlacehoder")];
                                            
                                            NSNumber * num = @(isOne&&userName.length>0 && isTwo&& isThree&& isAgreeProtocol.boolValue == YES);
                                            return  num;

                                            
                                        }]
                                       distinctUntilChanged];
    
    
    [[purchaseSignal deliverOnMainThread] subscribeNext:^(NSNumber * x) {
        @strongify(self);
        if (x.boolValue == YES) {
            self.sellBtn.enabled = YES;
        }else{
            self.sellBtn.enabled = NO;
        }
        
    }];
    
    //发送订单
    [[self.viewModel.OTCSendOrderCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(IDCMOrderResultModel * x) {
        @strongify(self); //下单成功
        [self.subject sendNext:@{@"orderModel":x,
                                 @"otcCoinModel":self.otcCoinModel,
                                 @"otcCurrencyModel":self.otcCurrencyModel,
                                 @"paymentModel":self.paymentModel,
                                 @"amount":self.sellCountTextField.text,
                                 @"type":@(self.purchaseType),
                                 @"cancelCount":@(self.settingModel.CancelCount)
                                 }];
        self.purchaseType = self.purchaseType;
    }];
    
    [self.viewModel.OTCSendOrderCommand.errors subscribeNext:^(id x) { //下单失败
        @strongify(self);
        if ([x isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dict = (NSDictionary *) x ;
            NSInteger status = [dict[@"status"] integerValue];
            if (status == 733) {
                [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_DK_lackMoney")];
            }else if (status == 701){
                [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_DK_unavaiableAmount")];
            }else if (status == 743){
                NSString *time = [NSString idcw_stringWithFormat:@"%@",dict[@"data"][@"ForbidExpiredSeconds"]];
                NSInteger surplusTime = [time integerValue];
                [self showForbidTime:surplusTime];
            }else if (status == 611){
                [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_TokenWalletInsuff")];
            }
            
        }
        
    }];
    
    //交易配置信息
    [[self.viewModel.OTCTradeSettingCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(IDCMOTCSettingModel * settingModel) {
        @strongify(self);
        for (IDCMOTCCurrencyModel * currencyModel in settingModel.Currencies) { //记录上次选中的法币
            
            if (self.otcCurrencyModel&&currencyModel.Id == self.otcCurrencyModel.Id) {
                currencyModel.isSelect = YES;
            }
        }
        for (IDCMOTCCionModel * coinModel in settingModel.CoinSettings) { //记录上次选中的虚拟币
            if (self.otcCoinModel&&coinModel.CoinId == self.otcCoinModel.CoinId) {
                coinModel.isSelect = YES;
            }
        }
        
        self.coinList = settingModel.CoinSettings;
        self.currencyList = settingModel.Currencies;
        
        self.settingModel = settingModel;
        self.settingModel.selectCurrency = self.otcCurrencyModel.Name;
        
        if (self.isRequestByPayMethond == 1 && self.settingModel.CoinSettings.count > 0) { //币种请求
            [self showSelectCollectionView:self.settingModel.CoinSettings WithAlertType:kIDCMCoinType];
        }
        if (self.isRequestByPayMethond == 2 && self.settingModel.Currencies.count > 0) { //法币请求
            [self showSelectCollectionView:self.settingModel.Currencies WithAlertType:kIDCMCurrencyType];
        }
        
        if (self.isRequestByPayMethond == 11 && self.settingModel.Payments.count > 0) {// 选择法币过后判断支付方式
            NSMutableArray * payMss = @[].mutableCopy;
            for (IDCMOTCPaymentModel * paymentModel in self.settingModel.Payments) {
                if ([paymentModel.LocalCurrencyCode isEqualToString:self.otcCurrencyModel.Name]) {
                    [payMss addObject:paymentModel];
                }
            }
            if (payMss.count == 1) {
                IDCMOTCPaymentModel * paymentModel = payMss.firstObject;
                paymentModel.isSelected = YES;
                [self setPaymethodsWithModel:paymentModel];
            }
        }
        if (self.isRequestByPayMethond == 12) { //下单按钮请求
            if (self.settingModel.IsForbidTrade == NO) { //没静止下单
                if (self.purchaseType == BUYTYPE) { //买入
                    [self sendOrderAlertView];
                }else{//卖出 先比较总资产 再请求订单
                    [self.viewModel.userAssestCommand execute:self.otcCoinModel.CoinCode];
                }
            }else{
                
                NSInteger surplusTime = self.settingModel.ForbidExpiredSeconds?self.settingModel.ForbidExpiredSeconds:0;
                [self showForbidTime:surplusTime];
            }
            
            
        }
        if (self.isRequestByPayMethond == 3 ) { //点击支付方式请求的
            NSInteger judge = 1; //判断是否有对应的 币种的银行卡
            NSMutableArray * bankArrM = @[].mutableCopy;
            for (IDCMOTCPaymentModel * paymentModel in self.settingModel.Payments) {
                if ([paymentModel.LocalCurrencyCode isEqualToString:self.otcCurrencyModel.Name]) {
                    judge = 2;
                    [bankArrM addObject:paymentModel];
                }
            }
            if (settingModel.Payments == nil || self.settingModel.Payments.count == 0 ||judge ==1) { // 没支付方式
                
                
                [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                    configure.title(SWLocaloziString(@"3.0_DK_settPay"));
                    configure.getBtnsConfig.firstObject.btnTitle(SWLocaloziString(@"3.0_DK_sayLatter"));
                    configure.getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_DK_goSetting")).btnCallback(^{
                        @strongify(self);
                        self.isSetPay = YES;
                        [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMPayMethodController"
                                                                           withViewModelName:@"IDCMPayMethodViewModel"
                                                                                  withParams:@{@"type":@0}
                                                                                    animated:YES];
                        
                        
                    });
                    configure.title(SWLocaloziString(@"3.0_DK_settPay"));
                }];
                
                
            }else{ //有支付方式
                self.isSetPay = NO;
                if (self.currentSelectViewIndex ==3) { //选择支付方式回调
                    
                    if (self.paymentModel) {
                        for (IDCMOTCPaymentModel * paymentModel in self.settingModel.Payments) { //找到之前选中的支付方式
                            if (self.paymentModel) {
                                if (self.paymentModel.ID == paymentModel.ID) {
                                    paymentModel.isSelected = YES;
                                }
                            }
                        }
                    } else {
                        if (bankArrM.count == 1) {
                            IDCMOTCPaymentModel * paymentModel = bankArrM.firstObject;
                            paymentModel.isSelected = YES;
                            [self setPaymethodsWithModel:paymentModel];
                        }
                    }
                    
                    
                    NSString * payTitle = self.purchaseType == BUYTYPE ?SWLocaloziString(@"3.0_DK_otcChooseType"):SWLocaloziString(@"3.0_DK_otcChooseReceiveType");
                    
                    [IDCMSelectPayMethodsView showWithTitle:payTitle models:bankArrM canMultipleSelect:NO isFilter:NO cellConfigure:^(SelectPayViewCell *cell, id model) {
                        
                        IDCMOTCPaymentModel * paymentModel = model;
                        if ([paymentModel.PayTypeCode isEqualToString:@"AliPay"]) { //支付宝
                            cell.countryLabel.text = paymentModel.LocalCurrencyCode;
                            cell.payTitleLabel.text =  SWLocaloziString(@"3.0_DK_otcAlipay");// paymentModel.PayAttributes.BankName;
                            cell.payAccountLabel.text = paymentModel.PayAttributes.AccountNo;
                            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:paymentModel.PayTypeLogo]];
                            
                        }
                        if ([paymentModel.PayTypeCode isEqualToString:@"Bankcard"]) { //银行卡
                            cell.countryLabel.text = paymentModel.LocalCurrencyCode;
                            cell.payTitleLabel.text = paymentModel.PayAttributes.BankName;
                            cell.payAccountLabel.text = [IDCMUtilsMethod addSpaceByString:paymentModel.PayAttributes.AccountNo separateCount:4];
                            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:paymentModel.PayTypeLogo]];
                        }
                        
                        if ([paymentModel.PayTypeCode isEqualToString:@"WeChat"]) { //微信
                            cell.countryLabel.text = paymentModel.LocalCurrencyCode;
                            cell.payTitleLabel.text =  SWLocaloziString(@"3.0_paylist_wechat");// paymentModel.PayAttributes.BankName;
                            cell.payAccountLabel.text = paymentModel.PayAttributes.AccountNo;
                            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:paymentModel.PayTypeLogo]];
                        }
                        
                    } selectedCallback:^(NSArray *models) {
                        @strongify(self);
                        IDCMOTCPaymentModel * paymentModel = models.firstObject;
                        [self setPaymethodsWithModel:paymentModel];
                    }];
                }
            }
        }
        
    }];
    [[self.viewModel.OTCTradeSettingCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue != YES) {
            [IDCMHUD dismiss];
        }
    }];
    //获取最新 数量区间
    [[self.viewModel.OTCTradeNoHudSettingCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(IDCMOTCSettingModel * settingModel) {
         @strongify(self);
         if (!self.otcCoinModel) {
             return ;
         }
         IDCMOTCCionModel *otcCoinModel = nil;
         for (IDCMOTCCionModel *model in settingModel.CoinSettings) {
             if ([model.CoinCode isEqualToString:self.otcCoinModel.CoinCode]) {
                 otcCoinModel = model;
             }
         }
         if (!otcCoinModel) {
             return;
         }
         if (self.purchaseType == BUYTYPE) {
             NSNumber * num ;
             if ([otcCoinModel.MinBuyQuantity compare:[NSNumber numberWithDouble:0.001]] == NSOrderedAscending ) {
                 num = [NSNumber numberWithDouble:0.0001];
             }else{
                 num = otcCoinModel.MinBuyQuantity;
             }
             NSString * min = [IDCMUtilsMethod precisionControl:num];
             NSString * max = [IDCMUtilsMethod precisionControl:otcCoinModel.MaxBuyQuantity];
             max = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:max] fractionDigits:4];
             max = [IDCMUtilsMethod changeFloat:max];
             self.min = num;
             self.max = otcCoinModel.MaxBuyQuantity;
             if ([otcCoinModel.MinBuyQuantity compare:[NSNumber numberWithDouble:0]]==NSOrderedSame&&[otcCoinModel.MaxSellQuantity compare:[NSNumber numberWithDouble:0]]==NSOrderedSame ) {
                 self.min = @0;
                 self.sellCountTextField.placeholder = @"0";
             }else{
                 self.sellCountTextField.placeholder = [NSString idcw_stringWithFormat:@"%@-%@",min,max];
             }
             
         }else{
             NSNumber * num ;
             if ([otcCoinModel.MinSellQuantity compare:[NSNumber numberWithDouble:0.001]] == NSOrderedAscending ) {
                 num = [NSNumber numberWithDouble:0.0001];
             }else{
                 num = otcCoinModel.MinSellQuantity;
             }
             NSString * min = [IDCMUtilsMethod precisionControl:num];
             NSString * max = [IDCMUtilsMethod precisionControl:otcCoinModel.MaxSellQuantity];
             max = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:max] fractionDigits:4];
             max = [IDCMUtilsMethod changeFloat:max];
             self.min = num;
             self.max = otcCoinModel.MaxSellQuantity;
             if ([otcCoinModel.MinSellQuantity compare:[NSNumber numberWithDouble:0]]==NSOrderedSame&&[otcCoinModel.MaxSellQuantity compare:[NSNumber numberWithDouble:0]]==NSOrderedSame) { //最小卖出和最大卖出都为 0时候
                 self.min = @0;
                 self.sellCountTextField.placeholder = @"0";
             }else{
                 self.sellCountTextField.placeholder = [NSString idcw_stringWithFormat:@"%@-%@",min,max];
             }
             
         }
     }];
    
    [[self.viewModel.OTCBaseSettingCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(IDCMSysSettingModel * model) {
        @strongify(self);
        self.sysSettingModel = model;
    }];
    [[self.viewModel.OTCBaseSettingCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue != YES) {
            [IDCMHUD dismiss];
        }
    }];
    [self.viewModel.OTCBaseSettingCommand execute:nil];
    
    //买卖 按钮
    [[[self.sellBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         @strongify(self);
         [self endEditing:YES];
         
         IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
         if (![userModel.mobile isNotBlank]) { // 承兑商未设置手机号
             [self goBindPhone]; //校验
             return;
         }
         
         if (self.isAgreeProtocol.integerValue == 0) { //没同意协议
             [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                 [configure.getBtnsConfig removeFirstObject];
                 configure.title([NSString stringWithFormat:@"%@%@",
                                  NSLocalizedString(@"3.0_OTCExchangeBuyAndSellCurrencyRulePlese", nil),
                                  NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyRule", nil)])
                 .getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"2.2.3_IKnow"));
             }];
             return;
         }
          self.isRequestByPayMethond = 12;
         [self.viewModel.OTCTradeSettingCommand execute:nil];
     }];
    
    //比较资产
    [[[self.viewModel.userAssestCommand.executionSignals switchToLatest]deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        DDLogDebug(@"Sell === %@",x);
        if (x) {
            NSDecimalNumber * currentBalance = [NSDecimalNumber decimalNumberWithString:x];
            NSDecimalNumber * inputBalance =  [NSDecimalNumber decimalNumberWithString:self.sellCountTextField.text];
            if ([inputBalance compare:currentBalance] == NSOrderedDescending) { //比当前资产大
                [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_DK_lackSellMoney")];
            }else{
                [self sendOrderAlertView];
            }
        }
    }];
    
    [[self.agreeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^( UIButton *  x) {
        @strongify(self);
         BOOL  isFirstArgreeProtocol = [CommonUtils  getBoolValueInUDWithKey:@"agree_OTC_protocol"];
         if (!isFirstArgreeProtocol) {
             [CommonUtils saveBoolValueInUD:YES forKey:@"agree_OTC_protocol"];
         }
         x.selected = !x.selected;
         self.isAgreeProtocol = x.selected?@1:@0;
     }];

    [[self.rulebtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton * x) {
         NSString *rulesUrl = [NSString stringWithFormat:@"%@%@?lang=%@",[IDCMServerConfig getIDCMWebAddr],TradingRules_URL,[IDCMUtilsMethod getH5Language]];
         [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMWebViewController"
                                                            withViewModelName:@"IDCMWebViewModel"
                                                                   withParams:@{@"requestURL":rulesUrl,
                                                                                @"title":SWLocaloziString(@"3.0_DK_otcRule")}];
     }];
    
    [self.viewModel.OTCTradeSettingCommand execute:nil];

}

- (void)setPaymethodsWithModel:(IDCMOTCPaymentModel *)model {
    self.paymentModel = model;
    NSString * payName = @"" ;
    if ([model.PayTypeCode isEqualToString:@"AliPay"]) { //支付宝
        payName = SWLocaloziString(@"3.0_DK_otcAlipay");
    }
    if ([model.PayTypeCode isEqualToString:@"Bankcard"]) { //银行卡
        payName = model.PayAttributes.BankName;
    }
    if ([model.PayTypeCode isEqualToString:@"WeChat"]) { //微信
        payName = SWLocaloziString(@"3.0_paylist_wechat");
    }
    [self wordImageAttributedString:model.PayTypeLogo name:payName index:3];
}

-(void)sendOrderAlertView{
    @weakify(self);
    [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
        
        @strongify(self);
        NSString * matchStr = [SWLocaloziString(@"3.0_DK_matchTime") stringByReplacingOccurrencesOfString:@"[IDCWS]" withString:[NSString stringWithFormat:@"%ld",self.sysSettingModel.AllowQuotePriceDuration]];
        NSString * typeStr = self.purchaseType == BUYTYPE ?SWLocaloziString(@"3.0_DK_buyIn"):SWLocaloziString(@"3.0_DK_sellOut");
        NSString * language = [IDCMUtilsMethod getPreferredLanguage];
        NSString * alertStr;
        NSString * countStr = [IDCMUtilsMethod separateNumberUseCommaWith:self.sellCountTextField.text];
        if ([language isEqualToString:@"zh-Hans"]||[language isEqualToString:@"zh-Hant"]) {
            alertStr = [NSString stringWithFormat:@"%@%@%@",typeStr, countStr,self.sellCountCurrencyNameLabel.text];
        }else{
            alertStr = [NSString stringWithFormat:@"%@ %@ %@",typeStr, countStr,self.sellCountCurrencyNameLabel.text];
        }
        
        configure.title(alertStr);
        configure.subTitle(matchStr).getBtnsConfig.lastObject.btnCallback(^{
            @strongify(self);
            NSDecimalNumber * numTemp = [NSDecimalNumber decimalNumberWithString:self.sellCountTextField.text];
            if (self.purchaseType == BUYTYPE) { //买入
                if ([numTemp compare:self.otcCoinModel.MinBuyQuantity] == NSOrderedAscending) { //小
                    [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_DK_otcMinBuy")];
                    return ;
                }
                if ([numTemp compare:self.otcCoinModel.MaxBuyQuantity] == NSOrderedDescending) {
                    [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_DK_otcMaxBuy")];
                    return ;
                }
            }else{//卖出
                if ([numTemp compare:self.otcCoinModel.MinSellQuantity] == NSOrderedAscending) { //小
                    [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_DK_otcMinSell")];
                    return ;
                }
                if ([numTemp compare:self.otcCoinModel.MaxSellQuantity] == NSOrderedDescending) {
                    [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_DK_otcMaxSell")];
                    return ;
                }
                
            }
            
            NSNumber * purchaseType = self.purchaseType==BUYTYPE?@1:@2;
            NSDictionary * para = @{@"CoinId": [NSNumber numberWithInteger:self.otcCoinModel.CoinId],
                                    @"CurrencyId":[NSNumber numberWithInteger:self.otcCurrencyModel.Id],
                                    @"QuoteQuantity":numTemp,
                                    @"PaymentModeId": [NSNumber numberWithInteger:self.paymentModel.ID],
                                    @"TradeDirection":purchaseType
                                    };
            [self.viewModel.OTCSendOrderCommand execute:para];
            
        });;
        
    }];
    
}
#pragma mark --- 去绑定手机
- (void)goBindPhone{
    
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

}
#pragma mark 显示禁止时间
- (void)showForbidTime:(NSInteger)surplusTime{
    if (surplusTime<=0) {
//        return;
        surplusTime = labs(surplusTime);
    }
    NSInteger distance =surplusTime; //还剩余多少秒

    NSInteger day = distance/86400;//天
    NSInteger  hour =  ceil((distance-day*86400)/3600.00); //小时;
    if (hour ==24) {
        day = day +1 ;
        hour = 0;
    }
//    DDLogDebug(@"timestampTimes =%ld- %ld",day,hour);
    NSString * alertString;
    if (day>0) { //1天以上
        if (hour >0) { //1天1小时以上
         alertString = [SWLocaloziString(@"3.0_DK_otcForbidTime") stringByReplacingOccurrencesOfString:@"[IDCWD]" withString:[NSString stringWithFormat:@"%ld",day]];
         alertString = [alertString stringByReplacingOccurrencesOfString:@"[IDCWH]" withString:[NSString stringWithFormat:@"%ld",hour]];
        }else{//1天整（1天 0小时）
          alertString = [SWLocaloziString(@"3.0_DK_otcForbidTimeDay") stringByReplacingOccurrencesOfString:@"[IDCWD]" withString:[NSString stringWithFormat:@"%ld",day]];
        }
    }else{//24小时以内
      alertString = [SWLocaloziString(@"3.0_DK_otcForbidTimeHour") stringByReplacingOccurrencesOfString:@"[IDCWH]" withString:[NSString stringWithFormat:@"%ld",hour]];
    }
    [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
        [configure.getBtnsConfig removeFirstObject];
        configure.title(alertString)
        .getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"2.0_gongxiButton"));
    }];
}
- (void)configUI {

    @weakify(self);
    self.backgroundColor = UIColorWhite;
    [self addSubview:self.backImageView];
    //选择 买入币种
    CGRect rect1 = CGRectMake(self.backImageView.left + 2, 0, self.backImageView.width - 4, 46);
    self.sellCurrencyLabel = [[UILabel alloc] init];
    self.sellCurrencyTextField = [[UILabel alloc] init];
    [self addSubview:
     [self createOneLineViewWithFrame:rect1
                       leftLabelTuple:RACTuplePack(self.sellCurrencyLabel,
                                                   NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyType", nil))
                      rightLabelTuple:RACTuplePack(self.sellCurrencyTextField,
                                                   NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyTypePlacehoder", nil))
                          btnCallback:^(UIButton *btn) {
                        
                              @strongify(self);
                              [self endEditing:YES];
                              self.currentSelectViewIndex = 1;
                              self.isRequestByPayMethond = 1;
//                              IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
//                              if (![userModel.mobile isNotBlank]) { // 承兑商未设置手机号
//                                  [self goBindPhone]; //校验
//                                  return;
//                              }
                              if (self.settingModel && self.settingModel.CoinSettings.count > 0) {
                                  [self showSelectCollectionView:self.settingModel.CoinSettings WithAlertType:kIDCMCoinType];
                              }else{ // 没网没数据时候请求
                                  [self.viewModel.OTCTradeSettingCommand execute:nil];
                              }
                             
                          }]];
    //选择 买入数量
    CGRect rect2 = CGRectMake(self.backImageView.left + 2, 46 , self.backImageView.width - 4, 46);
    self.sellCountLabel = [[UILabel alloc] init];
    self.sellCountTextField = [[IDCMCustomerTextField alloc] init];
    self.sellCountTextField.textInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    self.sellCountTextField.delegate = self;
    [self addSubview:
     [self createOneLineViewWithFrame:rect2
                       leftLabelTuple:RACTuplePack(self.sellCountLabel,
                                                   NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyCount", nil))
                      rightLabelTuple:RACTuplePack(self.sellCountTextField, nil)
                          btnCallback:nil]];
    //选择法币
    CGRect rect3 = CGRectMake(self.backImageView.left + 2, 46 * 2, self.backImageView.width - 4, 46);
    self.payCurrencyLabel = [[UILabel alloc] init];
    self.payCurrencyTextField = [[UILabel alloc] init];
    [self addSubview:
     [self createOneLineViewWithFrame:rect3
                       leftLabelTuple:RACTuplePack(self.payCurrencyLabel,
                                                   NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyPay", nil))
                      rightLabelTuple:RACTuplePack(self.payCurrencyTextField,
                                                   NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyPayPlacehoder", nil))
                          btnCallback:^(UIButton *btn) {
                             @strongify(self);
                              [self endEditing:YES];
                              self.currentSelectViewIndex = 2;
                              self.isRequestByPayMethond = 2 ;
//                              IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
//                              if (![userModel.mobile isNotBlank]) { // 承兑商未设置手机号
//                                  [self goBindPhone]; //校验
//                                  return;
//                              }
                              if (self.settingModel && self.settingModel.Currencies.count > 0) {
                                   [self showSelectCollectionView:self.settingModel.Currencies WithAlertType:kIDCMCurrencyType];
                              }else{
                                  [self.viewModel.OTCTradeSettingCommand execute:nil];
                              }
                          }]];
    
    CGRect rect4 = CGRectMake(self.backImageView.left + 2, 46 * 3 , self.backImageView.width - 4, 46);
    self.payMethodLabel = [[UILabel alloc] init];
    self.payMethodTextField = [[UILabel alloc] init];
    //设置 收款方式
    [self addSubview:
     [self createOneLineViewWithFrame:rect4
                       leftLabelTuple:RACTuplePack(self.payMethodLabel,
                                                   NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyPayMthod", nil))
                      rightLabelTuple:RACTuplePack(self.payMethodTextField,
                                                   NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyPayMthodPlacehoder", nil))
                          btnCallback:^(UIButton *btn) {
                              @strongify(self);
                              [self endEditing:YES];
                              self.currentSelectViewIndex = 3;
                              self.isRequestByPayMethond = 3;
//                              IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
//                              if (![userModel.mobile isNotBlank]) { // 承兑商未设置手机号
//                                  [self goBindPhone]; //校验
//                                  return;
//                              }
                              
                               BOOL isThree = ![self.payCurrencyTextField.attributedText.string isEqualToString:SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyPayPlacehoder")]&&![self.payCurrencyTextField.attributedText.string isEqualToString:SWLocaloziString(@"3.0_OTCExchangeSellCurrencyPayPlacehoder")];
                              if (!isThree) { //没选择默认支付法币
                                  [self popCurrencyList];
                                  return;
                              }
                              [self.viewModel.OTCTradeSettingCommand execute:nil];
                              
                          }]];
    
    [self addSubview:self.ruleView];
    [self addSubview:self.sellBtn];
    self.size = CGSizeMake(SCREEN_WIDTH, self.sellBtn.bottom + 16);
    
}

- (UIImageView *)backImageView {
    return SW_LAZY(_backImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:@"2.1_midback_phrases_bg_image_box"];
        imageView.size = CGSizeMake(SCREEN_WIDTH - 24, 187);
        imageView.left = 12;
        imageView;
    }));
}

- (UIView *)createOneLineViewWithFrame:(CGRect)frame
                        leftLabelTuple:(RACTuple *)leftTuple
                       rightLabelTuple:(RACTuple *)rightTuple
                           btnCallback:(void(^)(UIButton *btn))btnCallback {
    
    RACTupleUnpack(UILabel *leftLabel,NSString *leftTitle) = leftTuple;
    RACTupleUnpack(QMUITextField *rightTextField,NSString *placeholder) = rightTuple;
    
    UIView *view = [[UIView alloc] init];
    view.frame = frame;
    view.backgroundColor = [UIColor clearColor];
    
    if (!leftLabel) { leftLabel = [UILabel new]; }
    leftLabel.textColor = textColor666666;
    leftLabel.font = textFontPingFangRegularFont(12);
    leftLabel.text = leftTitle;
    [leftLabel sizeToFit];
    leftLabel.left = 12;
    leftLabel.centerY = view.height / 2;
    [view addSubview:leftLabel];
    
    UIImageView *imageView;
    if (btnCallback) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.0_angle"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.right = view.width - 12;
        imageView.centerY = leftLabel.centerY;
        [view addSubview:imageView];
    }
    
    if (!rightTextField) {
        if (placeholder.length >0) {
           rightTextField = [UILabel new];
        }else{
           rightTextField = [QMUITextField new];
        }
    }
    if ([rightTextField isKindOfClass:[UILabel class]]) {
        rightTextField.textColor = textColor999999;
        rightTextField.font = textFontPingFangRegularFont(12);
        rightTextField.text = placeholder;
    }else{
        rightTextField.textColor = textColor333333;
        rightTextField.font = textFontPingFangRegularFont(12);
        rightTextField.keyboardType =  UIKeyboardTypeDecimalPad;
        QMUILabel * rightView= [[QMUILabel alloc] init];
        rightView.textColor = textColor333333;
        rightView.font = textFontPingFangRegularFont(12);
        rightView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
        self.sellCountCurrencyNameLabel = rightView;
        rightTextField.rightView = rightView;
        rightTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    rightTextField.textAlignment = NSTextAlignmentRight;
    if (btnCallback) {
        rightTextField.width = imageView.left - leftLabel.right - 10 - 5;
    } else {
        rightTextField.width = view.width - leftLabel.right - 10 - 10;
    }
    
    rightTextField.left = leftLabel.right + 10;
    rightTextField.height = view.height;
    rightTextField.centerY = leftLabel.centerY;
    [view addSubview:rightTextField];
    
    if (btnCallback) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(view.width / 2, 0, view.width / 2, view.height);
        [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
         subscribeNext:btnCallback];
        [view addSubview:btn];
    }
    
    if (![leftTitle isEqualToString:NSLocalizedString(@"3.0_OTCExchangeSellCurrencyPayMthod", nil)]&&![leftTitle isEqualToString:NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyPayMthod", nil)]) { 
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        line.left = leftLabel.left;
        line.width = view.width - leftLabel.left;
        line.height = .5;
        line.bottom = view.height;
        [view addSubview:line];
    }
    
    return view;
}

- (UIView *)ruleView {
    return SW_LAZY(_ruleView, ({
        
        UIView *view = [[UIView alloc] init];
        UIFont * font ;
        NSString * language = [IDCMUtilsMethod getPreferredLanguage];
        if ([language isEqualToString:@"zh-Hans"]||[language isEqualToString:@"zh-Hant"]) {
            font = textFontPingFangRegularFont(14);
        }else{
            font = textFontPingFangRegularFont(12);
        }
        
        QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        btn.imagePosition = QMUIButtonImagePositionRight;
        [btn setTitle:@"    " forState:UIControlStateNormal];
        BOOL  isFirstArgreeProtocol = [CommonUtils  getBoolValueInUDWithKey:@"agree_OTC_protocol"];
        btn.selected = isFirstArgreeProtocol;
        [btn setImage:[UIImage imageNamed:@"3.0_unSelectArrow"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"3.0_selectArrow"] forState:UIControlStateSelected];
        btn.size = CGSizeMake(31, 30);
        self.agreeBtn = btn;
        [view addSubview:btn];
        
        UILabel *ruleLabel = [[UILabel alloc] init]; //我已阅读并同意
        ruleLabel.textColor = textColor999999;
        ruleLabel.font = font;
        ruleLabel.text = NSLocalizedString(@"3.0_OTCExchangeBuyAndSellCurrencyRule", nil);
        [ruleLabel sizeToFit];
        ruleLabel.height = 20;
        ruleLabel.left = btn.right + 6;
        [view addSubview:ruleLabel];
        ruleLabel.userInteractionEnabled = YES;
        
        UIGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
          btn.selected = !btn.selected;
          self.isAgreeProtocol = @(self.agreeBtn.selected);
        }];
        [ruleLabel addGestureRecognizer:tap];
        UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ruleBtn setTitleColor:SetColor(41, 104, 185) forState:UIControlStateNormal];
        ruleBtn.titleLabel.font = font;
        [ruleBtn setTitle:NSLocalizedString(@"3.0_OTCExchangeBuyCurrencyRule", nil)
                 forState:UIControlStateNormal];
        [ruleBtn sizeToFit];
        ruleBtn.height = 20;
        ruleBtn.left = ruleLabel.right;
        [view addSubview:ruleBtn];
        self.rulebtn = ruleBtn;
        
        view.height = 20;
        CGFloat width = btn.width + ruleLabel.width + ruleBtn.width;
        if (width > SCREEN_WIDTH - 24 + 14) {
            ruleLabel.width = (SCREEN_WIDTH - 24 + 14 - ruleBtn.width - btn.width);
            width = SCREEN_WIDTH - 24 + 14;
            ruleBtn.left = ruleLabel.right;
        }
        view.width = width;
        view.centerX = SCREEN_WIDTH / 2 - 8;
        view.top = self.backImageView.bottom + 15;
        btn.centerY = view.height / 2;
        view;
    }));
}


- (UIButton *)sellBtn {
    return SW_LAZY(_sellBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        
        btn.width = SCREEN_WIDTH - 28;
        btn.height = 40;
        btn.left = 14;
        btn.top = self.ruleView.bottom + 16;
        
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"3.0_OTCExchangeSellCurrencyBtn", nil)
             forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithHexString:@"#999FA5"]];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setBackgroundImage:image2 forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateDisabled];
        btn;
    }));
}

-(void)wordImageAttributedString:(NSString *) url name:(NSString *) coniName index:(NSInteger) index {
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
    UILabel * goalLabel =  [self  getViewByCurrentIndex:index];
    goalLabel.attributedText = [[NSAttributedString alloc] initWithString:coniName];
    [manager loadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        //回调从新设置
//        if (image) {
            NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = image;
            attachment.bounds = CGRectMake(0, -8, 24, 24);
            NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:coniName];
            [textAttrStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
            [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [textAttrStr appendAttributedString:nameAttributedString];
            [textAttrStr addAttribute:NSKernAttributeName value:@(4)
                                range:NSMakeRange(0, 1)];
            goalLabel.attributedText = textAttrStr ;
            goalLabel.textColor = textColor333333;
//        }
    }];

}

//获取对应的 label
-(UILabel *)getViewByCurrentIndex:(NSInteger) index{
    
    switch (index) {
        case 1:
            return self.sellCurrencyTextField;
            break;
        case 2:
            return self.payCurrencyTextField;
            break;
        case 3:
            return self.payMethodTextField;
            break;
        case 11:
            return self.payMethodTextField;
            break;
        default:
            return nil;
            break;
    }
}
#pragma mark -- 选择币种弹框
-(void)popCoinList{
    [self endEditing:YES];
    self.currentSelectViewIndex = 1;
    self.isRequestByPayMethond = 1;
    IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    if (![userModel.mobile isNotBlank]) { // 承兑商未设置手机号
        [self goBindPhone]; //校验
        return;
    }
    if (self.settingModel && self.settingModel.CoinSettings.count > 0) {
        [self showSelectCollectionView:self.settingModel.CoinSettings WithAlertType:kIDCMCoinType];
    }else{ //没网没数据时候请求
        [self.viewModel.OTCTradeSettingCommand execute:nil];
        
    }
}
#pragma mark - 选择法币 列表弹框
-(void)popCurrencyList{
    [self endEditing:YES];
    self.currentSelectViewIndex = 2;
    self.isRequestByPayMethond = 2 ;
    IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    if (![userModel.mobile isNotBlank]) { // 承兑商未设置手机号
        [self goBindPhone]; //校验
        return;
    }
    
    if (self.settingModel && self.settingModel.Currencies.count > 0) {
        [self showSelectCollectionView:self.settingModel.Currencies WithAlertType:kIDCMCurrencyType];
    }else{
        [self.viewModel.OTCTradeSettingCommand execute:nil];
    }
}
-(void)requestImageList:(NSInteger)currentIndex {
    
    [self.viewModel.OTCTradeSettingCommand execute:nil];
 
}

-(void)showSelectCollectionView:(NSArray *) incons WithAlertType:(IDCMAlertTypeType)type{
    NSInteger totalRow = ((incons.count - 1) / 4 + 1);
    CGFloat bottomMargin =  totalRow < 5 ? 10 : 0;
    if (totalRow > 4) {totalRow = 4;}
    CGFloat totalHeight =  totalRow * (70 + 20) + 52 + bottomMargin;
    NSString * title = @"";
    if (self.currentSelectViewIndex == 1) {
        title = SWLocaloziString(@"3.0_CurrencyTypeSwitchDigital");
    }else if (self.currentSelectViewIndex == 2){
        title = SWLocaloziString(@"3.0_CurrencySwith");
        
    }
    IDCMChooseBTypeView * listView= [[IDCMChooseBTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 24, totalHeight)  bTypes:incons title:title withType:type];
    listView.delegate = self;
    [IDCMBaseCenterTipView showTipViewToView:nil size:CGSizeMake(SCREEN_WIDTH - 24, totalHeight) contentView:listView automaticDismiss:NO animationStyle:1 tipViewStatusCallback:nil];
    
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.sellCountTextField]) {
//        IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
//        if (![userModel.mobile isNotBlank]) { // 承兑商未设置手机号
//            [self goBindPhone]; //校验
//            return NO;
//        }
        
        BOOL isThree = ![self.sellCurrencyTextField.attributedText.string isEqualToString:SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyTypePlacehoder")]&&![self.sellCurrencyTextField.attributedText.string isEqualToString:SWLocaloziString(@"3.0_OTCExchangeSellCurrencyTypePlacehoder")];
        if (!isThree) { //没选择默认支付法币
            [self popCoinList];
            return NO;
        }
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.isBeginEndit = YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.isBeginEndit = NO;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
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
        
        textField.text = [toBeString stringByReplacingOccurrencesOfString:@"," withString:@"."];
        return NO;
    }
    
    if ([textField isEqual:self.sellCountTextField]) { // 数量
        if ([toBeString containsString:@"."]) { //含有小数点的 精确位数
            NSArray * arr = [toBeString componentsSeparatedByString:@"."];
            if ([arr[1] length] > 4) {
                return NO;
            }
            
        }
        
    }
    NSDecimalNumber * amountNum = [NSDecimalNumber decimalNumberWithString:toBeString];
//    if ([amountNum compare:self.min] == NSOrderedAscending) { //小 延迟计算
//        textField.text = [NSString stringWithFormat:@"%@",self.min];
//        return NO;
//    }
    
    if (self.max.floatValue > 0) {//最大值大于0 时候 等于0时候 延迟计算
        if ([amountNum compare:self.max] == NSOrderedDescending) { //大
            textField.text = [NSString stringWithFormat:@"%@",self.max];
            return NO;
        }
    }
    
    
    return YES;
}
//回调
- (void)iconWindow:(IDCMChooseBTypeView *) iconView clickedButtonAtIndex:(NSIndexPath *) index selectIndex:(NSIndexPath *) select{
    
    
    if (self.currentSelectViewIndex == 1) { //选择虚拟币
        
    
        IDCMOTCCionModel * otcCoinModel = self.coinList[index.row] ;
        otcCoinModel.isSelect = YES;
        if (select) {
            IDCMOTCCionModel * otcCoinLastModel = self.coinList[select.row];
            otcCoinLastModel.isSelect =NO;
        }
       
        
        self.otcCoinModel = otcCoinModel;
        [self wordImageAttributedString:otcCoinModel.Logo name:otcCoinModel.dk_uppercaseLetter index:self.currentSelectViewIndex];
        self.sellCountCurrencyNameLabel.text = otcCoinModel.dk_uppercaseLetter; //单位
        [self.sellCountCurrencyNameLabel sizeToFit];
        self.sellCountTextField.text = @"";
        if (self.purchaseType == BUYTYPE) {
            NSNumber * num ;
            if ([otcCoinModel.MinBuyQuantity compare:[NSNumber numberWithDouble:0.001]] == NSOrderedAscending ) {
                num = [NSNumber numberWithDouble:0.0001];
            }else{
                num = otcCoinModel.MinBuyQuantity;
            }
            NSString * min = [IDCMUtilsMethod precisionControl:num];
            NSString * max = [IDCMUtilsMethod precisionControl:otcCoinModel.MaxBuyQuantity];
            max = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:max] fractionDigits:4];
            max = [IDCMUtilsMethod changeFloat:max];
            self.min = num;
            self.max = otcCoinModel.MaxBuyQuantity;
            if ([otcCoinModel.MinBuyQuantity compare:[NSNumber numberWithDouble:0]]==NSOrderedSame&&[otcCoinModel.MaxSellQuantity compare:[NSNumber numberWithDouble:0]]==NSOrderedSame ) {
                self.min = @0;
                self.sellCountTextField.placeholder = @"0";
            }else{
                self.sellCountTextField.placeholder = [NSString idcw_stringWithFormat:@"%@-%@",min,max];
            }
            
            // 单纯刷新承兑商的上下限
            [self.viewModel.OTCTradeNoHudSettingCommand execute:nil];
            
        }else{
            NSNumber * num ;
            if ([otcCoinModel.MinSellQuantity compare:[NSNumber numberWithDouble:0.001]] == NSOrderedAscending ) {
                num = [NSNumber numberWithDouble:0.0001];
            }else{
                num = otcCoinModel.MinSellQuantity;
            }
            NSString * min = [IDCMUtilsMethod precisionControl:num];
            NSString * max = [IDCMUtilsMethod precisionControl:otcCoinModel.MaxSellQuantity];
            max = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:max] fractionDigits:4];
            max = [IDCMUtilsMethod changeFloat:max];
            self.min = num;
            self.max = otcCoinModel.MaxSellQuantity;
            if ([otcCoinModel.MinSellQuantity compare:[NSNumber numberWithDouble:0]]==NSOrderedSame&&[otcCoinModel.MaxSellQuantity compare:[NSNumber numberWithDouble:0]]==NSOrderedSame) { //最小卖出和最大卖出都为 0时候
                 self.min = @0;
                 self.sellCountTextField.placeholder = @"0";
            }else{
                 self.sellCountTextField.placeholder = [NSString idcw_stringWithFormat:@"%@-%@",min,max];
            }
            
        }
       
    }else if (self.currentSelectViewIndex == 2){ //选择法币
        self.paymentModel.isSelected = NO;
        self.paymentModel.isSelected = nil; //清除原来选中状态
        NSString * holderStr = self.purchaseType == BUYTYPE?SWLocaloziString(@"3.0_OTCExchangeBuyCurrencyPayMthodPlacehoder"):SWLocaloziString(@"3.0_OTCExchangeSellCurrencyPayMthodPlacehoder"); //清除选择支付方式
        self.payMethodTextField.attributedText = [[NSMutableAttributedString alloc] initWithString:holderStr attributes:@{
                                                                                                                                                                                  NSFontAttributeName:textFontPingFangRegularFont(12.0f),
                                                                                                                                                                                  NSForegroundColorAttributeName:textColor999999
                                                                                                                                                                                  }];
        IDCMOTCCurrencyModel * otcCurrencyModel = self.currencyList[index.row];
        otcCurrencyModel.isSelect = YES;
        if (select) {
            IDCMOTCCurrencyModel * otcLastCurrencyModel = self.currencyList[select.row];
            otcLastCurrencyModel.isSelect = NO;
        }
        
        self.otcCurrencyModel = otcCurrencyModel;
        self.settingModel.selectCurrency = self.otcCurrencyModel.Name;//设置 选择的法币
        [self wordImageAttributedString:otcCurrencyModel.Logo name:otcCurrencyModel.Name index:self.currentSelectViewIndex];
        
#pragma mark — 判断是否只有一个支付方式
        self.isRequestByPayMethond = 11;
        [self.viewModel.OTCTradeSettingCommand execute:nil];
    }
}
// 第二个view 设值
-(void)currencyListCellSelect:(NSString *) currencyName{
    self.sellCountTextField.text =nil;
    [self.sellCountCurrencyNameLabel setText:currencyName];
    [self.sellCountCurrencyNameLabel sizeToFit];
}
//获取当前时间戳 毫秒单位
-(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/ShenZhen"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}



-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
@end
