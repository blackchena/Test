//
//  IDCMAddCoinViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/25.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMAddCoinViewModel : IDCMBaseViewModel
/**
 *  增加币种
 */
@property (strong, nonatomic) RACCommand *addCoinCommand;
/**
 *   钱包列表数组
 */
@property (strong, nonatomic) NSMutableArray *walletListData;
@end
