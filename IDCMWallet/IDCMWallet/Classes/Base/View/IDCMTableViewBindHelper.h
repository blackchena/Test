//
//  IDCMTableViewBindHelper.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/10.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDCMTableViewBindHelperConfig;


// 配置TableView信息的Block
typedef IDCMTableViewBindHelperConfig *(^tableViewBindObjectBlock)(id value);
typedef IDCMTableViewBindHelperConfig *(^tableViewBindIntTypeBlock)(NSInteger value);
typedef IDCMTableViewBindHelperConfig *(^tableViewBindFloatTypeBlock)(CGFloat value);
// 提供外部配置Block
typedef void (^tableViewBindConfigBlock)(IDCMTableViewBindHelperConfig *configure);



/*********  配置类  ***********/
@interface IDCMTableViewBindHelperConfig : NSObject
// TableView的动画
- (tableViewBindIntTypeBlock)tableViewAnimationType;
// TableView的组数
- (tableViewBindIntTypeBlock)numberOfSections;
// TableView的组的头部视图的高度
- (tableViewBindFloatTypeBlock)headerSectionViewHeight;
// TableView的组的底部视图的高度
- (tableViewBindFloatTypeBlock)footerSectionViewHeight;
// TableView的组的头部视图
- (tableViewBindObjectBlock)headerInSectionView;
// TableView的组的底部视图
- (tableViewBindObjectBlock)footerInSectionView;

@end


@interface IDCMTableViewBindHelper : NSObject


/**
 xib创建cell时调用
 
 @param tableView tableview
 @param source 数据信号
 @param didSelectionCommand cell选中信号
 @param templateCell Nib的类名
 @return 配置好的tableview
 */
+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)didSelectionCommand
                       templateCellWithNib:(NSString *)templateCell;

/**
 代码创建cell时调用
 
 @param tableView tableview
 @param source 数据信号
 @param didSelectionCommand cell选中信号
 @param templateCell cell的类名
 @return 配置好的tableview
 */
+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)didSelectionCommand
                              templateCell:(NSString *)templateCell;

/**
 代码创建cell时调用
 
 @param tableView tableview
 @param source 数据信号
 @param didSelectionCommand cell选中信号
 @param templateCell cell的类名
 @param configBlock 配置的block
 @return 配置好的tableview
 */
+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)didSelectionCommand
                              templateCell:(NSString *)templateCell
                      tableviewConfigBlock:(tableViewBindConfigBlock)configBlock;

@end
