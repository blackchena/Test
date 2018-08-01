//
//  IDCMNewCurrencyTradingCell.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/28.
//  Copyright © 2018年 IDCM. All rights reserved.
//


#import "IDCMNewCurrencyTradingCell.h"
#import "IDCMNewCurrencyTradingModel.h"


@interface IDCMNewCurrencyTradingCell ()
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *typeButton;
@property (nonatomic,strong) UILabel *currencyLabel;
@property (nonatomic,strong) UILabel *fromLabel;
@property (nonatomic,strong) UILabel *currencyNumberLabel;
@property (nonatomic,strong) UILabel *preogressLabel;
@property (nonatomic,strong) IDCMNewCurrencyTradingModel *cellViewModel;
@end


@implementation IDCMNewCurrencyTradingCell
@dynamic cellViewModel;

- (void)initConfig {
    [super initConfig];
    self.contentView.backgroundColor = viewBackgroundColor;
    self.customSubViewsArray = @[self.topView,
                                 self.bottomView];
}

- (void)reloadCellData {
    
    IDCMNewCurrencyTradingModel *model = self.cellViewModel;
    
    NSString *currency = @"";
    UIColor *textColor = nil;
    NSString *currencyNumber = nil;
    NSString *from = nil;
    
    NSInteger presion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:model.currency withType:kIDCMCurrencyPrecisionQuantity];
    
    if ([model.trade_type isEqualToNumber:@(1)]){
        NSString *str = @"";
        NSString *bitcoinString = @"";
        if (model.isToken) {
            
            str = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:model.amount]] fractionDigits:presion];
            str = [IDCMUtilsMethod changeFloat:str];
            bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
        }else{
            NSNumber *amountNum = [NSNumber numberWithDouble:[[IDCMUtilsMethod precisionControl:model.amount]  doubleValue]+[[IDCMUtilsMethod precisionControl:model.tx_fee] doubleValue]];
            str = [NSString stringFromNumber:amountNum fractionDigits:presion];
            str = [IDCMUtilsMethod changeFloat:str];
            bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
        }
        
        currency = [NSString stringWithFormat:@"%@ %@",bitcoinString,[model.currency uppercaseString]];;
        // 发送
        currency = [NSString stringWithFormat:@"-%@",currency];
        textColor = UIColorFromRGB(0x2968B9);
        currencyNumber = [self changeEncryptStringWithStar:model.receiver_address];
        from =  NSLocalizedString(@"2.0_Send", nil);
        
    } else {
        
        NSString *str = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:model.amount]] fractionDigits:presion];
        str = [IDCMUtilsMethod changeFloat:str];
        NSString *bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
        currency = [NSString stringWithFormat:@"%@ %@",bitcoinString,[model.currency uppercaseString]];
        
        currency = [NSString stringWithFormat:@"+%@",currency];
        textColor = UIColorFromRGB(0xFC8968);
        currencyNumber = [self changeEncryptStringWithStar:model.send_address];
        from = NSLocalizedString(@"2.0_From", nil);
    }
    
    //时间
    self.timeLabel.text  = model.customerTime;
    //币种的金额
    self.currencyLabel.text = currency;
    self.currencyLabel.textColor  = textColor;
    //交易序列号
    self.currencyNumberLabel.text = currencyNumber;
    //来自
    self.fromLabel.text = from;
    //状态
    [self configStatusLabel:model andType:model.trade_type.integerValue];
    //发送还是接收
    self.typeButton.selected = ![model.trade_type isEqualToNumber:@(1)];
}

- (void)configStatusLabel:(IDCMNewCurrencyTradingModel *)model andType:(NSInteger)type {
    //设置颜色
    NSString *statusString = nil;
    NSString *confirmations  = @"";
    if ([model.confirmations integerValue] > 1000) {
        confirmations  = @"1,000+";
    }else{
        confirmations  = [IDCMUtilsMethod separateNumberUseCommaWith:model.confirmations];
    }
    if ([model.confirmations integerValue] >= [model.total_confirmations integerValue]) {
        statusString = [NSString stringWithFormat:@"%@ (%@ %@)",SWLocaloziString(@"2.0_Complete"),confirmations,NSLocalizedString(@"2.1_Confirmed", nil)];
    }else {
        statusString = [NSString stringWithFormat:@"%@ (%@/%@ %@)",SWLocaloziString(@"2.1_Ongoing"),model.confirmations,model.total_confirmations,NSLocalizedString(@"2.1_Confirmed", nil)];
    }
    if (model.txReceiptStatus) {
        self.preogressLabel.text = statusString;
        self.preogressLabel.textColor = textColor333333;
    }else{
        self.preogressLabel.text = SWLocaloziString(@"2.2.1_FailedTransfer");
        self.preogressLabel.textColor = SetColor(253, 104, 104);
    }
}

- (NSString *)changeEncryptStringWithStar:(NSString *)encryptStr {
    if (encryptStr.length < 15) {
        return nil;
    }
    NSString *front = [encryptStr substringWithRange:NSMakeRange(0, 15)];
    NSString *back = [encryptStr substringWithRange:NSMakeRange(encryptStr.length - 5, 5)];
    return  [NSString stringWithFormat:@"%@...%@",front,back];
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    if (highlighted == YES) {
//        // 选中时候的样式
//        self.contentView.backgroundColor = SetColor(231, 235, 239);
//    } else {
//        // 未选中时候的样式
//        self.contentView.backgroundColor = [UIColor redColor];
//    }
//}

- (UIView *)topView {
    if (!_topView){
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 30);
        [_topView addSubview:self.timeLabel];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xdddddd);
        line.width = _topView.width;
        line.height = 0.5;
        line.bottom = _topView.height;
        [_topView addSubview:line];
    }
    return _topView;
}

- (UILabel *)timeLabel {
    return SW_LAZY(_timeLabel   , ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor666666;
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentLeft;
        label.height = _topView.height;
        label.width = _topView.width - 24;
        label.top = 0;
        label.left = 12;
        label;
    }));
}

- (UIView *)bottomView {
    if (!_bottomView){
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColorWhite;
        _bottomView.frame = CGRectMake(0, self.topView.bottom, self.topView.width, 90);
        
        [_bottomView addSubview:self.typeButton];
        [_bottomView addSubview:self.currencyLabel];
        
        RACTuple *tupleOne = [self createOneLineView];
        self.fromLabel = tupleOne.first;
        self.currencyNumberLabel = tupleOne.last;
        self.fromLabel.top = self.currencyNumberLabel.top = self.typeButton.bottom + 3;
        [_bottomView addSubview:self.fromLabel];
        [_bottomView addSubview:self.currencyNumberLabel];
        
        RACTuple *tupleTwo = [self createOneLineView];
        UILabel *stateLabel = tupleTwo.first;
        stateLabel.text = SWLocaloziString(@"2.0_Status");
        self.preogressLabel = tupleTwo.last;
        stateLabel.top = self.preogressLabel.top = self.fromLabel.bottom + 3;
        [_bottomView addSubview:stateLabel];
        [_bottomView addSubview:self.preogressLabel];
    }
    return _bottomView;
}

- (UIButton *)typeButton {
    return SW_LAZY(_typeButton, ({
        UIButton *btn =
        [UIButton creatCustomButtonNormalStateWithTitile:SWLocaloziString(@"2.0_SendRecordButton")
                                               titleFont:textFontPingFangRegularFont(12)
                                              titleColor:UIColorFromRGB(0x2968B9)
                                            butttonImage:[UIImage imageNamed:@"2.1_sender_btn_icon"]
                                         backgroundImage:nil
                                         backgroundColor:nil
                                        clickThingTarget:nil
                                                  action:nil];
        btn.userInteractionEnabled = NO;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setImage:[UIImage imageNamed:@"2.1_recieve_btn_icon"] forState:UIControlStateSelected];
        [btn setTitle:SWLocaloziString(@"2.0_ReciveRecordButton") forState:UIControlStateSelected];
        [btn setTitleColor:UIColorFromRGB(0xFC8968) forState:UIControlStateSelected];
        btn.width = 80;
        btn.height = 30;
        btn.top = 3;
        btn.left = 12;
        btn;
    }));
}

- (UILabel *)currencyLabel {
    return SW_LAZY(_currencyLabel, ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0xFC8968);
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.height = 20;
        label.width = _bottomView.width - self.typeButton.right - 12;
        label.right = _bottomView.width - 12;
        label.centerY = self.typeButton.centerY;
        label;
    }));
}

- (RACTuple *)createOneLineView {
    UILabel *LeftLabel = [[UILabel alloc] init];
    LeftLabel.font = textFontPingFangRegularFont(12);
    LeftLabel.textColor = textColor999999;
    LeftLabel.textAlignment = NSTextAlignmentLeft;
    LeftLabel.height = 20;
    LeftLabel.width = self.typeButton.width;
    LeftLabel.left = self.typeButton.left;
        
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.font = textFontPingFangRegularFont(12);
    rightLabel.textColor = textColor333333;
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.height = LeftLabel.height;
    rightLabel.width = self.currencyLabel.width;
    rightLabel.right = self.currencyLabel.right;
    return RACTuplePack(LeftLabel, rightLabel);
}

@end



























