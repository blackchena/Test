//
//  IDCMAcceptantMarginManageViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/4/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
@class IDCMAcceptMarginManageModel;

@interface IDCMAcceptantMarginManageViewModel : IDCMBaseViewModel
@property (nonatomic,strong) RACCommand *GetOtcAcceptantInfoCommand;///< POST 获取承兑商状态和保证金列表
@property (nonatomic,strong) RACCommand *SetPaySequenceCommand;///< POST 设置扣款顺序
@property (nonatomic,strong) RACCommand *CheckWithdrawCommand;///< POST 是否能提取

@property (nonatomic,strong) NSArray <IDCMAcceptMarginManageModel *> *DepositList;///< 保证金列表
@end
