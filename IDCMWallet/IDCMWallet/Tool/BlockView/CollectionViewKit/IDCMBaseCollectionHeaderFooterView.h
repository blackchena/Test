//
//  IDCMBaseCollectionHeaderFooterView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMBaseCollectionViewModel.h"
#import "IDCMBaseCollectionSectionModel.h"


@interface IDCMBaseCollectionHeaderFooterView : UICollectionReusableView

@property (nonatomic, assign, readonly) BOOL isHeader;
@property (nonatomic, assign, readonly) NSIndexPath *indexPath;
@property (nonatomic,strong) IDCMBaseCollectionViewModel *viewModel;
@property (nonatomic,strong) IDCMBaseCollectionSectionModel *sectionViewModel;


- (void)initConfig;
- (void)reloadHeaderFooterViewData;
- (void)configureHeaderFooterView;
+ (instancetype)headerFooterViewWithCollectionView:(UICollectionView *)collectionView
                                         indexPath:(NSIndexPath *)indexPath
                                          isHeader:(BOOL)isHeader
                                         viewModel:(IDCMBaseCollectionViewModel *)viewModel;
@end
