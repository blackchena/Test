//
//  IDCMChartsViewCell.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMTableViewCell.h"
#import "IDCMTrendChartModel.h"
#import "IDCMChartModel.h"


typedef NS_ENUM(NSInteger , IDCMDidSelectChartsType) {
    IDCMDidSelectAssets           = 1, // 选择资产
    IDCMDidSelectCharts           = 2, // 选择行情

};

typedef void(^IDCMDidSelectChartsButtonBlock)(IDCMDidSelectChartsType type);

@interface IDCMChartsViewCell : IDCMTableViewCell

/**
 按钮回调
 */
@property (nonatomic,copy) IDCMDidSelectChartsButtonBlock didSelectChartsBlock;

- (void)setChartDataArr:(NSMutableArray *)dataArr withIndex:(NSInteger)index withShowType:(NSInteger)showType;
@end
