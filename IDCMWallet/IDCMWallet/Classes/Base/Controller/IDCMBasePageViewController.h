//
//  IDCMBasePageViewController.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <WMPageController/WMPageController.h>

@class IDCMBaseViewModel;

@interface IDCMBasePageViewController : WMPageController

/**
 *  viewModel
 */
@property (strong, nonatomic, readonly) IDCMBaseViewModel *viewModel;

- (instancetype)initWithViewModel:(IDCMBaseViewModel *)viewModel;
- (void)bindViewModel;
+ (void)popCallBack:(NSDictionary *)para;

@end
