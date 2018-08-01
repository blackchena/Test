//
//  IDCMOTCExchangeRecordViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMBaseTableViewModel.h"


@interface IDCMOTCExchangeRecordViewModel : IDCMBaseTableViewModel
@property (nonatomic,strong)  RACCommand * commandGetState;
@end
