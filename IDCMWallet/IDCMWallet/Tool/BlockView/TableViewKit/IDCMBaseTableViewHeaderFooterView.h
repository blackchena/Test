//
//  IDCMBaseTableViewHeaderFooterView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/25.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMBaseTableSectionModel.h"
#import "IDCMBaseTableViewModel.h"

@interface IDCMBaseTableViewHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, assign, readonly) BOOL isHeader;
@property (nonatomic, assign, readonly) NSInteger section;
@property (nonatomic,strong) IDCMBaseTableViewModel *viewModel;
@property (nonatomic,strong) IDCMBaseTableSectionModel *sectionViewModel;

- (void)initConfig;
- (void)reloadHeaderFooterViewData;
- (void)configureHeaderFooterView;
+ (instancetype)headerFooterViewWithTableView:(UITableView *)tableView
                                      section:(NSInteger)section
                                     isHeader:(BOOL)isHeader
                                    viewModel:(IDCMBaseTableViewModel *)viewModel;

@end
