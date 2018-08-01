//
//  IDCMBaseTableViewCell.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/25.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMBaseTableViewModel.h"
#import "IDCMBaseTableViewCell.h"

@interface IDCMBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) IDCMBaseTableViewModel *viewModel;
@property (nonatomic, strong, readonly) NSIndexPath *indexPath;
@property (nonatomic, strong, readonly) IDCMBaseTableCellModel *cellViewModel;
@property (nonatomic, strong) NSArray<UIView *> *customSubViewsArray;


- (void)initConfig;
- (void)configureCell;
- (void)reloadCellData;
+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath
                        viewModel:(IDCMBaseTableViewModel *)viewModel;

@end
