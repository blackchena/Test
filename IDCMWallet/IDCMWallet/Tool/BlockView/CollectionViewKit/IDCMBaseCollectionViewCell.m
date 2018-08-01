//
//  IDCMBaseCollectionViewCell.m
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseCollectionViewCell.h"


@interface IDCMBaseCollectionViewCell ()
@property (nonatomic, strong) NSIndexPath *indexPath;
@end


@implementation IDCMBaseCollectionViewCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfig];
    }
    return  self;
}

+ (instancetype)cellWithColletionView:(UICollectionView *)collectionView
                            indexPath:(NSIndexPath *)indexPath
                            viewModel:(IDCMBaseCollectionViewModel *)viewModel {
    
    IDCMBaseCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self)
                                              forIndexPath:indexPath];
    cell.cellViewModel = [viewModel getCellViewModelAtIndexPath:indexPath];
    cell.viewModel = viewModel;
    cell.indexPath = indexPath;
    [cell configureCell];
    return cell;
}

- (void)initConfig {}
- (void)configureCell {};
- (void)reloadCellData {};
- (void)setCustomSubViewsArray:(NSArray<UIView *> *)customSubViewsArray {
    _customSubViewsArray = customSubViewsArray;
    for (UIView *subView in customSubViewsArray) {
        [self.contentView addSubview:subView];
    }
}

@end







