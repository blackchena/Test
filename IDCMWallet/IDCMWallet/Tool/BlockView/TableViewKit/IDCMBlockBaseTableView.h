//
//  IDCMBlockBaseTableView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/23.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBlockTableView.h"
#import "IDCMBaseTableViewModel.h"

typedef NS_ENUM(NSUInteger, IDCMRefreshType) {
    IDCMRefreshTypeNone,           // 没有加载刷新控件
    IDCMRefreshTypePullDown,      // 只有下拉刷新
    IDCMRefreshTypePullUp,       // 只有上拉刷新
    IDCMRefreshTypePullDownAndUp// 既有下拉刷拉 又有上拉刷新
};

typedef NS_ENUM(NSUInteger, IDCMSeactionViewKinds) {
    SeactionHeaderView,  // seation 头部视图
    SeactionFooterView, // seation 尾部视图
};


@class IDCMBaseTableSectionModel, IDCMBaseTableCellModel, IDCMBaseTableViewCell, IDCMBaseTableViewHeaderFooterView;
@interface IDCMBlockBaseTableViewConfigure : IDCMBlockTableViewConfigure


- (instancetype)configEmptyViewConfigure:(configureBlock)configure;
- (instancetype)configRegisterCellClasses:(NSArray<Class> *)classes;
- (instancetype)configHeaderFooterViewClasses:(NSArray<Class> *)classes;

- (instancetype)configCellClassForRow:(Class(^)(IDCMBaseTableCellModel *cellViewModel, NSIndexPath * indexPath))block;
- (instancetype)configHeaderFooterViewClassAtSection:(Class(^)(IDCMBaseTableSectionModel *sectionViewModel,
                                                               IDCMSeactionViewKinds seactionViewKinds,
                                                               NSUInteger section))block;

- (instancetype)configCell:(void(^)(IDCMBaseTableViewCell *cell,
                                    IDCMBaseTableCellModel *cellViewModel,
                                    NSIndexPath *indexPath))block;
- (instancetype)configHeaderFooterView:(void(^)(IDCMBaseTableViewHeaderFooterView *headerFooterView,
                                                IDCMBaseTableSectionModel *sectionViewModel,
                                                IDCMSeactionViewKinds seactionViewKinds,
                                                NSUInteger section))block;
@end


typedef void(^RefreshAction)(void);
@interface IDCMBlockBaseTableView : IDCMBlockTableView

+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                       refreshType:(IDCMRefreshType)refreshType
                     refreshAction:(RefreshAction(^)(BOOL isHeaderFresh))refreshAction
                         viewModel:(IDCMBaseTableViewModel *)viewModel
                         configure:(IDCMBlockBaseTableViewConfigure *)configure;

- (void)configCommandSignaleSub:(void(^)(id value))signaleSub
                       erresSub:(void(^)(id value))erresSub
                   executingSub:(void(^)(id value))executingSub;

- (void)showEmptyView;
- (void)dismissEmptyView;

@end












