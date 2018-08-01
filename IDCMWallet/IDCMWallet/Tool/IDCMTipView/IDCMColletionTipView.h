//
//  IDCMColletionTipView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseCenterTipView.h"


typedef NS_ENUM(NSUInteger, ColletionTipViewPositonType) {
    ColletionTipViewPositonType_Center = 0,
    ColletionTipViewPositonType_Bottom
};

typedef void (^colltionTipViewItemClickBlock)(id model);

@interface IDCMColletionTipView : UIView


/**
 void

 @param title title
 @param cellClass 里面collectionView里面cell
 @param modelsArray 模型数据
 @param wHRatio item宽高比例
 @param interRows 有多少列
 @param maxLineRows 最多显示多少行
 @param margin 边框距离左右的距离
 @param contentInset item内容距离上下左右的距离
 @param lineSpacing 行间距
 @param interitemSpacing 列间距
 @param positionType 位置
 @param itemClickCallback 点击item回调
 */
+ (void)showWithTitle:(NSString *)title
            cellClass:(Class)cellClass
          modelsArray:(NSArray *)modelsArray
              wHRatio:(CGFloat)wHRatio
             interRows:(NSInteger)interRows
         maxLineRows:(NSInteger)maxLineRows
               margin:(CGFloat)margin
         contentInset:(UIEdgeInsets)contentInset
          lineSpacing:(CGFloat)lineSpacing
     interitemSpacing:(CGFloat)interitemSpacing
         positionType:(ColletionTipViewPositonType)positionType
    itemClickCallback:(colltionTipViewItemClickBlock)itemClickCallback;

/**
 void
 
 @param title title
 @param cellClass 里面collectionView里面cell
 @param modelsArray 模型数据
 @param itemSize item宽高
 @param interRows 有多少列
 @param maxLineRows 最多显示多少行
 @param margin 边框距离左右的距离
 @param contentInset item内容距离上下左右的距离
 @param lineSpacing 行间距
 @param interitemSpacing 列间距
 @param positionType 位置
 @param itemClickCallback 点击item回调
 */
+ (void)showWithTitle:(NSString *)title
            cellClass:(Class)cellClass
          modelsArray:(NSArray *)modelsArray
             itemSize:(CGSize)itemSize
            interRows:(NSInteger)interRows
          maxLineRows:(NSInteger)maxLineRows
               margin:(CGFloat)margin
         contentInset:(UIEdgeInsets)contentInset
          lineSpacing:(CGFloat)lineSpacing
     interitemSpacing:(CGFloat)interitemSpacing
         positionType:(ColletionTipViewPositonType)positionType
    itemClickCallback:(colltionTipViewItemClickBlock)itemClickCallback;

+ (void)reloadWithModels:(NSArray *)models;
+ (void)showHUD;
+ (void)dismissHUD;

+ (void)setAnimationFromViewForPropertyName:(NSString *)property
                                     toView:(UIView *)view
                                     offset:(CGPoint)offset;



@end














