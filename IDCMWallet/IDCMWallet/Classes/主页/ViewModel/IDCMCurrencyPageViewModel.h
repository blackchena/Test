//
//  IDCMCurrencyPageViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMCurrencyPageViewModel : IDCMBaseViewModel
/**
 *  选中时的标题尺寸
 *
 */
@property (nonatomic, assign) CGFloat titleSizeSelected;

/**
 *  非选中时的标题尺寸
 *
 */
@property (nonatomic, assign) CGFloat titleSizeNormal;

/**
 *  标题选中时的颜色, 颜色是可动画的.
 *
 */
@property (nonatomic, strong) UIColor * _Nullable titleColorSelected;

/**
 *  标题非选择时的颜色, 颜色是可动画的.
 *
 */
@property (nonatomic, strong) UIColor * _Nullable titleColorNormal;

/**
 *  标题的字体名字
 *
 */
@property (nonatomic, nullable, copy) NSString *titleFontName;
@end
