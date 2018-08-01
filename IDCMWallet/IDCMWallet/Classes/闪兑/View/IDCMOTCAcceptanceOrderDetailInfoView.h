//
//  IDCMOTCAcceptanceOrderDetailInfoView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IDCMOTCAcceptanceOrderType) {
    kIDCMOTCAcceptanceOrderBuyType       = 1, // 买
    kIDCMOTCAcceptanceOrderSellType      = 2, // 卖
};

@interface IDCMOTCAcceptanceOrderDetailInfoModel : NSObject
/**
 *  买卖类型
 */
@property (assign, nonatomic) IDCMOTCAcceptanceOrderType type;
/**
 *   标题
 */
@property (copy, nonatomic) NSString *title;
/**
 *   卖家
 */
@property (copy, nonatomic) NSString *user;
/**
 *   支付方式logo
 */
@property (copy, nonatomic) NSString *payLogo;
/**
 *   次数
 */
@property (copy, nonatomic) NSString *countNum;
/**
 *   响应时间/支付时间
 */
@property (copy, nonatomic) NSString *payResponeTime;
/**
 *   买入时间/收款时间
 */
@property (copy, nonatomic) NSString *buyColeectionTime;
@end

@interface IDCMOTCAcceptanceOrderDetailInfoView : UIView
/**
 *  绑定数据
 */
@property (strong, nonatomic) RACSubject *dataSubject;
@end
