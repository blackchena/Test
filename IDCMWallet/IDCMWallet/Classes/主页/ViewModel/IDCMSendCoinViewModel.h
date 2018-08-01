//
//  IDCMSendCoinViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMRecommendModel.h"
@class IDCMCurrencyMarketModel;


typedef NS_ENUM(NSUInteger, IDCMCurrencyLayoutType) {
    kIDCMCurrencyLayoutTypeNomal              = 1, // 正常
    kIDCMCurrencyLayoutTypeHidenSlider        = 2, // 隐藏滑条
    kIDCMCurrencyLayoutTypeHidenFee           = 3  // 隐藏矿工费
};


@interface IDCMSendCoinViewModel : IDCMBaseViewModel
/**
 *  market model
 */
@property (strong, nonatomic) IDCMCurrencyMarketModel *marketModel;
/**
 *  推荐费用 model
 */
@property (strong, nonatomic) IDCMRecommendModel *recommendModel;
/**
 *   接收地址
 */
@property (copy, nonatomic) NSString *reciveAddress;
/**
 *   发送数量
 */
@property (copy, nonatomic) NSString *amount;
/**
 *   备注
 */
@property (copy, nonatomic) NSString *comment;
/**
 *   费用
 */
@property (copy, nonatomic) NSNumber *fee;
/**
 *   支付密码
 */
@property (copy, nonatomic) NSString *payPassword;

@property (nonatomic, strong) RACSignal *validAddressSignal;
/**
 *  验证地址合法性
 */
@property (strong, nonatomic) RACCommand *varifyAddressCommand;
/**
 *  发送
 */
@property (strong, nonatomic) RACCommand *sendCommand;
/**
 *  发送
 */
@property (strong, nonatomic) RACCommand *sendFaceIDCommand;
/**
 *  获取推荐的费用
 */
@property (strong, nonatomic) RACCommand *getRecommendedFeeCommand;
/**
 *  校验提交发送的虚拟币表单
 */
@property (strong, nonatomic) RACCommand *validSendFormCommand;
/**
 *  切割地址
 */
@property (strong, nonatomic) RACCommand *validComplicatedAddressCommand;
/**
 *  是否隐藏slider
 */
@property (assign, nonatomic) IDCMCurrencyLayoutType currencyLayoutType;
@end
