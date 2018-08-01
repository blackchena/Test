//
//  IDCMAcceptantPickupBondController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantPickupBondController.h"
#import "IDCMAcceptantPickupBondViewModel.h"
#import "IDCMAcceptantBondSuccessView.h"
#import "IDCMAcceptantBondSureView.h"
#import "IDCMChooseBTypeView.h"
#import "IDCMAcceptantCoinModel.h"
#import "IDCMScanQrCodeController.h"


@interface IDCMAcceptantPickupBondController ()<IconWindowDelegate,QMUITextFieldDelegate>
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) UILabel *currencyLabel;
@property (nonatomic,strong) QMUITextField *currencyCountTextField;
@property (nonatomic,strong) QMUILabel *currencyCountTitle;

@property (nonatomic,strong) UILabel *bondBalanceLabel;

@property (nonatomic,strong) UIView *addressView;
@property (nonatomic,strong) UITextField *addressTextField;
@property (nonatomic,strong) UIButton *copyAddressBtn;
@property (nonatomic,strong) QMUIButton *scanBtn;

@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UILabel * coinImageAndTypeLabel;
@property (nonatomic,strong) IDCMAcceptantPickupBondViewModel *viewModel;

@end


@implementation IDCMAcceptantPickupBondController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

#pragma mark — supper method
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    
    self.btn.rac_command = self.viewModel.btnToPickupBondcommand;
    [[[self.viewModel.btnToPickupBondcommand.executing skip:1] deliverOnMainThread]
     subscribeNext:^(NSNumber * _Nullable x) {
         @strongify(self);
         [self.view endEditing:YES];
         
         NSString *minAmount = @"";
         if ([[self.viewModel.selectCoinModel.coinCode uppercaseString] isEqualToString:@"LTC"]) {
             minAmount = @"0.0006";
         }else{
             minAmount = @"0.00006";
         }
         if ([[NSDecimalNumber decimalNumberWithString:self.viewModel.countValue] compare:[NSDecimalNumber decimalNumberWithString:minAmount]] == NSOrderedAscending) {
             [IDCMShowMessageView showErrorWithMessage:[NSString idcw_stringWithFormat:@"%@%@",SWLocaloziString(@"3.0_Bin_WitdrawlMinNum"),minAmount]];
             return;
         }
         
         if ([[NSDecimalNumber decimalNumberWithString:self.viewModel.countValue]  compare:[NSDecimalNumber decimalNumberWithString:self.viewModel.withdrawAmount]] == NSOrderedDescending) {
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.1_InsufficientBalance", nil)];
             return;
         }
         
         NSArray *array = @[RACTuplePack(NSLocalizedString(@"2.0_Address", nil), [self.viewModel.address isNotBlank] ? self.viewModel.address : @"", @(45))
                            ];
         NSString *coin = [self.viewModel.selectCoinModel.coinCode isNotBlank] ? self.viewModel.selectCoinModel.coinCode.uppercaseString : @"";
         NSString *coinValue = [NSString stringWithFormat:@"%@ %@",coin,self.currencyCountTextField.text];
         IDCMAcceptantBondSureView *view1 =
         [IDCMAcceptantBondSureView bondSureViewWithTitle:NSLocalizedString(@"3.0_SurePickUp", nil)
                                                 subTitle:coinValue
                                             sureBtnTitle:NSLocalizedString(@"3.0_NowTimePickUp", nil)
                                                confidArr:array
                                            closeBtnInput:^(id input) {
                                                [IDCMScrollViewPageTipView dismissWithComletion:nil];
                                            }
                                             sureBtnInput:^(id input) {
                                                 [IDCMScrollViewPageTipView scrollToNextPage];
                                             }];
         
         
         IDCMPINView *pinView = [IDCMPINView bindPINViewType:IDCMPINButtonImageCloseType
                                               closeBtnInput:^(id input) {
                                                   // 返回上一页
                                                   [IDCMScrollViewPageTipView dismissWithComletion:nil];
                                               }
                                              PINFinishBlock:^(NSString *password) {
                                                  @strongify(self);
                                                  NSDictionary *input = @{
                                                                          @"PIN":password
                                                                          };
                                                  [self.viewModel.pickupBondcommand execute:input];
                                              }];

         NSString *coinId = [self.viewModel.selectCoinModel.coinID isNotBlank] ? self.viewModel.selectCoinModel.coinID : @"";
         NSString *coinCode = [self.viewModel.selectCoinModel.coinCode isNotBlank] ? self.viewModel.selectCoinModel.coinCode : @"";

         IDCMAcceptantBondSuccessView *view3 =
         [IDCMAcceptantBondSuccessView bondSuccessViewTitle:NSLocalizedString(@"3.0_PickUpCompleteInfo", nil)
                                                   subTitle:SWLocaloziString(@"2.0_QueryRecord")
                                                   btnTitle:NSLocalizedString(@"3.0_PickUpComplete", nil)
                                              completeInput:^(id input) {
                                                  [IDCMScrollViewPageTipView dismissWithComletion:^{
                                                      [IDCMMediatorAction
                                                       idcm_pushViewControllerWithClassName:@"IDCMAcceptantBondWaterController"
                                                       withViewModelName:@"IDCMAcceptantBondWaterViewModel"
                                                       withParams:@{@"CoinId":coinId,
                                                                    @"CoinCode":coinCode,
                                                                    @"JumpType":@"0"}
                                                       animated:YES];
                                                  }];
                                              }];

         [IDCMScrollViewPageTipView showTipViewToView:nil
                                         contentViews:@[view1,pinView, view3]
                                         contentSizes:@[@(CGSizeMake(SCREEN_WIDTH, 440 + kSafeAreaBottom))]
                                     initialPageIndex:0
                                        scrollEnabled:NO
                                         positionType:1];
    }];
    

    [[self.viewModel.getOTCListCoincommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSMutableArray *  _Nullable coinList) {
        
    }];
    [self.viewModel.getOTCListCoincommand.errors subscribeNext:^(NSError * _Nullable x) {
    }];
    [self.viewModel.getOTCListCoincommand execute:nil];
    
    self.copyAddressBtn.rac_command = RACCommand.emptyCommand(^(UIButton *btn){
        @strongify(self);
        [self.view endEditing:YES];
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        NSString *address = [pasteboard string];
        if ([address isNotBlank]) {
            self.addressTextField.text = address;
            NSDictionary *param = @{
                                    @"address":address,
                                    @"currency":[self.viewModel.selectCoinModel.coinCode lowercaseString]
                                    };
            [self.viewModel.varifyAddressCommand execute:param];
        }
    });
    
    self.scanBtn.rac_command = RACCommand.emptyCommand(^(UIButton *btn){
        @strongify(self);
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
                                                @"currency":[self.viewModel.selectCoinModel.coinCode lowercaseString]
                                                };
                        [self.viewModel.validComplicatedAddressCommand execute:param];
                    }else{
                        self.addressTextField.text = scanStr;
                        NSDictionary *param = @{
                                                @"address":scanStr,
                                                @"currency":[self.viewModel.selectCoinModel.coinCode lowercaseString]
                                                };
                        [self.viewModel.varifyAddressCommand execute:param];
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
    });
    
    [[[self.viewModel.varifyAddressCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         NSString *data = [NSString idcw_stringWithFormat:@"%@",response[@"data"]];
         if ([data integerValue] == 0 || [status isEqualToString:@"0"]) {
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
         }
     }];
    [[[self.viewModel.validComplicatedAddressCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         NSString *address = [NSString idcw_stringWithFormat:@"%@",response[@"data"]];
         if ([address isNotBlank] && [status isEqualToString:@"1"]) {
             self.addressTextField.text = address;
         }else{
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
         }
     }];

    [[self.viewModel.pickupBondcommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *respose) {
        @strongify(self);
        [self fetchSendFormData:respose];
    }];
}
- (void)fetchSendFormData:(NSDictionary *)response
{
    NSInteger status= [response[@"status"] integerValue];
    
    if ([response[@"data"] isKindOfClass:[NSDictionary class]] && status == 1 && ![response[@"data"][@"statusCode"] isKindOfClass:[NSNull class]]) {
        NSString *errStr = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"statusCode"]];
        NSInteger errorCode = [errStr integerValue];
        
        if (errorCode == 0) {
            
            [IDCMScrollViewPageTipView scrollToNextPage];
            
        }else if (errorCode == 3 || errorCode == 102 | errorCode == 107 || errorCode == 108){
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_WalletInsuff", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else if (errorCode == 6){
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_AddressInvalid", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else if (errorCode == 106){
            [IDCMShowMessageView showErrorWithMessage:[NSString stringWithFormat:@"%@%@",[@"ETH" uppercaseString],NSLocalizedString(@"2.2.1_TokenWalletInsuff", nil)]];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else if (errorCode == 9){
            NSString *minAmount = @"";
            if ([[self.viewModel.selectCoinModel.coinCode uppercaseString] isEqualToString:@"LTC"]) {
                minAmount = @"0.0006";
            }else{
                minAmount = @"0.00006";
            }
            if ([[NSDecimalNumber decimalNumberWithString:self.viewModel.countValue] compare:[NSDecimalNumber decimalNumberWithString:minAmount]] == NSOrderedAscending) {
                [IDCMShowMessageView showErrorWithMessage:[NSString idcw_stringWithFormat:@"%@%@",SWLocaloziString(@"3.0_Bin_WitdrawlMinNum"),minAmount]];
            }
        }else if (errorCode == 10){
            
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.1_PINError", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else{
            NSString *errorCodeStr = [NSString stringWithFormat:@"%ld",errorCode];
            [IDCMShowMessageView showMessageWithCode:errorCodeStr];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }
        
    }else if([response[@"data"] isKindOfClass:[NSDictionary class]] && status == 0){
        NSString *errStr = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"statusCode"]];
        NSInteger errorCode = [errStr integerValue];
        if (errorCode == 5){
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_TransferSend", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else{
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_jf_pickup_fail_msg", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }
        
    }else{
        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_jf_pickup_fail_msg", nil)];
        [IDCMScrollViewPageTipView dismissWithComletion:nil];
    }
}
#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
    [self configSignal];
}

- (void)configSignal {
    
    @weakify(self);
    RAC(self.viewModel, currency) =
    [RACObserve(self.currencyLabel, attributedText) map:^id (NSAttributedString *value) {
        return [value.string isEqualToString:NSLocalizedString(@"3.0_CurrencyTypeSwitchDigital", nil)] ?  @"" : value;
    }];
    RAC(self.viewModel, countValue) = self.currencyCountTextField.rac_textSignal;
    
    RAC(self.viewModel, address) = [self.addressTextField.rac_textSignal merge:
                                    RACObserve(self.addressTextField, text)];
    
    RACSignal *currencyLabelSignal =
    [RACObserve(self.currencyLabel, attributedText) map:^id (NSAttributedString *value) {
        return [value.string isEqualToString:NSLocalizedString(@"3.0_CurrencyTypeSwitchDigital", nil)] ? @(NO) : @(YES);
    }];
    RAC(self.currencyCountTextField, userInteractionEnabled) = currencyLabelSignal;
    
    [[RACScheduler mainThreadScheduler] afterDelay:.25 schedule:^{
        [currencyLabelSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            
            CGFloat alpha = 0.0;
            CGFloat addressTop = 0.0;
            if ([x boolValue]) {
                alpha = 1.0;
                addressTop = 130;
//                self.bondBalanceLabel.text = [NSString stringWithFormat:@"%@: 56.3453 BTC", NSLocalizedString(@"2.0_BlanceTitle", nil)];
                
            } else {
                alpha = 0.0;
                addressTop = 103;
            }
            
            [UIView animateWithDuration:.35 animations:^{
                self.bondBalanceLabel.alpha = alpha;
                self.addressView.top = addressTop;
                self.btn.top = self.addressView.bottom + 20;
            }];
        }];
    }];
}
#pragma mark — IconWindowDelegate
- (void)iconWindow:(IDCMChooseBTypeView *) iconView
clickedButtonAtIndex:(NSIndexPath *) index
       selectIndex:(NSIndexPath *) select{
    [self refreshCurrencyInfoWithModel:self.viewModel.coinArray[index.row]];
}

#pragma mark — 配置UI相关
- (void)configUI {
    @weakify(self);
    
    self.navigationItem.title = NSLocalizedString(@"3.0_AcceptantPickUpBond", nil);
    self.view.backgroundColor = viewBackgroundColor;
    [self.view addSubview:self.contentScrollView];
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[self class]];
    
    self.currencyLabel = [[UILabel alloc] init];
    CGRect rect1 = CGRectMake(0, 0, self.view.width, 46);
    [self.contentScrollView addSubview:
     [self createOneLineViewWithFrame:rect1
                            leftTitle:NSLocalizedString(@"3.0_AcceptantBondCurrencyType", nil)
                       rightTextField:self.currencyLabel
                          btnCallback:^(UIButton *btn) {
                              
                              @strongify(self);
                              [self.view endEditing:YES];
                              [self showSelectCollectionView:self.viewModel.coinArray];
                          }]];
    
    self.currencyCountTextField = [[QMUITextField alloc] init];
    self.currencyCountTextField.delegate = self;
    CGRect rect2 = CGRectMake(0, 46 , self.view.width, 46);
    [self.contentScrollView addSubview:
     [self createOneLineViewWithFrame:rect2
                            leftTitle:NSLocalizedString(@"3.0_AcceptantBondCount", nil)
                       rightTextField:self.currencyCountTextField
                          btnCallback:nil]];
    
    [self.contentScrollView addSubview:self.bondBalanceLabel];
    [self.contentScrollView addSubview:self.addressView];
    [self.contentScrollView addSubview:self.btn];
}

-(void)showSelectCollectionView:(NSArray *) incons{
    if (incons.count == 0) {
        return;
    }
    NSInteger totalRow = ((incons.count - 1) / 4 + 1);
    CGFloat bottomMargin =  totalRow < 5 ? 10 : 0;
    if (totalRow > 4) {totalRow = 4;}
    CGFloat totalHeight =  totalRow * (70 + 20) + 52 + bottomMargin;
    IDCMChooseBTypeView * listView= [[IDCMChooseBTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 24, totalHeight) bTypes:incons title:NSLocalizedString(@"3.0_AcceptantBondCurrencyTypeSwitch", nil)  withType:kIDCMAcceptantCoinType];
    listView.delegate = self;
    [IDCMBaseCenterTipView showTipViewToView:nil size:CGSizeMake(SCREEN_WIDTH - 24, totalHeight)
                                 contentView:listView
                            automaticDismiss:NO
                              animationStyle:1
                       tipViewStatusCallback:nil];
}

- (void)refreshCurrencyInfoWithModel:(IDCMAcceptantCoinModel *)model {
    
    self.coinImageAndTypeLabel.font = textFontPingFangRegularFont(14);
    self.coinImageAndTypeLabel.textColor = textColor333333;
    self.currencyCountTitle.text = model.coinCode.uppercaseString;
    [self.currencyCountTitle sizeToFit];
    [self.currencyCountTextField resignFirstResponder];
    self.viewModel.selectCoinModel = model;
    NSString *blanceNum = [IDCMUtilsMethod precisionControl:model.DepositBanlance];
    NSString *banlance =  [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:blanceNum] fractionDigits:4];
    self.viewModel.withdrawAmount = banlance;

    self.bondBalanceLabel.text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"3.0_AcceptantCashDepositBalance", nil),banlance,model.coinCode.uppercaseString];
    self.currencyLabel.attributedText =
    [[NSAttributedString alloc] initWithString:model.coinCode.uppercaseString attributes:@{NSFontAttributeName : textFontPingFangRegularFont(14),
                                                                        NSForegroundColorAttributeName : textColor333333}];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
    [manager loadImageWithURL:[NSURL URLWithString:model.conLogo] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        //回调从新设置
        if (image) {
            NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = image;
            attachment.bounds = CGRectMake(0, -6.5, 24, 24);
            NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:model.coinCode.uppercaseString];
            [textAttrStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
            [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [textAttrStr appendAttributedString:nameAttributedString];
            [textAttrStr addAttribute:NSKernAttributeName value:@(4)
                                range:NSMakeRange(0, 1)];
            self.currencyLabel.attributedText = textAttrStr ;
            self.currencyLabel.textColor = textColor333333;
        }
    }];
}
#pragma mark - UITextField delegate

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
    
    if ([textField isEqual:self.currencyCountTextField]) { // 数量
        if ([toBeString containsString:@"."]) { //含有小数点的 精确位数
            NSArray * arr = [toBeString componentsSeparatedByString:@"."];
            if ([arr[1] length] > 4) {
                return NO;
            }
        }
    }
    
    return YES;
}
#pragma mark - getters and setters

- (UIScrollView *)contentScrollView {
    return SW_LAZY(_contentScrollView, ({
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.alwaysBounceVertical = YES;
        scrollView.frame = self.view.bounds;
        scrollView;
    }));
}

- (UILabel *)bondBalanceLabel {
    return SW_LAZY(_bondBalanceLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor666666;
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.height = 17;
        label.width = self.view.width - 24;;
        label.top = 103;
        label.right = self.view.width - 12;
        label.alpha = 0.0;
        label;
    }));
}

- (UIView *)addressView {
    return SW_LAZY(_addressView, ({
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 103, self.view.width, 63);
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor666666;
        label.font = textFontPingFangRegularFont(14);
        label.text = NSLocalizedString(@"2.0_Address", nil);
        [label sizeToFit];
        label.height = 20;
        label.left = 12;
        label.top = 8;
        [view addSubview:label];
        
        self.scanBtn.height = view.height - 20;
        self.scanBtn.width =  self.scanBtn.height;
        self.scanBtn.right = view.width - 12;
        self.scanBtn.centerY = view.height / 2;
        [view addSubview:self.scanBtn];
        
        self.copyAddressBtn.centerY = label.centerY;
        self.copyAddressBtn.left = label.right + 10;
        [view addSubview:self.copyAddressBtn];
       
        self.addressTextField.width = self.scanBtn.left - 10 - label.left;
        self.addressTextField.height = 17;
        self.addressTextField.left = label.left;
        self.addressTextField.top = label.bottom + 8;
        [view addSubview:self.addressTextField];
        
        view;
    }));
}

- (UIButton *)copyAddressBtn {
    return SW_LAZY(_copyAddressBtn, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = textFontPingFangRegularFont(10);
        [btn setTitleColor:[UIColor colorWithHexString:@"#2968B9"] forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString(@"2.0_pasteAddress", nil) forState:UIControlStateNormal];
        CGFloat width = [btn.currentTitle widthForFont:textFontPingFangRegularFont(10)];
        btn.size = CGSizeMake(width + 20, 16);
        btn.layer.cornerRadius = 2.0;
        btn.layer.borderColor = kThemeColor.CGColor;
        btn.layer.borderWidth = .5;
        btn.layer.masksToBounds = YES;
        btn;
    }));
}

- (UITextField *)addressTextField {
    return SW_LAZY(_addressTextField, ({
        
        UITextField *textField = [[UITextField alloc] init];
        textField.textColor = textColor333333;
        textField.font = textFontPingFangRegularFont(12);
        textField.placeholder = NSLocalizedString(@"2.1_EnterAddress", nil);
        textField;
    }));
}

- (QMUIButton *)scanBtn {
    return SW_LAZY(_scanBtn, ({
        
        QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = textFontPingFangRegularFont(12);
        btn.imagePosition = QMUIButtonImagePositionTop;
        btn.spacingBetweenImageAndTitle = 5;
        [btn setImage:[UIImage imageNamed:@"2.0_saomiao"] forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString(@"2.1_ScanButton", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#2968B9"] forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(10);
        btn;
    }));
}

- (UIButton *)btn {
    return SW_LAZY(_btn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.view.width - 24;
        btn.height = 40;
        btn.top = self.addressView.bottom + 20;
        btn.left = 12;
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"3.0_AcceptantPickUpBond", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setBackgroundImage:image1 forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateDisabled];
        btn;
    }));
}

- (UIView *)createOneLineViewWithFrame:(CGRect)frame
                             leftTitle:(NSString *)leftTitle
                        rightTextField:(UIView *)rightTextField
                           btnCallback:(void(^)(UIButton *btn))btnCallback {
    
    UIView *view = [[UIView alloc] init];
    view.frame = frame;
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.textColor = textColor666666;
    leftLabel.font = textFontPingFangRegularFont(12);
    leftLabel.text = leftTitle;
    [leftLabel sizeToFit];
    leftLabel.height = 20;
    leftLabel.left = 12;
    leftLabel.centerY = view.height / 2;
    [view addSubview:leftLabel];
    
    if (btnCallback) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.0_angle"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.right = view.width - 12;
        imageView.centerY = leftLabel.centerY;
        [view addSubview:imageView];
        
        UILabel *label = (UILabel *)rightTextField;
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = textColor999999;
        label.font = textFontPingFangRegularFont(12);
        label.text = NSLocalizedString(@"3.0_CurrencyTypeSwitchDigital", nil);
        label.width = imageView.left - leftLabel.right - 10 - 6 ;
        label.height = view.height;
        label.left = leftLabel.right + 10;
        label.centerY = leftLabel.centerY;
        [view addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(view.width / 2, 0, view.width / 2, view.height);
        [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
         subscribeNext:btnCallback];
        [view addSubview:btn];
        self.coinImageAndTypeLabel = label;
        
    } else {
        
        QMUITextField *textField = (QMUITextField *)rightTextField;
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = textColor333333;
        textField.placeholderColor = textColor999999;
        textField.font = textFontPingFangRegularFont(12);
        textField.keyboardType =  UIKeyboardTypeDecimalPad;
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.width = view.width - leftLabel.right - 10 - 12 ;
        textField.left = leftLabel.right + 10;
        textField.height = view.height;
        textField.centerY = leftLabel.centerY;
        textField.placeholder = NSLocalizedString(@"3.0_AcceptantPickUpCountPlaceholder", nil);
        
        QMUILabel * rightView= [[QMUILabel alloc] init];
        rightView.textColor = textColor333333;
        rightView.font = textFontPingFangRegularFont(12);
        rightView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 1, 0);
        textField.rightView = rightView;
    }
    
    if ([leftTitle isEqualToString:NSLocalizedString(@"3.0_AcceptantBondCurrencyType", nil)]) {
        UIView *line = [UIView new];
        line.backgroundColor = viewBackgroundColor;
        line.height = 1.0;
        line.width = view.width - leftLabel.left;
        line.left = leftLabel.left;
        line.bottom = view.height;
        [view addSubview:line];
    }
    
    [view addSubview:rightTextField];
    return view;
}

- (UILabel *)currencyCountTitle {
    return (QMUILabel *)self.currencyCountTextField.rightView;
}

@end



