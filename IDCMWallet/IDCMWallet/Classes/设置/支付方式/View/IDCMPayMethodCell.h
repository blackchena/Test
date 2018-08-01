//
//  IDCMPayMethodCell.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "MGSwipeTableCell.h"
#import "IDCMPaymentListModel.h"

@interface IDCMDeleteCellBtn : MGSwipeButton
@end
@interface IDCMPayMethodCell : MGSwipeTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath
                            model:(IDCMPaymentListModel *)model;

- (void)reloadCellData;

@end
