//
//  IDCMTradingPageViewController.h
//  IDCMWallet
//
//  Created by BinBear on 2018/4/27.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBasePageViewController.h"
#import "IDCMTradingPageNavigationBar.h"

@interface IDCMTradingPageViewController : IDCMBasePageViewController
/**
 *  自定义导航
 */
@property (strong, nonatomic) IDCMTradingPageNavigationBar *idcw_navigationBar;
@end
