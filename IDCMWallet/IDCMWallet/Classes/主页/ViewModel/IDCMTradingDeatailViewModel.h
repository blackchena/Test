//
//  IDCMTradingDeatailViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/27.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMNewCurrencyTradingModel.h"

@interface IDCMTradingDeatailViewModel : IDCMBaseViewModel
/**
 *  dealModel
 */
@property (strong, nonatomic) IDCMNewCurrencyTradingModel *dealModel;
/**
 *  编辑
 */
@property (strong, nonatomic) RACCommand *editeCommand;
/**
 *  是否手势编辑
 */
@property (assign, nonatomic) BOOL isGestuerEdit;
@end
