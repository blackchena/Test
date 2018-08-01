//
//  IDCMHomeAmountView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/18.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMHomeAmountView.h"
#import "IDCMAmountModel.h"

@interface IDCMHomeAmountView ()
/**
 *  增加币种
 */
@property (strong, nonatomic) UIButton *addCoin;
/**
 *  资产标题
 */
@property (strong, nonatomic) UILabel *amountLabel;
/**
 *  资产
 */
@property (strong, nonatomic) UILabel *amount;
@end

@implementation IDCMHomeAmountView
#pragma mark - Life Cycle
+ (instancetype)bondSureViewWithAmountInput:(RACSignal *)amountSignal
                             addCoinCommand:(CommandInputBlock)addCoinCommand{
    
    IDCMHomeAmountView *view = [[self alloc] init];
    view.backgroundColor = kThemeColor;
    view.addCoin.rac_command = RACCommand.emptyCommand(addCoinCommand);
    @weakify(view);
    [amountSignal subscribeNext:^(NSDictionary *dic) {
        @strongify(view);
        IDCMAmountModel *amountModel = [IDCMAmountModel yy_modelWithDictionary:dic];
        
        // 总资产标题
        view.amountLabel.text = [NSString stringWithFormat:@"%@ (%@)",NSLocalizedString(@"2.0_Amount", nil),amountModel.localCurrency];
        
        // 总资产
        NSString *amountNum = [IDCMUtilsMethod precisionControl:amountModel.totalAssetMoney];
        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amountNum];
        NSInteger presion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:nil withType:kIDCMCurrencyPrecisionTotalAssets];
        NSString *preStr = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringFromNumber:num fractionDigits:presion]];
        view.amount.text = [NSString stringWithFormat:@"%@ %@",amountModel.currencySymbol ,preStr];
        [view changeAttributedFontWithLabel:view.amount withFont:SetFont(@"PingFang-SC-Medium", 14) with:NSMakeRange(0, amountModel.currencySymbol.length)];
        
    }];
    
    return view;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.addCoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-9);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.width.equalTo(@22);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-9);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.greaterThanOrEqualTo(@(30));
        make.height.equalTo(@20);
    }];
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-9);
        make.left.equalTo(self.amountLabel.mas_right).offset(6);
        make.right.equalTo(self.addCoin.mas_left);
        make.height.equalTo(@25);
    }];
}

#pragma mark - Action
- (void)changeAttributedFontWithLabel:(UILabel *)label withFont:(UIFont *)font with:(NSRange)range
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attrStr addAttribute:NSFontAttributeName value:font range:range];
    label.attributedText = attrStr;
}

#pragma mark - Getter & Setter
- (UIButton *)addCoin
{
    return SW_LAZY(_addCoin, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIImageMake(@"2.0_addCoinButton") forState:UIControlStateNormal];
        [self addSubview:button];
        button;
    }));
}
- (UILabel *)amountLabel
{
    return SW_LAZY(_amountLabel, ({
        UILabel *view = [UILabel new];
        view.textColor = SetAColor(255, 255, 255, 0.8);
        view.font = SetFont(@"PingFang-SC-Regular", 12);
        view.text = SWLocaloziString(@"");
        [self addSubview:view];
        view;
    }));
}
- (UILabel *)amount
{
    return SW_LAZY(_amount, ({
        UILabel *view = [UILabel new];
        view.textColor = UIColorWhite;
        view.font = SetFont(@"PingFang-SC-Medium", 18);
        [self addSubview:view];
        view;
    }));
}
@end
