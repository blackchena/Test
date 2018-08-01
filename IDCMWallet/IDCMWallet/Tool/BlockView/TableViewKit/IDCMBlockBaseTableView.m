//
//  IDCMBlockBaseTableView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/23.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBlockBaseTableView.h"
#import "IDCMBaseTableViewCell.h"
#import "IDCMBaseTableCellModel.h"
#import "IDCMBaseTableSectionModel.h"
#import "IDCMBaseTableViewHeaderFooterView.h"


@interface IDCMBlockBaseTableViewConfigure ()
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSArray *registerCellClasses;
@property (nonatomic,strong) NSArray *registerHeaderFooterViewClasses;
@property (nonatomic,copy) NSInteger(^numberOfSections)(UITableView *tableView);
@property (nonatomic,copy) NSInteger(^numberOfRowsInSection)(UITableView *tableView, NSInteger section);
@property (nonatomic,copy) Class(^cellClassForRowBlock)(IDCMBaseTableCellModel *cellViewModel,NSIndexPath * indexPath);
@property (nonatomic,copy) Class(^headerFooterViewClassAtSectionBlock)
                                (IDCMBaseTableSectionModel *sectionViewModel,
                                IDCMSeactionViewKinds seactionViewKinds,
                                NSUInteger section);
@property (nonatomic,copy) void (^configCellBlock) (IDCMBaseTableViewCell *cell,
                                                    IDCMBaseTableCellModel *cellViewModel,
                                                    NSIndexPath *indexPath);
@property (nonatomic,copy) void (^configHeaderFooterViewBlock)( IDCMBaseTableViewHeaderFooterView *headerFooterView,
                                                                IDCMBaseTableSectionModel *sectionViewModel,
                                                                IDCMSeactionViewKinds seactionViewKinds,
                                                                NSUInteger section);
@end
@implementation IDCMBlockBaseTableViewConfigure
- (instancetype)configEmptyViewConfigure:(configureBlock)configure {
    if (configure) {
        _emptyViewConfigure = [configure copy];
    }
    return self;
}
- (instancetype)configRegisterCellClasses:(NSArray<Class> *)classes {
    _registerCellClasses = classes;
    return self;
}
- (instancetype)configHeaderFooterViewClasses:(NSArray<Class> *)classes {
    _registerHeaderFooterViewClasses = classes;
    return self;
}
- (instancetype)configCellClassForRow:(Class(^)(IDCMBaseTableCellModel *cellViewModel,NSIndexPath * indexPath))block {
    _cellClassForRowBlock = [block copy];
    return self;
}
- (instancetype)configHeaderFooterViewClassAtSection:(Class(^)(IDCMBaseTableSectionModel *sectionViewModel,
                                                               IDCMSeactionViewKinds seactionViewKinds,
                                                               NSUInteger section))block {
    _headerFooterViewClassAtSectionBlock = [block copy];
    return self;
}
- (instancetype)configCell:(void(^)(IDCMBaseTableViewCell *cell,
                                    IDCMBaseTableCellModel *cellViewModel,
                                    NSIndexPath *indexPath))block {
    _configCellBlock = [block copy];
    return self;
}
- (instancetype)configHeaderFooterView:(void(^)(IDCMBaseTableViewHeaderFooterView *headerFooterView,
                                                IDCMBaseTableSectionModel *sectionViewModel,
                                                IDCMSeactionViewKinds seactionViewKinds,
                                                NSUInteger section))block {
    _configHeaderFooterViewBlock = [block copy];
    return self;
}
@end


@interface IDCMBlockBaseTableView ()
@property (nonatomic,copy) void(^signalSub)(id value);
@property (nonatomic,copy) void(^errorsSub)(id value);
@property (nonatomic,copy) void(^executingSub)(id value);
@property (nonatomic,assign) IDCMRefreshType refreshType;
@property (nonatomic,strong) RACCommand *pullUpCommand;
@property (nonatomic,strong) RACCommand *pullDownCommand;
@property (nonatomic,strong) RACCommand *nsewDataCommand;
@property (nonatomic,strong) IDCMBaseTableViewModel *viewModel;
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSMutableArray<RACDisposable *> *disposees;
@end


@implementation IDCMBlockBaseTableView
+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                       refreshType:(IDCMRefreshType)refreshType
                     refreshAction:(RefreshAction(^)(BOOL isHeaderFresh))refreshAction
                         viewModel:(IDCMBaseTableViewModel *)viewModel
                         configure:(IDCMBlockBaseTableViewConfigure *)configure {
    
    RefreshAction (^refresh)(BOOL isHeaderFresh) = ^(BOOL isHeaderFresh){
        RefreshAction action = ^{
            IDCMTableViewLoadDataType type = isHeaderFresh ?
            IDCMTableViewLoadDataTypeNew : IDCMTableViewLoadDataTypeMore;
            [viewModel.tableViewExecuteCommand(type) execute:nil];
        };
        return
        refreshAction ? (refreshAction(isHeaderFresh) ?: action) : action;
    };
    
    RefreshAction headerBlock =
    (refreshType == IDCMRefreshTypePullDown || refreshType == IDCMRefreshTypePullDownAndUp) ?
    refresh(YES) : nil;
    
    RefreshAction footerBlock =
    (refreshType == IDCMRefreshTypePullUp || refreshType == IDCMRefreshTypePullDownAndUp) ?
    refresh(NO) : nil;
    
    IDCMBlockBaseTableView *tableView =
    [self tableViewWithFrame:frame
                       style:style
                   configure:configure
       headerRefreshCallback:headerBlock
       footerRefreshCallback:footerBlock];
    
    tableView.viewModel = viewModel;
    tableView.refreshType = refreshType;
    tableView.nsewDataCommand = viewModel.tableViewExecuteCommand(0);
    tableView.pullDownCommand = viewModel.tableViewExecuteCommand(1);
    tableView.pullUpCommand = viewModel.tableViewExecuteCommand(2);
    [tableView configTableViewBlockWithConfigure:configure];
    [tableView configViewModel];
    return tableView;
}

- (void)configTableViewBlockWithConfigure:(IDCMBlockBaseTableViewConfigure *)configure {
    if (configure.emptyViewConfigure) {
        self.emptyViewConfigure = configure.emptyViewConfigure;
    }
    
    [self registerCellWithCellClasses:configure.registerCellClasses];
    [self registerHeaderFooterWithViewClasses:configure.registerHeaderFooterViewClasses];
    
    @weakify(self);
    if (!configure.numberOfSections) {
        [configure configNumberOfSections:^NSInteger(UITableView *tableView) {
            @strongify(self)
            return  self.viewModel.sectionModels.count;
        }];
    }
    if (!configure.numberOfRowsInSection) {
        [configure configNumberOfRowsInSection:^NSInteger(UITableView *tableView, NSInteger section) {
            @strongify(self)
            return [self.viewModel getSectionViewModelAtSection:section].cellModels.count;
        }];
    }
    
    [[[[[[configure configCellForRowAtIndexPath:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        @strongify(self)
        if (configure.cellClassForRowBlock) {
            Class cellClass = configure.cellClassForRowBlock([self.viewModel getCellViewModelAtIndexPath:indexPath],indexPath);
            if (class_getSuperclass(cellClass) == IDCMBaseTableViewCell.class) {
                return [cellClass cellWithTableView:tableView
                                          indexPath:indexPath
                                          viewModel:self.viewModel];
            }
        }return nil;
    }] configWillDisplayCell:^(UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath) {
        @strongify(self)
        if ([cell isKindOfClass:IDCMBaseTableViewCell.class]) {
           [((IDCMBaseTableViewCell *)cell) reloadCellData];
        }
        configure.configCellBlock ?
        configure.configCellBlock((IDCMBaseTableViewCell *)cell, [self.viewModel getCellViewModelAtIndexPath:indexPath], indexPath) : nil;
    }] configViewForHeaderInSection:^UIView *(UITableView *tableView, NSInteger section) {
        @strongify(self)
        if (configure.headerFooterViewClassAtSectionBlock) {
            id headerClass =
            configure.headerFooterViewClassAtSectionBlock([self.viewModel getSectionViewModelAtSection:section],0, section);
            if (class_getSuperclass(headerClass) == IDCMBaseTableViewHeaderFooterView.class) {
                return [headerClass
                        headerFooterViewWithTableView:tableView
                        section:section
                        isHeader:YES
                        viewModel:self.viewModel];
            } else {
                return headerClass;
            }
        }return nil;
    }] configWillDisplayHeaderView:^(UITableView *tableView,UIView *view,NSInteger section) {
        @strongify(self)
        if ([view isKindOfClass:IDCMBaseTableViewHeaderFooterView.class]) {
            [((IDCMBaseTableViewHeaderFooterView *)view) reloadHeaderFooterViewData];
        }
        configure.configHeaderFooterViewBlock ?
        configure.configHeaderFooterViewBlock((IDCMBaseTableViewHeaderFooterView *)view,
                                              [self.viewModel getSectionViewModelAtSection:section], 0, section) : nil;
    }] configViewForFooterInSection:^UIView *(UITableView *tableView, NSInteger section) {
        @strongify(self)
        if (configure.headerFooterViewClassAtSectionBlock) {
            id headerClass =
            configure.headerFooterViewClassAtSectionBlock([self.viewModel getSectionViewModelAtSection:section],1, section);
            if (class_getSuperclass(headerClass) == IDCMBaseTableViewHeaderFooterView.class) {
                return [headerClass
                        headerFooterViewWithTableView:tableView
                        section:section
                        isHeader:NO
                        viewModel:self.viewModel];
            } else {
                return headerClass;
            }
        }return nil;
    }] configWillDisplayFooterView:^(UITableView *tableView, UIView *view, NSInteger section) {
        @strongify(self)
        if ([view isKindOfClass:IDCMBaseTableViewHeaderFooterView.class]) {
            [((IDCMBaseTableViewHeaderFooterView *)view) reloadHeaderFooterViewData];
        }
        configure.configHeaderFooterViewBlock ?
        configure.configHeaderFooterViewBlock((IDCMBaseTableViewHeaderFooterView *)view,
                                              [self.viewModel getSectionViewModelAtSection:section], 1, section) : nil;
    }];
}

- (void)configViewModel {
    
    @weakify(self);
    void (^subscribeSignal)(id) = ^(id x){
        @strongify(self);
        if (!self) {  return ;}
        self.signalSub ?
        ({
            self.signalSub(x);
        }):
        ({
            !self.signalSub ?: self.signalSub(x);
            [self reloadData];
            switch (self.refreshType) {
                case IDCMRefreshTypePullDown:{
                    [self endRefreshWithTitle:SWLocaloziString(@"2.1_DidLoadSuccess")];
                }break;
                case IDCMRefreshTypePullUp:{
                    if ([x isKindOfClass:[NSNumber class]]) {
                        if ([x boolValue]) {
                            [self.footRefreshControl
                             endRefreshingAndNoLongerRefreshingWithAlertText:
                             SWLocaloziString(@"2.1_MJRefreshBackFooterNoMoreDataText")];
                        }else{
                            [self.footRefreshControl resumeRefreshAvailable];
                        }
                    }
                }break;
                case IDCMRefreshTypePullDownAndUp:{
                    [self endRefreshWithTitle:SWLocaloziString(@"2.1_DidLoadSuccess")];
                    if ([x isKindOfClass:[NSNumber class]]) {
                        if ([x boolValue]) {
                            [self.footRefreshControl
                             endRefreshingAndNoLongerRefreshingWithAlertText:
                             SWLocaloziString(@"2.1_MJRefreshBackFooterNoMoreDataText")];
                        }else{
                            [self.footRefreshControl resumeRefreshAvailable];
                        }
                    }
                }break;
                default:
                break;
            }
        });
    };
    
    void(^subscribeErrors)(NSError *x) = ^(NSError *x){
        @strongify(self);
        if (!self) {  return ;}
        self.errorsSub ?
        ({
            self.errorsSub(x);
        }):
        ({
            [self endRefreshWithTitle:nil];
            if (self.viewModel.sectionModels.count <= 0) {
                [self reloadData];
                if (self.refreshType == IDCMRefreshTypePullUp ||
                    self.refreshType == IDCMRefreshTypePullDownAndUp) {
                    [self.footRefreshControl
                     endRefreshingAndNoLongerRefreshingWithAlertText:
                     SWLocaloziString(@"2.1_MJRefreshBackFooterNoMoreDataText")];
                }
            }
        });
    };
    
    void (^subscribeExecuting)(NSNumber * executing) = ^(NSNumber * executing){
        @strongify(self);
        if (!self) {  return ;}
        self.executingSub ?
        ({
            self.executingSub(executing);
        }):
        ({
            if (!executing.boolValue) {
                [IDCMHUD dismiss];
                if (self.emptyViewConfigure) {
                    if (self.viewModel.sectionModels.count) {
                        [self dismissEmptyView];
                    } else {
                        [self showEmptyView];
                    }
                }
            }
        });
    };
    
    __block NSMutableArray *tempArray = @[].mutableCopy;
    NSArray *array = @[self.nsewDataCommand , self.pullDownCommand, self.pullUpCommand];
    [array enumerateObjectsUsingBlock:^(RACCommand *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![tempArray containsObject:obj]) {
            
            RACDisposable *disposeOne = [[obj.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:subscribeSignal];
            RACDisposable *disposeTwo = [obj.errors subscribeNext:subscribeErrors];
            RACDisposable *disposeThree = [[[obj.executing skip:1] deliverOnMainThread] subscribeNext:subscribeExecuting];
            
            if (disposeOne && [disposeOne isKindOfClass:[RACDisposable class]]) {
                [self.disposees addObject:disposeOne];
            }
            
            if (disposeTwo && [disposeTwo isKindOfClass:[RACDisposable class]]) {
                [self.disposees addObject:disposeTwo];
            }
            
            if (disposeThree && [disposeThree isKindOfClass:[RACDisposable class]]) {
                [self.disposees addObject:disposeThree];
            }
        }
        [tempArray addObject:obj];
    }];
}

- (void)configCommandSignaleSub:(void(^)(id value))signaleSub
                       erresSub:(void(^)(id value))erresSub
                   executingSub:(void(^)(id value))executingSub {
    self.signalSub = [signaleSub copy];
    self.errorsSub = [erresSub copy];
    self.executingSub = [executingSub copy];
}

- (void)showEmptyView {
    if (self.emptyViewConfigure) {
        [IDCMHUD showEmptyViewToView:self
                           configure:self.emptyViewConfigure
                      reloadCallback:nil];
    }
}

- (void)dismissEmptyView {
    [IDCMHUD dismissEmptyViewForView:self];
}

- (void)dealloc {
    [self.disposees makeObjectsPerformSelector:@selector(dispose)];
}

- (NSMutableArray *)disposees {
    return SW_LAZY(_disposees, ({
        @[].mutableCopy;
    }));
}


@end










