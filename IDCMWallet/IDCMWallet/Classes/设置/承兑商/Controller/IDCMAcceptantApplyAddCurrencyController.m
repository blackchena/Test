//
//  IDCMAcceptantApplyAddCurrencyController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyAddCurrencyController.h"
#import "IDCMAcceptantApplyAddCurrencyViewModel.h"
#import "IDCMFlashExchangeViewModel.h"
#import "IDCMChooseBTypeView.h"
#import "IDCMAcceptantCoinModel.h"

@interface IDCMAcceptantApplyAddCurrencyController ()<IconWindowDelegate,QMUITextFieldDelegate>
@property (nonatomic,strong) IDCMAcceptantApplyAddCurrencyViewModel *viewModel;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) UILabel *currencyLabel;
@property (nonatomic,strong) QMUITextField *currencyMaxTextField;
@property (nonatomic,strong) QMUILabel *currencyMaxTitle;
@property (nonatomic,strong) QMUITextField *currencyMinTextField;
@property (nonatomic,strong) QMUILabel *currencyMinTitle;
@property (nonatomic,strong) QMUILabel *offerPriceLabel;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UIButton *plusBtn;
@property (nonatomic,strong) UIButton *minusBtn;
@property (nonatomic,strong) UIButton *plusBtnEx;
@property (nonatomic,strong) UIButton *minusBtnEx;
@end


@implementation IDCMAcceptantApplyAddCurrencyController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
    //请求币种列表
    [self requestCoinList];
}

#pragma mark — supper method
- (void)bindViewModel {
    [super bindViewModel];
    self.saveBtn.rac_command = self.viewModel.saveCommand;
    @weakify(self);
    [[self.viewModel.getOtcCoinListCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(NSDictionary *  response) {
        @strongify(self);
        
             if (self.viewModel.currencyType == AddCurrencyType_SellEdit || self.viewModel.currencyType == AddCurrencyType_BuyEdit) {
                 //设置
                 IDCMAcceptantCoinModel * model = [[IDCMAcceptantCoinModel alloc ] init];
                 model.coinCode = self.viewModel.editDict[@"coinCode"];
                 model.maxAmount = self.viewModel.editDict[@"max"];
                 model.minAmount = self.viewModel.editDict[@"min"];
                 model.premium = self.viewModel.editDict[@"premium"];
                 for (NSInteger i=0; i<self.viewModel.acceptantCoinList.count; i++) {
                     //找到名称相同的model 置为选中状态
                     IDCMAcceptantCoinModel * temp = self.viewModel.acceptantCoinList[i];
                     if ([temp.coinCode isEqualToString:self.viewModel.editDict[@"coinCode"]]) {
                         temp.isSelect = YES;
                         model.conLogo = temp.conLogo;
                     }
                 }
                 //
                 self.viewModel.selectModel = model;
                 //刷新页面
                 [self refreshCurrencyInfoWithModel:model];
             }
    }];
    //保存成功
    [[self.viewModel.saveCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(NSDictionary *  response) {
         @strongify(self);
         
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         if ([status isEqual:@"1"] && [response[@"data"] isKindOfClass:[NSNumber class]] && [response[@"data"] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
             if (self.completion) {
                 self.completion(nil);
             }
         }
     }];
}
-(void)requestCoinList{
    
    [self.viewModel.getOtcCoinListCommand execute:nil];
}
#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    @weakify(self);
    
    self.navigationItem.title = self.viewModel.title;
    self.view.backgroundColor = viewBackgroundColor;
    [self.view addSubview:self.contentScrollView];
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[self class]];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.currencyLabel = [[UILabel alloc] init];
    CGRect rect1 = CGRectMake(0, 0, self.view.width, 46);
    [self.contentScrollView addSubview:
    [self createOneLineViewWithFrame:rect1
                           leftTitle:NSLocalizedString(@"3.0_AcceptantCurrencyType", nil)
                      rightTextField:self.currencyLabel
                         btnCallback:^(UIButton *btn) {
                             
                             @strongify(self);
                             [self.view endEditing:YES];
                             if (self.viewModel.currencyType != AddCurrencyType_SellEdit && self.viewModel.currencyType != AddCurrencyType_BuyEdit) {
                                
                                 [self showSelectCollectionView:self.viewModel.acceptantCoinList];
                             }
                         }]];
    
    self.currencyMaxTextField = [[QMUITextField alloc] init];
    CGRect rect2 = CGRectMake(0, 46 , self.view.width, 46);
    [self.contentScrollView addSubview:
    [self createOneLineViewWithFrame:rect2
                           leftTitle:NSLocalizedString(@"3.0_AcceptantCurrencyMax", nil)
                      rightTextField:self.currencyMaxTextField
                         btnCallback:nil]];
    
    self.currencyMinTextField = [[QMUITextField alloc] init];
    CGRect rect3 = CGRectMake(0, 46 * 2, self.view.width, 46);
    [self.contentScrollView addSubview:
    [self createOneLineViewWithFrame:rect3
                           leftTitle:NSLocalizedString(@"3.0_AcceptantCurrencyMin", nil)
                      rightTextField:self.currencyMinTextField
                         btnCallback:nil]];
    
    CGRect rect4 = CGRectMake(0, 46 * 3 , self.view.width, 46);
    [self.contentScrollView addSubview:
    [self createOneLineViewWithFrame:rect4
                            leftTitle:NSLocalizedString(@"3.0_OfferPricePremium", nil)
                       rightTextField:nil
                          btnCallback:nil]];

    //—
    [self.contentScrollView addSubview:self.minusBtn];
    self.minusBtn.frame = CGRectMake(self.view.width - 125, 46 * 3 + 11, 24, 24);
    self.minusBtnEx = [UIButton buttonWithType:UIButtonTypeCustom];
    self.minusBtnEx.backgroundColor = [UIColor clearColor];
    self.minusBtnEx.frame =CGRectMake(self.view.width - 136, 46 * 3, 35, 35);
    [[self.minusBtnEx rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if ([self.offerPriceLabel.text hasPrefix:@"+"]) {
            
            NSString * premium = [self.offerPriceLabel.text substringWithRange:NSMakeRange(1, self.offerPriceLabel.text.length -2)];
            if ([premium floatValue]<= -10) {
                return ;
            }else{
                [self setPremiumString:[NSString stringWithFormat:@"%.1f",([premium floatValue]  - 0.5)]];
            }
        }else{
            NSString * premium = [self.offerPriceLabel.text substringWithRange:NSMakeRange(0, self.offerPriceLabel.text.length -1)];
            if ([premium floatValue] <= -10) {
                return ;
            }else{
                [self setPremiumString:[NSString stringWithFormat:@"%.1f",([premium floatValue] - 0.5)]];
            }
        }
    }];
     [self.contentScrollView addSubview:self.minusBtnEx];
    //
    [self.contentScrollView addSubview:self.offerPriceLabel];
    self.offerPriceLabel.frame = CGRectMake(self.view.width - 101, 46 * 3 + 11, 71, 24);
    //+

    [self.contentScrollView addSubview:self.plusBtn];
    self.plusBtn.frame = CGRectMake(self.view.width - 36, 46 * 3 + 11, 24, 24);
    self.plusBtnEx= [UIButton buttonWithType:UIButtonTypeCustom];
    self.plusBtnEx.backgroundColor = [UIColor clearColor];
    self.plusBtnEx.frame =CGRectMake(self.view.width - 37, 46 * 3, 35, 35);
    
    [[self.plusBtnEx rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if ([self.offerPriceLabel.text hasPrefix:@"+"]) {
            
            NSString * premium = [self.offerPriceLabel.text substringWithRange:NSMakeRange(1, self.offerPriceLabel.text.length -2)];
            if ([premium floatValue]>=10) {
                return ;
            }else{
                [self setPremiumString:[NSString stringWithFormat:@"%.1f",([premium floatValue]  + 0.5)]];
            }
        }else{
            NSString * premium = [self.offerPriceLabel.text substringWithRange:NSMakeRange(0, self.offerPriceLabel.text.length -1)];
            if ([premium floatValue] >=10) {
                return ;
            }else{
                [self setPremiumString:[NSString stringWithFormat:@"%.1f",([premium floatValue] + 0.5)]];
            }
        }
    }];
    [self.contentScrollView addSubview:self.plusBtnEx];
    UIView * viewBack = [[UIView alloc] init];
    viewBack.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:viewBack];
    [viewBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.equalTo(self.currencyMinTextField.mas_bottom).offset(46);
    }];

    UILabel * tipView= [[UILabel alloc] init];
    tipView.numberOfLines = 0;
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.text = NSLocalizedString(@"3.0_AcceptantPremiumPriceTips", nil);
    tipView.textColor = textColor666666;
    tipView.font = textFontPingFangRegularFont(14);
    tipView.textAlignment = NSTextAlignmentLeft;
    [viewBack addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBack).offset(12);
        make.right.equalTo(viewBack).offset(-12);
        make.top.equalTo(viewBack);
        make.bottom.equalTo(viewBack).offset(-20);
    }];

    [self.contentScrollView addSubview:self.saveBtn];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScrollView).offset(12);
        make.width.mas_equalTo(SCREEN_WIDTH -24);
        make.top.equalTo(viewBack.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    RAC(self.viewModel, currency) =
    [RACObserve(self.currencyLabel, attributedText) map:^id (NSAttributedString *value) {
        return [value.string isEqualToString:NSLocalizedString(@"3.0_CurrencyTypeSwitch", nil)] ?  @"" : value;
    }];
    RAC(self.viewModel, maxValue) = self.currencyMaxTextField.rac_textSignal;
    RAC(self.viewModel, minValue) = self.currencyMinTextField.rac_textSignal;
    RAC(self.plusBtnEx,enabled)=
    RAC(self.minusBtnEx,enabled)=
    RAC(self.currencyMaxTextField, userInteractionEnabled) =
    RAC(self.currencyMinTextField, userInteractionEnabled) =
    [RACObserve(self.currencyLabel, attributedText) map:^id (NSAttributedString *value) {
        return [value.string isEqualToString:NSLocalizedString(@"3.0_CurrencyTypeSwitch", nil)] ? @(NO) : @(YES);
    }];
    RAC(self.viewModel, premiumPrice) = [RACObserve(self.offerPriceLabel, text) map:^id (NSString *value) {
        
        NSString  * premium = @"0.0";
        if (value){
            if ([value hasPrefix:@"+"]) {
                premium =  [value substringWithRange:NSMakeRange(1,value.length -2)];
            }else{
                premium =  [value substringWithRange:NSMakeRange(0,value.length -1)];
            }
        }
        return premium;
    }];
    self.currencyMaxTextField.delegate = self;
    self.currencyMinTextField.delegate = self;
    self.currencyMaxTextField.tag = 1001;
    self.currencyMinTextField.tag = 1002;
    self.currencyMaxTextField.placeholder = NSLocalizedString(@"3.0_AcceptantMaxLimitation", nil);
    self.currencyMinTextField.placeholder = NSLocalizedString(@"3.0_AcceptantMinLimitation", nil);
    [self.currencyMaxTextField setValue:textFontPingFangRegularFont(14) forKeyPath:@"_placeholderLabel.font"];
    [self.currencyMinTextField setValue:textFontPingFangRegularFont(14) forKeyPath:@"_placeholderLabel.font"];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //不允许第一个 输入 0 或者 . ,
    if ([textField.text isEqualToString:@""] && ([string isEqualToString:@","] || [string isEqualToString:@"."])) {
        return NO;
    }
    NSInteger dotNum = 1;
    if (textField.tag == 1001) {
        dotNum= 5;
    }else if (textField.tag == 1002){
        dotNum = 5;
    }
    //没有小数位
    if (dotNum == 1 &&([string isEqualToString:@","] ||[string isEqualToString:@"."] )) {
        return NO;
    }
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //处理越南语的情况
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
    //处理 - 号
    if ([textField.text containsString:@"-"]&&[string isEqualToString:@"-"]) {
        return NO;
    }
    if (textField.text.length>0&&[string isEqualToString:@"-"]) {
        return NO;
    }
    if ([string isEqualToString:@","]) {
        
        textField.text = [text stringByReplacingOccurrencesOfString:@"," withString:@"."];
        return NO;
    }
    if ([textField.text containsString:@"."]) {
        if ([string isEqualToString:@"."]) {
            return NO ;
        }else{
            if (![string isEqualToString:@""]) { //輸入
                NSRange range = [text rangeOfString:@"."];
                NSString * substr;
                if (range.location!= NSNotFound) {
                    substr = [text substringFromIndex:range.location];
                }
                if (substr.length>dotNum) {
                    return NO;
                }else{
                    return YES;
                }
                return YES;
                
            }else{ //刪除
                return YES;
            }
        }
    }else{
        return YES;
    }
}

-(void)showSelectCollectionView:(NSArray *) incons{
    
    
    [IDCMColletionTipView showWithTitle:NSLocalizedString(@"3.0_AcceptantCurrencyTypeSwitch", nil)
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
                      itemClickCallback:^(IDCMAcceptantCoinModel * model) {
                          
                          for (IDCMAcceptantCoinModel * model  in incons) {
                              model.isSelect = NO;
                          }
                          model.isSelect = YES;
                          self.viewModel.selectModel = model;
                          [self refreshCurrencyInfoWithModel:model];
                      }];
}

#pragma mark — IconWindowDelegate

- (void)refreshCurrencyInfoWithModel:(IDCMAcceptantCoinModel *)model {
    
    self.currencyMaxTitle.text =
    self.currencyMinTitle.text = model.coinCodeUpperString;
    [self.currencyMaxTitle sizeToFit];
    [self.currencyMinTitle sizeToFit];
    [self.currencyMaxTextField resignFirstResponder];
    self.currencyMaxTextField.placeholder = NSLocalizedString(@"3.0_AcceptantMaxLimitation", nil);
    self.currencyMinTextField.placeholder = NSLocalizedString(@"3.0_AcceptantMinLimitation", nil);
    self.currencyMaxTextField.text = nil;
    self.currencyMinTextField.text = nil;
    //设值
    if (model.maxAmount) {
        self.currencyMaxTextField.text =[IDCMUtilsMethod getStringFrom:model.maxAmount];
    }
    if (model.minAmount) {
        self.currencyMinTextField.text = [IDCMUtilsMethod getStringFrom:model.minAmount];
    }
    if (model.premium) {
        [self setPremiumString:model.premium];
    }
    self.currencyLabel.attributedText =
    [[NSAttributedString alloc] initWithString:model.coinCodeUpperString attributes:@{NSFontAttributeName : textFontPingFangRegularFont(14),
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
            NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:model.coinCodeUpperString];
            [textAttrStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
            [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [textAttrStr appendAttributedString:nameAttributedString];
            [textAttrStr addAttribute:NSKernAttributeName value:@(4)
                                range:NSMakeRange(0, 1)];
            [textAttrStr addAttributes:@{NSForegroundColorAttributeName : textColor333333} range:NSMakeRange(0, textAttrStr.length)];
            self.currencyLabel.attributedText = textAttrStr ;
        }
    }];
}
-(void)setPremiumString:(NSString *) str{
    if (!str)  return;
    if ([str floatValue] >0)  {
        self.offerPriceLabel.text = [NSString stringWithFormat:@"%@%@%@",@"+",str,@"%"];
         self.offerPriceLabel.textColor = textColor333333;
    }else if ([str floatValue]  == 0){
        self.offerPriceLabel.text = [NSString stringWithFormat:@"%@%@",str,@"%"];
        self.offerPriceLabel.textColor = textColor999999;
    }else{
        self.offerPriceLabel.text = [NSString stringWithFormat:@"%@%@",str,@"%"];
        self.offerPriceLabel.textColor = textColor333333;
    }
}
#pragma mark - getters and setters
- (UIScrollView *)contentScrollView {
    return SW_LAZY(_contentScrollView, ({
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.alwaysBounceVertical = YES;
        scrollView;
    }));
}

- (UIButton *)saveBtn {
    return SW_LAZY(_saveBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"3.0_Save", nil) forState:UIControlStateNormal];
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
- (UIButton *)plusBtn {
    return SW_LAZY(_plusBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setImage:[UIImage imageNamed:@"premiumPlus"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"premiumPlus"] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn;
    }));
}
- (UIButton *)minusBtn {
    return SW_LAZY(_minusBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setImage:[UIImage imageNamed:@"premiumMinus"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"premiumMinus"] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        label.text = NSLocalizedString(@"3.0_CurrencyTypeSwitch", nil);
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
        
        QMUILabel * rightView= [[QMUILabel alloc] init];
        rightView.textColor = textColor333333;
        rightView.font = textFontPingFangRegularFont(12);
        rightView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 1, 0);
        textField.rightView = rightView;
    }
    
    if (![leftTitle isEqualToString:NSLocalizedString(@"3.0_OfferPricePremium", nil)]) {
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

- (UILabel *)currencyMaxTitle {
    return (QMUILabel *)self.currencyMaxTextField.rightView;
}

- (UILabel *)currencyMinTitle {
    return (QMUILabel *)self.currencyMinTextField.rightView;
}

-(UILabel *)offerPriceLabel{
    if (!_offerPriceLabel) {
        _offerPriceLabel = [[QMUILabel alloc] init];
        _offerPriceLabel.textAlignment = NSTextAlignmentCenter;
        _offerPriceLabel.font = textFontPingFangRegularFont(14);
        _offerPriceLabel.textColor =textColor999999;
        _offerPriceLabel.text = @"0.0%";
    }
    return _offerPriceLabel;
}
@end
