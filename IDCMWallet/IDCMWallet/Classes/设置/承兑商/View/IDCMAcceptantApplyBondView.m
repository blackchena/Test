//
//  IDCMAcceptantApplyBondView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//


#import "IDCMAcceptantApplyBondViewModel.h"
#import "IDCMAcceptantBondSuccessView.h"
#import "IDCMAcceptantApplyBondView.h"
#import "IDCMFlashExchangeViewModel.h"
#import "IDCMAcceptantBondSureView.h"
#import "IDCMChooseBTypeView.h"
#import "IDCMCoinListModel.h"
#import "StepSlider.h"



@interface IDCMAcceptantApplyBondView ()
@property (nonatomic,strong) IDCMAcceptantApplyBondViewModel *viewModel;
@property (nonatomic,strong) UILabel *currencyLabel;
@property (nonatomic,strong) QMUITextField *currencyCountTextField;
@property (nonatomic,strong) QMUILabel *currencyCountTitle;
@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) UILabel *balanceLabel;

@property (nonatomic,strong) UIView *addressView;
@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UIView *feeView;
@property (nonatomic,strong) UILabel *feeLabel;

@property (nonatomic,strong) UILabel *feeDesLabel;

@property (nonatomic,strong) QMUISlider *slider;
@property (nonatomic,strong) StepSlider *feeSlider;

@property (nonatomic,strong) RACSubject *completeSignal;
@end


@implementation IDCMAcceptantApplyBondView
+ (instancetype)bondViewWithFrame:(CGRect)frame
                    completeSignal:(RACSubject *)completeSignal{
    IDCMAcceptantApplyBondView *view = [[IDCMAcceptantApplyBondView alloc] init];
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
    
    self.btn.rac_command = self.viewModel.bondcommand;
    [[self.viewModel.bondcommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (![x boolValue]) {
            @strongify(self);
            [self endEditing:YES];
            
            NSArray *array = @[RACTuplePack(NSLocalizedString(@"2.0_Address", nil), @"shfoewoeofh23hofuesohfosefhosehfoshefohsefho", @(45)),
                               RACTuplePack(NSLocalizedString(@"2.0_MinersCost", nil), @"4.2324 BTC", @(45)) ];
            IDCMAcceptantBondSureView *view1 =
            [IDCMAcceptantBondSureView bondSureViewWithTitle:NSLocalizedString(@"3.0_SurePickIn", nil)
                                                    subTitle:@"BTC 3.2343"
                                                sureBtnTitle:NSLocalizedString(@"3.0_NowTimePickIn", nil)
                                                   confidArr:array
                                               closeBtnInput:^(id input) {
                                                   [IDCMScrollViewPageTipView dismissWithComletion:nil];
                                               }
                                                sureBtnInput:^(id input) {
                                                    [IDCMScrollViewPageTipView scrollToNextPage];
                                                }];
            
            IDCMAcceptantBondSuccessView *view2 =
            [IDCMAcceptantBondSuccessView bondSuccessViewTitle:NSLocalizedString(@"3.0_PickInCompleteInfo", nil)
                                                      subTitle:NSLocalizedString(@"2.0_QueryRecord", nil)
                                                      btnTitle:NSLocalizedString(@"3.0_PickInComplete", nil)
                                                 completeInput:^(id input) {
                                                     [IDCMScrollViewPageTipView dismissWithComletion:^{
                                                         [self.completeSignal sendNext:nil];
                                                     }];
                                                 }];;

            [IDCMScrollViewPageTipView showTipViewToView:nil
                                            contentViews:@[view1, view2]
                                            contentSizes:@[@(CGSizeMake(SCREEN_WIDTH, 440 + kSafeAreaBottom))]
                                        initialPageIndex:0
                                           scrollEnabled:NO
                                            positionType:1];
        }
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
                self.balanceLabel.text = @"余额: 0 BTC";
            } else {
                alpha = 0.0;
                addressTop = 103;
            }
            
            [UIView animateWithDuration:.35 animations:^{
                self.balanceLabel.alpha = alpha;
                self.addressView.top = addressTop;
//                self.feeView.top = self.addressView.bottom + 10;
                self.btn.top = self.addressView.bottom + 20;
            }];
        }];
    }];
    
    RAC(self.feeLabel, text) = [[self.currencyCountTextField.rac_textSignal combineLatestWith:RACObserve(self.currencyCountTitle, text)] reduceEach:^(NSString *count, NSString *title){
        return [NSString stringWithFormat:@"%.4f %@", [count floatValue] / 10, title ?: @""];
    }];
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
                          }]];
    
    self.currencyCountTextField = [[QMUITextField alloc] init];
    CGRect rect2 = CGRectMake(0, 46 , self.width, 46);
    [self addSubview:
     [self createOneLineViewWithFrame:rect2
                            leftTitle:NSLocalizedString(@"3.0_AcceptantBondCount", nil)
                       rightTextField:self.currencyCountTextField
                          btnCallback:nil]];
    
    [self addSubview:self.balanceLabel];
    [self addSubview:self.addressView];
//    [self addSubview:self.feeView];
    [self addSubview:self.btn];
    
    self.addressLabel.text = @"23jsejskjslndlflehfwoehf23323sljfldjfe";
}

-(void)showSelectCollectionView:(NSArray *) incons{
    
    [IDCMColletionTipView showWithTitle:NSLocalizedString(@"3.0_AcceptantBondCurrencyTypeSwitch", nil)
                              cellClass:[IDCMBTypeCollectionViewCell class]
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
                          [self refreshCurrencyInfoWithModel:model];
                      }];
}

- (void)refreshCurrencyInfoWithModel:(IDCMCoinModel *)model {
    
    self.currencyCountTitle.text = model.coinLabel.uppercaseString;
    [self.currencyCountTitle sizeToFit];
    [self.currencyCountTextField resignFirstResponder];
    
    self.currencyLabel.attributedText =
    [[NSAttributedString alloc] initWithString:model.coinLabel attributes:@{NSFontAttributeName : textFontPingFangRegularFont(14),
                                                                        NSForegroundColorAttributeName : textColor333333}];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
    [manager loadImageWithURL:[NSURL URLWithString:model.coinUrl] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        //回调从新设置
        if (image) {
            NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = image;
            attachment.bounds = CGRectMake(0, -8, 24, 24);
            NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:model.coinLabel];
            [textAttrStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
            [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [textAttrStr appendAttributedString:nameAttributedString];
            [textAttrStr addAttribute:NSKernAttributeName value:@(5)
                                range:NSMakeRange(0, 2)];
            self.currencyLabel.attributedText = textAttrStr ;
            self.currencyLabel.textColor = textColor333333;
        }
    }];
}

#pragma mark - getters and setters
- (UILabel *)feeDesLabel{
    return SW_LAZY(_feeDesLabel, ({
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textColor = SetColor(251, 48, 48);
        lbl.font = textFontPingFangRegularFont(12);
        lbl.text = NSLocalizedString(@"3.0_jf_AcceptantCashDeposit_fee_des", nil);

        lbl;
    }));
}

- (UIView *)feeView {
    return SW_LAZY(_feeView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.size = CGSizeMake(self.width, 67);
        view.top = self.addressView.bottom + 10;

        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor666666;
        label.font = textFontPingFangRegularFont(12);
        label.text = NSLocalizedString(@"2.0_MinersCost", nil);
        label.width = self.width * .4 - 24;
        label.height = 17;
        label.left = 12;
        label.top = 13;
        [view addSubview:label];
        
        UILabel *feeLabel = [[UILabel alloc] init];
        feeLabel.textColor = textColor333333;
        feeLabel.font = textFontPingFangRegularFont(12);
        feeLabel.text = @"0.0000";
        feeLabel.width = label.width;
        feeLabel.height = 17;
        feeLabel.left = label.left;
        feeLabel.top = label.bottom + 7;
        [view addSubview:feeLabel];
        self.feeLabel = feeLabel;
        
        self.feeSlider.width = view.width - 15 - label.right - 10;
        self.feeSlider.height = 45;
        self.feeSlider.left = label.right + 10;
        self.feeSlider.top = 10;
        [view addSubview:self.feeSlider];
       
        view;
    }));
}

- (StepSlider *)feeSlider {
    
    return SW_LAZY(_feeSlider, ({
        
        StepSlider *view = [StepSlider new];
        view.maxCount = 3;
        view.trackCircleRadius = 3.5;
        view.trackHeight = 1;
        view.tintColor = SetColor(41, 104, 185);
        view.trackColor = SetColor(221, 221, 221);
        view.sliderCircleRadius = 8.5;
        [view setIndex:1];
        view.labelColor = SetColor(153, 153, 153);
        view.labelFont = textFontPingFangRegularFont(10);
        view.labelOffset = 9.0f;
        view.labels = @[SWLocaloziString(@"2.1_sendSlow"), SWLocaloziString(@"2.1_sendRecommended"), SWLocaloziString(@"2.1_sendFast")];
        view.sliderCircleImage = UIImageMake(@"2.1_slidrCycle");
        view;
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
        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithHexString:@"#999FA5"]];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setBackgroundImage:image2 forState:UIControlStateDisabled];
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
    leftLabel.font = textFontPingFangRegularFont(14);
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
        label.font = textFontPingFangRegularFont(14);
        label.text = SWLocaloziString(@"3.0_CurrencyTypeSwitchDigital");
        label.width = imageView.left - leftLabel.right - 10 - 12 ;
        label.height = view.height;
        label.left = leftLabel.right + 10;
        label.centerY = leftLabel.centerY;
        [view addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(view.width / 2, 0, view.width / 2, view.height);
        [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
         subscribeNext:btnCallback];
        [view addSubview:btn];
        
    } else {
        
        QMUITextField *textField = (QMUITextField *)rightTextField;
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = textColor333333;
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
- (IDCMAcceptantApplyBondViewModel *)viewModel {
    return SW_LAZY(_viewModel, ({
        [IDCMAcceptantApplyBondViewModel new];
    }));
}

@end






