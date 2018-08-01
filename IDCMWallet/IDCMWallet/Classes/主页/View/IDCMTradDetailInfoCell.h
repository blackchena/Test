//
//  IDCMTradDetailInfoCell.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/30.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMNewCurrencyTradingModel.h"

@interface IDCMTradDetailInfoCell : UITableViewCell

- (void)setDealModel:(IDCMNewCurrencyTradingModel *)model WithRow:(NSInteger)row;
@end
