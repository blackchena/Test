//
//  IDCMAcceptantApplyStepsEndVC.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyStepsEndVC.h"
#import "IDCMAcceptVariableCell.h"
#import "IDCMSegmentProcessView.h"
#import "IDCMAcceptantSectionHeadView.h"
#import "IDCMAcceptVariableModel.h"
#import "IDCMAcceptantApplyCompleteView.h"
#import "IDCMAcceptantViewController.h"
#import "IDCMApplyAcceptantStepView.h"
#import "IDCMAcceptantApplyStepsEndViewModel.h"
#import "IDCMAcceptantPickinBondView.h"

#import "IDCMOTCPaymentModel.h"
#import "IDCMSelectPayMethodsView.h"

@interface IDCMAcceptantApplyStepsEndVC (){

    CGFloat  adjustHeight;
}
@property (strong, nonatomic) IDCMAcceptantApplyStepsEndViewModel * viewModel;
@property (nonatomic,strong) IDCMApplyAcceptantStepView *stepOneView;
@property (nonatomic,strong) IDCMApplyAcceptantStepView *stepTwoView;
@property (nonatomic,strong) IDCMAcceptantPickinBondView *bondView;
@property (nonatomic,strong) IDCMAcceptantApplyCompleteView *completeView;
@property (nonatomic,strong) IDCMSegmentProcessView * firstHead;

@end

@implementation IDCMAcceptantApplyStepsEndVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.currentStep = 1;
    [self initUIView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self requestEachStepData];
    [super viewWillAppear:animated];
}
-(void)initUIView{
    
    self.navigationItem.title = SWLocaloziString(@"3.0_AcceptantApply");
    self.view.backgroundColor  = viewBackgroundColor;
    
    CGRect textRect = [SWLocaloziString(@"3.0_Bin_AcceptBuyCoin") boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/4.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 12)} context:nil];
    adjustHeight = textRect.size.height>30 ? 12 :0;
    [self.firstHead setStepIndex:self.currentStep animation:NO];
    [self.view addSubview: self.firstHead];
    //依据当前的步骤 展示页面
    if (self.currentStep == 0) {
        [self.view addSubview:self.stepOneView];
        [self.view addSubview:self.stepTwoView];
        self.stepTwoView.alpha = 0;
        [self.view addSubview:self.bondView];
        self.bondView.alpha  =  0;
        [self.view addSubview:self.completeView];
        self.completeView.alpha = 0;
    }else if(self.currentStep == 1){
        [self.view addSubview:self.stepTwoView];
        [self.view addSubview:self.bondView];
        self.bondView.alpha  =  0;
        [self.view addSubview:self.completeView];
        self.completeView.alpha = 0;
    }else if (self.currentStep == 2){
        [self.view addSubview:self.bondView];
        [self.view addSubview:self.completeView];
        self.completeView.alpha = 0;
    }
}
-(void)requestEachStepData{
    if (self.currentStep == 0) {
        //请求第一步 承兑买币
        [ self.viewModel.OTCGetExchangeBuyListCommand execute:nil];
    }else if (self.currentStep == 1){
        //请求第二步 承兑买币
        [ self.viewModel.OTCGetExchangeSellListCommand execute:nil];
    }
}
-(void)bindViewModel{
    //
    if (!self.viewModel) {
        self.viewModel = [[ IDCMAcceptantApplyStepsEndViewModel alloc] init];
    }
    [super bindViewModel];
    @weakify(self);
    //获取承兑买币币种列表和支持支付方式列表
    [[self.viewModel.OTCGetExchangeBuyListCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
       
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"] &&[response[@"data"] isKindOfClass:[NSDictionary class]]) {

            NSArray * exchangeCoinList = response[@"data"][@"ExchangeCoinList"];
            NSArray * exchangePayList = response[@"data"][@"ExchangePayList"];
            
            NSMutableArray * arr1 = [[NSMutableArray alloc] init];
            NSMutableArray * arr2 = [[NSMutableArray alloc] init];
            if ([exchangeCoinList isKindOfClass:[NSArray class]] && exchangeCoinList.count>0) {
          
                
                [exchangeCoinList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  IDCMAcceptVariableModel * model =   [IDCMAcceptVariableModel yy_modelWithDictionary:obj];
                    model .modelType = kAcceptCoinAndLimitationType;
                    [arr1 addObject:model];
                }];
            }
            if ([exchangePayList isKindOfClass:[NSArray class]] && exchangePayList.count>0) {
                [exchangePayList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IDCMAcceptVariableModel * model =   [IDCMAcceptVariableModel yy_modelWithDictionary:obj];
                    model .modelType = kAcceptCurrencyAndPayType;
                    [arr2 addObject:model];
                }];
  
            }
            self.stepOneView.sectionOneArray = arr1;
            self.stepOneView.sectionTwoArray = arr2;
            [self.stepOneView reloadView];
        }
    }];
    
    //获取承兑卖币币种列表和法币数量列表
    [[self.viewModel.OTCGetExchangeSellListCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"] &&[response[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            NSArray * exchangeCoinList = response[@"data"][@"ExchangeCoinList"];
            NSArray * exchangePayList = response[@"data"][@"ExchangePayList"];
            NSMutableArray * arr1 = [[NSMutableArray alloc] init];
            NSMutableArray * arr2 = [[NSMutableArray alloc] init];
            
            if ([exchangeCoinList isKindOfClass:[NSArray class]] && exchangeCoinList.count>0) {
                [exchangeCoinList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IDCMAcceptVariableModel * model =   [IDCMAcceptVariableModel yy_modelWithDictionary:obj];
                    model .modelType = kAcceptCoinAndLimitationType;
                    [arr1 addObject:model];
                }];
            }
            if ([exchangePayList isKindOfClass:[NSArray class]] && exchangePayList.count>0) {
                [exchangePayList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IDCMAcceptVariableModel * model =   [IDCMAcceptVariableModel yy_modelWithDictionary:obj];
                    model .modelType = kAcceptCurrencyAndAmountType;
                    [arr2 addObject:model];
                }];
   
            }
            self.stepTwoView.sectionOneArray = arr1;
            self.stepTwoView.sectionTwoArray = arr2;
            [self.stepTwoView reloadView];
        }
    }];
    ///
    //删除承兑币种
    [[self.viewModel.OTCExchangeCoinRemoveCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"]) {
            //刷新
            [self requestEachStepData];
        }
    }];
    
    //法币和资金量
    [[self.viewModel.OTCExchangeLocalCurrencyRemoveCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"]) {
            //刷新
            [self requestEachStepData];
        }
    }];
    
    
    //删除支付方式
    [[self.viewModel.OTCExchangePayModeRemoveCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"]) {
            //刷新
            [self requestEachStepData];
        }
    }];
    //获取支付方式
    [[self.viewModel.OTCGetExchangePayModeListCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"]) {
            //弹框
            NSArray * payMethodsList = response[@"data"];
            NSMutableArray * arr = [[NSMutableArray alloc] init];
            if ([payMethodsList isKindOfClass:[NSArray class]] && payMethodsList.count>0) {
                [payMethodsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IDCMOTCPaymentModel * model =   [IDCMOTCPaymentModel yy_modelWithDictionary:obj];
                    [arr addObject:model];
                }];
            }
            
            for (IDCMAcceptVariableModel * model1 in self.stepOneView.sectionTwoArray) {
                for (IDCMOTCPaymentModel * model2  in arr) {
                    if (model1.payModeId == model2.ID) {
                        model2.isSelected  = YES;
                    }
                }
            }
            
            if (arr.count>0) {
                //展示
                [IDCMSelectPayMethodsView showWithTitle:SWLocaloziString(@"3.0_AcceptantRecievePayType") models:arr canMultipleSelect:YES isFilter:YES cellConfigure:^(SelectPayViewCell *cell, IDCMOTCPaymentModel * paymentModel) {
                    
                    if ([paymentModel.PayTypeCode isEqualToString:@"AliPay"]) { //支付宝
                        cell.countryLabel.text = paymentModel.LocalCurrencyCode;
                        cell.payTitleLabel.text =  SWLocaloziString(@"3.0_DK_otcAlipay");// paymentModel.PayAttributes.BankName;
                        cell.payAccountLabel.text = paymentModel.PayAttributes.AccountNo;
                        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:paymentModel.PayTypeLogo]];
                    }
                    if ([paymentModel.PayTypeCode isEqualToString:@"Bankcard"]) { //银行卡
                        cell.countryLabel.text = paymentModel.LocalCurrencyCode;
                        cell.payTitleLabel.text = paymentModel.PayAttributes.BankName;
                        cell.payAccountLabel.text =
                        [IDCMUtilsMethod addSpaceByString:paymentModel.PayAttributes.BankNoHide separateCount:4];
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
                    NSMutableString * currencyStrs = [[NSMutableString alloc] init] ;
                    for (NSUInteger i=0; i<models.count; i++) {
                        IDCMOTCPaymentModel * model = models[i];
                        [currencyStrs appendString:[NSString stringWithFormat:@",%ld",(long)model.ID]];
                    }
                    [self.viewModel.OTCExchangePayModeAddCommand execute:@{@"ID":currencyStrs}];
                }];
            }
        }else if([status isEqualToString:@"619"]){
            
            //跳转到添加支付方式
            [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                configure.title(SWLocaloziString(@"3.0_DK_settPay"));
                [configure.getBtnsConfig removeFirstObject];
                configure.getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_DK_goSetting")).btnCallback(^{
                    
                    [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMPayMethodController"
                                                                       withViewModelName:@"IDCMPayMethodViewModel"
                                                                              withParams:@{@"type":@0}
                                                                                animated:YES];
                    
                });
            }];
            
        }else{
            
            [IDCMShowMessageView showMessageWithCode:status];
        }
    }];
    //增加支付方式
    [[self.viewModel.OTCExchangePayModeAddCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        @strongify(self);
        [self requestEachStepData];

    }];
    
    //
    [[self.viewModel.OTCSetCurrentStepCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"] && [response[@"data"] boolValue]) {
            if (self.currentStep == 0) {

                self.stepTwoView.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
                [UIView animateWithDuration: .35
                                      delay: 0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     @strongify(self);
                                     self.stepOneView.alpha = 0.0;
                                     self.stepTwoView.alpha = 1.0;
                                     self.stepTwoView.transform = CGAffineTransformIdentity;
                                     self.stepOneView.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
                                 } completion:^(BOOL finished) {
                                     @strongify(self);
                                     [self.firstHead setStepIndex:1 animation:NO];
                                     self.currentStep = 1;
                                     // 防止第二步没点确定 退出
                                     [self requestEachStepData];
                                 }];
                
          
            }else if (self.currentStep == 1){
                
                self.bondView.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
                [UIView animateWithDuration: .35
                                      delay: 0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     @strongify(self);
                                     self.stepTwoView.alpha = 0.0;
                                     self.bondView.alpha = 1.0;
                                     self.bondView.transform = CGAffineTransformIdentity;
                                     self.stepTwoView.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
                                 } completion:^(BOOL finished) {
                                     @strongify(self);
                                     [self.firstHead setStepIndex:2 animation:NO];
                                     self.currentStep = 2;
                                 }];
            }
        }
    }];
}

-(UIView *) currentPage{
    
    if (self.currentStep == 0) {
        return self.stepOneView;
    }else if(self.currentStep == 1){
        return self.stepTwoView;

    }else if (self.currentStep == 2){
        return self.bondView;
    }
    return nil;
}

#pragma arguments
//过了第一步 不再后退
- (BOOL)shouldHoldBackButtonEvent{
    if (self.currentStep >0) {
        return YES;
    }
    return NO;
}
- (BOOL)canPopViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return NO;
}
#pragma mark -
//步骤 一
-(IDCMApplyAcceptantStepView *) stepOneView{
    return SW_LAZY(_stepOneView, ({
        @weakify(self);
      IDCMApplyAcceptantStepView * stepOne = [IDCMApplyAcceptantStepView applyAcceptantStepViewWithFrame:CGRectMake(0, 60 + adjustHeight, self.view.width, self.view.height - 60 -adjustHeight) type:1 subTitles:@[SWLocaloziString(@"3.0_Bin_AddCurrencyLimit_Buy"),SWLocaloziString(@"3.0_Bin_AddPayType")]
                                       completeSignal:RACSubject.createSubject(^(id value){
          
            @strongify(self);
          
            [self.viewModel.OTCSetCurrentStepCommand execute:@2];
        })];

        [stepOne.deleteSubject subscribeNext:^(IDCMAcceptVariableModel * model) {
            
            if (model.modelType == kAcceptCoinAndLimitationType) {
                [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                    configure.title(SWLocaloziString(@"3.0_AcceptantCoinDeleteTip")).getBtnsConfig.lastObject.btnCallback(^{
                        @strongify(self);
                        [self.viewModel.OTCExchangeCoinRemoveCommand execute:@{@"ID":model.dataID}];
                    }) ;
                }];
            }else if(model.modelType == kAcceptCurrencyAndPayType){
                [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                    configure.title(SWLocaloziString(@"3.0_AcceptantCurrencyDeleteTip")).getBtnsConfig.lastObject.btnCallback(^{
                        @strongify(self);
                        [self.viewModel.OTCExchangePayModeRemoveCommand execute:@{@"ID":model.dataID}];
                    }) ;
                }];
            }
        }];
        [stepOne.editSubject subscribeNext:^(IDCMAcceptVariableModel * model) {
            @strongify(self);
            if (model.modelType == kAcceptCoinAndLimitationType) {
                
                if (!model.coinCode ) return ;
                NSDictionary * editParams = @{
                                              @"title":SWLocaloziString(@"3.0_AcceptantEditAddBuyCurrency"),
                                              @"max":model.max,
                                              @"min":model.min,
                                              @"coinCode":model.coinCode,
                                              @"premium":model.premiumReal,
                                              @"dataID":model.dataID,
                                              };
                [IDCMMediatorAction
                 idcm_pushViewControllerWithClassName:@"IDCMAcceptantApplyAddCurrencyController"
                 withViewModelName:@"IDCMAcceptantApplyAddCurrencyViewModel"
                 withParams:@{@"editDict":editParams,@"currencyType":@2}
                 animated:YES
                 completion:^(NSDictionary *para) {
                     @strongify(self);
                     [self.viewModel.OTCGetExchangeBuyListCommand execute:nil];
                 }];
            }else if(model.modelType == kAcceptCurrencyAndPayType){
                [self.viewModel.OTCGetExchangePayModeListCommand execute:nil];
            }
        }];
        
        [stepOne.sectionHeaderSubject subscribeNext:^(NSDictionary * params) {
            @strongify(self);
            if ([params[@"section"] isEqualToString:@"0"]) {
                [IDCMMediatorAction
                 idcm_pushViewControllerWithClassName:@"IDCMAcceptantApplyAddCurrencyController"
                 withViewModelName:@"IDCMAcceptantApplyAddCurrencyViewModel"
                 withParams:@{@"currencyType":@0}
                 animated:YES
                 completion:^(NSDictionary *para) {
                     @strongify(self);
                     [self.viewModel.OTCGetExchangeBuyListCommand execute:nil];
                 }];
            }else if([params[@"section"] isEqualToString:@"1"]){
                [self.viewModel.OTCGetExchangePayModeListCommand execute:nil];
            }
        }];

        stepOne.sectionHeaderTitles =@[@[SWLocaloziString(@"3.0_Bin_AcceptBuyCoinLimit"),SWLocaloziString(@"3.0_Bin_AcceptBuyCurrency"),SWLocaloziString(@"3.0_Bin_EachAcceptanceLimit"),SWLocaloziString(@"3.0_Bin_PricePremium")],@[SWLocaloziString(@"3.0_Bin_LocalCuccencyType"),SWLocaloziString(@"3.0_Bin_FiatCurrency"),SWLocaloziString(@"3.0_Bin_PayType")]];
        stepOne;
    }));
}
//步骤 二
-(IDCMApplyAcceptantStepView *) stepTwoView{
    return SW_LAZY(_stepTwoView, ({
        @weakify(self);
      IDCMApplyAcceptantStepView * stepTwo = [IDCMApplyAcceptantStepView applyAcceptantStepViewWithFrame:CGRectMake(0, 60 + adjustHeight, self.view.width, self.view.height - 60 -adjustHeight) type:2 subTitles:@[SWLocaloziString(@"3.0_Bin_AddCurrencyLimit_Sell"),SWLocaloziString(@"3.0_AcceptantAddCurrencyAndAmount")]
                                                     completeSignal:RACSubject.createSubject(^(id value){
          
            @strongify(self);
          
            //
            [self.viewModel.OTCSetCurrentStepCommand execute:@3];

        })];
        
        [stepTwo.deleteSubject subscribeNext:^(IDCMAcceptVariableModel * model) {
            
            if (model.modelType == kAcceptCoinAndLimitationType) {
                [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                    configure.title(SWLocaloziString(@"3.0_AcceptantCoinDeleteTip")).getBtnsConfig.lastObject.btnCallback(^{
                        @strongify(self);
                        [self.viewModel.OTCExchangeCoinRemoveCommand execute:@{@"ID":model.dataID}];
                    }) ;
                }];
            }else if(model.modelType == kAcceptCurrencyAndAmountType){
                [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                    configure.title(SWLocaloziString(@"3.0_AcceptantConfirmRemoveCurrecyAndAmount")).getBtnsConfig.lastObject.btnCallback(^{
                        @strongify(self);
                        [self.viewModel.OTCExchangeLocalCurrencyRemoveCommand execute:@{@"ID":model.dataID}];
                    }) ;
                }];
            }
        }];
        
        [stepTwo.editSubject subscribeNext:^(IDCMAcceptVariableModel * model) {
            
            if (model.modelType == kAcceptCoinAndLimitationType) {
                
                if (!model.coinCode ) return ;
                NSDictionary * editParams = @{
                                              @"title":SWLocaloziString(@"3.0_AcceptantEditAddSellCurrency"),
                                              @"max":model.max,
                                              @"min":model.min,
                                              @"coinCode":model.coinCode,
                                              @"premium":model.premiumReal,
                                              @"dataID":model.dataID,
                                              };
                [IDCMMediatorAction
                 idcm_pushViewControllerWithClassName:@"IDCMAcceptantApplyAddCurrencyController"
                 withViewModelName:@"IDCMAcceptantApplyAddCurrencyViewModel"
                 withParams:@{@"editDict":editParams,@"currencyType":@3}
                 animated:YES
                 completion:^(NSDictionary *para) {
                     @strongify(self);
                     [self.viewModel.OTCGetExchangeSellListCommand execute:nil];
                 }];
            }else if(model.modelType == kAcceptCurrencyAndAmountType){
                NSDictionary * editParams = @{
                                              @"LocalCurrencyId":model.currencyName,
                                              @"Amount":model.amount,
                                              @"dataID":model.dataID,
                                              };
                [IDCMMediatorAction
                 idcm_pushViewControllerWithClassName:@"IDCMAcceptantApplyAddPayCurrencyController"
                 withViewModelName:@"IDCMAcceptantApplyAddPayCurrencyViewModel"
                 withParams:@{@"editDict":editParams,@"pageType":@1}
                 animated:YES
                 completion:^(NSDictionary *para) {
                     @strongify(self);
                     [self.viewModel.OTCGetExchangeSellListCommand execute:nil];
                 }];
            }
        }];
        
        [stepTwo.sectionHeaderSubject subscribeNext:^(NSDictionary * params) {
            if ([params[@"section"] isEqualToString:@"0"]) {
                [IDCMMediatorAction
                 idcm_pushViewControllerWithClassName:@"IDCMAcceptantApplyAddCurrencyController"
                 withViewModelName:@"IDCMAcceptantApplyAddCurrencyViewModel"
                 withParams:@{@"currencyType":@1}
                 animated:YES
                 completion:^(NSDictionary *para) {
                     @strongify(self);
                     [self.viewModel.OTCGetExchangeSellListCommand execute:nil];
                 }];
            }else if([params[@"section"] isEqualToString:@"1"]){
                [IDCMMediatorAction
                 idcm_pushViewControllerWithClassName:@"IDCMAcceptantApplyAddPayCurrencyController"
                 withViewModelName:@"IDCMAcceptantApplyAddPayCurrencyViewModel"
                 withParams:nil
                 animated:YES
                 completion:^(NSDictionary *para) {
                     @strongify(self);
                     [self.viewModel.OTCGetExchangeSellListCommand execute:nil];
                 }];
            }
        }];
    stepTwo.sectionHeaderTitles=@[@[SWLocaloziString(@"3.0_AcceptantSellCoinCurrencyAndLimitation"),SWLocaloziString(@"3.0_Bin_AcceptBuyCurrency"),SWLocaloziString(@"3.0_Bin_EachAcceptanceLimit"),SWLocaloziString(@"3.0_Bin_PricePremium")],@[SWLocaloziString(@"3.0_AcceptantAcceptCurrencyTypeAndAmount"),SWLocaloziString(@"3.0_CurrencyType"),SWLocaloziString(@"3.0_CurrencyCount")]];
        stepTwo;
        
    }));
}

//步骤 三
- (IDCMAcceptantPickinBondView *)bondView {
    return SW_LAZY(_bondView, ({
        
        @weakify(self);
        [IDCMAcceptantPickinBondView bondViewWithFrame:CGRectMake(0, 70 + adjustHeight, self.view.width, self.view.height - 70 -adjustHeight)
                                       completeSignal:RACSubject.createSubject(^(id value){
            @strongify(self);
            self.completeView.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
            [UIView animateWithDuration: .35
                                  delay: 0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 @strongify(self);
                                 self.bondView.alpha = 0.0;
                                 self.completeView.alpha = 1.0;
                                 self.completeView.transform = CGAffineTransformIdentity;
                                 self.bondView.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
                             } completion:^(BOOL finished) {
                                 @strongify(self);
                                 self.bondView.hidden = YES;
                                 [self.firstHead setStepIndex:3 animation:NO];
                                 self.currentStep = 3;
                             }];
        })];
    }));
}

////步骤 四 完成
- (IDCMAcceptantApplyCompleteView *)completeView {
    return SW_LAZY(_completeView, ({
        
        @weakify(self);
        CommandInputBlock commandInput = ^(UIButton *btn){
            @strongify(self);
//            IDCMAcceptantViewController * vc = [IDCMAcceptantViewController new];
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
        [IDCMAcceptantApplyCompleteView completeViewWithFrame:CGRectMake(0, 70+ adjustHeight, self.view.width, self.view.height - 70 -adjustHeight)
                                              completeInput:commandInput];
    }));
}
//头部的进度 显示
-( IDCMSegmentProcessView * )firstHead{
    
    
    if (!_firstHead) {
        _firstHead = [[IDCMSegmentProcessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,58 + adjustHeight) titles:@[SWLocaloziString(@"3.0_Bin_AcceptSellCoin"),SWLocaloziString(@"3.0_Bin_AcceptBuyCoin"),SWLocaloziString(@"3.0_Bin_RechargeDeposit"),SWLocaloziString(@"3.0_Bin_RechargeComplite")]];
    }
    return _firstHead;
}

@end
