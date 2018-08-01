//
//  IDCMPayMethodController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantBondSuccessView.h"
#import "IDCMFlashExchangeViewModel.h"
#import "IDCMAcceptantBondSureView.h"
#import "IDCMPayMethodController.h"
#import "IDCMPayMethodViewModel.h"
#import "IDCMChooseBTypeView.h"
#import "IDCMCurrencyCollectionViewCell.h"
#import "IDCMPayMethodModel.h"
#import "IDCMPaySwitchViewModel.h"
#import "IDCMSelectPayMethodsView.h"
#import "IDCMSelectPhotosTool.h"

@interface IDCMPayMethodController ()<UITextFieldDelegate>
@property (nonatomic,strong) IDCMPayMethodViewModel *viewModel;
@property (nonatomic,strong) IDCMPaySwitchViewModel *paySwitchViewModel;

@property (nonatomic,strong) UIScrollView *contentScrollView;

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *currencyLabel;
@property (nonatomic,strong) UILabel *payMethodLabel;


@property (nonatomic,strong) UIView *oldSelectMethodView;///< 记录之前选中的支付方式

// 互联网方式相关
@property (nonatomic,strong) UIView *networkMethodView;
@property (nonatomic,strong) UILabel *networkAccountLbl;///< 网络方式账号

@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *accountTextField;
@property (nonatomic,strong) UIView *centerLine;
@property (nonatomic,strong) QMUIButton *addQRCodeBtn;///< 添加二维码按钮
@property (nonatomic,strong) UIImageView *QRCodeImageView;///< 二维码图片
@property (nonatomic,strong) UIButton *delQRCodeBtn;///< 删除二维码按钮
@property (nonatomic,strong) UIView *QRCodeSelectView;///< 二维码选择view

// 银行卡方式相关
@property (nonatomic,strong) UIView *BankCardMethodView;///< 银行


@property (nonatomic,strong) UITextField *cardPeopleNameTextField;
@property (nonatomic,strong) UITextField *cardAccountTextField;
@property (nonatomic,strong) UITextField *cardBankNameTextField;
@property (nonatomic,strong) UITextField *cardBankSubNameTextField;
@property (nonatomic,strong) UITextField *cardBankAddressTextField;
@property (nonatomic,strong) UITextField *cardBankCodeTextField;
@property (nonatomic,strong) UITextField *cardBankCityTextField;

@property (nonatomic,strong) UIView *cardPeopleNameView;
@property (nonatomic,strong) UIView *cardAccountView;
@property (nonatomic,strong) UIView *cardBankNameView;
@property (nonatomic,strong) UIView *cardBankSubNameView;
@property (nonatomic,strong) UIView *cardBankAddressView;
@property (nonatomic,strong) UIView *cardBankCodeView;
@property (nonatomic,strong) UIView *cardBankCityView;

@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) NSMutableArray<UIView *> * bankViewList;


/**
 String UserName;String AccountNo;String BankName;String SwiftCode;String City;String BankAddress;String BankBranch;
 */
@property (nonatomic,strong) NSMutableDictionary<NSString *,UITextField *> * bankViewMdict;

@property (nonatomic,strong) NSArray<IDCMPaytypeListItemModel *> * PaytypeList;
@property (nonatomic,strong) NSArray<IDCMLocalCurrencyListItemModel *> * CurrencyList;

@property (nonatomic,strong) IDCMLocalCurrencyListItemModel *selectCurrencyModel;///< 选中的国家
@property (nonatomic,strong) IDCMPaytypeListItemModel *selectPayModel;///< 选中的支付方式

@property (nonatomic,strong)NSString *previousTextFieldContent;
@property (nonatomic,strong)UITextRange *previousSelection;

@end


@implementation IDCMPayMethodController
@dynamic viewModel;
#pragma mark — life cycle
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    self.bankViewList = @[].mutableCopy;
    self.bankViewMdict = @{}.mutableCopy;
    
    [super viewDidLoad];
    self.view.backgroundColor = viewBackgroundColor;
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[self class]];
    [self initConfigure];
    [self initSwitchViewModel];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark — supper method
- (void)initSwitchViewModel{
    self.paySwitchViewModel = [[IDCMPaySwitchViewModel alloc] initWithParams:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    subscribeBlock(^subscribe)(void) = ^{
        return ^(id value){
            @strongify(self);
            [self.view endEditing:YES];
            if ([value boolValue]) {
                return ;
            }
            
            IDCMPINView *pinView = [IDCMPINView bindPINViewType:IDCMPINButtonImageCloseType
                                          closeBtnInput:^(id input) {
                                              // 返回上一页
                                              [IDCMScrollViewPageTipView dismissWithComletion:nil];
                                          }
                                         PINFinishBlock:^(NSString *password) {
                                             @strongify(self);
                                             NSDictionary *input = @{
                                                                     @"PIN":password,
                                                                     @"LocalCurrencyId":self.selectCurrencyModel.ID,
                                                                     @"PayTypeId":self.selectPayModel.ID
                                                                     };
                                             [self.viewModel.requestDataCommand execute:input];
                                         }];
            
            NSString *str = self.viewModel.viewType == PayMethodViewType_Add ? 
            NSLocalizedString(@"3.0_AddPayMethodsSuccess", nil) :
            NSLocalizedString(@"3.0_EditPayMethodsSuccess", nil);
            IDCMAcceptantBondSuccessView *successView =
            [IDCMAcceptantBondSuccessView bondSuccessViewTitle:str
                                                      subTitle:nil
                                                      btnTitle:NSLocalizedString(@"3.0_jf_pay_Complete", nil)
                                                 completeInput:^(id input) {
                                                     [IDCMScrollViewPageTipView dismissWithComletion:^{
                                                         @strongify(self);
                                                         [self.navigationController popViewControllerAnimated:YES];

                                                     }];
                                                 }];

            [IDCMScrollViewPageTipView showTipViewToView:nil
                                            contentViews:@[pinView,successView]
                                            contentSizes:@[@(CGSizeMake(SCREEN_WIDTH, 440 + kSafeAreaBottom))]
                                        initialPageIndex:0
                                           scrollEnabled:NO
                                            positionType:1];
        };
    };
    [[self.viewModel.requestDataCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(NSDictionary *respose) {
         @strongify(self);
         NSInteger status = [respose[@"status"] integerValue];

         if (status == 1 && [respose[@"data"] isKindOfClass:[NSNumber class]]) {
                 NSInteger data = [respose[@"data"] integerValue];
                 if (data == 1) {
                     if (self.completion) {
                         self.completion(nil);
                     }
                     [IDCMScrollViewPageTipView scrollToNextPage];
                 }else{
                     [IDCMShowMessageView showMessageWithCode:[NSString idcw_stringWithFormat:@"%ld",(long)status]];

                     [IDCMScrollViewPageTipView dismissWithComletion:^{
                         
                     }];
                 }
             }
         else{
             [IDCMShowMessageView showMessageWithCode:[NSString idcw_stringWithFormat:@"%ld",(long)status]];
             [IDCMScrollViewPageTipView dismissWithComletion:^{
                 
             }];
         }
     }];

    
    [RACObserve(self.viewModel, payMethodType) subscribeNext:^(NSNumber * x) {
        @strongify(self);
        PayMethodType type = [x integerValue];

        switch (type) {
            case PayMethodType_Network:{
                self.btn.rac_command = self.viewModel.addNetworkMethodCommand;
                [[[self.viewModel.addNetworkMethodCommand.executing skip:1] deliverOnMainThread] subscribeNext:subscribe()];
            }
                break;
            case PayMethodType_BankCard_USD:{
                self.btn.rac_command = self.viewModel.addUSDBankCardMethodCommand;
                [[[self.viewModel.addUSDBankCardMethodCommand.executing skip:1] deliverOnMainThread] subscribeNext:subscribe()];
            }
                break;
            case PayMethodType_BankCard_CNY:{
                self.btn.rac_command = self.viewModel.addCNYBankCardMethodCommand;
                [[[self.viewModel.addCNYBankCardMethodCommand.executing skip:1] deliverOnMainThread] subscribeNext:subscribe()];
            }
                break;
            case PayMethodType_BankCard_VND:{
                self.btn.rac_command = self.viewModel.addVNDBankCardMethodCommand;
                [[[self.viewModel.addVNDBankCardMethodCommand.executing skip:1] deliverOnMainThread] subscribeNext:subscribe()];
            }
                break;
        }
    }];
    
    [[[[self.viewModel.GetPaymentModeCommand executionSignals] switchToLatest] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x[@"data"] isKindOfClass:[NSDictionary class]]) {
            IDCMPayMethodModel *model = [IDCMPayMethodModel yy_modelWithDictionary:x[@"data"]];
            self.CurrencyList = model.LocalCurrencyList;
            self.PaytypeList = model.PaytypeList;
            self.paySwitchViewModel.PaytypeList = model.PaytypeList;

            if (self.viewModel.viewType == PayMethodViewType_Edit) { //编辑状态
                self.topView.userInteractionEnabled = NO;
                for (IDCMLocalCurrencyListItemModel *currency in model.LocalCurrencyList) {
                    if ([self.viewModel.editPaymentModel.LocalCurrencyId isEqualToString:currency.ID]) {
                        self.selectCurrencyModel = currency;
                    }
                }
                
                for (IDCMPaytypeListItemModel *paytype in model.PaytypeList) {
                    if ([self.viewModel.editPaymentModel.PayTypeId isEqualToString:paytype.ID]) {
                        self.selectPayModel = paytype;
                    }
                }
                
                NSDictionary *attrDict = [self.viewModel.editPaymentModel.PayAttributes yy_modelToJSONObject];
                for (NSString *key in attrDict.allKeys) {
                    if ([key isEqualToString:@"QRCode"]) {
                        self.QRCodeSelectView.hidden = NO;
                        self.addQRCodeBtn.hidden = YES;
                        self.viewModel.QRCodeURL = attrDict[key];

                        @weakify(self);
                        [self.QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:attrDict[key]]completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            @strongify(self);
                            self.viewModel.QRCodeImg = image;
                        }];
                    }
                    for (NSString *tfKey in self.bankViewMdict.allKeys) {
                        NSString * realKey = [self.viewModel.editPaymentModel.PayTypeCode isEqualToString:@"Bankcard"] ? key : [NSString stringWithFormat:@"NetWork_%@",key];
                        if ([realKey isEqualToString:tfKey]) {
                            UITextField *tf = self.bankViewMdict[tfKey];
                            if (tf == self.cardAccountTextField) {
                                NSString *bankText = attrDict[key];
                                NSString *bank = [self formatterBankCardNum:bankText];
                                tf.text = bank;
                            }
                            else{
                                tf.text = attrDict[key];
                            }
                        }
                    }
                }
            }
        }

    }];
    
    [self.viewModel.GetPaymentModeCommand.errors subscribeNext:^(NSError * _Nullable x) {
        
    }];
}

-(NSString *)formatterBankCardNum:(NSString *)string{
    NSString *tempStr=string;

    NSInteger size =(tempStr.length / 4);
    
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    
    for (int n = 0;n < size; n++){
        [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(size*4, (tempStr.length % 4))]];
    
    tempStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tempStr;
}
#pragma mark — private methods

#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
    [self configSignal];
    
    [self.viewModel.GetPaymentModeCommand execute:nil];

}

- (void)configSignal {
    
    @weakify(self);
    RAC(self.viewModel, currency) =
    [RACObserve(self.currencyLabel, attributedText) map:^id (NSAttributedString *value) {
        return [value.string isEqualToString:NSLocalizedString(@"3.0_CurrencySwith", nil)] ?  @"" : value;
    }];
    RAC(self.viewModel, method) =
    [RACObserve(self.payMethodLabel, attributedText) map:^id (NSAttributedString *value) {
        return [value.string isEqualToString:NSLocalizedString(@"3.0_PayMethodsSwitch", nil)] ?  @"" : value;
    }];
    RAC(self.viewModel, networkMethodPeopleName) = [self.nameTextField.rac_textSignal merge:
                                                    RACObserve(self.nameTextField, text)];
    
    RAC(self.viewModel, networkMethodAccount) = [self.accountTextField.rac_textSignal merge:
                                                 RACObserve(self.accountTextField, text)];
    
    RAC(self.viewModel, bankCardMethodAccount) = [self.cardAccountTextField.rac_textSignal merge:
                                                       RACObserve(self.cardAccountTextField, text)];
    
    RAC(self.viewModel, bankCardMethodPeopleName) = [self.cardPeopleNameTextField.rac_textSignal merge:
                                                          RACObserve(self.cardPeopleNameTextField, text)];
    
    RAC(self.viewModel, bankCardMethodBankName) = [self.cardBankNameTextField.rac_textSignal merge:
                                                        RACObserve(self.cardBankNameTextField, text)];
    
    RAC(self.viewModel, bankCardMethodSubBankName) = [self.cardBankSubNameTextField.rac_textSignal merge:
                                                           RACObserve(self.cardBankSubNameTextField, text)];
    
    RAC(self.viewModel, bankCardMethodBankAddress) = [self.cardBankAddressTextField.rac_textSignal merge:
                                                           RACObserve(self.cardBankAddressTextField, text)];
    
    RAC(self.viewModel, bankCardMethodBankCode) = [self.cardBankCodeTextField.rac_textSignal merge:
                                                        RACObserve(self.cardBankCodeTextField, text)];
    
    RAC(self.viewModel, bankCardMethodBankCity) = [self.cardBankCityTextField.rac_textSignal merge:
                                                        RACObserve(self.cardBankCityTextField, text)];

    
    RACSignal *payMethodSignal = [RACSignal combineLatest:@[RACObserve(self, selectCurrencyModel),RACObserve(self, selectPayModel)] reduce:^(IDCMLocalCurrencyListItemModel *currency, IDCMPaytypeListItemModel *methods){
        @strongify(self);
        if (currency) {
            self.currencyLabel.attributedText =
            [[NSAttributedString alloc] initWithString:currency.LocalCurrencyCode attributes:@{NSFontAttributeName : textFontPingFangRegularFont(14),
                                                                                               NSForegroundColorAttributeName : textColor333333}];
            SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
            [manager loadImageWithURL:[NSURL URLWithString:currency.LocalCurrencyLogo] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                //回调从新设置
                if (image) {
                    @strongify(self);
                    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
                    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                    attachment.image = image;
                    attachment.bounds = CGRectMake(0, -8, 24, 24);
                    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:currency.LocalCurrencyCode];
                    [nameAttributedString addAttributes:@{NSFontAttributeName : textFontPingFangRegularFont(14),
                                                          NSForegroundColorAttributeName : textColor333333} range:NSMakeRange(0, currency.LocalCurrencyCode.length)];
                    
                    [textAttrStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
                    [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
                    [textAttrStr appendAttributedString:nameAttributedString];
                    [textAttrStr addAttribute:NSKernAttributeName value:@(2)
                                        range:NSMakeRange(0, 1)];
                    self.currencyLabel.attributedText = textAttrStr ;
                }
            }];
        }
        if (methods) {
            NSString *payTitle = methods.PayTypeCode;
            NSString * language = [IDCMUtilsMethod getPreferredLanguage];
            
            if ([language isEqualToString:@"zh-Hans"]) {
                if ([payTitle isEqualToString:@"AliPay"]) {
                    payTitle = @"支付宝";
                }else if ([payTitle isEqualToString:@"WeChat"]){
                    payTitle = @"微信";
                }else{
                    payTitle = @"银行借记卡";
                }
            }else if ([language isEqualToString:@"zh-Hant"]){
                if ([payTitle isEqualToString:@"AliPay"]) {
                    payTitle = @"支付寶";
                }else if ([payTitle isEqualToString:@"WeChat"]){
                    payTitle = @"微信";
                }else{
                    payTitle = @"銀行借記卡";
                }
            }
            
            self.payMethodLabel.attributedText =
            [[NSAttributedString alloc] initWithString:payTitle
                                            attributes:@{NSFontAttributeName : textFontPingFangRegularFont(14),
                                                         NSForegroundColorAttributeName : textColor333333}];
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
            [manager loadImageWithURL:[NSURL URLWithString:methods.PayTypeLogo] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                @strongify(self);
                
                //回调从新设置
                if (image) {
                    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
                    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                    attachment.image = image;
                    attachment.bounds = CGRectMake(0, -8, 24, 24);
                    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:payTitle];
                    [nameAttributedString addAttributes:@{NSFontAttributeName : textFontPingFangRegularFont(14),
                                                          NSForegroundColorAttributeName : textColor333333} range:NSMakeRange(0, payTitle.length)];
                    
                    [textAttrStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
                    [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
                    [textAttrStr appendAttributedString:nameAttributedString];
                    [textAttrStr addAttribute:NSKernAttributeName value:@(2)
                                        range:NSMakeRange(0, 1)];
                    self.payMethodLabel.attributedText = textAttrStr ;
                }
            }];
        }
        if (currency && methods) {
            if ([methods.PayTypeCode isEqualToString:@"AliPay"]) {
                self.networkAccountLbl.text = SWLocaloziString(@"3.0_PayMethods_ali_account");
                return @(PayMethodType_Network);
            }
            else if ([methods.PayTypeCode isEqualToString:@"WeChat"]) {
                self.networkAccountLbl.text = SWLocaloziString(@"3.0_PayMethods_wechat_account");
                return @(PayMethodType_Network);
            }
            else{
                if ([currency.LocalCurrencyCode isEqualToString:@"USD"]) {
                    return @(PayMethodType_BankCard_USD);
                }
                else if ([currency.LocalCurrencyCode isEqualToString:@"CNY"]){
                    return @(PayMethodType_BankCard_CNY);
                }
                else if([currency.LocalCurrencyCode isEqualToString:@"VND"]) {
                    return @(PayMethodType_BankCard_VND);
                }
                else{
                    return @(-1);//没有选中
                }
            }
        }
        else{
            return @(-1);//没有选中
        }
    }];
    [payMethodSignal subscribeNext:^(NSNumber * x) {
        if (x.integerValue != -1) {
            @strongify(self);
            PayMethodType type = [x integerValue];
            self.viewModel.payMethodType = type;
            [self payMethodViewAnimation];
        }
    }];
}

#pragma mark — 配置UI相关
- (void)configUI {
    self.navigationItem.title =
    self.viewModel.viewType == PayMethodViewType_Add ?
    NSLocalizedString(@"3.0_AddPayMethods", nil) :
    NSLocalizedString(@"3.0_EditPayMethods", nil);
    
    [self.btn setTitle:
     (self.viewModel.viewType == PayMethodViewType_Add ?
      SWLocaloziString(@"3.0_jf_pay_add") :
      SWLocaloziString(@"3.0_jf_pay_edit"))
              forState:UIControlStateNormal];
    
    self.view.backgroundColor = viewBackgroundColor;

    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.networkMethodView];
    [self.contentScrollView addSubview:self.BankCardMethodView];
    [self.contentScrollView addSubview:self.topView];
    [self.contentScrollView addSubview:self.btn];
}

- (void)payMethodViewAnimation{
    UIView *selectView = nil;
    UIView *oldView = self.oldSelectMethodView;
    BOOL centerLineAlpha = NO;
    CGFloat height = 0;
    switch (self.viewModel.payMethodType) {
        case PayMethodType_Network:{
            selectView = self.networkMethodView;
            centerLineAlpha = YES;
            height = 46 * 2 + 128;
        }
            break;
        case PayMethodType_BankCard_USD:{
            selectView = self.BankCardMethodView;
            centerLineAlpha = NO;
            NSArray *sortArray = @[@0,@1,@2,@4,@5,@6,@3];
            NSInteger index = 1;
            for (NSNumber *num in sortArray) {
                for (UIView *view in self.bankViewList) {
                    NSInteger sortIndex = [num integerValue] + 100;
                    if (view.tag == sortIndex) {
                        view.top = 46*index;
                    }
                }
                index++;
            }

            height = 46 * 6;
        }
            break;
        case PayMethodType_BankCard_CNY:{
            selectView = self.BankCardMethodView;
            centerLineAlpha = NO;
            NSArray *sortArray = @[@0,@1,@2,@3,@4,@5,@6];
            NSInteger index = 1;
            for (NSNumber *num in sortArray) {
                for (UIView *view in self.bankViewList) {
                    NSInteger sortIndex = [num integerValue] + 100;
                    if (view.tag == sortIndex) {
                        view.top = 46*index;
                    }
                }
                index++;
            }
            height = 46 * 5;

        }
            break;
        case PayMethodType_BankCard_VND:{
            selectView = self.BankCardMethodView;
            centerLineAlpha = NO;
            height = 46 * 6;
            NSArray *sortArray = @[@0,@1,@2,@6,@3,@5,@4];
            NSInteger index = 1;
            for (NSNumber *num in sortArray) {
                for (UIView *view in self.bankViewList) {
                    NSInteger sortIndex = [num integerValue] + 100;
                    if (view.tag == sortIndex) {
                        view.top = 46*index;
                    }
                }
                index++;
            }
        }
            break;
    }

    [UIView animateWithDuration:.35 animations:^{
        
        if (oldView != selectView) {
            self.centerLine.alpha = centerLineAlpha ? 1.0 : 0.0;
            oldView.alpha = 0.0;
            selectView.alpha = 1.0;
        }

        selectView.top = self.topView.bottom + (centerLineAlpha ? 0 : 10);
        selectView.height = height;
        self.btn.top = selectView.bottom + 20;

    }];
    
    self.oldSelectMethodView = selectView;
}

-(void)showSelectCollectionView:(NSArray *) incons{
    @weakify(self);
    [IDCMColletionTipView showWithTitle:NSLocalizedString(@"3.0_CurrencyTypeSwith", nil)
                              cellClass:[IDCMCurrencyCollectionViewCell class]
                            modelsArray:incons
                               itemSize:CGSizeMake(70, 70)
                              interRows:4
                            maxLineRows:4
                                 margin:12
                           contentInset:UIEdgeInsetsMake(0, 20, 30, 20)
                            lineSpacing:20
                       interitemSpacing:10
                           positionType:0
                      itemClickCallback:^(id model) {
                          @strongify(self);
                          [self refreshCurrencyInfoWithModel:model];
                      }];
}

- (void)showPaySwitchView{
    @weakify(self);
    [IDCMSelectPayMethodsView showWithTitle:SWLocaloziString(@"3.0_PayMethodsSwitch")
                                     models:self.paySwitchViewModel.PaytypeList
                              cellConfigure:^(SelectPayViewCell *cell, IDCMPaytypeListItemModel *model) {
                                  
                                  NSString *payTitle = model ? model.PayTypeCode : @"";
                                  NSString * language = [IDCMUtilsMethod getPreferredLanguage];
                                  if ([language isEqualToString:@"zh-Hans"]) {
                                      if ([payTitle isEqualToString:@"AliPay"]) {
                                          payTitle = @"支付宝";
                                      }else if ([payTitle isEqualToString:@"WeChat"]){
                                          payTitle = @"微信";
                                      }else{
                                          payTitle = @"银行借记卡";
                                      }
                                  }else if ([language isEqualToString:@"zh-Hant"]){
                                      if ([payTitle isEqualToString:@"AliPay"]) {
                                          payTitle = @"支付寶";
                                      }else if ([payTitle isEqualToString:@"WeChat"]){
                                          payTitle = @"微信";
                                      }else{
                                          payTitle = @"銀行借記卡";
                                      }
                                  }
                                  cell.payTitleLabel.text = payTitle;
                                  [cell.iconImageView
                                   sd_setImageWithURL:[NSURL URLWithString:model ? model.PayTypeLogo : @""]];
                                  
    } selectedCallback:^(IDCMPaytypeListItemModel *model) {
        @strongify(self);
        if (model != self.selectPayModel) {
            self.selectPayModel = model;
        }
    }];
}
- (void)refreshCurrencyInfoWithModel:(IDCMLocalCurrencyListItemModel *)model {
    model.isSelect = YES;
    if (self.selectCurrencyModel && ![model.ID isEqualToString:self.selectCurrencyModel.ID]) {
        self.selectCurrencyModel.isSelect = NO;
    }
    self.selectCurrencyModel = model;
}

#pragma mark - getters and setters
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView){
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.backgroundColor = viewBackgroundColor;
        _contentScrollView.alwaysBounceVertical = YES;
        _contentScrollView.frame = self.view.bounds;
    }
    return _contentScrollView;
}
- (QMUIButton *)addQRCodeBtn{
    return SW_LAZY(_addQRCodeBtn, ({
        QMUIButton *btn = [[QMUIButton alloc] init];
        btn.frame = CGRectMake(12, 46*2 + 14 , SCREEN_WIDTH - 24, 100);
        btn.imagePosition = QMUIButtonImagePositionTop;
        btn.spacingBetweenImageAndTitle = 12;
        [btn setBackgroundImage:UIImageMake(@"3.2_pay_addQRCode_bg") forState:(UIControlStateNormal)];
        [btn setBackgroundImage:UIImageMake(@"3.2_pay_addQRCode_bg") forState:(UIControlStateHighlighted)];
        [btn setTitle:SWLocaloziString(@"3.0_PayMethods_qrcode_title") forState:(UIControlStateNormal)];
        [btn setTitleColor:SetColor(41, 104, 185) forState:(UIControlStateNormal)];
        [btn setTitleColor:SetColor(41, 104, 185) forState:(UIControlStateHighlighted)];
        btn.titleLabel.font = textFontPingFangRegularFont(14);
        [btn setImage:UIImageMake(@"3.2_pay_addQRCode") forState:UIControlStateNormal];
        [btn setImage:UIImageMake(@"3.2_pay_addQRCode") forState:UIControlStateHighlighted];
        [btn setAdjustsButtonWhenHighlighted:NO];
        btn;
    }));
}
- (UIView *)QRCodeSelectView{
    return SW_LAZY(_QRCodeSelectView, ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 46*2,SCREEN_WIDTH, 128);
        view.hidden = YES;
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.layer.cornerRadius = 6.0;
        imageV.layer.masksToBounds = YES;
        imageV.backgroundColor = SetColor(216, 216, 216);
        [view addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(16);
            make.size.mas_equalTo(CGSizeMake(90, 100));
            make.centerX.equalTo(view);
        }];
        self.QRCodeImageView = imageV;
        
        UIButton *delBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [delBtn setImage:UIImageMake(@"3.2_pay_delQRCode") forState:(UIControlStateNormal)];
        [view addSubview:delBtn];
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerX.equalTo(imageV.mas_right);
            make.centerY.equalTo(imageV.mas_top);
        }];
        self.delQRCodeBtn = delBtn;
        view;
    }));
}
- (UIView *)topView {
    return SW_LAZY(_topView, ({

        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 46 * 2);

        @weakify(self);
        self.currencyLabel = [[UILabel alloc] init];
        CGRect rect1 = CGRectMake(0, 0, view.width, 46);
        [view addSubview:
         [self createOneLineViewWithFrame:rect1
                                leftTitle:NSLocalizedString(@"3.0_CurrencyType", nil)
                                rightView:self.currencyLabel
                               rightTitle:NSLocalizedString(@"3.0_CurrencySwith", nil)
                              btnCallback:^(UIButton *btn) {

                                  @strongify(self);
                                  [self.view endEditing:YES];
                                  NSMutableArray <IDCMLocalCurrencyListItemModel *>*mArray = @[].mutableCopy;
                                  
                                  if (self.selectPayModel) { //如果有选中的支付方式，要根据支付选择国家
                                      NSArray <IDCMLocalCurrencyListItemModel *>*selectArray = self.selectPayModel.LocalCurrencyList;
                                      for (IDCMLocalCurrencyListItemModel *currencyModel in selectArray) {
                                          
                                          for (IDCMLocalCurrencyListItemModel *allModel in self.CurrencyList) {
                                              if ([currencyModel.LocalCurrencyCode isEqualToString:allModel.LocalCurrencyCode] && [currencyModel.ID isEqualToString:allModel.ID]) {
                                                  [mArray addObject:allModel];
                                              }
                                          }
                                      }
                                  }
                                  else{
                                      [mArray addObjectsFromArray:self.CurrencyList];
                                  }
                                  if (mArray.count > 0) {
                                      [self showSelectCollectionView:mArray];
                                  }
                              }]];

        self.payMethodLabel = [[UILabel alloc] init];
        CGRect rect2 = CGRectMake(0, 46 , view.width, 46);
        [view addSubview:
         [self createOneLineViewWithFrame:rect2
                                leftTitle:NSLocalizedString(@"3.0_PayMethods", nil)
                                rightView:self.payMethodLabel
                               rightTitle:NSLocalizedString(@"3.0_PayMethodsSwitch", nil)
                              btnCallback:^(UIButton *btn) {
                                  
                                  @strongify(self);
                                  [self.view endEditing:YES];
                                  NSMutableArray <IDCMPaytypeListItemModel *>*mArray = @[].mutableCopy;

                                  if (self.selectCurrencyModel) { //如果有选中的国家，要根据国家选择支付
                                      NSArray <IDCMPaytypeListItemModel *>*selectArray = self.selectCurrencyModel.PaytypeList;
                                      for (IDCMPaytypeListItemModel *payModel in selectArray) {
                                          
                                          for (IDCMPaytypeListItemModel *allModel in self.PaytypeList) {
                                              if ([payModel.PayTypeCode isEqualToString:allModel.PayTypeCode] && [payModel.ID isEqualToString:allModel.ID]) {
                                                  [mArray addObject:allModel];
                                              }
                                          }
                                      }
                                  }
                                  else{
                                      [mArray addObjectsFromArray:self.PaytypeList];
                                  }
                                  
                                  self.paySwitchViewModel.PaytypeList = mArray;
                                  if (mArray.count > 0) {
                                      [self showPaySwitchView];
                                  }
                              }]];
        view;
    }));
}

- (UIView *)networkMethodView {
    return SW_LAZY(_networkMethodView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0,  SCREEN_WIDTH, 46  * 2 + 128);
        view.alpha = 0.0;
      
        self.nameTextField = [[UITextField alloc] init];
        CGRect rect3 = CGRectMake(0, 0, view.width, 46);
        [view addSubview:
        [self createOneLineViewWithFrame:rect3
                               leftTitle:NSLocalizedString(@"3.0_Name", nil)
                               rightView:self.nameTextField
                              rightTitle:NSLocalizedString(@"3.0_NamePlaceholder", nil)
                             btnCallback:nil]];
        [self.bankViewMdict setObject:self.nameTextField forKey:@"NetWork_UserName"];

        self.accountTextField = [[UITextField alloc] init];
        CGRect rect4 = CGRectMake(0, 46, view.width, 46);
        [view addSubview:
        [self createOneLineViewWithFrame:rect4
                               leftTitle:SWLocaloziString(@"3.0_PayMethods_ali_account")
                               rightView:self.accountTextField
                              rightTitle:@"example@hotmail.com"
                             btnCallback:nil]];
        [self.bankViewMdict setObject:self.accountTextField forKey:@"NetWork_AccountNo"];
        [view addSubview:self.QRCodeSelectView];
        @weakify(self);
        
        [[self.delQRCodeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                configure.title(NSLocalizedString(@"3.0_DeleteQRCodeSure", nil)).getBtnsConfig.lastObject.btnCallback(^{
                    @strongify(self);
                    self.addQRCodeBtn.hidden = NO;
                    self.QRCodeSelectView.hidden = YES;
                    self.QRCodeImageView.image = nil;
                    self.viewModel.QRCodeImg = nil;
                    self.viewModel.QRCodeURL = @"";
                });
                configure.getBtnsConfig.firstObject.btnCallback(^{
                });
            }];
        }];
        
        [[self.addQRCodeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.view endEditing:YES];
            [IDCMBottomListTipView showTipViewToView:nil titleArray:@[SWLocaloziString(@"3.0_Chat_TakePhoto"),SWLocaloziString(@"3.0_Chat_Photo"),SWLocaloziString(@"3.0_Chat_Cancle")] itemClickCallback:^(NSInteger index, id title) {
                if (index == 2){
                    return ;
                }
                [[IDCMSelectPhotosTool sharedSelectPhotosTool] selectSiglePhotoFromCamera:index == 0 thumbnailWithSize:CGSizeZero completeCallback:^(UIImage *thumbnailPhoto, UIImage *originPhoto) {
                    UIImage *img = [UIImage imageWithData:UIImageJPEGRepresentation(originPhoto, 0.2)];
                    [[RACScheduler mainThreadScheduler] schedule:^{
                        @strongify(self);
                        self.addQRCodeBtn.hidden = YES;
                        self.QRCodeSelectView.hidden = NO;
                        self.QRCodeImageView.image = img;
                        self.viewModel.QRCodeImg = img;
                    }];
                }];
            }];
        }];
        [view addSubview:self.addQRCodeBtn];
        view;
    }));
}

- (UIView *)BankCardMethodView {
    return SW_LAZY(_BankCardMethodView, ({
        
        UIView *view = [[UIView alloc] init];
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0,  SCREEN_WIDTH, 46 * 8);
        view.alpha = 0.0;
        
        NSString *str1 = NSLocalizedString(@"3.0_BankCard", nil);
        NSString *str2 = NSLocalizedString(@"3.0_BankTip", nil);
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]
                                           initWithString:[NSString stringWithFormat:@"%@%@", str1, str2]];
        [attr addAttributes:@{ NSFontAttributeName : textFontPingFangRegularFont(14),
                               NSForegroundColorAttributeName : textColor333333
                               } range:NSMakeRange(0, str1.length)];
        
        [attr addAttributes:@{ NSFontAttributeName : textFontPingFangRegularFont(14),
                               NSForegroundColorAttributeName : textColor999999
                               } range:NSMakeRange(str1.length, attr.length - str1.length)];
        CGRect rect1 = CGRectMake(0, 0, view.width, 46);
        [view addSubview:
         [self createOneLineViewWithFrame:rect1
                                leftTitle:attr
                                rightView:nil
                               rightTitle:nil
                              btnCallback:nil]];
        
        self.cardPeopleNameTextField = [[UITextField alloc] init];
        CGRect rect2 = CGRectMake(0, 46 , view.width, 46);
        UIView *cardPeopleNameView = [self createOneLineViewWithFrame:rect2
                                                            leftTitle:NSLocalizedString(@"3.0_Name", nil)
                                                            rightView:self.cardPeopleNameTextField
                                                           rightTitle:NSLocalizedString(@"3.0_BankNamePlaceholder", nil)
                                                          btnCallback:nil];
        cardPeopleNameView.tag = 100;
        [view addSubview:cardPeopleNameView];
        [self.bankViewList addObject:cardPeopleNameView];
        [self.bankViewMdict setObject:self.cardPeopleNameTextField forKey:@"UserName"];
        
        self.cardAccountTextField = [[UITextField alloc] init];
        CGRect rect3 = CGRectMake(0, 46 * 2, view.width, 46);
        UIView *cardAccountView = [self createOneLineViewWithFrame:rect3
                                                         leftTitle:NSLocalizedString(@"3.0_Account", nil)
                                                         rightView:self.cardAccountTextField
                                                        rightTitle:NSLocalizedString(@"3.0_AccountPlaceholder", nil)
                                                       btnCallback:nil];
        cardAccountView.tag = 101;
        [view addSubview:cardAccountView];
        [self.bankViewList addObject:cardAccountView];
        [self.bankViewMdict setObject:self.cardAccountTextField forKey:@"AccountNo"];
        self.cardAccountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        self.cardAccountTextField.delegate = self;
        [self.cardAccountTextField addTarget:self
                          action:@selector(reformatAsCardNumber:)
                forControlEvents:UIControlEventEditingChanged];
//
        self.cardBankNameTextField = [[UITextField alloc] init];
        CGRect rect4 = CGRectMake(0, 46 * 3, view.width, 46);
        UIView *cardBankNameView = [self createOneLineViewWithFrame:rect4
                                                      leftTitle:NSLocalizedString(@"3.0_Bank", nil)
                                                      rightView:self.cardBankNameTextField
                                                     rightTitle:NSLocalizedString(@"3.0_BankPlaceholder", nil)
                                                    btnCallback:nil];
        cardBankNameView.tag = 102;
        [view addSubview:cardBankNameView];
        [self.bankViewList addObject:cardBankNameView];
        [self.bankViewMdict setObject:self.cardBankNameTextField forKey:@"BankName"];

        
        self.cardBankSubNameTextField = [[UITextField alloc] init];
        CGRect rect5 = CGRectMake(0, 46 * 4, view.width, 46);
        UIView *cardBankSubNameView = [self createOneLineViewWithFrame:rect5
                                                             leftTitle:NSLocalizedString(@"3.0_BankSub", nil)
                                                             rightView:self.cardBankSubNameTextField
                                                            rightTitle:NSLocalizedString(@"3.0_BankBranchPlaceholder", nil)
                                                           btnCallback:nil];
        cardBankSubNameView.tag = 103;
        [view addSubview:cardBankSubNameView];
        [self.bankViewList addObject:cardBankSubNameView];
        [self.bankViewMdict setObject:self.cardBankSubNameTextField forKey:@"BankBranch"];

        
        self.cardBankAddressTextField = [[UITextField alloc] init];
        CGRect rect6 = CGRectMake(0, 46 * 5, view.width, 46);
        UIView *cardBankAddressView = [self createOneLineViewWithFrame:rect6
                                                            leftTitle:NSLocalizedString(@"3.0_BankAddress", nil)
                                                            rightView:self.cardBankAddressTextField
                                                           rightTitle:NSLocalizedString(@"3.0_BankAddressPlaceholder", nil)
                                                           btnCallback:nil];
        cardBankAddressView.tag = 104;
        [view addSubview:cardBankAddressView];
        [self.bankViewList addObject:cardBankAddressView];
        [self.bankViewMdict setObject:self.cardBankAddressTextField forKey:@"BankAddress"];

        
        self.cardBankCodeTextField = [[UITextField alloc] init];
        CGRect rect7 = CGRectMake(0, 46 * 6, view.width, 46);
        UIView *cardBankCodeView = [self createOneLineViewWithFrame:rect7
                                                          leftTitle:@"SWIFT CODE"
                                                          rightView:self.cardBankCodeTextField
                                                         rightTitle:NSLocalizedString(@"3.0_BankCodePlaceholder", nil)
                                                        btnCallback:nil];
        cardBankCodeView.tag = 105;
        [view addSubview:cardBankCodeView];
        [self.bankViewList addObject:cardBankCodeView];
        [self.bankViewMdict setObject:self.cardBankCodeTextField forKey:@"SwiftCode"];

        
        self.cardBankCityTextField = [[UITextField alloc] init];
        CGRect rect8 = CGRectMake(0, 46 * 7, view.width, 46);
        UIView *cardBankCityView = [self createOneLineViewWithFrame:rect8
                                                          leftTitle:NSLocalizedString(@"3.0_BankCity", nil)
                                                          rightView:self.cardBankCityTextField
                                                         rightTitle:NSLocalizedString(@"3.0_BankCityPlaceholder", nil)
                                                        btnCallback:nil];
        cardBankCityView.tag = 106;
        [view addSubview:cardBankCityView];
        [self.bankViewList addObject:cardBankCityView];
        [self.bankViewMdict setObject:self.cardBankCityTextField forKey:@"City"];

        view;
    }));
}


- (UIButton *)btn {
    return SW_LAZY(_btn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.view.width - 24;
        btn.height = 40;
        btn.top = self.topView.bottom + 20;
        btn.left = 12;
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"2.1_Submit", nil) forState:UIControlStateNormal];
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



- (UIView *)createOneLineViewWithFrame:(CGRect)frame
                             leftTitle:(id)leftTitle
                            rightView:(UIView *)rightView
                            rightTitle:(NSString *)rightTitle
                           btnCallback:(void(^)(UIButton *btn))btnCallback {
    
    UIView *view = [[UIView alloc] init];
    view.frame = frame;
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.textColor = textColor666666;
    leftLabel.font = textFontPingFangRegularFont(14);
    if ([leftTitle isKindOfClass:[NSString class]]) {
        leftLabel.text = leftTitle;
        if([leftTitle isEqualToString:SWLocaloziString(@"3.0_PayMethods_ali_account")]){
            self.networkAccountLbl = leftLabel;
            leftLabel.width = view.width / 2 - 50;
        }
        else{
            [leftLabel sizeToFit];
        }
    }
    if ([leftTitle isKindOfClass:[NSAttributedString class]] ||
        [leftTitle isKindOfClass:[NSMutableAttributedString class]]  ) {
        leftLabel.attributedText = leftTitle;
        [leftLabel sizeToFit];
    }
    leftLabel.height = 20;
    leftLabel.left = 12;
    leftLabel.centerY = view.height / 2;
    [view addSubview:leftLabel];
    
    if (btnCallback && rightView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.0_angle"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.right = view.width - 12;
        imageView.centerY = leftLabel.centerY;
        [view addSubview:imageView];
        
        UILabel *label = (UILabel *)rightView;
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = textColor999999;
        label.font = textFontPingFangRegularFont(14);
        label.text = rightTitle;
        label.width = imageView.left - leftLabel.right - 10 - 3 ;
        label.height = view.height;
        label.left = leftLabel.right + 10;
        label.centerY = leftLabel.centerY;
        [view addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(view.width / 2, 0, view.width / 2, view.height);
        [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
         subscribeNext:btnCallback];
        [view addSubview:btn];
        
        if (self.viewModel.editPaymentModel) {
            imageView.hidden = YES;
            label.width = imageView.right - leftLabel.right - 10;

        }
        else{
            imageView.hidden = NO;
            label.width = imageView.left - leftLabel.right - 10 - 3;

        }
        
    } else if (rightView) {
        
        UITextField *textField = (UITextField *)rightView;
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = textColor333333;
        textField.font = textFontPingFangRegularFont(14);
        textField.keyboardType =  UIKeyboardTypeDefault; //UIKeyboardTypeDecimalPad;
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.width = view.width - leftLabel.right - 10 - 12 ;
        textField.left = leftLabel.right + 10;
        textField.height = view.height;
        textField.centerY = leftLabel.centerY;
        textField.placeholder = rightTitle;
    }
    
    if ([leftLabel isKindOfClass:[NSString class]]) {
        if (![leftTitle isEqualToString:SWLocaloziString(@"3.0_PayMethods_ali_account")] &&
            ![leftTitle isEqualToString:NSLocalizedString(@"3.0_BankSub", nil)]) {
            UIView *line = [UIView new];
            line.backgroundColor = viewBackgroundColor;
            line.height = 1.0;
            line.width = view.width - leftLabel.left;
            line.left = leftLabel.left;
            line.bottom = view.height;
            [view addSubview:line];
            if ([leftTitle isEqualToString:NSLocalizedString(@"3.0_PayMethods", nil)]) {
                self.centerLine = line;
                line.alpha = 0.0;
            }
        }

    } else {
        UIView *line = [UIView new];
        line.backgroundColor = viewBackgroundColor;
        line.height = 1.0;
        line.width = view.width - leftLabel.left;
        line.left = leftLabel.left;
        line.bottom = view.height;
        [view addSubview:line];
    }

    [view addSubview:rightView];
    return view;
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    CGFloat keyboardTop = self.view.height - height;
    if (self.btn.bottom > keyboardTop) {
        if (self.viewModel.payMethodType == PayMethodType_Network ) {
            CGFloat top = 46*2;
            self.contentScrollView.top = -top;
        }
        else{
            CGFloat top = 46*3 + 10;
            self.contentScrollView.top = -top;
        }

    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    self.contentScrollView.top = 0;
}
#pragma mark - UITextFieldDelegate
// Version 1.2
// Source and explanation: http://stackoverflow.com/a/19161529/1709587
-(void)reformatAsCardNumber:(UITextField *)textField
{
    // In order to make the cursor end up positioned correctly, we need to
    // explicitly reposition it after we inject spaces into the text.
    // targetCursorPosition keeps track of where the cursor needs to end up as
    // we modify the string, and at the end we set the cursor position to it.
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    
    NSString *cardNumberWithoutSpaces =
    [self removeNonDigits:textField.text
andPreserveCursorPosition:&targetCursorPosition];
    
    if ([cardNumberWithoutSpaces length] > 20) {
        // If the user is trying to enter more than 19 digits, we prevent
        // their change, leaving the text field in  its previous state.
        // While 16 digits is usual, credit card numbers have a hard
        // maximum of 19 digits defined by ISO standard 7812-1 in section
        // 3.8 and elsewhere. Applying this hard maximum here rather than
        // a maximum of 16 ensures that users with unusual card numbers
        // will still be able to enter their card number even if the
        // resultant formatting is odd.
        [textField setText:self.previousTextFieldContent];
        textField.selectedTextRange = self.previousSelection;
        return;
    }
    
    NSString *cardNumberWithSpaces =
    [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces
                      andPreserveCursorPosition:&targetCursorPosition];
    
    textField.text = cardNumberWithSpaces;
    UITextPosition *targetPosition =
    [textField positionFromPosition:[textField beginningOfDocument]
                             offset:targetCursorPosition];
    
    [textField setSelectedTextRange:
     [textField textRangeFromPosition:targetPosition
                           toPosition:targetPosition]
     ];
}

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    // Note textField's current state before performing the change, in case
    // reformatTextField wants to revert it
    self.previousTextFieldContent = textField.text;
    self.previousSelection = textField.selectedTextRange;
    
    return YES;
}

/*
 Removes non-digits from the string, decrementing `cursorPosition` as
 appropriate so that, for instance, if we pass in `@"1111 1123 1111"`
 and a cursor position of `8`, the cursor position will be changed to
 `7` (keeping it between the '2' and the '3' after the spaces are removed).
 */
- (NSString *)removeNonDigits:(NSString *)string
    andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string
                          andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if ((i>0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}

//}
@end



