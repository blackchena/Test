//
//  IDCMBaseCollectionHeaderFooterView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseCollectionHeaderFooterView.h"


@interface IDCMBaseCollectionHeaderFooterView ()
@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, assign) NSIndexPath *indexPath;
@end


@implementation IDCMBaseCollectionHeaderFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfig];
    }
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfig];
    }
    return self;
}

+ (instancetype)headerFooterViewWithCollectionView:(UICollectionView *)collectionView
                                         indexPath:(NSIndexPath *)indexPath
                                          isHeader:(BOOL)isHeader
                                         viewModel:(IDCMBaseCollectionViewModel *)viewModel {
    IDCMBaseCollectionHeaderFooterView *headerFooterView = [collectionView
                                                          dequeueReusableSupplementaryViewOfKind:(isHeader ? UICollectionElementKindSectionHeader : UICollectionElementKindSectionFooter) withReuseIdentifier:NSStringFromClass(self) forIndexPath:indexPath];
    headerFooterView.sectionViewModel = [viewModel getSectionViewModelAtSection:indexPath.section];
    headerFooterView.isHeader = isHeader;
    headerFooterView.indexPath = indexPath;
    headerFooterView.viewModel = viewModel;
    [headerFooterView configureHeaderFooterView];
    return headerFooterView;
}

- (void)initConfig {self.backgroundColor = [UIColor whiteColor];}
- (void)reloadHeaderFooterViewData {}
- (void)configureHeaderFooterView{};
@end













