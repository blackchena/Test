//
//  IDCMBaseTableViewController.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/19.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@class IDCMBaseViewModel;

@interface IDCMBaseTableViewController : QMUICommonTableViewController

/**
 *  viewModel
 */
@property (strong, nonatomic, readonly) IDCMBaseViewModel *viewModel;

- (instancetype)initWithViewModel:(IDCMBaseViewModel *)viewModel withStyle:(UITableViewStyle)style;
- (void)bindViewModel;
+ (void)popCallBack:(NSDictionary *)para;

@end
