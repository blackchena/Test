//
//  IDCMBaseBlockCollectionView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBlockCollectionView.h"
#import "IDCMBaseBlockCollectionView.h"
#import "IDCMBaseCollectionViewModel.h"
#import "IDCMBlockBaseTableView.h"


@class IDCMBaseCollectionSectionModel, IDCMBaseCollectionCellModel, IDCMBaseCollectionViewCell, IDCMBaseCollectionHeaderFooterView;
@interface IDCMBaseBlockCollectionViewConfigure : IDCMBlockCollectionViewConfigure

- (instancetype)configEmptyViewConfigure:(configureBlock)configure;
- (instancetype)configRegisterCellClasses:(NSArray<Class> *)classes;
- (instancetype)configHeaderViewClasses:(NSArray<Class> *)classes;
- (instancetype)configFooterViewClasses:(NSArray<Class> *)classes;

- (instancetype)configCellClassForRow:(Class(^)(IDCMBaseCollectionCellModel *cellViewModel, NSIndexPath * indexPath))block;
- (instancetype)configHeaderFooterViewClassAtSection:(Class(^)(IDCMBaseCollectionSectionModel *sectionViewModel,
                                                               IDCMSeactionViewKinds seactionViewKinds,
                                                               NSIndexPath *indexPath))block;

- (instancetype)configCell:(void(^)(IDCMBaseCollectionViewCell *cell,
                                    IDCMBaseCollectionCellModel *cellViewModel,
                                    NSIndexPath *indexPath))block;
- (instancetype)configHeaderFooterView:(void(^)(IDCMBaseCollectionHeaderFooterView *headerFooterView,
                                                IDCMBaseCollectionSectionModel *sectionViewModel,
                                                IDCMSeactionViewKinds seactionViewKinds,
                                                NSIndexPath *indexPath))block;
@end



@interface IDCMBaseBlockCollectionView : IDCMBlockCollectionView

+ (instancetype)colletionViewWithFrame:(CGRect)frame
                                layout:(UICollectionViewLayout *)layout
                           refreshType:(IDCMRefreshType)refreshType
                             viewModel:(IDCMBaseCollectionViewModel *)viewModel
                             configure:(IDCMBaseBlockCollectionViewConfigure *)configure;

- (void)configCommandSignaleSub:(void(^)(id value))signaleSub
                       erresSub:(void(^)(id value))erresSub
                   executingSub:(void(^)(id value))executingSub;

- (void)showEmptyView;
- (void)dismissEmptyView;

@end










