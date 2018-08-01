//
//  IDCMBaseBlockCollectionView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseBlockCollectionView.h"
#import "IDCMBaseCollectionViewCell.h"
#import "IDCMBaseCollectionCellModel.h"
#import "IDCMBaseCollectionSectionModel.h"
#import "IDCMBaseCollectionHeaderFooterView.h"


@interface IDCMBaseBlockCollectionViewConfigure ()
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSArray *registerCellClasses;
@property (nonatomic,strong) NSArray *registerHeaderViewClasses;
@property (nonatomic,strong) NSArray *registerFooterViewClasses;

@property (nonatomic,copy) NSInteger(^numberOfSectionsBlock)(UICollectionView *collectionView);
@property (nonatomic,copy) NSInteger(^numberOfItemsInSectionBlock)(UICollectionView *collectionView, NSInteger section);

@property (nonatomic,copy) Class(^cellClassForRowBlock)(IDCMBaseCollectionCellModel *cellViewModel,NSIndexPath * indexPath);
@property (nonatomic,copy) Class(^headerFooterViewClassAtSectionBlock)
                                (IDCMBaseCollectionSectionModel *sectionViewModel,
                                 IDCMSeactionViewKinds seactionViewKinds,
                                 NSIndexPath *indexPath);
@property (nonatomic,copy) void (^configCellBlock) (IDCMBaseCollectionViewCell *cell,
                                                    IDCMBaseCollectionCellModel *cellViewModel,
                                                    NSIndexPath *indexPath);
@property (nonatomic,copy) void (^configHeaderFooterViewBlock)( IDCMBaseCollectionHeaderFooterView *headerFooterView,
                                                                IDCMBaseCollectionSectionModel *sectionViewModel,
                                                                IDCMSeactionViewKinds seactionViewKinds,
                                                                NSIndexPath *indexPath);
@end

@implementation IDCMBaseBlockCollectionViewConfigure
- (instancetype)configEmptyViewConfigure:(configureBlock)configure {
    _emptyViewConfigure = [configure copy];
    return self;
}
- (instancetype)configRegisterCellClasses:(NSArray<Class> *)classes {
    _registerCellClasses = classes;
    return self;
}
- (instancetype)configHeaderViewClasses:(NSArray<Class> *)classes {
    _registerHeaderViewClasses = classes;
    return self;
}
- (instancetype)configFooterViewClasses:(NSArray<Class> *)classes {
    _registerFooterViewClasses = classes;
    return self;
}

- (instancetype)configCellClassForRow:(Class(^)(IDCMBaseCollectionCellModel *cellViewModel, NSIndexPath * indexPath))block {
    _cellClassForRowBlock = [block copy];
    return self;
}

- (instancetype)configHeaderFooterViewClassAtSection:(Class(^)(IDCMBaseCollectionSectionModel *sectionViewModel,
                                                               IDCMSeactionViewKinds seactionViewKinds,
                                                               NSIndexPath *indexPath))block {
    _headerFooterViewClassAtSectionBlock = [block copy];
    return self;
}

- (instancetype)configCell:(void(^)(IDCMBaseCollectionViewCell *cell,
                                    IDCMBaseCollectionCellModel *cellViewModel,
                                    NSIndexPath *indexPath))block {
    _configCellBlock = [block copy];
    return self;
    
}

- (instancetype)configHeaderFooterView:(void(^)(IDCMBaseCollectionHeaderFooterView *headerFooterView,
                                                IDCMBaseCollectionSectionModel *sectionViewModel,
                                                IDCMSeactionViewKinds seactionViewKinds,
                                                NSIndexPath *indexPath))block {
    _configHeaderFooterViewBlock = [block copy];
    return self;
    
}

@end



@interface IDCMBaseBlockCollectionView ()
@property (nonatomic,copy) void(^signalSub)(id value);
@property (nonatomic,copy) void(^errorsSub)(id value);
@property (nonatomic,copy) void(^executingSub)(id value);
@property (nonatomic,assign) IDCMRefreshType refreshType;
@property (nonatomic,strong) RACCommand *pullUpCommand;
@property (nonatomic,strong) RACCommand *pullDownCommand;
@property (nonatomic,strong) RACCommand *nsewDataCommand;
@property (nonatomic,strong) IDCMBaseCollectionViewModel *viewModel;
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSMutableArray<RACDisposable *> *disposees;
@end


@implementation IDCMBaseBlockCollectionView
+ (instancetype)colletionViewWithFrame:(CGRect)frame
                                layout:(UICollectionViewLayout *)layout
                           refreshType:(IDCMRefreshType)refreshType
                             viewModel:(IDCMBaseCollectionViewModel *)viewModel
                             configure:(IDCMBaseBlockCollectionViewConfigure *)configure {
    
    typedef void(^action)(void);
    action (^refresh)(BOOL isHeaderFresh) = ^(BOOL isHeaderFresh){
        return ^{
            IDCMCollectionViewLoadDataType type = isHeaderFresh ?
            IDCMCollectionViewLoadDataTypeNew : IDCMCollectionViewLoadDataTypeMore;
            [viewModel.collectionViewExecuteCommand(type) execute:nil];;
        };
    };

    action headerBlock =
    (refreshType == IDCMRefreshTypePullDown || refreshType == IDCMRefreshTypePullDownAndUp) ?
    refresh(YES) : nil;

    action footerBlock =
    (refreshType == IDCMRefreshTypePullUp || refreshType == IDCMRefreshTypePullDownAndUp) ?
    refresh(NO) : nil;

    IDCMBaseBlockCollectionView *collectionView =
    [self collectionViewWithFrame:frame
                           layout:layout
                        configure:configure
            headerRefreshCallback:headerBlock
            footerRefreshCallback:footerBlock];

    collectionView.viewModel = viewModel;
    collectionView.refreshType = refreshType;
    collectionView.nsewDataCommand = viewModel.collectionViewExecuteCommand(0);
    collectionView.pullDownCommand = viewModel.collectionViewExecuteCommand(1);
    collectionView.pullUpCommand = viewModel.collectionViewExecuteCommand(2);
    [collectionView configCollectionViewBlockWithConfigure:configure];
    [collectionView configViewModel];
    return collectionView;
}

- (void)configCollectionViewBlockWithConfigure:(IDCMBaseBlockCollectionViewConfigure *)configure {
    @weakify(self);
    
    if (configure.emptyViewConfigure) {
        self.emptyViewConfigure = configure.emptyViewConfigure;
    }

    [self registerCellWithCellClasses:configure.registerCellClasses];
    [self registerHeaderWithViewClasses:configure.registerHeaderViewClasses];
    [self registerFooterWithViewClasses:configure.registerFooterViewClasses];
    
    if (!configure.numberOfSectionsBlock) {
        [configure configNumberOfSections:^NSInteger(UICollectionView *collectionView) {
            @strongify(self)
            return  self.viewModel.sectionModels.count;
        }];
    }
    if (!configure.numberOfItemsInSectionBlock) {
        [configure configNumberOfItemsInSection:^NSInteger(UICollectionView *collectionView, NSInteger section) {
            @strongify(self)
            return [self.viewModel getSectionViewModelAtSection:section].cellModels.count;
        }];
    }
    
    [[[[configure configCellForItemAtIndexPath:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
        @strongify(self)
        if (configure.cellClassForRowBlock) {
            Class cellClass = configure.cellClassForRowBlock([self.viewModel getCellViewModelAtIndexPath:indexPath],indexPath);
            if (class_getSuperclass(cellClass) == IDCMBaseCollectionViewCell.class) {
                return
                [cellClass cellWithColletionView:collectionView
                                       indexPath:indexPath
                                       viewModel:self.viewModel];
            }
        }return nil;
    }] configWillDisplayCell:^(UICollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath) {
        @strongify(self)
        if ([cell isKindOfClass:IDCMBaseCollectionViewCell.class]) {
            [((IDCMBaseCollectionViewCell *)cell) reloadCellData];
        }
        configure.configCellBlock ?
        configure.configCellBlock((IDCMBaseCollectionViewCell *)cell, [self.viewModel getCellViewModelAtIndexPath:indexPath], indexPath) : nil;
    }] configSeactionHeaderFooterView:^UICollectionReusableView *(UICollectionView *collectionView, NSString *kind, NSIndexPath *indexPath) {
        if (configure.headerFooterViewClassAtSectionBlock) {
            if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
                Class secionHeaderClass =
                configure.headerFooterViewClassAtSectionBlock([self.viewModel getSectionViewModelAtSection:indexPath.section], 0, indexPath);
                if (class_getSuperclass(secionHeaderClass) == IDCMBaseCollectionHeaderFooterView.class) {
                    return
                    [secionHeaderClass headerFooterViewWithCollectionView:collectionView
                                                                indexPath:indexPath
                                                                 isHeader:YES
                                                                viewModel:self.viewModel];
                }
            } else {
                Class secionFooterClass =
                configure.headerFooterViewClassAtSectionBlock([self.viewModel getSectionViewModelAtSection:indexPath.section], 1, indexPath);
                if (class_getSuperclass(secionFooterClass) == IDCMBaseCollectionHeaderFooterView.class) {
                    return
                    [secionFooterClass headerFooterViewWithCollectionView:collectionView
                                                                indexPath:indexPath
                                                                 isHeader:YES
                                                                viewModel:self.viewModel];
                } else {
                    return [secionFooterClass new];
                }
            }
        }return nil;
    }] configWillDisPlayHeaderFooterView:^void (UICollectionView *collectionView, UICollectionReusableView *view, NSString *kind, NSIndexPath *indexPath) {
            @strongify(self)
            if ([view isKindOfClass:IDCMBaseCollectionHeaderFooterView.class]) {
                [((IDCMBaseCollectionHeaderFooterView *)view) reloadHeaderFooterViewData];
            }
            configure.configHeaderFooterViewBlock ?
            configure.configHeaderFooterViewBlock((IDCMBaseCollectionHeaderFooterView *)view, [self.viewModel getSectionViewModelAtSection:indexPath.section], ![kind isEqualToString:UICollectionElementKindSectionHeader], indexPath) : nil;
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
                   executingSub:(void(^)(id value))executingSub  {
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












