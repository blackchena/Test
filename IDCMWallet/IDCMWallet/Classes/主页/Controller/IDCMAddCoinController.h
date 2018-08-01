//
//  IDCMAddCoinController.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseViewController.h"
#import "IDCMAddCoinViewModel.h"

typedef void(^IDCMAddCoinBlock)(NSMutableArray *modelArr);

@interface IDCMAddCoinController : IDCMBaseViewController
/**
 *   选中回调
 */
@property (copy, nonatomic) IDCMAddCoinBlock addCoinBlock;

@end
