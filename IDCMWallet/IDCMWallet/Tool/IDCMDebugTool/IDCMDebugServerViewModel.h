//
//  IDCMDebugServerViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMDebugServerViewModel : IDCMBaseViewModel
/**
 *  data
 */
@property (strong, nonatomic) RACSignal *dataSignal;
/**
 *  cell选择
 */
@property (strong, nonatomic) RACCommand *selectCommand;

- (NSArray *)getDetailData;
@end
