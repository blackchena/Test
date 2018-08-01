//
//  IDCMBackupMemorizingWordsViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMRandomListModel.h"

@interface IDCMBackupMemorizingWordsViewModel : IDCMBaseViewModel

@property (nonatomic,strong) RACCommand *timerCommand;
@property (nonatomic,strong) IDCMRandomListModel *listModel;
@property (nonatomic,strong) RACCommand *memorizingWordsCommand;

/**
 *  备份的类型  0:创建钱包时备份  1：进入应用时备份 2：老用户备份
 */
@property (strong, nonatomic) NSNumber *backupType;
/**
 *  是否是作为跟控制器
 */
@property (strong, nonatomic) NSNumber *isSetRootViewController;
@end
