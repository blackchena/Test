//
//  IDCMAcceptantPickinBondView.m
//  IDCMWallet
//
//  Created by IDCM on 2018/5/10.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMAcceptantPickinBondViewModel.h"
#import "IDCMAcceptantPickinBondView.h"
#import "IDCMChooseBTypeView.h"
#import "IDCMAcceptantCoinModel.h"
#import "IDCMAcceptantBondSureView.h"
#import "IDCMAcceptantBondSuccessView.h"

@interface IDCMAcceptantPickinBondView()<IconWindowDelegate, QMUITextFieldDelegate>
@property (nonatomic,strong) IDCMAcceptantPickinBondViewModel *viewModel;
@property (nonatomic,strong) UILabel *currencyLabel;
@property (nonatomic,strong) QMUITextField *currencyCountTextField;
@property (nonatomic,strong) QMUILabel *currencyCountTitle;
@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) UILabel *balanceLabel;

@property (nonatomic,strong) UIView *addressView;
@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UILabel *feeDesLabel;

@property (nonatomic,strong) RACSubject *completeSignal;
@property (nonatomic,strong) UILabel * coinImageAndTypeLabel;

@end

@implementation IDCMAcceptantPickinBondView
+ (instancetype)bondViewWithFrame:(CGRect)frame
                   completeSignal:(RACSubject *)completeSignal{
    IDCMAcceptantPickinBondView *view = [[IDCMAcceptantPickinBondView alloc] init];
    view.frame = frame;
    view.backgroundColor = viewBackgroundColor;
    view.alwaysBounceVertical = YES;
    view.completeSignal = completeSignal;
    [view initConfigure];
    return view;
}

- (void)initConfigure {
    [self configUI];
    [self configSignal];
}

- (void)configSignal {
    @weakify(self);
    
    self.btn.rac_command = self.viewModel.btnToPickinBondcommand;
    
    [[self.viewModel.btnToPickinBondcommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (![x boolValue]) {
            @strongify(self);
            [self endEditing:YES];
            
        
            if ([[NSDecimalNumber decimalNumberWithString:self.viewModel.countValue]  compare:[NSDecimalNumber decimalNumberWithString:self.viewModel.withdrawAmount]] == NSOrderedDescending) {
                [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.1_InsufficientBalance", nil)];
                return;
            }
            
            if ([[NSDecimalNumber decimalNumberWithString:self.viewModel.countValue]  compare:self.viewModel.selectCoinModel.minAmount] == NSOrderedAscending) {
                NSString *show = [SWLocaloziString(@"3.0_AcceptantBondCountTip_in") stringByReplacingOccurrencesOfString:@"[IDCWN]" withString:[NSString stringWithFormat:@"%@",self.viewModel.selectCoinModel.minAmount]];
                show = [show  stringByReplacingOccurrencesOfString:@"[IDCWC]" withString:self.viewModel.selectCoinModel.coinCode.uppercaseString];
                NSString *tip = show;
                [IDCMShowMessageView showErrorWithMessage:tip];
                return;
            }
            
            NSArray *array = @[RACTuplePack(SWLocaloziString(@"2.0_Address"), [self.viewModel.selectCoinModel.sysWalletAddress isNotBlank] ? self.viewModel.selectCoinModel.sysWalletAddress : @"", @(30))];
            NSString *coin = [self.viewModel.selectCoinModel.coinCode isNotBlank] ? [self.viewModel.selectCoinModel.coinCode uppercaseString] : @"";
            NSString *coinValue = [NSString stringWithFormat:@"%@ %@",coin,self.currencyCountTextField.text];
            IDCMAcceptantBondSureView *view1 =
            [IDCMAcceptantBondSureView bondSureViewWithTitle:NSLocalizedString(@"3.0_SurePickIn", nil)
                                                    subTitle:coinValue
                                                sureBtnTitle:NSLocalizedString(@"3.0_NowTimePickIn", nil)
                                                   confidArr:array
                                               closeBtnInput:^(id input) {
                                                   [IDCMScrollViewPageTipView dismissWithComletion:nil];
                                               }
                                                sureBtnInput:^(id input) {
                                                    [IDCMScrollViewPageTipView scrollToNextPage];
                                                }];
            
            
            IDCMPINView *pinView = [IDCMPINView bindPINViewType:IDCMPINButtonImageBackType
                                                  closeBtnInput:^(id input) {
                                                      // 返回上一页
                                                      [IDCMScrollViewPageTipView dismissWithComletion:nil];
                                                  }
                                                 PINFinishBlock:^(NSString *password) {
                                                     @strongify(self);
                                                     NSDictionary *input = @{
                                                                             @"PIN":password
                                                                             };
                                                     [self.viewModel.pickinBondcommand execute:input];
                                                 }];
            
            IDCMAcceptantBondSuccessView *view3 =
            [IDCMAcceptantBondSuccessView bondSuccessViewTitle:NSLocalizedString(@"3.0_PickInCompleteInfo", nil)
                                                      subTitle:nil
                                                      btnTitle:NSLocalizedString(@"3.0_PickInComplete", nil)
                                                 completeInput:^(id input) {
                                                     [IDCMScrollViewPageTipView dismissWithComletion:^{
                                                         @strongify(self);
                                                         [self.completeSignal sendNext:nil];
                                                     }];
                                                 }];;
            
            [IDCMScrollViewPageTipView showTipViewToView:nil
                                            contentViews:@[view1,pinView,view3]
                                            contentSizes:@[@(CGSizeMake(SCREEN_WIDTH, 440 + kSafeAreaBottom))]
                                        initialPageIndex:0
                                           scrollEnabled:NO
                                            positionType:1];
        }
    }];
    [[self.viewModel.pickinBondcommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary *respose) {
        @strongify(self);
        [self fetchSendFormData:respose];

    }];
    
    
    [[self.viewModel.getOTCCoincommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSMutableArray *  _Nullable coinList) {

    }];
    [self.viewModel.getOTCCoincommand.errors subscribeNext:^(NSError * _Nullable x) {
    }];
    [self.viewModel.getOTCCoincommand execute:nil];
    [[self.viewModel.getBalanceByCoinCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSString *x) {
        @strongify(self);
        self.balanceLabel.text = [NSString stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"3.0_AcceptantBalance", nil),x,self.viewModel.selectCoinModel.coinCode.uppercaseString];
    }];
    
    RAC(self.viewModel, currency) =
    [RACObserve(self.currencyLabel, attributedText) map:^id (NSAttributedString *value) {
        return [value.string isEqualToString:NSLocalizedString(@"3.0_CurrencyTypeSwitchDigital", nil)] ?  @"" : value;
    }];
    RAC(self.viewModel, countValue) = self.currencyCountTextField.rac_textSignal;
    
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
                self.balanceLabel.text = [NSString stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"3.0_AcceptantBalance", nil),@"",self.viewModel ? self.viewModel.selectCoinModel.coinCode.uppercaseString : @""];

            } else {
                alpha = 0.0;
                addressTop = 103;
            }
            
            [UIView animateWithDuration:.35 animations:^{
                @strongify(self);
                self.balanceLabel.alpha = alpha;
                self.addressView.top = addressTop;
                //                self.feeView.top = self.addressView.bottom + 10;
                self.btn.top = self.addressView.bottom + 20;
                self.feeDesLabel.top = self.btn.bottom + 20;
            }];
        }];
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
        }else if (errorCode == 10){
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.1_PINError", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }else if (errorCode == 802){
            [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_OngoingOTCOrders")];
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
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_jf_pickin_fail_msg", nil)];
            [IDCMScrollViewPageTipView dismissWithComletion:nil];
        }
        
    }else{
        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_jf_pickin_fail_msg", nil)];
        [IDCMScrollViewPageTipView dismissWithComletion:nil];
    }
}
- (void)configUI {
    @weakify(self);
    
    self.currencyLabel = [[UILabel alloc] init];
    CGRect rect1 = CGRectMake(0, 0, self.width, 46);
    [self addSubview:
     [self createOneLineViewWithFrame:rect1
                            leftTitle:NSLocalizedString(@"3.0_AcceptantBondCurrencyType", nil)
                       rightTextField:self.currencyLabel
                          btnCallback:^(UIButton *btn) {
                              
                              @strongify(self);
                              [self endEditing:YES];
                            [self showSelectCollectionView:self.viewModel.coinArray];
                          }]];
    
    self.currencyCountTextField = [[QMUITextField alloc] init];
    self.currencyCountTextField.delegate = self;
    CGRect rect2 = CGRectMake(0, 46 , self.width, 46);
    [self addSubview:
     [self createOneLineViewWithFrame:rect2
                            leftTitle:NSLocalizedString(@"3.0_AcceptantBondCount", nil)
                       rightTextField:self.currencyCountTextField
                          btnCallback:nil]];
    
    [self addSubview:self.balanceLabel];
    [self addSubview:self.addressView];
    [self addSubview:self.btn];
    [self addSubview:self.feeDesLabel];
    [self.feeDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH -24);
    }];

    self.addressLabel.text = @"";
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

#pragma mark — IconWindowDelegate
- (void)iconWindow:(IDCMChooseBTypeView *) iconView
clickedButtonAtIndex:(NSIndexPath *) index
       selectIndex:(NSIndexPath *) select{
    [self refreshCurrencyInfoWithModel:self.viewModel.coinArray[index.row]];
}

- (void)refreshCurrencyInfoWithModel:(IDCMAcceptantCoinModel *)model {
    self.viewModel.selectCoinModel = model;
    self.currencyCountTitle.text = model.coinCode.uppercaseString;
    self.addressLabel.text = model.sysWalletAddress;
    NSString *minAmount =[NSString stringWithFormat:@"%@",model.minAmount];
    NSString *currencyPlaceholder = [SWLocaloziString(@"3.0_AcceptantBondCountPlaceholder_in") stringByReplacingOccurrencesOfString:@"[IDCW]" withString:minAmount];
    self.currencyCountTextField.placeholder = currencyPlaceholder;
    self.coinImageAndTypeLabel.font = textFontPingFangRegularFont(14);
    [self.currencyCountTitle sizeToFit];
    [self.currencyCountTextField resignFirstResponder];
    
    self.viewModel.address = model.sysWalletAddress;
    
    self.currencyLabel.attributedText =
    [[NSAttributedString alloc] initWithString:model.coinCode.uppercaseString attributes:@{NSFontAttributeName : textFontPingFangRegularFont(14),
                                                                            NSForegroundColorAttributeName : textColor333333}];
    @weakify(self);
    SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
    [manager loadImageWithURL:[NSURL URLWithString:model.conLogo] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {

        //回调从新设置
        if (image) {
            @strongify(self);
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
            self.viewModel.currency = textAttrStr;

        }
    }];
    
    [self.viewModel.getBalanceByCoinCommand execute:nil];
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
- (UILabel *)feeDesLabel{
    return SW_LAZY(_feeDesLabel, ({
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textColor = SetColor(251, 48, 48);
        lbl.font = textFontPingFangRegularFont(12);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
        lbl.text = NSLocalizedString(@"3.0_AcceptantBondPickInInfo", nil);
        lbl;
    }));
}

- (UIView *)addressView {
    return SW_LAZY(_addressView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.size = CGSizeMake(self.width, 40);
        view.top = 103;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor666666;
        label.font = textFontPingFangRegularFont(12);
        label.text = NSLocalizedString(@"2.0_Address", nil);
        [label sizeToFit];
        label.left = 12;
        label.centerY = view.height / 2;
        [view addSubview:label];
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.textColor = textColor333333;
        addressLabel.font = textFontPingFangRegularFont(12);
        addressLabel.textAlignment = NSTextAlignmentRight;
        addressLabel.height = 17;
        addressLabel.width = self.width - label.right - 24;
        addressLabel.right = self.width - 12;
        addressLabel.centerY = label.centerY;
        [view addSubview:addressLabel];
        self.addressLabel = addressLabel;
        
        view;
    }));
}

- (UILabel *)balanceLabel {
    return SW_LAZY(_balanceLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor666666;
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.height = 17;
        label.width = self.width - 24;;
        label.top = 103;
        label.right = self.width - 12;
        label.alpha = 0.0;
        label;
    }));
}

- (UIButton *)btn {
    return SW_LAZY(_btn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.width - 24;
        btn.height = 40;
        btn.top = self.addressView.bottom + 20;
        btn.left = 12;
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"3.0_AcceptantBondPickIn", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
//        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithHexString:@"#999FA5"]];
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
        label.text = SWLocaloziString(@"3.0_CurrencyTypeSwitchDigital");
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
        textField.placeholder = NSLocalizedString(@"3.0_AcceptantBondCountPlaceholder", nil);
        
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
- (IDCMAcceptantPickinBondViewModel *)viewModel {
    return SW_LAZY(_viewModel, ({
        [IDCMAcceptantPickinBondViewModel new];
    }));
}
@end



