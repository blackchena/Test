//
//  IDCMHomeChartView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMHomeChartView.h"
#import "iCarousel.h"
#import "IDCMAmountModel.h"
#import "AAChartView.h"
#import "IDCMHistoryAssetModel.h"
#import "IDCMAssetListModel.h"
#import "IDCMHistoryMarketModel.h"
#import "IDCMPriceModel.h"
#import "IDCMHomeChartViewTool.h"

#define PAGE_OFFSET 12

@interface IDCMHomeChartView ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic,strong) iCarousel *carousel;

@property (nonatomic, strong) NSArray *chartsGroup;
@end

@implementation IDCMHomeChartView


#pragma mark - initview
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self carousel];

    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self carousel];

}
- (void)setAmountModel:(IDCMAmountModel *)amountModel
{
    _amountModel = amountModel;
    
    
    if ([amountModel.showType integerValue] == 0) { // 资产
        self.chartsGroup = amountModel.historyAssetData;
    }else if ([amountModel.showType integerValue] == 1){ // 行情
        self.chartsGroup = amountModel.historyMarketData;
    }
    if (self.chartsGroup.count > 1) {
        self.carousel.scrollEnabled = YES;
    }else{
        self.carousel.scrollEnabled = NO;
    }
    [self.carousel reloadData];
}

#pragma mark - life cycle
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.top.bottom.equalTo(self);
    }];
}
- (void)dealloc
{
    self.carousel.dataSource = nil;
    self.carousel.delegate = nil;
}
#pragma mark - iCarouselDelegate && iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.chartsGroup.count;
}
-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    CGFloat viewWidth = SCREEN_WIDTH - 2*PAGE_OFFSET;
    if (view == nil) {

        AAChartView *chartView = [[AAChartView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.height)];
        chartView.contentHeight = self.height-10;
        chartView.backgroundColor = UIColorWhite;
        chartView.layer.borderColor = SetColor(225, 231, 255).CGColor;
        chartView.layer.borderWidth= 0.5;
        chartView.layer.cornerRadius = 5;
        chartView.layer.shadowOpacity = 1;// 阴影透明度
        chartView.layer.shadowColor = SetColor(214, 223, 245).CGColor;// 阴影的颜色
        chartView.layer.shadowRadius = 2;// 阴影扩散的范围控制
        chartView.layer.shadowOffset = CGSizeMake(0, 2);// 阴影的范围
        chartView.scrollEnabled = NO;

        view = chartView;
    }
    if ([self.amountModel.showType integerValue] == 0) { // 资产
        
        IDCMHistoryAssetModel *model = self.chartsGroup[index];
        
        NSMutableArray *amountArr = @[].mutableCopy;
        NSMutableArray *dateArr = @[].mutableCopy;
        NSMutableArray *toolArr = @[].mutableCopy;
        
        NSString *title = @"";
        if ([model.currency isEqualToString:@"total"]) {
            title = SWLocaloziString(@"2.0_AmountTrendTitle");
        }else{
            title = [NSString stringWithFormat:@"%@%@%@",SWLocaloziString(@"2.1_SevenDay"),[model.currency uppercaseString],SWLocaloziString(@"2.1_AssetValueTitle")];
        }
        
        [model.dateList enumerateObjectsUsingBlock:^(IDCMAssetListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 金额
            NSString *amountNum = [IDCMUtilsMethod precisionControl:obj.marketMoney];
            NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amountNum];
            NSInteger presion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:model.currency withType:kIDCMCurrencyPrecisionAssets];
            NSString *preStr = [NSString stringFromNumber:num fractionDigits:presion];
            [amountArr addObject:[NSDecimalNumber decimalNumberWithString:[preStr stringByReplacingOccurrencesOfString:@"," withString:@"."]]];
            
            // 日期
            NSArray *tempArr = [obj.timeDate componentsSeparatedByString:@"-"];
            NSString *monthStr = tempArr[1];
            NSString *monthCode = [monthStr substringToIndex:1];
            NSString *monthDateStr;
            if ([monthCode isEqualToString:@"0"]) {
                monthDateStr = [monthStr substringFromIndex:1];
            }else{
                monthDateStr = monthStr;
            }
            NSString *dayStr = tempArr[2];
            NSString *dayCode = [dayStr substringToIndex:1];
            NSString *dayDateStr;
            if ([dayCode isEqualToString:@"0"]) {
                dayDateStr = [dayStr substringFromIndex:1];
            }else{
                dayDateStr = dayStr;
            }
            NSString *dateStr = [NSString stringWithFormat:@"%@/%@",monthDateStr,dayDateStr];
            [dateArr addObject:dateStr];
            
            NSString *toolStr = [NSString stringWithFormat:@"%@ %@",[IDCMUtilsMethod separateNumberUseCommaWith:preStr],self.amountModel.localCurrency];
            [toolArr addObject:toolStr];
        }];
        
        CGFloat valueMax = [[amountArr valueForKeyPath:@"@max.floatValue"] floatValue];
        CGFloat valueMin = [[amountArr valueForKeyPath:@"@min.floatValue"] floatValue];
        CGFloat max , min;
        if (valueMax > 0) {
            max = valueMax + 5;
        }else{
            max = 1;
        }
        if (valueMin > 0) {
            min =  0;
        }else{
            min = -1;
        }
        AAChartModel *chsrtModel = AAObject(AAChartModel)
        .chartTypeSet(AAChartTypeSpline)
        .titleSet(title)
        .subtitleSet(@"")
        .categoriesSet(dateArr)
        .colorsThemeSet(@[[NSString stringWithFormat:@"rgba(%d,%d,%d,1)",79,109,178]])
        .yAxisTitleSet(@"")
        .tooltipValueSuffixSet([NSString stringWithFormat:@" %@",model.localCurrency])
        .yAxisGridLineWidthSet(@0)
        .seriesSet(@[
                     AAObject(AASeriesElement)
                     .nameSet(NSLocalizedString(@"2.0_AmountTrend", nil))
                     .dataSet(amountArr),
                     ]
                   );
        chsrtModel.yAxisLabelsEnabled = NO;
        chsrtModel.yAxisVisible = NO;
        chsrtModel.connectNulls = YES;
        chsrtModel.legendEnabled = NO;
        chsrtModel.yAxisMin = @(min);
        chsrtModel.yAxisMax = @(max);
        chsrtModel.markerRadius = @3;
        chsrtModel.titleFontColor = @"#000000";
        chsrtModel.titleFontSize = @(10);
        [(AAChartView *)view aa_drawChartWithChartModel:chsrtModel];
        
    }else if ([self.amountModel.showType integerValue] ==  1){ // 行情
        
        IDCMHistoryMarketModel *model = self.chartsGroup[index];
        
        NSMutableArray *amountArr = @[].mutableCopy;
        NSMutableArray *toolArr = @[].mutableCopy;
        NSArray *yArr = @[];
        
        NSString *title = [NSString stringWithFormat:@"%@ %@",[model.currency uppercaseString],SWLocaloziString(@"2.1_MarketPrice")];
        
        [model.dateList enumerateObjectsUsingBlock:^(IDCMPriceModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 价格
            NSString *amountNum = [IDCMUtilsMethod precisionControl:obj.price];
            NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amountNum];
            [amountArr addObject:num];
            NSInteger presion = [[IDCMDataManager sharedDataManager] getCurrencyPrecisionWithCurrency:model.currency withType:kIDCMCurrencyPrecisionMarket];
            NSString *preStr = [NSString stringFromNumber:num fractionDigits:presion];
            NSString *toolStr = [NSString stringWithFormat:@"%@ %@",self.amountModel.currencySymbol,[IDCMUtilsMethod separateNumberUseCommaWith:preStr]];
            [toolArr addObject:toolStr];
        }];
        
        double valueMax = [[amountArr valueForKeyPath:@"@max.doubleValue"] doubleValue];
        double valueMin = [[amountArr valueForKeyPath:@"@min.doubleValue"] doubleValue];
        yArr = [IDCMHomeChartViewTool handleChartViewCoordinateWithValueMax:valueMax
                                                                   valueMin:valueMin];
        
        AAChartModel *chsrtModel = AAObject(AAChartModel)
        .chartTypeSet(AAChartTypeLine)
        .titleSet(title)
        .subtitleSet(@"")
        .categoriesSet(toolArr)
        .colorsThemeSet(@[[NSString stringWithFormat:@"rgba(%d,%d,%d,1)",79,109,178]])
        .yAxisTitleSet(@"")
        .yAxisGridLineWidthSet(@0)
        .yAxisAllowDecimalsSet(YES)//是否允许Y轴坐标值小数
        .yAxisTickPositionsSet(yArr)//指定y轴坐标
        .yAxisMinSet(@(valueMin))
        .yAxisMaxSet(@(valueMax))
        .seriesSet(@[
                     AAObject(AASeriesElement)
                     .nameSet(model.localCurrency)
                     .dataSet(amountArr),
                     ]
                   );
        chsrtModel.xAxisLabelsEnabled = NO;
        chsrtModel.xAxisVisible = NO;
        chsrtModel.yAxisVisible = YES;
        chsrtModel.connectNulls = YES;
        chsrtModel.legendEnabled = NO;
        chsrtModel.markerRadius = @0;
        chsrtModel.tooltipValueString = @"";
        chsrtModel.tooltipCrosshairs = NO;
//        chsrtModel.tooltipEnabled = NO;
        chsrtModel.titleFontColor = @"#2E406B";
        chsrtModel.titleFontSize = @(10);
        [(AAChartView *)view aa_drawChartWithChartModel:chsrtModel];
    }
    return view;
}


-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.8f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * self.carousel.itemWidth * 1.2, 0.0, 0.0);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}


#pragma mark
#pragma mark  -- function
-(void)scrollToIndex:(NSInteger)index
{
    [self.carousel scrollToItemAtIndex:index animated:NO];
}
#pragma mark - getter
- (iCarousel *)carousel
{
    return SW_LAZY(_carousel, ({
        
        iCarousel *carousel = [[iCarousel alloc] init];
        carousel.delegate = self;
        carousel.dataSource = self;
        carousel.pagingEnabled = YES;
        carousel.type = iCarouselTypeCustom;
        [self addSubview:carousel];
        carousel;
    }));
}

@end
