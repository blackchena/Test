//
//  IDCMOTCSignalRTool.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/4.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, IDCMOTCSignalRState) {
    kIDCMOTCSignalRStateClose      = 1, // 关闭
    kIDCMOTCSignalRStateOpen       = 2, // 打开
    kIDCMOTCSignalRStateAdd        = 3, // 加组成功
    kIDCMOTCSignalRStateLeave      = 4, // 退组成功
};

typedef NS_ENUM(NSUInteger, IDCMOTCChatType) {
    kIDCMOTCChatMessageType    = 1, // 消息
    kIDCMOTCChatImageType      = 2, // 图片
};

typedef void(^completionHandler)(RACSignal *signal);


@interface IDCMOTCSignalRTool : NSObject
/************ 初始化相关 *************/
/**
 获取SignalR实例

 @return 返回SignalR实例
 */
+ (instancetype)sharedOTCSignal;

/**
 获取signalRUrl
 */
- (void)getSignalrUrl;

/**
 建立连接
 */
- (void)initHub;
/**
 关闭signalR
 */
- (void)closeSignalR;
/**
 *  连接状态
 */
@property (assign, nonatomic)  IDCMOTCSignalRState signalState;
/************ 聊天相关 *************/
/**
 加入聊天组

 @param orderNum 订单号，不能为空
 */
- (void)addChatGroup:(NSString *)orderNum;
/**
 退出聊天组
 */
- (void)leaveChatGroup;

/**
 发送消息

 @param type 消息类型
 @param content 内容
 @param block 回调block
 */
- (void)sendChatType:(IDCMOTCChatType)type andWithContent:(id)content completionHandler:(completionHandler)block;

/**
 *  获取推送的消息
 */
@property (strong, nonatomic) RACSubject *otcChatMessageSubject;

/************ 订单相关 *************/
/**
 *  推送用户确认报价信息
 */
@property (strong, nonatomic) RACSubject *confirmQuoteOrderSubject;
/**
 *  下单推送到承兑商
 */
@property (strong, nonatomic) RACSubject *otcNewestOrderSubject;
/**
 *  订单状态变更通知到承兑商
 */
@property (strong, nonatomic) RACSubject *otcOrderStatusChangeSubject;
/**
 *  系统通知
 */
@property (strong, nonatomic) RACSubject *ootcNotificationSubject;
/**
 *  承兑商报价通知客户
 */
@property (strong, nonatomic) RACSubject *quotePriceNotificationSubject;
@end
