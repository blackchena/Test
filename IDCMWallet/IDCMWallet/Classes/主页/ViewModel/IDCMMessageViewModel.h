//
//  IDCMMessageViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/31.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMMessageViewModel : IDCMBaseViewModel
/**
 *  删除消息
 */
@property (strong, nonatomic) RACCommand *deleteMessageCommand;
/**
 *  确认已读
 */
@property (strong, nonatomic) RACCommand *confirmReadCommand;
/**
 每页请求的数据的数量
 */
@property (strong, nonatomic) NSNumber *pageSize;
/**
 *  数据总页数
 */
@property (strong, nonatomic) NSNumber *totalPage;

- (NSString *)getRequsetParmaWithIndex:(NSInteger)index;
@end
