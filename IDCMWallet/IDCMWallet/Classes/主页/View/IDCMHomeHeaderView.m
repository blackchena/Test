//
//  IDCMHomeHeaderView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMHomeHeaderView.h"
#import "IDCMAmountModel.h"
#import "IDCMNewsModel.h"
#import "IDCMHomeChartView.h"
#import "IDCMHistoryAssetModel.h"
#import "IDCMAssetListModel.h"

@interface IDCMHomeHeaderView ()
/**
 *  顶部view
 */
@property (strong, nonatomic) UIView *topView;
/**
 *  横幅view
 */
@property (strong, nonatomic) UIView *marqueeView;
/**
 *  横幅图标
 */
@property (strong, nonatomic) UIImageView *marqueeLogo;
/**
 *  关闭横幅
 */
@property (strong, nonatomic) UIButton *closeMarquee;

/**
 *  总资产标题
 */
@property (strong, nonatomic) UILabel *amountLabel;
/**
 *  资产
 */
@property (strong, nonatomic) UILabel *amount;
/**
 *  资产涨幅
 */
@property (strong, nonatomic) UILabel *amountIncrease;
/**
 *  涨幅图标
 */
@property (strong, nonatomic) UIImageView *increaseLoge;
/**
 *  价格走势
 */
@property (strong, nonatomic) UIView *trendView;
/**
 *  曲线图
 */
@property (strong, nonatomic) IDCMHomeChartView *chartView;
@end

@implementation IDCMHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        @weakify(self);
        // 添加数字币种
        [[[self.addCoin rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
         subscribeNext:^(__kindof UIControl * _Nullable x) {


             [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMCurrencyPageController" withViewModelName:@"IDCMCurrencyPageViewModel" withParams:nil];
         }];
        // 关闭按钮
        [[[self.closeMarquee rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
         subscribeNext:^(__kindof UIControl * _Nullable x) {
             @strongify(self);
             if (self.marqueeDismissBlock) {
                 self.marqueeDismissBlock(IDCMMarqueeDismissClose);
             }
         }];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.isShowLabel) {
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(210);
        }];
    }else{
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(170);
        }];
    }

    if (self.isShowLabel) {
        self.marqueeView.hidden = NO;
        [self.marqueeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_top);
            make.left.right.equalTo(self);
            make.height.equalTo(@40);
        }];
        [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.marqueeView.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(-12);
            make.height.equalTo(@20);
        }];
        [self.marqueeLogo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.marqueeView.mas_centerY);
            make.left.equalTo(self.marqueeView.mas_left).offset(12);
            make.width.height.equalTo(@16);
        }];
        [self.closeMarquee mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.marqueeView.mas_centerY);
            make.right.equalTo(self.marqueeView.mas_right).offset(-10);
            make.width.height.equalTo(@25);
        }];
    }else{
        self.marqueeView.hidden = YES;
        [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_top).offset(5);
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(-12);
            make.height.equalTo(@20);
        }];
    }
    
    [self.amount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountLabel.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@30);
    }];
    [self.increaseLoge mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amount.mas_bottom).offset(5);
        make.left.equalTo(self.mas_left).offset(12);
        make.height.equalTo(@10);
        make.width.equalTo(@8);
    }];
    [self.chartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.height.equalTo(@160);
    }];
    [self.addCoin mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.increaseLoge.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.width.equalTo(@22);
    }];
}
- (void)setNewsModel:(IDCMNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    for (UIView *view in self.marqueeView.subviews) {
        if ([view isKindOfClass:[QMUIMarqueeLabel class]]) {
            [view removeFromSuperview];
        }
    }
    QMUIMarqueeLabel *lable = [[QMUIMarqueeLabel alloc] init];
    lable.textColor = UIColorWhite;
    lable.font = textFontPingFangRegularFont(12);
    lable.textAlignment = NSTextAlignmentLeft;
    lable.shouldFadeAtEdge = NO;
    lable.userInteractionEnabled = YES;
    [self.marqueeView addSubview:lable];
    // 点击横幅
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.marqueeDismissBlock) {
            self.marqueeDismissBlock(IDCMSMarqueeDismissPush);
        }
    }];
    [lable addGestureRecognizer:tap];
    
    if ([newsModel.msgType isEqualToNumber:@(1)]) { // 系统公告
        self.marqueeView.backgroundColor = SetColor(255, 102, 102);
    }else if ([newsModel.msgType isEqualToNumber:@(2)]){ // 活动公告
        self.marqueeView.backgroundColor = SetColor(71, 166, 255);
    }
    [lable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.marqueeView.mas_centerY);
        make.right.equalTo(self.closeMarquee.mas_left).offset(-10);
        make.left.equalTo(self.marqueeLogo.mas_right).offset(10);
        make.height.equalTo(@17);
    }];
    
    NSString *msg = [NSString stringWithFormat:@"%@: %@",newsModel.msgTitle,newsModel.secondaryTitle];
    if ([msg isNotBlank]) {
        [lable qmui_calculateHeightAfterSetAppearance];
    }
    lable.text = msg;
    lable.speed = 0.5;
}
- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    IDCMAmountModel *amountModel = [IDCMAmountModel yy_modelWithDictionary:data];
    
    // 设置总资产数据
    [self configAmountData:amountModel];
    // 设置图表
    [self configTheChartView:amountModel];
}
- (void)configAmountData:(IDCMAmountModel *)amountModel
{
    
    // 总资产标题
    self.amountLabel.text = [NSString stringWithFormat:@"%@ (%@)",SWLocaloziString(@"2.0_Amount"),amountModel.localCurrency];

    // 总资产
    NSString *amountNum = [IDCMUtilsMethod precisionControl:amountModel.totalAssetMoney];
    NSInteger presion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:nil withType:kIDCMCurrencyPrecisionTotalAssets];
    NSString *preStr = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:amountNum] fractionDigits:presion]];
    self.amount.text = [NSString stringWithFormat:@"%@ %@",amountModel.currencySymbol ,preStr];
    [self changeAttributedFontWithLabel:self.amount withFont:SetFont(@"PingFang-SC-Medium", 16) with:NSMakeRange(0, amountModel.currencySymbol.length)];
    // 涨幅
    if (![amountModel.persent isNotBlank] && ![amountModel.dValue isNotBlank]) {
        // 昨天的资产为0
        self.amountIncrease.hidden = YES;
        self.increaseLoge.hidden = YES;
    }else if ([amountModel.assetChangeType integerValue] == 1 && [amountModel.dValue isNotBlank] && [amountModel.persent isNotBlank]){
        // 资产增长
        self.increaseLoge.hidden = NO;
        self.amountIncrease.hidden = NO;
        self.amountIncrease.text = [NSString stringWithFormat:@"%@ (%@)  %@",amountModel.dValue,amountModel.persent,NSLocalizedString(@"2.0_Fluctuation", nil)];
        self.increaseLoge.image = UIImageMake(@"2.0_jiantoushang");
        [self.amountIncrease mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.increaseLoge.mas_centerY);
            make.left.equalTo(self.increaseLoge.mas_right).offset(4);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@14);
        }];
        [self changeAttributedFontWithLabel:self.amountIncrease with:NSMakeRange(self.amountIncrease.text.length-SWLocaloziString(@"2.0_Fluctuation").length, SWLocaloziString(@"2.0_Fluctuation").length)];
        
    }else if ([amountModel.assetChangeType integerValue] == 2 && [amountModel.dValue isNotBlank] && [amountModel.persent isNotBlank]){
        
        // 资产减少
        self.increaseLoge.hidden = NO;
        self.amountIncrease.hidden = NO;
        self.amountIncrease.text = [NSString stringWithFormat:@"%@ (%@)  %@",amountModel.dValue,amountModel.persent,NSLocalizedString(@"2.0_Fluctuation", nil)];
        self.increaseLoge.image = UIImageMake(@"2.0_jiantouxia");
        [self.amountIncrease mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.increaseLoge.mas_centerY);
            make.left.equalTo(self.increaseLoge.mas_right).offset(4);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@14);
        }];
        [self changeAttributedFontWithLabel:self.amountIncrease with:NSMakeRange(self.amountIncrease.text.length-SWLocaloziString(@"2.0_Fluctuation").length, SWLocaloziString(@"2.0_Fluctuation").length)];
    }else if ([amountModel.assetChangeType integerValue] == 3 && [amountModel.dValue isNotBlank] && [amountModel.persent isNotBlank]){
        // 资产不变
        self.increaseLoge.hidden = YES;
        self.amountIncrease.hidden = NO;
        self.amountIncrease.text = [NSString stringWithFormat:@"%@ (%@)  %@",amountModel.dValue,amountModel.persent,NSLocalizedString(@"2.0_Fluctuation", nil)];
        [self.amountIncrease mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.increaseLoge.mas_centerY);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@14);
        }];
        [self changeAttributedFontWithLabel:self.amountIncrease with:NSMakeRange(self.amountIncrease.text.length-SWLocaloziString(@"2.0_Fluctuation").length, SWLocaloziString(@"2.0_Fluctuation").length)];
    }
}
- (void)changeAttributedFontWithLabel:(UILabel *)label withFont:(UIFont *)font with:(NSRange)range
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attrStr addAttribute:NSFontAttributeName value:font range:range];
    label.attributedText = attrStr;
}
- (void)changeAttributedFontWithLabel:(UILabel *)label with:(NSRange)range
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:SetAColor(255, 255, 255, 0.6) range:range];
    label.attributedText = attrStr;
}
- (void)configTheChartView:(IDCMAmountModel *)amountModel {
    

    self.chartView.amountModel = amountModel;
    
    if ([amountModel.showType integerValue] == 0) { // 资产
        [amountModel.historyAssetData enumerateObjectsUsingBlock:^(IDCMHistoryAssetModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isDefault && amountModel.historyAssetData.count > 1) {
                [self.chartView scrollToIndex:idx];
            }
        }];
    }else if ([amountModel.showType integerValue] == 1){ // 行情
        [amountModel.historyMarketData enumerateObjectsUsingBlock:^(IDCMHistoryAssetModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isDefault && amountModel.historyMarketData.count > 1) {
                [self.chartView scrollToIndex:idx];
            }
        }];
    }
    
}

#pragma mark - getterv
- (UIView *)topView
{
    return SW_LAZY(_topView,({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(46, 64, 107);
        [self addSubview:view];
        view;
    }));
}
- (UIView *)marqueeView
{
    return SW_LAZY(_marqueeView, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(71, 166, 255);
        view.layer.borderColor = UIColorWhite.CGColor;
        view.layer.borderWidth = 0.5;
        [self.topView addSubview:view];
        view;
    }));
}
- (UIImageView *)marqueeLogo
{
    return SW_LAZY(_marqueeLogo, ({
        
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view.image = UIImageMake(@"2.1_marqueeLogo");
        [self.marqueeView addSubview:view];
        view;
    }));
}
- (UIButton *)closeMarquee
{
    return SW_LAZY(_closeMarquee, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIImageMake(@"2.1_closeMarquee") forState:UIControlStateNormal];
        [self.marqueeView addSubview:button];
        button;
    }));
}
- (UILabel *)amountLabel
{
    return SW_LAZY(_amountLabel, ({
        UILabel *view = [UILabel new];
        view.textColor = SetAColor(255, 255, 255, 0.8);
        view.font = SetFont(@"PingFang-SC-Regular", 14);
        [self.topView addSubview:view];
        view;
    }));
}
- (UILabel *)amount
{
    return SW_LAZY(_amount, ({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor whiteColor];
        view.font = SetFont(@"PingFang-SC-Medium", 26);
        [self.topView addSubview:view];
        view;
    }));
}
- (UIButton *)addCoin
{
    return SW_LAZY(_addCoin, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIImageMake(@"2.0_addCoinButton") forState:UIControlStateNormal];
        [self.topView addSubview:button];
        button;
    }));
}
- (UILabel *)amountIncrease
{
    return SW_LAZY(_amountIncrease, ({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor whiteColor];
        view.textAlignment = NSTextAlignmentLeft;
        view.font = SetFont(@"PingFang-SC-Regular", 10);
        [self.topView addSubview:view];
        view;
    }));
}

- (UIImageView *)increaseLoge
{
    return SW_LAZY(_increaseLoge, ({
        
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        [self.topView addSubview:view];
        view;
        
    }));
}
- (UIView *)trendView
{
    return SW_LAZY(_trendView, ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = SetColor(225, 231, 255).CGColor;
        view.layer.borderWidth= 0.5;
        view.layer.cornerRadius = 5;
        view.layer.shadowOpacity = 1;// 阴影透明度
        view.layer.shadowColor = SetColor(214, 223, 245).CGColor;// 阴影的颜色
        view.layer.shadowRadius = 2;// 阴影扩散的范围控制
        view.layer.shadowOffset = CGSizeMake(0, 2);// 阴影的范围
        [self addSubview:view];
        view;
    }));
}
- (IDCMHomeChartView *)chartView
{
    return SW_LAZY(_chartView, ({
        
        IDCMHomeChartView *view = [[IDCMHomeChartView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        view;
    }));
}
@end
