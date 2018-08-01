//
//  IDCMAcountSafeViewCell.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/28.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMAcountSafeViewCell
// @abstract <#类的描述#>
// @discussion <#类的功能#>
//
#import <UIKit/UIKit.h>
#import "IDCMAcountSafeListModel.h"

@interface IDCMAcountSafeViewCell : UITableViewCell

/**
 *  arrow
 */
@property (strong, nonatomic) UIImageView *arrow;
/**
 *  line
 */
@property (strong, nonatomic) UIView *line;
/**
 *  model
 */
@property (strong, nonatomic) IDCMAcountSafeListModel *acountModel;
@end
