//
//  IDCMSendCoinController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/21.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMSendCoinController.h"
#import "IDCMSendCoinViewModel.h"

#import "IDCMScanQrCodeController.h"
#import "IDCMCurrencyMarketModel.h"
#import "IDCMSendSuccessView.h"
#import "IDCMUserInfoModel.h"
#import "IDCMBioMetricAuthenticator.h"
#import "IDCMSendAddressView.h"
#import "IDCMSendCoinView.h"
#import "IDCMFeeView.h"


@interface IDCMSendCoinController ()<UITextFieldDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMSendCoinViewModel *viewModel;
/**
 *  uiscorllciew
 */
@property (strong, nonatomic) UIScrollView *scrollview;
/**
 *  contentView
 */
@property (strong, nonatomic) UIView *contentView;
/**
 *  接收地址
 */
@property (strong, nonatomic) IDCMSendAddressView *reciveView;
/**
 *  发送数量
 */
@property (strong, nonatomic) IDCMSendCoinView *sendView;
/**
 *  矿工费
 */
@property (strong, nonatomic) IDCMFeeView *feeView;
/**
 *  发送按钮
 */
@property (strong, nonatomic) UIButton *sendButton;
/**
 *  密码输入框
 */
@property (strong, nonatomic) IDCMPINView *passwordView;
/**
 *  发送成功页面
 */
@property (strong, nonatomic) IDCMSendSuccessView *successView;
/**
 *  是否设置faceID
 */
@property (assign, nonatomic) BOOL isfaceID;
/**
 *   支付密码
 */
@property (copy, nonatomic) NSString *payPassWord;
/**
 *  推荐费Disposable
 */
@property (strong, nonatomic) RACDisposable *feeDisposable;
/**
 *  地址Disposable
 */
@property (strong, nonatomic) RACDisposable *addressDisposable;
/**
 *  地址切割Disposable
 */
@property (strong, nonatomic) RACDisposable *complicatedAddressDisposable;

@end

@implementation IDCMSendCoinController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseData];
    
    [self subViewsLayout];
}

#pragma mark - configBase
- (void)configBaseData
{
    self.view.backgroundColor = SetColor(245, 247, 249);
    self.navigationItem.title = NSLocalizedString(@"2.0_SendButton", nil);
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[self class]];
    
    // 应用退到后台时移除弹框
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:RemoveAlertKey object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        
        [IDCMScrollViewPageTipView dismissWithComletion:nil];
    }];
    
    if (self.viewModel.marketModel.isToken) {
        self.feeView.feeLabel.text = [self.viewModel.marketModel.coinUnit uppercaseString];
    }else{
        self.feeView.feeLabel.text = [self.viewModel.marketModel.currency uppercaseString];
    }
    self.viewModel.fee = @(0);

    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:self.viewModel.marketModel.realityBalance]];
    NSInteger currencyPresion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:self.viewModel.marketModel.currency_unit withType:kIDCMCurrencyPrecisionQuantity];
    NSString *str = [NSString stringFromNumber:num fractionDigits:currencyPresion];
    NSString *bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
    self.sendView.sendTitleLable.text = [NSString stringWithFormat:@"%@ %@: %@",[self.viewModel.marketModel.currency uppercaseString],NSLocalizedString(@"2.0_SendBlance", nil),bitcoinString];
    self.sendView.coinTypeLabel.text = [self.viewModel.marketModel.currency uppercaseString];
    
    
}
- (void)subViewsLayout
{
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollview);
        make.width.equalTo(self.scrollview);
        make.height.equalTo(@(SCREEN_HEIGHT-kNavigationBarHeight-kSafeAreaTop));
    }];
    // 发送数量模块
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollview);
        make.top.equalTo(self.scrollview.mas_top);
        make.height.equalTo(@87);
    }];
    
    // 接收地址模块
    [self.reciveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollview);
        make.top.equalTo(self.sendView.mas_bottom).offset(10);
        make.height.equalTo(@70);
    }];
    
    // 矿工费模块
    CGFloat feeHeight;
    if (self.viewModel.currencyLayoutType == kIDCMCurrencyLayoutTypeNomal) {
        feeHeight = 105;
    }else if(self.viewModel.currencyLayoutType == kIDCMCurrencyLayoutTypeHidenSlider){
        feeHeight = 83;
    }else{
        feeHeight = 40;
    }
    [self.feeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollview);
        make.top.equalTo(self.reciveView.mas_bottom).offset(10);
        make.height.equalTo(@(feeHeight));
    }];
    
    // 发送按钮
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollview.mas_right).offset(-15);
        make.left.equalTo(self.scrollview.mas_left).offset(15);
        make.top.equalTo(self.feeView.mas_bottom).offset(16);
        make.height.equalTo(@40);
    }];
}
#pragma mark - Bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    // 扫描
    [self.reciveView.scanButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
            @strongify(self);
            if (granted) {
                IDCMScanQrCodeController *scanVC= [IDCMScanQrCodeController new];
                scanVC.libraryType = SLT_Native;
                scanVC.scanCodeType = SCT_QRCode;
                scanVC.style = [IDCMUtilsMethod scanStyleWith:0 andWithBorderColor:nil];
                scanVC.isNeedScanImage = NO;
                scanVC.scanQRCodeBlock = ^(NSString *scanStr) {
                    @strongify(self);
                    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@":=&?-+*%#@()"];
                    NSRange range = [scanStr rangeOfCharacterFromSet:cset];
                    if (range.location != NSNotFound) {
                        NSDictionary *param = @{
                                                @"address":scanStr,
                                                @"currency":[self.viewModel.marketModel.currency lowercaseString]
                                                };
                        [self.viewModel.validComplicatedAddressCommand execute:param];
                    }else{
                        self.reciveView.reciveAddressTextField.text = scanStr;
                        [self.viewModel.varifyAddressCommand execute:nil];
                    }
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
    }];
    self.addressDisposable = [[[self.viewModel.varifyAddressCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         if ([response[@"data"] isKindOfClass:[NSNumber class]]) {
             if ([response[@"data"] integerValue] == 0 || [status isEqualToString:@"0"]) {
                 [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
             }
         }else{
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
         }
         
     }];
    self.complicatedAddressDisposable = [[[self.viewModel.validComplicatedAddressCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         NSString *address = [NSString idcw_stringWithFormat:@"%@",response[@"data"]];
         if ([status isEqualToString:@"1"] && [address isNotBlank]) {
             self.reciveView.reciveAddressTextField.text = address;
         }else{
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
         }
     }];
    
    // 绑定发送数量已经发送地址
    RAC(self.viewModel,reciveAddress) = [RACObserve(self.reciveView.reciveAddressTextField, text) merge:self.reciveView.reciveAddressTextField.rac_textSignal];
    RAC(self.viewModel,amount) = [RACObserve(self.sendView.sendTextField, text) merge:self.sendView.sendTextField.rac_textSignal];
    RAC(self.viewModel,comment) = [RACObserve(self.feeView.feeTextField, text) merge:self.feeView.feeTextField.rac_textSignal];

    [[self.viewModel.validAddressSignal deliverOnMainThread]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         if ([value integerValue] == 0) {
             self.sendButton.enabled = NO;
             [self.sendButton setTitleColor:SetAColor(255, 255, 255, 0.5) forState:UIControlStateNormal];
         }else{
             self.sendButton.enabled = YES;
             [self.sendButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
         }
     }];
    
    
    // 点击确认发送
    [[self.sendButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self.view endEditing:YES];
         
         // 余额不足
         if ([self.viewModel.marketModel.balance isEqualToNumber:self.viewModel.marketModel.realityBalance] && [self.viewModel.marketModel.balance compare:[NSDecimalNumber decimalNumberWithString:self.viewModel.amount]] == NSOrderedAscending) {
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_WalletInsuff", nil)];
             return;
         }
         
         // 是代币的情况，并且ETH不足
         if (self.viewModel.marketModel.isToken) {

             if ([self.viewModel.marketModel.ethBalanceForToken compare:[NSDecimalNumber decimalNumberWithString:self.viewModel.recommendModel.slow]] == NSOrderedAscending || [self.viewModel.marketModel.ethBalanceForToken compare:@(0)] == NSOrderedAscending) {
                 [IDCMShowMessageView showErrorWithMessage:[NSString stringWithFormat:@"%@%@",[self.viewModel.marketModel.coinUnit uppercaseString],NSLocalizedString(@"2.2.1_TokenWalletInsuff", nil)]];
                 return;
             }
         }
         
         // 判断是否在转汇确认中
         if ([self.viewModel.marketModel.balance compare:self.viewModel.marketModel.realityBalance] == NSOrderedAscending && [self.viewModel.marketModel.balance compare:[NSDecimalNumber decimalNumberWithString:self.viewModel.amount]] == NSOrderedAscending) {
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_TransferSend", nil)];
             return;
         }
         
         // ETH、ETC、以及ETH的代币不做最小发送金额限制
         if (!self.viewModel.marketModel.isToken && ![[self.viewModel.marketModel.currency uppercaseString] isEqualToString:@"ETC"] && ![[self.viewModel.marketModel.currency uppercaseString] isEqualToString:@"ETH"]) {
             
             NSString *minAmount = @"";
             if ([[self.viewModel.marketModel.currency uppercaseString] isEqualToString:@"LTC"]) {
                 minAmount = @"0.0006";
             }else{
                 minAmount = @"0.00006";
             }
             if ([[NSDecimalNumber decimalNumberWithString:self.viewModel.amount] compare:[NSDecimalNumber decimalNumberWithString:minAmount]] == NSOrderedAscending) {
                 [IDCMShowMessageView showErrorWithMessage:[NSString idcw_stringWithFormat:@"%@%@",SWLocaloziString(@"2.0_MinNum"),minAmount]];
                 return;
             }
         }else{
             
             if ([[NSDecimalNumber decimalNumberWithString:self.viewModel.amount] compare:@(0)] == NSOrderedSame) {
                 [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_SendNumberNotZero")];
                 return;
             }
             
         }
         
         // 校验发送金额
         [self.viewModel.validSendFormCommand execute:nil];
     }];
    
    // 校验发送
    [[[self.viewModel.validSendFormCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         
         @strongify(self);
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         
         if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
             
             NSString *statusCode = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"statusCode"]];
             if ([statusCode isEqualToString:@"0"]) { // 无OTC订单
                 
                 NSString *tag = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"tag"]];
                 if ([tag isEqualToString:@"pending"]) { // 在pending状态,不能有第二笔发送
                     [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.2.1_IsPending")];
                     return ;
                 }else if ([tag isEqualToString:@"lackofmoney"]){ // 有转汇中的交易，不能发送下一笔
                     [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.0_TransferSend")];
                     return ;
                 }
                 
                 self.viewModel.amount = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"amount"]];
                 self.viewModel.fee = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",response[@"data"][@"fee"]]];
                 self.viewModel.reciveAddress = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"toAddress"]];
                 NSString *fee = @"";
                 if (self.viewModel.marketModel.isToken) {
                     fee = [NSString idcw_stringWithFormat:@"%@ %@",[NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:self.viewModel.fee]],[self.viewModel.marketModel.coinUnit uppercaseString]];
                 }else{
                     fee = [NSString idcw_stringWithFormat:@"%@ %@",[NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:self.viewModel.fee]],[self.viewModel.marketModel.currency uppercaseString]];
                 }
                 NSString *des = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"2.0_Describe", nil),NSLocalizedString(@"2.0_ConfirmLeaveDes", nil)];
                 NSMutableAttributedString *atr = [self configAttitues:des withRange:NSMakeRange(NSLocalizedString(@"2.0_Describe", nil).length+1, NSLocalizedString(@"2.0_ConfirmLeaveDes", nil).length)];
                 NSArray *arr = @[RACTuplePack(SWLocaloziString(@"2.0_SendReciveAddress"),self.viewModel.reciveAddress,@(30)),RACTuplePack(SWLocaloziString(@"2.0_MinersCost"),fee,@(30)),RACTuplePack(atr,self.feeView.feeTextField.text,@(60))];
                 IDCMAcceptantBondSureView *view = [IDCMAcceptantBondSureView bondSureViewWithTitle:SWLocaloziString(@"2.0_ConfirmationSend")
                                                                                           subTitle:[NSString idcw_stringWithFormat:@"%@ %@",self.viewModel.amount,[self.viewModel.marketModel.currency uppercaseString]]
                                                                                       sureBtnTitle:SWLocaloziString(@"2.0_ConfirmationSend")
                                                                                          confidArr:arr
                                                                                      closeBtnInput:^(id input) {
                                                                                          // 关闭
                                                                                          [IDCMScrollViewPageTipView dismissWithComletion:nil];
                                                                                      }
                                                                                       sureBtnInput:^(id input) {
                                                                                           @strongify(self);
                                                                                           // 跳转到输入PIN页面时，清除PIN
                                                                                           [self.passwordView removePasseword:NO];
                                                                                           [self judgeFaceIDPayOrPINPay];
                                                                                       }];
                 self.passwordView = [IDCMPINView bindPINViewType:IDCMPINButtonImageBackType
                                                    closeBtnInput:^(id input) {
                                                        // 返回上一页
                                                        [IDCMScrollViewPageTipView scrollToLastPage];
                                                    }
                                                   PINFinishBlock:^(NSString *password) {
                                                       @strongify(self);
                                                       self.viewModel.payPassword = password;
                                                       [self.viewModel.sendCommand execute:@"0"];
                                                   }];
                 
                 self.successView = [IDCMSendSuccessView bondSendSuccessViewWithCurrency:[self.viewModel.marketModel.currency uppercaseString]
                                                                            sureBtnInput:^(id input) {
                                                                                @strongify(self);
                                                                                [IDCMScrollViewPageTipView dismissWithComletion:nil];
                                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                            }
                                                                             finishBlock:^{
                                                                                 @strongify(self);
                                                                                 [IDCMScrollViewPageTipView dismissWithComletion:nil];
                                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                                             }];
                 
                 [IDCMScrollViewPageTipView showTipViewToView:nil
                                                 contentViews:@[view, self.passwordView,self.successView]
                                                 contentSizes:@[@(CGSizeMake(SCREEN_WIDTH, 440 + kSafeAreaBottom))]
                                             initialPageIndex:0
                                                scrollEnabled:NO
                                                 positionType:ScrollViewPageTipViewPositionType_Bottom];
                 
             }else if ([statusCode isEqualToString:@"802"]){  // 有OTC订单
                 
                 [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_OngoingOTCOrders")];
                 
             }
    
         }else if ([status isEqualToString:@"401"]){
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
         }
     }];
    
    // 输入支付密码支付
    [[[self.viewModel.sendCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         [self fetchSendFormData:response];
         
     }];
    // 输入支付密码发送出错了
    [self.viewModel.sendCommand.errors subscribeNext:^(NSError * error) {

        [IDCMScrollViewPageTipView dismissWithComletion:^{
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendFail", nil)];
        }];
        
    }];
    
    // faceID支付
    [[[self.viewModel.sendFaceIDCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         [self fetchSendFormData:response];
     }];
    // faceID支付发送出错了
    [self.viewModel.sendFaceIDCommand.errors subscribeNext:^(NSError * error) {

        [IDCMScrollViewPageTipView dismissWithComletion:^{
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendFail", nil)];
        }];

    }];


    // 监听发送输入框输入框是否结束状态
    [[self
      rac_signalForSelector:@selector(textFieldDidEndEditing:)
      fromProtocol:@protocol(UITextFieldDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         if (!self.viewModel.marketModel.isToken) {
             if (![[NSDecimalNumber decimalNumberWithString:self.viewModel.amount] isEqualToNumber:@(0)] && [self.sendView.sendTextField.text isNotBlank]) {
                 NSDictionary *param = @{
                                         @"sendToAddress":[self.viewModel.reciveAddress isNotBlank]?self.viewModel.reciveAddress:@"",
                                         @"amount":[NSDecimalNumber decimalNumberWithString:self.viewModel.amount],
                                         @"currency":[self.viewModel.marketModel.currency lowercaseString]
                                         };
                 [self.viewModel.getRecommendedFeeCommand execute:param];
             }
         }
     }];
    self.reciveView.reciveAddressTextField.delegate = self;
    self.sendView.sendTextField.delegate = self;
    
    // 监听获取推荐费用的数据
    self.feeDisposable = [[[self.viewModel.getRecommendedFeeCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self)
         
         if ([response[@"status"] integerValue] == 1 && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
             
             IDCMRecommendModel *model = [IDCMRecommendModel yy_modelWithDictionary:response[@"data"]];
             self.viewModel.recommendModel = model;
             self.viewModel.fee = [NSDecimalNumber decimalNumberWithString:model.fastFee];
             [self.feeView.slider setIndex:1 animated:YES];
             
             
             if (self.viewModel.marketModel.isToken) { // 是代币
                 
                 if ([self.viewModel.marketModel.currencyLayoutType integerValue] == 1) {
                     self.feeView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[IDCMUtilsMethod changeFloat:model.fastFee],[self.viewModel.marketModel.coinUnit uppercaseString]];
                 }else{
                     self.feeView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.viewModel.marketModel.coinUnit uppercaseString],[IDCMUtilsMethod changeFloat:model.fastFee]];
                 }
                 
             }else{ // 不是代币
                 
                 if ([self.viewModel.marketModel.currencyLayoutType integerValue] == 1) {
                     self.feeView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[IDCMUtilsMethod changeFloat:model.fastFee],[self.viewModel.marketModel.currency uppercaseString]];
                 }else{
                     self.feeView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.viewModel.marketModel.currency uppercaseString],[IDCMUtilsMethod changeFloat:model.fastFee]];
                 }
             }
             
         }
     }];
    // 监听滑块的下标
    [[RACObserve(self.feeView.slider, indexStr) deliverOnMainThread]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         if (self.viewModel.recommendModel) {
             if ([value isEqualToString:@"0"]) {
                 self.viewModel.fee = [NSDecimalNumber decimalNumberWithString:self.viewModel.recommendModel.slow];
                 if (self.viewModel.marketModel.isToken) { // 是代币
                     
                     self.feeView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.viewModel.marketModel.coinUnit uppercaseString],[IDCMUtilsMethod changeFloat:self.viewModel.recommendModel.slow]];
                     
                 }else{ // 不是代币
                     self.feeView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.viewModel.marketModel.currency uppercaseString],[IDCMUtilsMethod changeFloat:self.viewModel.recommendModel.slow]];
                 }
                 
             }else if ([value isEqualToString:@"1"]){
                 self.viewModel.fee = [NSDecimalNumber decimalNumberWithString:self.viewModel.recommendModel.fastFee];
                 if (self.viewModel.marketModel.isToken) { // 是代币
                     
                     self.feeView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.viewModel.marketModel.coinUnit uppercaseString],[IDCMUtilsMethod changeFloat:self.viewModel.recommendModel.fastFee]];
                     
                 }else{ // 不是代币
                     self.feeView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.viewModel.marketModel.currency uppercaseString],[IDCMUtilsMethod changeFloat:self.viewModel.recommendModel.fastFee]];
                 }
                 
             }else if([value isEqualToString:@"2"]){
                 self.viewModel.fee = [NSDecimalNumber decimalNumberWithString:self.viewModel.recommendModel.veryFastFee];
                 if (self.viewModel.marketModel.isToken) { // 是代币
                     
                     self.feeView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.viewModel.marketModel.coinUnit uppercaseString],[IDCMUtilsMethod changeFloat:self.viewModel.recommendModel.veryFastFee]];
                     
                 }else{ // 不是代币
                     self.feeView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.viewModel.marketModel.currency uppercaseString],[IDCMUtilsMethod changeFloat:self.viewModel.recommendModel.veryFastFee]];
                 }
                 
             }
         }
     }];
    
    // 粘贴地址
    [[self.reciveView.pasterButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self.view endEditing:YES];
         UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
         NSString *address = [pasteboard string];
         if ([address isNotBlank]) {
             self.reciveView.reciveAddressTextField.text = address;
             [self.viewModel.varifyAddressCommand execute:nil];
         }
     }];
    
    // 如果是代币，进入页面就请求推荐费用
    if (self.viewModel.marketModel.isToken) {
        NSDictionary *param = @{
                                @"sendToAddress":[self.viewModel.reciveAddress isNotBlank]?self.viewModel.reciveAddress:@"",
                                @"amount":@(1),
                                @"currency":[self.viewModel.marketModel.currency lowercaseString]
                                };
        [self.viewModel.getRecommendedFeeCommand execute:param];
    }
}

#pragma mark - Private methods
- (NSMutableAttributedString *)configAttitues:(NSString *)text withRange:(NSRange)range
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:textColor999999 range:range];
    [attrStr addAttribute:NSFontAttributeName value:textFontPingFangRegularFont(10) range:range];
    return attrStr;
}
// 处理sendForm数据
- (void)fetchSendFormData:(NSDictionary *)response
{
    NSInteger status= [response[@"status"] integerValue];
    
    if ([response[@"data"] isKindOfClass:[NSDictionary class]] && status == 1 && ![response[@"data"][@"statusCode"] isKindOfClass:[NSNull class]]) {
        
        NSString *statusCode = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"statusCode"]];
        NSInteger errorCode = [statusCode integerValue];
        
        if (errorCode == 0) {
            
            if (self.isfaceID) {
                [IDCMScrollViewPageTipView scrollToPageIndex:2];
            }else{
                [IDCMScrollViewPageTipView scrollToNextPage];
            }
            [self.successView bindTimerSignalToHintLabel];
            
        }else if (errorCode == 1){
            [IDCMShowMessageView showErrorWithMessage:[NSString stringWithFormat:@"%@%@",[self.viewModel.marketModel.currency uppercaseString],NSLocalizedString(@"2.2.1_TokenWalletInsuff", nil)]];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else if (errorCode == 3 || errorCode == 102 | errorCode == 107 || errorCode == 108){
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_WalletInsuff", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else if (errorCode == 6){
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else if (errorCode == 106){
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_BinBear_ETHInsufficientSend", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else if (errorCode == 9){
            
            NSString *minAmount = @"";
            if ([[self.viewModel.marketModel.currency uppercaseString] isEqualToString:@"LTC"]) {
                minAmount = @"0.0006";
            }else{
                minAmount = @"0.00006";
            }
            if ([[NSDecimalNumber decimalNumberWithString:self.viewModel.amount] compare:[NSDecimalNumber decimalNumberWithString:minAmount]] == NSOrderedAscending) {
                [IDCMShowMessageView showErrorWithMessage:[NSString idcw_stringWithFormat:@"%@%@",SWLocaloziString(@"2.0_MinNum"),minAmount]];
                return;
            }
            
        }else if (errorCode == 10){
            
            @weakify(self);
            [IDCMActionTipsView showWithConfigure:^(IDCMActionTipViewConfigure *configure) {
                
                [configure.getBtnsConfig removeFirstObject];
                configure.subTitle(SWLocaloziString(@"2.2.1_PINError"));
                configure
                .getBtnsConfig
                .lastObject
                .btnTitle(SWLocaloziString(@"2.2.1_AgainEnter"))
                .btnCallback(^{
                    @strongify(self);
                    [self.passwordView removePasseword:NO];
                });
            }];
            
        }else if (errorCode == 802){
            [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_OngoingOTCOrders")];
        }else{
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.1_FailedTransfer", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }
        
    }else if([response[@"data"] isKindOfClass:[NSDictionary class]] && status == 0){
        
        NSString *statusCode = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"statusCode"]];
        NSInteger errorCode = [statusCode integerValue];
        
        if (errorCode == 5){
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_TransferSend", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else{
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.1_FailedTransfer", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }
        
    }else{
        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.1_FailedTransfer", nil)];
        [IDCMScrollViewPageTipView dismissWithComletion:nil];
    }
}
// 判断指纹支付还是密码支付
- (void)judgeFaceIDPayOrPINPay
{
    @weakify(self);
    NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:FaceIDOrTouchIDKey];
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    if ([IDCMBioMetricAuthenticator canAuthenticate]) { // 开启了权限
        if ([dataDic count]>0 && dataDic) {
            [dataDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                @strongify(self);
                if ([model.user_name isEqualToString:key]) {
                    // 解密PIN
                    NSString *PIN = obj;
                    NSString *desPIN = aesDecryptString(PIN,AESLockPINKey);
                    self.payPassWord = desPIN;
                    self.isfaceID = YES;
                }
            }];
        }else{
            self.isfaceID = NO;
        }
        
    }else{ // 关闭了权限
        
        if ([dataDic count]>0 && dataDic) {
            [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([model.user_name isEqualToString:key]) {
                    [dataDic removeObjectForKey:key];
                }
            }];
            [IDCMUtilsMethod keyedArchiverWithObject:dataDic withKey:FaceIDOrTouchIDKey];
        }
        self.isfaceID = NO;
    }
    
    
    if (self.isfaceID) { // 使用faceID
        
        [IDCMBioMetricAuthenticator authenticateWithBioMetricsOfReason:isiPhoneX ? NSLocalizedString(@"2.0_UseFaceID", nil) : NSLocalizedString(@"2.0_UseTouchID", nil) successBlock:^{
            
            @strongify(self);
            [self.viewModel.sendFaceIDCommand execute:self.payPassWord];
            
        } failureBlock:^(IDCMAuthType authenticationType, NSString *errorMessage) {
            
            if (authenticationType == IDCMAuthTypeFallback) { // 用户取消，手动输入密码
                
                [IDCMScrollViewPageTipView scrollToNextPage];
                
            }
            if (authenticationType == IDCMAuthTypeNotEnrolled) { // 未设置
                [IDCMShowMessageView showErrorWithMessage:isiPhoneX ? NSLocalizedString(@"2.0_NotSetFaceID", nil) : NSLocalizedString(@"2.0_NotSetTouchID", nil)];
            }
            if (authenticationType == IDCMAuthTypeBiometryLockout) { // 多次验证，被锁
                [IDCMBioMetricAuthenticator authenticateWithPasscodeOfReason:errorMessage fallbackTitle:nil cancelTitle:nil successBlock:^{
                    
                } failureBlock:^(IDCMAuthType authenticationType, NSString *errorMessage) {
                    
                }];
            }
            
        }];
        
    }else{ // 使用密码

        [IDCMScrollViewPageTipView scrollToNextPage];
    }
}
#pragma mark - action

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.sendView.sendTextField) {
        
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

        if ([textField.text containsString:@","]&&[string isEqualToString:@","]) {
            
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendNumorrect", nil)];
            
            return NO;
        }
        if ([textField.text isEqualToString:@""]&&[string isEqualToString:@","]) {
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendNumorrect", nil)];
            return NO;
        }
        if ([textField.text containsString:@"."] &&[string isEqualToString:@","]) {
            
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendNumorrect", nil)];
            return NO;
        }
        
        
        if ([textField.text containsString:@"."]&&[string isEqualToString:@"."]) {
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendNumorrect", nil)];
            return NO;
        }
        if ([textField.text isEqualToString:@""]&&[string isEqualToString:@"."]) {
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendNumorrect", nil)];
            return NO;
        }
        if ([string isEqualToString:@","]) {
            
            textField.text = [toBeString stringByReplacingOccurrencesOfString:@"," withString:@"."];
            return NO;
        }
        return YES;
    
    }else if(textField == self.reciveView.reciveAddressTextField){
        if ([string isEqual: @" "]) {
            return NO;
        }else{
            return YES;
        }
        
    }else{
        return YES;
    }
}
#pragma mark - getter
- (UIScrollView *)scrollview
{
    return SW_LAZY(_scrollview, ({
        UIScrollView *view = [[UIScrollView alloc] init];
        view.showsHorizontalScrollIndicator = NO;
        view.showsVerticalScrollIndicator = NO;
        [self.view addSubview:view];
        view;
    }));
}
- (UIView *)contentView
{
    return SW_LAZY(_contentView, ({
        UIView *view = [UIView new];
        view.backgroundColor = viewBackgroundColor;
        [self.scrollview addSubview:view];
        view;
    }));
}
- (IDCMSendAddressView *)reciveView
{
    return SW_LAZY(_reciveView, ({
        IDCMSendAddressView *view = [IDCMSendAddressView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        view;
    }));
}

- (IDCMSendCoinView *)sendView
{
    return SW_LAZY(_sendView, ({
        IDCMSendCoinView *view = [IDCMSendCoinView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        view;
    }));
}


- (IDCMFeeView *)feeView
{
    return SW_LAZY(_feeView, ({
        IDCMFeeView *view = [[IDCMFeeView alloc] initWitdHidn:self.viewModel.currencyLayoutType];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        view;
    }));
}

- (UIButton *)sendButton
{
    return SW_LAZY(_sendButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Medium", 16);
        [button setBackgroundColor:kThemeColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:NSLocalizedString(@"2.0_SendButton", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        button;
    }));
}
- (void)dealloc{
    
    [self.feeDisposable dispose];
    [self.addressDisposable dispose];
    [self.complicatedAddressDisposable dispose];
}
@end
