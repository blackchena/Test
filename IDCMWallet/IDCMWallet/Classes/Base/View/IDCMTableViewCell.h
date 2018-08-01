//
//  IDCMTableViewCell.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/21.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMTableViewCell : UITableViewCell


/**
 获取重用的Cell

 @param tableView tableView
 @return 返回获取到的cell  如果不存在 会自动创建
 */
+ (instancetype)getTableViewContentCellWithTableView:(UITableView *)tableView;
;

@end
