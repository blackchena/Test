//
//  IDCMAcceptantViewController.h
//  IDCMWallet
//
//  Created by wangpu on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBasePageViewController.h"

@interface IDCMAcceptantViewController : IDCMBasePageViewController<WMPageControllerDelegate,WMPageControllerDataSource>

@property (nonatomic,assign) BOOL  isNeedRefresh ; //查询当前状态

@end
