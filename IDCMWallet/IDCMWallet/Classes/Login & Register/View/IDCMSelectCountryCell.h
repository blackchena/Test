//
//  IDCMSelectCountryCell.h
//  IDCMExchange
//
//  Created by BinBear on 2017/12/6.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMTableViewCell.h"

@class IDCMCountryListModel;

@interface IDCMSelectCountryCell : IDCMTableViewCell
/**
 *  model
 */
@property (strong, nonatomic) IDCMCountryListModel *model;
@end
