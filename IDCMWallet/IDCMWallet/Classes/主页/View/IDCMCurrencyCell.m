//
//  IDCMCurrencyCell.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMCurrencyCell.h"
#import "IDCMCurrencyMarketModel.h"


@interface IDCMCurrencyCell ()
/**
 *  容器
 */
@property (strong, nonatomic) UIView *containerView;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoView;
/**
 *  价格
 */
@property (strong, nonatomic) UILabel *numLabel;
/**
 *  对应的法币
 */
@property (strong, nonatomic) UILabel *amountLabel;

@end

@implementation IDCMCurrencyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self creatLayoutSubviews];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted == YES) {
        // 选中时候的样式
        self.containerView.backgroundColor = SetColor(231, 235, 239);
        
    } else {
        // 未选中时候的样式
        self.containerView.backgroundColor = [UIColor whiteColor];
    }
}
- (void)creatLayoutSubviews
{
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self.contentView.mas_top).offset(4);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
    }];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.left.equalTo(self.containerView.mas_left).offset(9);
        make.width.height.equalTo(@38);
        
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.left.equalTo(self.logoView.mas_right).offset(8);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@60);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(4);
        make.right.equalTo(self.containerView.mas_right).offset(-9);
        make.height.equalTo(@25);
        make.width.greaterThanOrEqualTo(@300);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-6);
        make.right.equalTo(self.containerView.mas_right).offset(-9);
        make.height.equalTo(@18);
        make.width.greaterThanOrEqualTo(@300);
    }];
    
}

- (void)bindViewModel:(id)viewModel{
    
    IDCMCurrencyMarketModel *makketModel = viewModel;
    
    // logo
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:makketModel.logo_url] placeholderImage:nil options:SDWebImageRefreshCached];
    // 币种名称
    self.titleLabel.text = [makketModel.currency_unit uppercaseString];
    // 余额
    NSString *blanceNum = [IDCMUtilsMethod precisionControl:makketModel.realityBalance];
    NSInteger currencyPresion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:makketModel.currency_unit withType:kIDCMCurrencyPrecisionQuantity];
    NSString *realityBalance = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:blanceNum] fractionDigits:currencyPresion];
    NSString *bitcoinStr = [IDCMUtilsMethod separateNumberUseCommaWith:realityBalance];
    self.numLabel.text = bitcoinStr;
    // 金额对应的法币
    double totalAmout = [makketModel.realityBalance doubleValue] * [makketModel.localCurrencyMarket doubleValue];
    NSInteger coinPresion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:makketModel.currency_unit withType:kIDCMCurrencyPrecisionMoney];
    NSString  *money = [NSString stringFromNumber:[NSNumber numberWithDouble:totalAmout] fractionDigits:coinPresion];
    NSString *preamoutStr = [IDCMUtilsMethod separateNumberUseCommaWith:money];
    self.amountLabel.text = [NSString idcw_stringWithFormat:@"≈ %@%@",makketModel.currencySymbol,preamoutStr];
}
#pragma mark - getter
- (UIView *)containerView
{
    return SW_LAZY(_containerView, ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = SetColor(225, 231, 255).CGColor;
        view.layer.borderWidth= 0.5;
        view.layer.cornerRadius = 5;
        view.layer.shadowOpacity = 1;// 阴影透明度
        view.layer.shadowColor = SetColor(204, 215, 241).CGColor;// 阴影的颜色
        view.layer.shadowRadius = 2;// 阴影扩散的范围控制
        view.layer.shadowOffset = CGSizeMake(0, 1);// 阴影的范围
        [self.contentView addSubview:view];
        view;
    }));
}
- (UILabel *)titleLabel{
    return SW_LAZY(_titleLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Medium", 14);
        lable.textColor = SetColor(51, 51, 51);
        lable.textAlignment = NSTextAlignmentLeft;
        [self.containerView addSubview:lable];
        lable;
    }));
}

- (UIImageView *)logoView
{
    return SW_LAZY(_logoView, ({
        
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        [self.containerView addSubview:view];
        view;
    }));
}
- (UILabel *)numLabel
{
    return SW_LAZY(_numLabel, ({
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Medium", 14);
        lable.textAlignment = NSTextAlignmentRight;
        lable.textColor = SetColor(51, 51, 51);
        [self.containerView addSubview:lable];
        lable;
    }));
}
- (UILabel *)amountLabel
{
    return SW_LAZY(_amountLabel, ({
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Regular", 14);
        lable.textAlignment = NSTextAlignmentRight;
        lable.textColor = SetColor(168, 172, 177);
        [self.containerView addSubview:lable];
        lable;
    }));
}
@end
