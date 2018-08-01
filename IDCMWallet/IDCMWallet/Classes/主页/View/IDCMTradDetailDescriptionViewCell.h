//
//  IDCMTradDetailDescriptionViewCell.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/30.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMNewCurrencyTradingModel.h"

@interface IDCMTradDetailDescriptionViewCell : UITableViewCell
/**
 *  model
 */
@property (strong, nonatomic) IDCMNewCurrencyTradingModel *model;
/**
 *   标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  输入框
 */
@property (strong, nonatomic) QMUITextView *textView;

@end
