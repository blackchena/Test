//
//  IDCMAcceptantBondWaterCell.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IDCMAcceptantBondWaterModel;

@interface IDCMAcceptantBondWaterCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath
                            model:(IDCMAcceptantBondWaterModel *)model;

- (void)reloadCellData;

+ (CGFloat)heightForCell:(IDCMAcceptantBondWaterModel *)model;

@end
