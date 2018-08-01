//
//  IDCMHomeAmountView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/18.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMHomeAmountView : UIView
/**
 创建一个AmountView
 
 @param amountSignal 账号信息
 @param addCoinCommand 添加币种信号
 @return AmountView
 */
+ (instancetype)bondSureViewWithAmountInput:(RACSignal *)amountSignal
                             addCoinCommand:(CommandInputBlock)addCoinCommand;
@end
