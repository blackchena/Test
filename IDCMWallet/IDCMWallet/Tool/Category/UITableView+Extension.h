//
//  UITableView+Extension.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extension)

/**
 注册Cell 纯代码和XIB
 
 @param cellClass cell的类
 */
- (void)registerCellWithCellClass:(Class)cellClass;
- (void)registerCellWithCellClasses:(NSArray<Class> *)cellClasses;



/**
 注册 tableview 的 header 和 footer
 
 @param viewClass header 和 footer 的类
 */
- (void)registerHeaderFooterWithViewClass:(Class)viewClass;
- (void)registerHeaderFooterWithViewClasses:(NSArray<Class> *)viewClasses;

@end
