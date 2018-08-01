//
//  IDCMWithdrawalController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/27.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMWithdrawalController.h"
#import "IDCMwithdrawalViewModel.h"
#import "IDCMWithdrawalAddressView.h"
#import "IDCMScanQrCodeController.h"
#import "IDCMPINView.h"
#import "IDCMBioMetricAuthenticator.h"

@interface IDCMWithdrawalController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMwithdrawalViewModel *viewModel;
/**
 *  输入提取地址
 */
@property (strong, nonatomic) IDCMWithdrawalAddressView *addressView;
/**
 *  确认提取
 */
@property (strong, nonatomic) IDCMAcceptantBondSureView *sureView;
/**
 *  PIN
 */
@property (strong, nonatomic) IDCMPINView *PINView;
/**
 *  icon
 */
@property (strong, nonatomic) UIImageView *iconImageView;
/**
 *  是否是指纹支付
 */
@property (assign, nonatomic) BOOL isTouchIDPay;
@end

@implementation IDCMWithdrawalController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SetColor(48, 57, 79);
    self.fd_prefersNavigationBarHidden = YES;
    IDCM_APPDelegate.threeType = kIDCMThreePartiesNomal;
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(70+kSafeAreaTop);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(87));
        make.width.equalTo(@(132));
    }];
}
#pragma mark - Bind
- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    
    [self configConfirmPayView];
    
    // 接收地址信号
    [[[self.viewModel.reciveCommand.executionSignals switchToLatest] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSString class]]) {
             
             if ([response[@"data"] isKindOfClass:[NSString class]]) {
                 NSString *str = [NSString idcw_stringWithFormat:@"%@",response[@"data"]];
                self.addressView.reciveView.reciveAddressTextField.text = str;
             }
             
         }else{
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_GetAddressFail", nil)];
         }
     }];
    
    [self.viewModel.reciveCommand execute:nil];
    
    // 绑定发送数量已经发送地址
    RAC(self.viewModel,reciveAddress) = [RACObserve(self.addressView.reciveView.reciveAddressTextField, text) merge:self.addressView.reciveView.reciveAddressTextField.rac_textSignal];

    // 监听验证地址Command
    [[[self.viewModel.varifyAddressCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         if ([response[@"data"] isKindOfClass:[NSNumber class]]) {
             if ([response[@"data"] integerValue] == 1 || [status isEqualToString:@"1"]) {
                 [IDCMScrollViewPageTipView scrollToNextPage];
             }else{
                 [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
             }
         }else{
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
         }
         
     }];
    // 监听切割地址Command
    [[[self.viewModel.validComplicatedAddressCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         NSString *address = [NSString idcw_stringWithFormat:@"%@",response[@"data"]];
         if ([status isEqualToString:@"1"] && [address isNotBlank]) {
             self.addressView.reciveView.reciveAddressTextField.text = address;
         }else{
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
         }
     }];
    
    // 监听提现Command
    [[[self.viewModel.requestDataCommand.executionSignals switchToLatest] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         [self fetchSendFormData:response];
     }];
    
    // 提现出错
    [[self.viewModel.requestDataCommand.errors deliverOnMainThread]
     subscribeNext:^(NSError * _Nullable x) {
         @strongify(self);
         if (!self.isTouchIDPay) {
             [IDCMScrollViewPageTipView scrollToNextPage];
         }
         
     }];

}

#pragma mark - Privater Methods
// 初始化确认支付页面
- (void)configConfirmPayView
{
    @weakify(self);
    
    self.addressView = [IDCMWithdrawalAddressView bondSureViewWithCloseButtonType:IDCMWithdrawCloseButtonImageCloseType
                                                                            Title:SWLocaloziString(@"3.0_Bin_InputExtractionAddress")
                                                                         subTitle:[NSString idcw_stringWithFormat:@"%@ %@",[self.viewModel.payModel.currency uppercaseString],[IDCMUtilsMethod separateNumberUseCommaWith:self.viewModel.payModel.amount]]
                                                                     sureBtnTitle:SWLocaloziString(@"3.0_Bin_Extraction")
                                                                    pasteBtnInput:^(id input) { // 粘贴
                                                                        @strongify(self);
                                                                        [self.view endEditing:YES];
                                                                        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
                                                                        NSString *address = [pasteboard string];
                                                                        if ([address isNotBlank]) {
                                                                            self.addressView.reciveView.reciveAddressTextField.text = address;
                                                                        }
                                                                    }
                                                                     scanBtnInput:^(id input) { // 扫一扫
                                                                        @strongify(self);
                                                                        [self pushScanController];
                                                                     }
                                                                    closeBtnInput:^(id input) { // 关闭
                                                                        @strongify(self);
                                                                        [self backToMerchantsApp];
                                                                    }
                                                                     sureBtnInput:^(id input) { // 提取
                                                                         @strongify(self);
                                                                         NSDictionary *param = @{
                                                                                                 @"address":self.viewModel.reciveAddress,
                                                                                                 @"currency":[self.viewModel.payModel.currency lowercaseString]
                                                                                                 };
                                                                         [self.viewModel.varifyAddressCommand execute:param];
                                                                         
                                                                     } templeSignal:self.viewModel.validAddressSignal];
    
    RACSignal *updateSignal = [RACObserve(self.viewModel, reciveAddress) map:^id _Nullable(id  _Nullable value) {
        
        return @[RACTuplePack(@(0),value)];
    }];
    
    NSArray *arr = @[RACTuplePack(SWLocaloziString(@"3.0_Bin_ExtractionAddress"),self.viewModel.reciveAddress,@(30))];
    self.sureView = [IDCMAcceptantBondSureView bondSureViewWithCloseButtonType:IDCMCloseButtonImageBackType
                                                                         Title:SWLocaloziString(@"3.0_Bin_WithdrawalConfirmation")
                                                                      subTitle:[NSString idcw_stringWithFormat:@"%@ %@",[self.viewModel.payModel.currency uppercaseString],[IDCMUtilsMethod separateNumberUseCommaWith:self.viewModel.payModel.amount]]
                                                                  sureBtnTitle:SWLocaloziString(@"3.0_Bin_ConfirmExtraction")
                                                                     confidArr:arr
                                                                 closeBtnInput:^(id input) { // 关闭
                                                                     
                                                                     [IDCMScrollViewPageTipView scrollToLastPage];
                                                                 }
                                                                  sureBtnInput:^(id input) { // 确认提取
                                                                      @strongify(self);
                                                                      
                                                                      [self.PINView removePasseword:NO];
                                                                      self.isTouchIDPay = NO;
                                                                      [self validationIDTouch];
                                                                      
                                                                  }
                                                              updateDataSignal:updateSignal
                                                                  templeSignal:[RACSignal return:@(YES)]];
    
    self.PINView = [IDCMPINView bindPINViewType:IDCMPINButtonImageBackType
                                  closeBtnInput:^(id input) {
                                      // 返回上一页
                                      [IDCMScrollViewPageTipView scrollToLastPage];
                                  }
                                 PINFinishBlock:^(NSString *password) {
                                     @strongify(self);
                                     self.viewModel.payPassword = password;
                                     [self.viewModel.requestDataCommand execute:nil];
                                 }];
    
    [IDCMScrollViewPageTipView showTipViewToView:self.view
                                    contentViews:@[self.addressView, self.sureView,self.PINView]
                                    contentSizes:@[@(CGSizeMake(SCREEN_WIDTH, 440 + kSafeAreaBottom))]
                                initialPageIndex:0
                                   scrollEnabled:NO
                                    positionType:ScrollViewPageTipViewPositionType_Bottom];
}

#pragma mark - Action
// 返回商户App
- (void)backToMerchantsApp
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@://",self.viewModel.payModel.appId];
    NSURL *url = [NSURL URLWithString:urlStr];
    if (@available(iOS 10,*)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            [IDCM_APPDelegate verifyPINViewController];
        }];
    }else{
        [[UIApplication sharedApplication] openURL:url];
        [IDCM_APPDelegate verifyPINViewController];
    }
}

- (void)showPayStateDialog:(NSString *)state withCancelTitle:(NSString *)cancelTitle withDoneTitle:(NSString *)doneTitle{
    @weakify(self);
    [IDCMActionTipsView showWithConfigure:^(IDCMActionTipViewConfigure *configure) {
        
        configure.title(state);
        // 返回
        configure
        .getBtnsConfig
        .firstObject
        .btnTitle(cancelTitle)
        .btnCallback(^{
            @strongify(self);
            [self backToMerchantsApp];
        });
        // 重试
        configure
        .getBtnsConfig
        .lastObject
        .btnTitle(doneTitle)
        .btnCallback(^{
            [IDCMScrollViewPageTipView scrollToLastPage];
        });
    }];
}
- (void)showPayPINErrorDialog{
    @weakify(self);
    [IDCMActionTipsView showWithConfigure:^(IDCMActionTipViewConfigure *configure) {
        
        configure.subTitle(SWLocaloziString(@"2.2.1_PINError"));
        // 返回
        configure
        .getBtnsConfig
        .firstObject
        .btnTitle(SWLocaloziString(@"2.2.1_Back"))
        .btnCallback(^{
            @strongify(self);
            [self backToMerchantsApp];
        });
        // 重试
        configure
        .getBtnsConfig
        .lastObject
        .btnTitle(SWLocaloziString(@"2.2.1_AgainEnter"))
        .btnCallback(^{
            @strongify(self);
            [self.PINView removePasseword:NO];
        });
    }];
}
// 处理sendForm数据
- (void)fetchSendFormData:(NSDictionary *)response{
    
    NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
    if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]] && ![response[@"data"][@"statusCode"] isKindOfClass:[NSNull class]]) {
        NSString *statusCode = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"statusCode"]];
        switch ([statusCode integerValue]) {
            case 0: // 成功
            {
                
                [self backToMerchantsApp];
            }
                break;
            case 106: // ETH不足
            {
                
                [self showPayStateDialog:SWLocaloziString(@"3.0_BinBear_ETHInsufficientWithdrawl") withCancelTitle:SWLocaloziString(@"2.2.1_Back") withDoneTitle:nil];
            }
                break;
            case 102:
            case 3: // 余额不足
            {
                [self showPayStateDialog:SWLocaloziString(@"2.2.1_InsufficientBalance") withCancelTitle:SWLocaloziString(@"2.2.1_Back") withDoneTitle:nil];
            }
                break;
            case 10: // PIN错误
            {
                [self showPayPINErrorDialog];
            }
                break;
            case 606: // 转汇确认中
            {
                [self showPayStateDialog:SWLocaloziString(@"2.0_TransferSend") withCancelTitle:SWLocaloziString(@"2.2.1_Back") withDoneTitle:SWLocaloziString(@"2.2.1_Retry")];
            }
                break;
            case 607: // 重复提现
            {
                [self showPayStateDialog:SWLocaloziString(@"3.0_Bin_RepeatWithdrawl") withCancelTitle:SWLocaloziString(@"2.2.1_Back") withDoneTitle:nil];
            }
                break;
            case 604:
            case 605:
            case -32600:
            case -32601:
            case -32602:
            case -32700:
                
            {
                [self showPayStateDialog:SWLocaloziString(@"2.2.1_ServerError") withCancelTitle:SWLocaloziString(@"2.2.1_Back") withDoneTitle:SWLocaloziString(@"2.2.1_Retry")];
            }
                break;
            default:
            {
                [self showPayStateDialog:SWLocaloziString(@"2.0_RequestError") withCancelTitle:SWLocaloziString(@"2.2.1_Back") withDoneTitle:SWLocaloziString(@"2.2.1_Retry")];
            }
                break;
        }
    }else{
        [self showPayStateDialog:SWLocaloziString(@"2.0_RequestError") withCancelTitle:SWLocaloziString(@"2.2.1_Back") withDoneTitle:SWLocaloziString(@"2.2.1_Retry")];
    }
}
// 扫一扫
- (void)pushScanController{
    
    @weakify(self);
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
                                            @"currency":[self.viewModel.payModel.currency lowercaseString]
                                            };
                    [self.viewModel.validComplicatedAddressCommand execute:param];
                }else{
                    self.addressView.reciveView.reciveAddressTextField.text = scanStr;
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
}
//验证指纹
- (void)validationIDTouch
{
    @weakify(self);
    NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:FaceIDOrTouchIDKey];
    if ([dataDic count]>0 && dataDic) {
        IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
        __block BOOL isSetTouchID = NO;
        [dataDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            @strongify(self);
            if ([model.user_name isEqualToString:key]) {
                isSetTouchID = YES;
                NSString *PIN = obj;
                NSString *desPIN = aesDecryptString(PIN,AESLockPINKey);
                self.viewModel.payPassword = desPIN;
            }
        }];
        if (isSetTouchID) {
            if ([IDCMBioMetricAuthenticator canAuthenticate]) { // 开启了权限
                
                [IDCMBioMetricAuthenticator authenticateWithBioMetricsOfReason:isiPhoneX ? NSLocalizedString(@"2.2.1_VerifyFaceID", nil) : NSLocalizedString(@"2.2.1_VerifyTouchID", nil) successBlock:^{
                    @strongify(self);
                    // 成功
                    self.isTouchIDPay = YES;
                    [self.viewModel.requestDataCommand execute:nil];
                    
                } failureBlock:^(IDCMAuthType authenticationType, NSString *errorMessage) {
                    
                    if (authenticationType == IDCMAuthTypeFallback) { //输入密码
                        [IDCMScrollViewPageTipView scrollToNextPage];
                    }
                    
                }];
            }else{ // 关闭了权限
                
                [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([model.user_name isEqualToString:key]) {
                        [dataDic removeObjectForKey:key];
                    }
                }];
                [IDCMScrollViewPageTipView scrollToNextPage];
            }
            
        }else{
            // 没有设置支付密码
            [IDCMScrollViewPageTipView scrollToNextPage];
        }
    }else{
        // 新用户
        [IDCMScrollViewPageTipView scrollToNextPage];
    }
}
#pragma mark - NetWork


#pragma mark - Delegate


#pragma mark - Getter & Setter
- (UIImageView *)iconImageView
{
    return SW_LAZY(_iconImageView, ({
        UIImageView *view = [UIImageView new];
        view.image = UIImageMake(@"2.2.1_PayViewLogo");
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.userInteractionEnabled = YES;
        view.clipsToBounds = YES;
        [self.view addSubview:view];
        view;
    }));
}


@end
