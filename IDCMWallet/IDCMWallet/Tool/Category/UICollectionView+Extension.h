//
//  UICollectionView+Extension.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Extension)

- (void)registerCellWithCellClass:(Class)cellClass;
- (void)registerCellWithCellClasses:(NSArray<Class> *)cellClasses;

- (void)registerHeaderWithViewClass:(Class)viewClass;
- (void)registerHeaderWithViewClasses:(NSArray<Class> *)viewClasses;

- (void)registerFooterWithViewClass:(Class)viewClass;
- (void)registerFooterWithViewClasses:(NSArray<Class> *)viewClasses;

@end
