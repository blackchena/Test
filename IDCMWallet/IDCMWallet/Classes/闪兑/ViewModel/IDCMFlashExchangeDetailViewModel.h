//
//  IDCMFlashExchangeDetailViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseTableViewModel.h"


@interface IDCMFlashExchangeDetailViewModel : IDCMBaseTableViewModel

@property (nonatomic,copy)   NSString *ID;
@property (nonatomic,assign) BOOL isGestuerEdit;
@property (nonatomic,strong) RACCommand *editCommand;

@end
