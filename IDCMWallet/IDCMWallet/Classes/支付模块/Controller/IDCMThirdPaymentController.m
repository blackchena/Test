//
//  IDCMThirdPaymentController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMThirdPaymentController.h"
#import "IDCMThirdPaymentViewModel.h"
#import "IDCMPINView.h"
#import "IDCMUserInfoModel.h"
#import "IDCMBioMetricAuthenticator.h"

@interface IDCMThirdPaymentController () 
@property (nonatomic, strong, readonly) IDCMThirdPaymentViewModel *viewModel;
/**
 *  icon
 */
@property (strong, nonatomic) UIImageView *iconImageView;
/**
 *  信息
 */
@property (strong, nonatomic) IDCMAcceptantBondSureView *sureView;
/**
 *  PIN
 */
@property (strong, nonatomic) IDCMPINView *PINView;
/**
 *  是否是指纹支付
 */
@property (assign, nonatomic) BOOL isTouchIDPay;
@end

@implementation IDCMThirdPaymentController
@dynamic viewModel;


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

#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    
    [self configConfirmPayView];
    
    [[self.viewModel.getInfoCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         
         NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         
         if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
             NSString *companyName = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"companyName"]];
             self.viewModel.companyName = companyName;
         }else{
             [IDCMShowMessageView showMessageWithCode:status];
         }
         
     }];
    
    
    // 监听支付请求
    [[[self.viewModel.requestDataCommand.executionSignals switchToLatest] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         [self fetchSendFormData:response];
     }];
    [[self.viewModel.requestDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        
        if (!executing.boolValue) {
            [IDCMHUD dismiss];
        }
    }];
    // 支付出错
    [[self.viewModel.requestDataCommand.errors deliverOnMainThread]
     subscribeNext:^(NSError * _Nullable x) {
         @strongify(self);
         if (!self.isTouchIDPay) {
             [IDCMScrollViewPageTipView scrollToNextPage];
         }
         
     }];
    
    [self.viewModel.getInfoCommand execute:nil];
}
// 初始化确认支付页面
- (void)configConfirmPayView
{
    @weakify(self);
    

    RACSignal *updateSignal = [RACObserve(self.viewModel, companyName) map:^id _Nullable(NSString *value) {
        
        return @[RACTuplePack(@(0),value)];
    }];
    RACSignal *validSignal = [RACObserve(self.viewModel, companyName) map:^id _Nullable(NSString *value) {
        
        return @(value.length > 0);
    }];
    
    NSArray *arr = @[RACTuplePack(SWLocaloziString(@"3.0_Bin_ReceivingParty"),self.viewModel.companyName,@(30))];
    self.sureView = [IDCMAcceptantBondSureView bondSureViewWithCloseButtonType:IDCMCloseButtonImageCloseType
                                                                         Title:SWLocaloziString(@"2.0_ConfirmationSend")
                                                                      subTitle:[NSString idcw_stringWithFormat:@"%@ %@",[self.viewModel.payModel.currency uppercaseString],[IDCMUtilsMethod separateNumberUseCommaWith:self.viewModel.payModel.amount]]
                                                                  sureBtnTitle:SWLocaloziString(@"2.0_ConfirmationSend")
                                                                     confidArr:arr
                                                                 closeBtnInput:^(id input) { // 关闭
                                                                     
                                                                     @strongify(self);
                                                                     [self backToMerchantsApp];
                                                                 }
                                                                  sureBtnInput:^(id input) { // 跳转到输入PIN页面时，清除PIN
                                                                      @strongify(self);
                                                                      [self.PINView removePasseword:NO];
                                                                      self.isTouchIDPay = NO;
                                                                      [self validationIDTouch];
                                                                      
                                                                  }
                                                              updateDataSignal:updateSignal
                                                                  templeSignal:validSignal];
    
    self.PINView = [IDCMPINView bindPINViewType:IDCMPINButtonImageBackType
                                       closeBtnInput:^(id input) {
                                           // 返回上一页
                                           [IDCMScrollViewPageTipView scrollToLastPage];
                                       }
                                      PINFinishBlock:^(NSString *password) {
                                          @strongify(self);
                                          self.viewModel.payPassword = password;
                                          [self.viewModel.requestDataCommand execute:@"0"];
                                      }];
    
    [IDCMScrollViewPageTipView showTipViewToView:self.view
                                    contentViews:@[self.sureView, self.PINView]
                                    contentSizes:@[@(CGSizeMake(SCREEN_WIDTH, 440 + kSafeAreaBottom))]
                                initialPageIndex:0
                                   scrollEnabled:NO
                                    positionType:ScrollViewPageTipViewPositionType_Bottom];
}
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
                
                [self showPayStateDialog:SWLocaloziString(@"3.0_BinBear_ETHInsufficientSend") withCancelTitle:SWLocaloziString(@"2.2.1_Back") withDoneTitle:nil];
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
            case 607: // 重复支付
            {
                [self showPayStateDialog:SWLocaloziString(@"2.2.1_RepeatPayment") withCancelTitle:SWLocaloziString(@"2.2.1_Back") withDoneTitle:nil];
            }
                break;
            case 802:
            {
                [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_OngoingOTCOrders")];
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
#pragma mark - getter
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
