//
//  IDCMFlashExchangeRecordController.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewController.h"
#import "IDCMBlockBaseTableView.h"

@interface IDCMFlashExchangeRecordController : IDCMBaseViewController

@property (nonatomic,strong) IDCMBlockBaseTableView *tableView;
@property (nonatomic,assign) BOOL netRequestDone;

@end
