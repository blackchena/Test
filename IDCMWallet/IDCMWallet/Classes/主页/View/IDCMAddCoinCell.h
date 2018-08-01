//
//  IDCMAddCoinCell.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMTableViewCell.h"
@class IDCMCurrencyMarketModel;
@interface IDCMAddCoinCell : UITableViewCell
/**
 *  model
 */
@property (strong, nonatomic) IDCMCurrencyMarketModel *makketModel;
@end
