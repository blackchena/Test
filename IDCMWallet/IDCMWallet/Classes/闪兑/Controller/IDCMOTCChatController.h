//
//  IDCMOTCChatController.h
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/4.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewController.h"

@interface IDCMOTCChatController : IDCMBaseViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, assign) BOOL isSell;

- (void)orderDown;
- (void)orderDoing;

- (void)setToBottom:(BOOL)animated;

@end
