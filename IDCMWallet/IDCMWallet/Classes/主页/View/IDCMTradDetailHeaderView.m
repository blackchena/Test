//
//  IDCMTradDetailHeaderView.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/21.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMTradDetailHeaderView.h"
#import "IDCMNewCurrencyTradingModel.h"

@interface IDCMTradDetailHeaderView ()
/**
 *  标题
 */
@property (strong, nonatomic) QMUIButton *coinTitle;
/**
 *  状态
 */
@property (strong, nonatomic) QMUIButton *statusLable;
/**
 *  发送地址容器
 */
@property (strong, nonatomic) UIView *sendView;
/**
 *  发送地址标题
 */
@property (strong, nonatomic) UILabel *sendAddressTitleLable;
/**
 *  发送地址
 */
@property (strong, nonatomic) UILabel *sendAddressLable;
/**
 *  接收地址容器
 */
@property (strong, nonatomic) UIView *reciveView;
/**
 *  接收地址标题
 */
@property (strong, nonatomic) UILabel *reciveAddressTitleLable;
/** 
 *  接收地址
 */
@property (strong, nonatomic) UILabel *reciveAddressLable;
/**
 *  图标
 */
@property (strong, nonatomic) UIImageView *logoView;
/**
 *  TxID标题
 */
@property (strong, nonatomic) UILabel *TxIDTitleLable;
/**
 *  TxID
 */
@property (strong, nonatomic) UILabel *TxIDLable;
/**
 *  复制ID
 */
@property (strong, nonatomic) UIButton *copyidButton;
/**
 *  区块浏览
 */
@property (strong, nonatomic) UIButton *viewButton;
/**
 *  底部view
 */
@property (strong, nonatomic) UIView *grayView;
@end

@implementation IDCMTradDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
       
        RACSignal *validCopySignal = [[RACSignal
                                       combineLatest:@[RACObserve(self.TxIDLable, text)]
                                       reduce:^(NSString *txidText) {
                                           return @(txidText.length > 0);
                                       }]
                                      distinctUntilChanged];
        
        RAC(self.copyidButton,enabled) = validCopySignal;
        RAC(self.viewButton,enabled) = validCopySignal;
        
        @weakify(self);
        // 复制Txid
        [[[self.copyidButton rac_signalForControlEvents:UIControlEventTouchUpInside]
          deliverOnMainThread]
         subscribeNext:^(__kindof UIControl * _Nullable x) {
             @strongify(self);
             
             UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
             [pasteboard setString:self.TxIDLable.text];
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_CopySuccess", nil)];
         }];
        // 区块查看
        [[[self.viewButton rac_signalForControlEvents:UIControlEventTouchUpInside]
          deliverOnMainThread]
         subscribeNext:^(__kindof UIControl * _Nullable x) {
             @strongify(self);
             if (self.dealModel.isJump && [self.dealModel.url isNotBlank] && [self.dealModel.txhash isNotBlank]) {
                 NSString *viewURL = [self.dealModel.url stringByReplacingOccurrencesOfString:@"{idcw_txid}" withString:self.dealModel.txhash];
                 if (@available(iOS 10,*)) {
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:viewURL] options:@{} completionHandler:^(BOOL success) {
                     }];
                 }else{
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:viewURL]];
                 }
             }
         }];
        
        RACSignal *detailInfoSignal = [RACObserve(self, dealModel) distinctUntilChanged];
        
       [[[detailInfoSignal deliverOnMainThread] filter:^BOOL(id  _Nullable value) {
           if (value) {
               return YES;
           }else{
               return NO;
           }
        }] subscribeNext:^(IDCMNewCurrencyTradingModel *model) {
             @strongify(self);
            
            NSInteger presion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:model.currency withType:kIDCMCurrencyPrecisionQuantity];
            
             if ([model.trade_type isEqualToNumber:@(0)]) {
                 [self.coinTitle setTitleColor:SetColor(252, 137, 104) forState:UIControlStateNormal];
                 NSString *str = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:model.amount]] fractionDigits:presion];
                 str = [IDCMUtilsMethod changeFloat:str];
                 NSString *bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
                 [self.coinTitle setTitle:[NSString stringWithFormat:@"+%@ %@",bitcoinString,[model.currency uppercaseString]] forState:UIControlStateNormal];
                 [self.coinTitle setImage:UIImageMake(@"2.1_DetailReceiveButton") forState:UIControlStateNormal];
             }else{
                 
                 NSString *bitcoinString = @"";
                 if (model.isToken) {
                     
                     NSString *str = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:model.amount]] fractionDigits:presion];
                     str = [IDCMUtilsMethod changeFloat:str];
                     bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
                 }else{
                     NSNumber *amountNum = [NSNumber numberWithDouble:[[IDCMUtilsMethod precisionControl:model.amount]  doubleValue]+[[IDCMUtilsMethod precisionControl:model.tx_fee] doubleValue]];
                     NSString *str = [NSString stringFromNumber:amountNum fractionDigits:presion];
                     str = [IDCMUtilsMethod changeFloat:str];
                     bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
                 }
                 
                 [self.coinTitle setTitleColor:SetColor(41, 104, 185) forState:UIControlStateNormal];
                 [self.coinTitle setTitle:[NSString stringWithFormat:@"-%@ %@",bitcoinString ,[model.currency uppercaseString]] forState:UIControlStateNormal];
                 [self.coinTitle setImage:UIImageMake(@"2.1_DetailSendButton") forState:UIControlStateNormal];
             }
            if (!model.txReceiptStatus) { // 是代币并且转汇异常
                
                [self.statusLable setTitle:SWLocaloziString(@"2.2.1_FailedTransfer") forState:UIControlStateNormal];
                [self.statusLable setImage:UIImageMake(@"2.2.1_zhuanhuiyichang") forState:UIControlStateNormal];
                [self.statusLable setTitleColor:SetColor(251, 48, 48) forState:UIControlStateNormal];
                
                
                
            }else{
                if ([model.confirmations integerValue] >= [model.total_confirmations integerValue]) {
                    
                    NSString *confirmations  = @"";
                    if ([model.confirmations integerValue] > 1000) {
                        confirmations  = @"1,000+";
                    }else{
                        confirmations  = [IDCMUtilsMethod separateNumberUseCommaWith:model.confirmations];
                    }
                    NSString *statusText = [NSString stringWithFormat:@"%@ (%@ %@)",SWLocaloziString(@"2.0_Complete"),confirmations,NSLocalizedString(@"2.1_Confirmed", nil)];
                    [self.statusLable setTitle:statusText forState:UIControlStateNormal];
                }else{
                    NSString *statusText = [NSString stringWithFormat:@"%@ (%@/%@ %@)",SWLocaloziString(@"2.1_Ongoing"),model.confirmations,model.total_confirmations,NSLocalizedString(@"2.1_Confirmed", nil)];
                    [self.statusLable setTitle:statusText forState:UIControlStateNormal];
                    
                }
                [self.statusLable setTitleColor:SetColor(51, 51, 51) forState:UIControlStateNormal];
                [self.statusLable setImage:nil forState:UIControlStateNormal];
                
            }
            
             self.TxIDLable.text = model.txhash;
             self.sendAddressLable.text = model.send_address;
             self.reciveAddressLable.text = model.receiver_address;
             
             [self creatView];
         }];
        
        
        [[[self.statusLable rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
         subscribeNext:^(__kindof UIControl * _Nullable x) {
             @strongify(self);
             if (!self.dealModel.txReceiptStatus) {
                 [self handleWindowShowing:self.dealModel.txhash];
             }
         }];
        
        
    }
    return self;
}
- (void)creatView
{
    
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@15);
    }];
    
    CGFloat copWidth = [NSLocalizedString(@"2.0_CopyID", nil) widthForFont:SetFont(@"PingFang-SC-Regular",12)] + 30;
    [self.copyidButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.grayView.mas_top).offset(-20);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@25);
        make.width.equalTo(@(copWidth));
    }];
    
    CGFloat viewWidth = [NSLocalizedString(@"2.1_ViewBlockchain", nil) widthForFont:SetFont(@"PingFang-SC-Regular",12)] + 30;
    [self.viewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.grayView.mas_top).offset(-20);
        make.right.equalTo(self.copyidButton.mas_left).offset(-15);
        make.height.equalTo(@25);
        make.width.equalTo(@(viewWidth));
    }];
    
    [self.TxIDTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.copyidButton.mas_top).offset(-28);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@17);
        make.width.equalTo(@50);
    }];
    
    [self.TxIDLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.copyidButton.mas_top).offset(-12);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@35);
        make.left.equalTo(self.TxIDTitleLable.mas_right).offset(15);
    }];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@90);
        make.width.equalTo(@40);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.TxIDLable.mas_top).offset(-20);
    }];
    
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.logoView.mas_left);
        make.height.equalTo(@90);
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(self.TxIDLable.mas_top).offset(-20);
    }];
    
    [self.sendAddressTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.sendView.mas_centerX);
        make.top.equalTo(self.sendView.mas_top).offset(10);
    }];
    
    [self.sendAddressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.bottom.equalTo(self.sendView.mas_bottom);
        make.centerX.equalTo(self.sendView.mas_centerX);
        make.top.equalTo(self.sendAddressTitleLable.mas_bottom).offset(2);
    }];
    
    [self.reciveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoView.mas_right);
        make.height.equalTo(@90);
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(self.TxIDLable.mas_top).offset(-20);
    }];
    
    [self.reciveAddressTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.reciveView.mas_centerX);
        make.top.equalTo(self.reciveView.mas_top).offset(10);
    }];
    
    [self.reciveAddressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.bottom.equalTo(self.reciveView.mas_bottom);
        make.centerX.equalTo(self.reciveView.mas_centerX);
        make.top.equalTo(self.reciveAddressTitleLable.mas_bottom).offset(2);
    }];

    [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.bottom.equalTo(self.sendView.mas_top).offset(-16);
        make.left.right.equalTo(self);
    }];
    
    [self.coinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.bottom.equalTo(self.statusLable.mas_top).offset(-8);
        make.left.right.equalTo(self);
    }];
    
}

- (void)handleWindowShowing:(NSString *)txHash
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.modal = YES;
    
    @weakify(modalViewController);
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        @strongify(modalViewController);
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(modalViewController.view).offset(12);
            make.center.equalTo(modalViewController.view);
        }];
    };
    [modalViewController showWithAnimated:YES completion:nil];
    
    
    UILabel *titleLable = [UILabel new];
    titleLable.text = SWLocaloziString(@"2.2.1_WhyFailed");
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = textColor333333;
    titleLable.font = textFontPingFangRegularFont(14);
    [contentView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).offset(22);
    }];
    
    UILabel *causeLabel = [UILabel new];
    causeLabel.text = SWLocaloziString(@"2.2.1_GeneralCause");
    causeLabel.textAlignment = NSTextAlignmentLeft;
    causeLabel.textColor = textColor333333;
    causeLabel.font = textFontPingFangRegularFont(14);
    causeLabel.numberOfLines = 0;
    [contentView addSubview:causeLabel];
    [causeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-16);
        make.left.equalTo(contentView).offset(16);
        make.top.equalTo(titleLable.mas_bottom).offset(16);
    }];
    
    UILabel *linkLabel = [UILabel new];
    linkLabel.userInteractionEnabled = YES;
    linkLabel.text = [NSString stringWithFormat:@"https://etherscan.io/tx/%@",txHash];
    linkLabel.textAlignment = NSTextAlignmentLeft;
    linkLabel.textColor = textColor333333;
    linkLabel.font = textFontPingFangRegularFont(12);
    linkLabel.numberOfLines = 0;
    linkLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [contentView addSubview:linkLabel];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:linkLabel.text];
    [attrStr addAttribute:NSLinkAttributeName value:[NSURL URLWithString:linkLabel.text] range:NSMakeRange(0,attrStr.length)];
    linkLabel.attributedText = attrStr;
    
    @weakify(linkLabel);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(linkLabel);
        if (@available(iOS 10,*)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkLabel.text] options:@{} completionHandler:^(BOOL success) {
            }];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkLabel.text]];
        }
    }];
    [linkLabel addGestureRecognizer:tap];
    
    
    [linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-16);
        make.left.equalTo(contentView).offset(16);
        make.top.equalTo(causeLabel.mas_bottom).offset(16);
        make.bottom.equalTo(contentView).offset(-22);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH-80, 10, 40, 40);
    [button setImage:UIImageMake(@"2.2.1_CloseButtonImage") forState:UIControlStateNormal];
    [contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-16);
        make.centerY.equalTo(titleLable);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [[[button rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(modalViewController);
         [modalViewController hideWithAnimated:YES completion:nil];
     }];
    
    
}
#pragma mark - getter
- (QMUIButton *)coinTitle
{
    return SW_LAZY(_coinTitle, ({
        QMUIButton *button = [[QMUIButton alloc] init];
        button.titleLabel.font = SetFont(@"PingFang-SC-Medium",20);
        button.adjustsImageWhenHighlighted = NO;
        button.adjustsButtonWhenHighlighted = NO;
        button.spacingBetweenImageAndTitle = 6;
        button.imagePosition = QMUIButtonImagePositionLeft;
        [self addSubview:button];
        button;
    }));
}
- (QMUIButton *)statusLable
{
    return SW_LAZY(_statusLable, ({
        QMUIButton *button = [[QMUIButton alloc] init];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular",14);
        [button setTitleColor:SetColor(51, 51, 51) forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        button.adjustsButtonWhenHighlighted = NO;
        button.spacingBetweenImageAndTitle = 3;
        button.imagePosition = QMUIButtonImagePositionRight;
        [self addSubview:button];
        button;
    }));
}
- (UIView *)sendView
{
    return SW_LAZY(_sendView, ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = kThemeColor.CGColor;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = 4;
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)sendAddressTitleLable
{
    return SW_LAZY(_sendAddressTitleLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Regular",12);
        view.text = NSLocalizedString(@"2.0_SendAddress", nil);
        view.textAlignment = NSTextAlignmentCenter;
        [self.sendView addSubview:view];
        view;
    }));
}
- (UILabel *)sendAddressLable
{
    return SW_LAZY(_sendAddressLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(102, 102, 102);
        view.font = SetFont(@"PingFang-SC-Regular",12);
        view.textAlignment = NSTextAlignmentCenter;
        view.numberOfLines = 0;
        [self.sendView addSubview:view];
        view;
    }));
}
- (UIView *)reciveView
{
    return SW_LAZY(_reciveView, ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = kThemeColor.CGColor;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = 4;
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)reciveAddressTitleLable
{
    return SW_LAZY(_reciveAddressTitleLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Regular",12);
        view.text = NSLocalizedString(@"2.0_ReciveAddress", nil);
        view.textAlignment = NSTextAlignmentCenter;
        [self.reciveView addSubview:view];
        view;
    }));
}
- (UILabel *)reciveAddressLable
{
    return SW_LAZY(_reciveAddressLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(102, 102, 102);
        view.font = SetFont(@"PingFang-SC-Regular",12);
        view.textAlignment = NSTextAlignmentCenter;
        view.numberOfLines = 0;
        [self.reciveView addSubview:view];
        view;
    }));
}
- (UIImageView *)logoView
{
    return SW_LAZY(_logoView, ({
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.image = [UIImage imageNamed:@"2.0_xiaofeiji"];
        view.clipsToBounds = YES;
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)TxIDTitleLable
{
    return SW_LAZY(_TxIDTitleLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(102, 102, 102);
        view.font = SetFont(@"PingFang-SC-Regular",14);
        view.textAlignment = NSTextAlignmentLeft;
        view.text = @"TxID";
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)TxIDLable
{
    return SW_LAZY(_TxIDLable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Regular",12);
        view.textAlignment = NSTextAlignmentRight;
        view.text = @"";
        view.numberOfLines = 0;
        [self addSubview:view];
        view;
    }));
}
- (UIButton *)copyidButton
{
    return SW_LAZY(_copyidButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"2.0_CopyID", nil) forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular",12);
        button.layer.cornerRadius = 2;
        button.layer.borderWidth = 1;
        button.layer.borderColor = kThemeColor.CGColor;
        [self addSubview:button];
        button;
    }));
}
- (UIButton *)viewButton
{
    return SW_LAZY(_viewButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"2.1_ViewBlockchain", nil) forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular",12);
        button.layer.cornerRadius = 2;
        button.layer.borderWidth = 1;
        button.layer.borderColor = kThemeColor.CGColor;
        [self addSubview:button];
        button;
    }));
}
- (UIView *)grayView
{
    return SW_LAZY(_grayView, ({
        UIView *view  = [UIView new];
        view.backgroundColor = SetColor(245, 247, 249);
        [self addSubview:view];
        view;
    }));
}
@end
