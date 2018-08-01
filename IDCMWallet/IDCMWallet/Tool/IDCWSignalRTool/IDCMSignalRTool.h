//
//  IDCMSignalRTool.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/15.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMSignalRTool : NSObject

/************ 初始化相关 *************/
/**
 获取SignalR实例
 
 @return 返回SignalR实例
 */
+ (instancetype)sharedSignal;
/**
 获取signalRUrl
 */
- (void)getSignalrUrl;
/**
 关闭signalR
 */
- (void)closeSignalR;
/************ 推送 *************/
/**
 *  最新价格推送
 */
@property (strong, nonatomic) RACSubject *realTrendSubject;
@end
