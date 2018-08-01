//
//  IDCMHomeChartView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IDCMAmountModel;
@interface IDCMHomeChartView : UIView
/**  chart数据 */
@property (strong, nonatomic) IDCMAmountModel *amountModel;

- (void)scrollToIndex:(NSInteger)index;
@end
