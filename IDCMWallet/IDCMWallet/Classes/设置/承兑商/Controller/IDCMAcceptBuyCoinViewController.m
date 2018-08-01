//
//  IDCMAcceptSellCoinViewController.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptBuyCoinViewController.h"
#import "IDCMAcceptVariableModel.h"
#import "IDCMAcceptantApplyStepsEndViewModel.h"
#import "IDCMApplyAcceptantStepView.h"
#import "IDCMOTCPaymentModel.h"
#import "IDCMSelectPayMethodsView.h"

@interface IDCMAcceptBuyCoinViewController ()
@property (strong, nonatomic, readonly) IDCMAcceptantApplyStepsEndViewModel *viewModel;
@property (nonatomic,strong) IDCMApplyAcceptantStepView * stepOneView;
@end

@implementation IDCMAcceptBuyCoinViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUIView];
    [self requestExchangeBuyList];

}
-(void)initUIView{
    
    self.view.backgroundColor  = viewBackgroundColor;
    [self.view addSubview:self.stepOneView];
}
//买
-(void)requestExchangeBuyList{

    [ self.viewModel.OTCGetExchangeBuyListCommand execute:nil];
}
-(void)bindViewModel{
    
    [super bindViewModel];
    @weakify(self);
    //获取承兑买币币种列表和法币数量列表
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
        }else{
            
            //请求数据错误
        }
    }];
    //删除承兑币种
    [[self.viewModel.OTCExchangeCoinRemoveCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"]) {
            //刷新
            [ self.viewModel.OTCGetExchangeBuyListCommand execute:nil];
        }else{
            
            //删除 错误
        }
    }];
    
    //获取支付方式
    [[self.viewModel.OTCGetExchangePayModeListCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"]) {
            //弹框
            NSArray * payMethodsList = response[@"data"];
            NSMutableArray < IDCMOTCPaymentModel *> * arr = [[NSMutableArray alloc] init];
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
        [self requestExchangeBuyList];
    }];
    //删除支付方式
    [[self.viewModel.OTCExchangePayModeRemoveCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"]) {
            //刷新
            [self requestExchangeBuyList];
        }else{
            //删除 错误
        }
    }];
    
    // 承兑买币的删除
    [self.stepOneView.deleteSubject subscribeNext:^(IDCMAcceptVariableModel * model) {
        
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
    // 承兑买币的编辑
    [self.stepOneView.editSubject subscribeNext:^(IDCMAcceptVariableModel * model) {
        @strongify(self);
        if (model.modelType == kAcceptCoinAndLimitationType) {
            
            if (! model.coinCode) return ;
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
             }
             ];
        }else if(model.modelType == kAcceptCurrencyAndPayType){
            [self.viewModel.OTCGetExchangePayModeListCommand execute:nil];
        }
    }];
    // 承兑买币的增加
    [self.stepOneView.sectionHeaderSubject subscribeNext:^(NSDictionary * params) {
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
    
    
}
//步骤 一
-(IDCMApplyAcceptantStepView *) stepOneView{
    return SW_LAZY(_stepOneView, ({
    
        IDCMApplyAcceptantStepView * stepOne = [IDCMApplyAcceptantStepView applyAcceptantStepViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-235-64-kStatusBarDifferHeight-kSafeAreaBottom) type:1 subTitles:@[SWLocaloziString(@"3.0_Bin_AddCurrencyLimit_Buy"),SWLocaloziString(@"3.0_Bin_AddPayType")]
                                                                                            completeSignal:nil];
        stepOne.sectionHeaderTitles =@[@[SWLocaloziString(@"3.0_Bin_AcceptBuyCoinLimit"),SWLocaloziString(@"3.0_Bin_AcceptBuyCurrency"),SWLocaloziString(@"3.0_Bin_EachAcceptanceLimit"),SWLocaloziString(@"3.0_Bin_PricePremium")],@[SWLocaloziString(@"3.0_Bin_LocalCuccencyType"),SWLocaloziString(@"3.0_Bin_FiatCurrency"),SWLocaloziString(@"3.0_Bin_PayType")]];
        stepOne;
    }));
}


@end

