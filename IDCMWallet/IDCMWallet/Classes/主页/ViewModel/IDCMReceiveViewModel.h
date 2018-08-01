//
//  IDCMReceiveViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/19.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMCurrencyMarketModel.h"

@interface IDCMReceiveViewModel : IDCMBaseViewModel
/**
 *  选中的model
 */
@property (strong, nonatomic) IDCMCurrencyMarketModel *marketModel;
/**
 *  接收地址
 */
@property (strong, nonatomic) RACCommand *reciveCommand;
@end
