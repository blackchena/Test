//
//  IDCMFoundViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/21.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMFoundViewModel : IDCMBaseViewModel
/**
 *  banner数据
 */
@property (strong, nonatomic) NSArray *bannerList;
/**
 *  dapp数据
 */
@property (strong, nonatomic) NSArray *dappList;
/**
 *  banner跳转command
 */
@property (strong, nonatomic) RACCommand *bannerCommand;
@end
