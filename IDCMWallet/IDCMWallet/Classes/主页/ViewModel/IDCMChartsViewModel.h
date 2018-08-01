//
//  IDCMChartsViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMChartsViewModel : IDCMBaseViewModel
/**
 *  配置显示种类
 */
@property (strong, nonatomic) RACCommand *configChartCommand;
@end
