//
//  IDCMCollectionViewBindHelper.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/22.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMCollectionViewBindHelper : NSObject

@property (weak, nonatomic) id<UICollectionViewDelegate> delegate;

/**
 xib创建cell时调用
 
 @param collectionView collectionView
 @param source 数据信号
 @param didSelectionCommand cell选中信号
 @param templateCell Nib的类名
 @return 配置好的collectionView
 */
+ (instancetype) bindingHelperForCollectionView:(UICollectionView *)collectionView
                                   sourceSignal:(RACSignal *)source
                               selectionCommand:(RACCommand *)didSelectionCommand
                            templateCellWithNib:(NSString *)templateCell;

/**
 代码创建cell时调用
 
 @param collectionView collectionView
 @param source 数据信号
 @param didSelectionCommand cell选中信号
 @param templateCell cell的类名
 @return 配置好的collectionView
 */
+ (instancetype) bindingHelperForCollectionView:(UICollectionView *)collectionView
                                   sourceSignal:(RACSignal *)source
                               selectionCommand:(RACCommand *)didSelectionCommand
                                   templateCell:(NSString *)templateCell;

@end
