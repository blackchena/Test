//
//  IDCMAcceptSaleCoinViewController.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptSellCoinViewController.h"
#import "IDCMAcceptVariableModel.h"
#import "IDCMApplyAcceptantStepView.h"
#import "IDCMAcceptantApplyStepsEndViewModel.h"


@interface IDCMAcceptSellCoinViewController ()
@property (strong, nonatomic, readonly) IDCMAcceptantApplyStepsEndViewModel *viewModel;
@property (nonatomic,strong) IDCMApplyAcceptantStepView * stepTwoView;


@end

@implementation IDCMAcceptSellCoinViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUIView];
    [self requestExchangeSellList];

    // Do any additional setup after loading the view.
}


-(void)initUIView{
    self.view.backgroundColor  = viewBackgroundColor;
    [self.view addSubview:self.stepTwoView];
}

-(void)requestExchangeSellList{

    [ self.viewModel.OTCGetExchangeSellListCommand execute:nil];
}
-(void)bindViewModel{
    
    [super bindViewModel];
    @weakify(self);
    
    //获取承兑买币币种列表和支持支付方式列表
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
            [self requestExchangeSellList];
        }else{
            
            //删除 错误
        }
    }];
    //法币和资金量
    [[self.viewModel.OTCExchangeLocalCurrencyRemoveCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *  response) {
        
        @strongify(self);
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"]) {
            //刷新
            [self requestExchangeSellList];
        }else{
            
            //删除 错误
        }
    }];
    
}


#pragma mark - 懒加载
//步骤 二
-(IDCMApplyAcceptantStepView *) stepTwoView{
    return SW_LAZY(_stepTwoView, ({
        @weakify(self);
        IDCMApplyAcceptantStepView * stepTwo = [IDCMApplyAcceptantStepView applyAcceptantStepViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-235-64-kStatusBarDifferHeight-kSafeAreaBottom) type:2 subTitles:@[SWLocaloziString(@"3.0_Bin_AddCurrencyLimit_Sell"),SWLocaloziString(@"3.0_AcceptantAddCurrencyAndAmount")]
                                                                                            completeSignal:nil];
        
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
                if (! model.coinCode )  return ;
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

@end
