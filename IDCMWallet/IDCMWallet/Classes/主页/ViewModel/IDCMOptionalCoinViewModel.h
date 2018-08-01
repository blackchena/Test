//
//  IDCMOptionalCoinViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/6/13.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMCurrencyMarketModel.h"

@interface IDCMOptionalCoinViewModel : IDCMBaseViewModel

/**
 *  增加币种
 */
@property (strong, nonatomic) RACCommand *addCoinCommand;

@property (nonatomic,strong) NSMutableArray<IDCMCurrencyMarketModel *> *dataArray;

@end
