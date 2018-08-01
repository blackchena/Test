//
//  IDCMAcceptantApplyAddPayCurrencyController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyAddPayCurrencyController.h"
#import "IDCMAcceptantApplyAddPayCurrencyViewModel.h"
#import "IDCMLocalCurrencyModel.h"
#import "IDCMBTypeCollectionViewCell.h"

@interface IDCMAcceptantApplyAddPayCurrencyController ()<QMUITextFieldDelegate>
@property (nonatomic,strong) IDCMAcceptantApplyAddPayCurrencyViewModel *viewModel;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) UILabel *currencyLabel;
@property (nonatomic,strong) QMUITextField *currencyCountTextField;
@property (nonatomic,strong) QMUILabel *currencyCountTitle;
@property (nonatomic,strong) UIButton *saveBtn;
@end


@implementation IDCMAcceptantApplyAddPayCurrencyController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
    [self requestCurrencyList];
}

#pragma mark — supper method
- (void)bindViewModel {
    [super bindViewModel];
    self.saveBtn.rac_command = self.viewModel.saveCommand;
    @weakify(self);
    [[self.viewModel.getOtcLocalCurrencyListCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(NSDictionary *  response) {
         @strongify(self);
         if (self.viewModel.pageType == EditCurrencyTypeAndAmount) {
             //设置
             IDCMLocalCurrencyModel * model = [[IDCMLocalCurrencyModel alloc ] init];
             model.localCurrencyCode = self.viewModel.editDict[@"LocalCurrencyId"];
             model.currencyAmount = self.viewModel.editDict[@"Amount"];
             for (NSInteger i=0; i<self.viewModel.currencysList.count; i++) {
                 //找到名称相同的model 置为选中状态
                 IDCMLocalCurrencyModel * temp = self.viewModel.currencysList[i];
                 if ([temp.localCurrencyCode isEqualToString:self.viewModel.editDict[@"localCurrencyCode"]]) {
                     temp.isSelect = YES;
                     model.currencyLogo = temp.currencyLogo;
                 }
             }
             //刷新页面
             self.viewModel.selectModel  = model;
             [self refreshCurrencyInfoWithModel:model];
         }
     }];
    //保存成功
    [[self.viewModel.saveCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(NSDictionary *  response) {
         @strongify(self);
         NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
         if ([status isEqual:@"1"] && [response[@"data"] isKindOfClass:[NSNumber class]] && [response[@"data"] boolValue]) {
             [self.navigationController popViewControllerAnimated:YES];
             if (self.completion) {
                 self.completion(nil);
             }
         }else{
             
             //保存失败
             
         }
     }];
}
//请求币种列表
-(void)requestCurrencyList{
    [self.viewModel.getOtcLocalCurrencyListCommand execute:nil];
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
    self.currencyLabel = [[UILabel alloc] init];
    CGRect rect1 = CGRectMake(0, 0, self.view.width, 46);
    [self.contentScrollView addSubview:
     [self createOneLineViewWithFrame:rect1
                            leftTitle:NSLocalizedString(@"3.0_CurrencyType", nil)
                       rightTextField:self.currencyLabel
                          btnCallback:^(UIButton *btn) {
                              
                              @strongify(self);
                              [self.view endEditing:YES];
                              if (self.viewModel.pageType != EditCurrencyTypeAndAmount) {
                                  [self showSelectCollectionView:self.viewModel.currencysList];
                              }
                          }]];
    
    self.currencyCountTextField = [[QMUITextField alloc] init];
    CGRect rect2 = CGRectMake(0, 46 , self.view.width, 46);
    [self.contentScrollView addSubview:
     [self createOneLineViewWithFrame:rect2
                            leftTitle:NSLocalizedString(@"3.0_CurrencyCount", nil)
                       rightTextField:self.currencyCountTextField
                          btnCallback:nil]];
    
    self.currencyCountTextField.placeholder =NSLocalizedString(@"3.0_AcceptantInputCurrencyAmount", nil);
    [self.contentScrollView addSubview:self.saveBtn];
    
    
    RAC(self.viewModel, currency) =
    [RACObserve(self.currencyLabel, attributedText) map:^id (NSAttributedString *value) {
        return [value.string isEqualToString:NSLocalizedString(@"3.0_CurrencyTypeSwith", nil)] ?  @"" : value;
    }];
    RAC(self.viewModel, amountValue) = self.currencyCountTextField.rac_textSignal;
    
    RAC(self.currencyCountTextField, userInteractionEnabled) =
    [RACObserve(self.currencyLabel, attributedText) map:^id (NSAttributedString *value) {
        return [value.string isEqualToString:NSLocalizedString(@"3.0_CurrencyTypeSwith", nil)] ? @(NO) : @(YES);
    }];
    self.currencyCountTextField.delegate = self;
    [self.currencyCountTextField setValue:textFontPingFangRegularFont(14) forKeyPath:@"_placeholderLabel.font"];
}

-(void)showSelectCollectionView:(NSArray *) incons{

    [IDCMColletionTipView showWithTitle:NSLocalizedString(@"3.0_CurrencyTypeSwith", nil)
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
                      itemClickCallback:^(IDCMLocalCurrencyModel * model) {
                        
                          for (IDCMLocalCurrencyModel * model  in incons) {
                              model.isSelect = NO;
                          }
                          model.isSelect = YES;
                          self.viewModel.selectModel = model;
                          [self refreshCurrencyInfoWithModel:model];
                      }];
}

#pragma mark — IconWindowDelegate

- (void)refreshCurrencyInfoWithModel:(IDCMLocalCurrencyModel *)model {
    
    self.viewModel.selectCurrency = model.localCurrencyCodeUpperString;
    self.currencyCountTitle.text = model.localCurrencyCodeUpperString;
    [self.currencyCountTitle sizeToFit];
    [self.currencyCountTextField resignFirstResponder];
    //设值
    self.currencyCountTextField.text = nil;
    if (model.currencyAmount) {
        self.currencyCountTextField.text = model.currencyAmount.stringValue;
    }
    self.currencyLabel.attributedText =
    [[NSAttributedString alloc] initWithString:model.localCurrencyCodeUpperString attributes:@{NSFontAttributeName : textFontPingFangRegularFont(14),
                                                                        NSForegroundColorAttributeName : textColor333333}];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
    [manager loadImageWithURL:[NSURL URLWithString:model.currencyLogo] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        //回调从新设置
        if (image) {
            NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = image;
            attachment.bounds = CGRectMake(0, -6.5, 24, 24);
            NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:model.localCurrencyCodeUpperString];
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
#pragma mark - textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //不允许第一个 或者 . ,
    if (![string isEqualToString:@""] && textField.text.length>14) {
        return NO;
    }
    if ([textField.text isEqualToString:@""] && ([string isEqualToString:@","] || [string isEqualToString:@"."])) {
        return NO;
    }
    NSInteger dotNum = 3;
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
#pragma mark - getters and setters
- (UIScrollView *)contentScrollView {
    return SW_LAZY(_contentScrollView, ({
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.alwaysBounceVertical = YES;
        scrollView.frame = self.view.bounds;
        scrollView;
    }));
}

- (UIButton *)saveBtn {
    return SW_LAZY(_saveBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.view.width - 24;
        btn.height = 40;
        btn.top = 113;
        btn.left = 12;
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

- (UIView *)createOneLineViewWithFrame:(CGRect)frame
                             leftTitle:(NSString *)leftTitle
                        rightTextField:(UIView *)rightTextField
                           btnCallback:(void(^)(UIButton *btn))btnCallback {
    
    UIView *view = [[UIView alloc] init];
    view.frame = frame;
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.textColor = textColor333333;
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
        label.text = NSLocalizedString(@"3.0_CurrencyTypeSwith", nil);
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
        textField.keyboardType =  UIKeyboardTypeNumberPad;
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
    
    if ([leftTitle isEqualToString:NSLocalizedString(@"3.0_CurrencyType", nil)]) {
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
