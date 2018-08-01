//
//  IDCMBaseCollectionViewCell.h
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMBaseCollectionCellModel.h"
#import "IDCMBaseCollectionViewModel.h"

@interface IDCMBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) NSIndexPath *indexPath;
@property (nonatomic, strong) NSArray<UIView *> *customSubViewsArray;
@property (nonatomic, strong) IDCMBaseCollectionViewModel *viewModel;
@property (nonatomic, strong) IDCMBaseCollectionCellModel *cellViewModel;


- (void)initConfig;
- (void)configureCell;
- (void)reloadCellData;
+ (instancetype)cellWithColletionView:(UICollectionView *)collectionView
                            indexPath:(NSIndexPath *)indexPath
                            viewModel:(IDCMBaseCollectionViewModel *)viewModel;
@end
