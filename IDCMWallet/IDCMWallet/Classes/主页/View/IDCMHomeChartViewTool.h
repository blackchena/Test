//
//  IDCMHomeChartViewTool.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMHomeChartViewTool : NSObject


/**
 处理HomeChartView y轴坐标值

 @param valueMax 最大值
 @param valueMin 最小值
 @return 坐标值数组
 */
+ (NSArray<NSNumber *> *)handleChartViewCoordinateWithValueMax:(double)valueMax
                                                      valueMin:(double)valueMin;



@end








