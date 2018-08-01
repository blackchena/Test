//
//  IDCMHomeViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/22.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@class IDCMUserStateModel;

@interface IDCMHomeViewModel : IDCMBaseViewModel
/**
 *  获取钱包列表 包含币种名称及logo
 */
@property (strong, nonatomic) RACCommand *walletListCommand;
/**
 *  获取七天历史金额数据以及行情走势
 */
@property (strong, nonatomic) RACCommand *trendDataCommand;
/**
 *  获取用户状态
 */
@property (strong, nonatomic) RACCommand *getUserSateCommand;
/**
 *  获取用户最新消息
 */
@property (strong, nonatomic) RACCommand *getNewMessageCommand;
/**
 *  确认已读
 */
@property (strong, nonatomic) RACCommand *confirmReadCommand;
/**
 *  领币
 */
@property (strong, nonatomic) RACCommand *getCoinCommand;
/**
 *  跳转command
 */
@property (strong, nonatomic) RACCommand *selectCommand;
/**
 *  获取币种精度command
 */
@property (strong, nonatomic) RACCommand *getCurrencyPrecisionCommand;

/**
 *   是否显示活动弹窗
 */
@property (assign, nonatomic) BOOL isActive;
/**
 *  币种列表数据
 */
@property (strong, nonatomic) NSArray *walletListData;

// 取消下拉刷新请求
- (void)cancelRefreshRequest;
@end
