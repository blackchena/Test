//
//  IDCMMarketViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"


typedef void(^flashExchangeSuber)(id);
typedef void(^completionAction)(NSString *pinPassword);
typedef NS_ENUM(NSUInteger, FlashExchangeCheckSignalType) {
    FlashExchangeCheckSignalType_NoSetPIN   ,     // 没有设置PIN
    FlashExchangeCheckSignalType_HasIDTouch ,    // 设置了指纹首选
    FlashExchangeCheckSignalType_HasSetPIN      //  没有设置指纹首选 设置了PIN
};



@interface IDCMMarketViewModel : IDCMBaseViewModel



/**
  将币币闪兑按钮UI事件信号 FlattenMap 成业务信号
 */
+ (RACSignal *(^)(id))flashExchangeCheckSignalFlattenMap;



/**
  币币闪兑业务信号的订阅函数subscriber

 @param action 验证成功的函数
 @return 返回信号订阅函数
 */
+ (flashExchangeSuber)flashExchangeCheckSignalSuberWithCompletionAction:(completionAction)action;



@end



