//
//  IDCMNewCurrencyTradingModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/28.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseTableCellModel.h"


typedef NS_ENUM(NSUInteger, IDCMDealType) {
    kIDCMDealTypeSend          = 1, // 已发送
    kIDCMDealTypeAccept        = 2  // 已接收
};


@interface IDCMNewCurrencyTradingModel : IDCMBaseTableCellModel
/**
 *  id
 */
@property (strong, nonatomic) NSNumber *ID;
/**
 *   时间
 */
@property (copy, nonatomic) NSString *create_time;
/**
 *   发送地址
 */
@property (copy, nonatomic) NSString *send_address;
/**
 *   接收地址
 */
@property (copy, nonatomic) NSString *receiver_address;
/**
 *   备注
 */
@property (copy, nonatomic) NSString *remark;
/**
 *   类别
 */
@property (strong, nonatomic) NSNumber *trade_type;
/**
 *   货币数量
 */
@property (strong, nonatomic) NSNumber *amount;
/**
 *   交易费用
 */
@property (strong, nonatomic) NSNumber *tx_fee;
/**
 *   确认数
 */
@property (copy, nonatomic) NSString *confirmations;
/**
 *   确认总数
 */
@property (copy, nonatomic) NSString *total_confirmations;
/**
 *   确认描述
 */
@property (copy, nonatomic) NSString *confirmation_des;
/**
 *   货币单位
 */
@property (copy, nonatomic) NSString *currency;
/**
 *   交易ID
 */
@property (copy, nonatomic) NSString *txhash;
/**
 *   区块链哈希
 */
@property (copy, nonatomic) NSString *blockhash;

/********** 2.1新增 **************/
/**
 *  区块浏览器跳转链接
 */
@property (copy, nonatomic) NSString *url;
/**
 *  是否跳转
 */
@property (assign, nonatomic) BOOL isJump;

/**
 *  时间单位
 */
@property (copy, nonatomic) NSString *intervalUnit;// = day;;
/**
 *   时间值
 */

@property (nonatomic,strong) NSNumber *timeInterval;// = 2;

/********** 2.2.1新增 **************/
/**
 *  是否代币
 */
@property (assign, nonatomic) BOOL isToken;
/**
 *  交易状态 0：转汇失败  1：转汇正常
 */
@property (assign, nonatomic) BOOL txReceiptStatus;
/**
 *  代币单位
 */
@property (copy, nonatomic) NSString *tokenUnit;
/**
 *  代币分类单位
 */
@property (copy, nonatomic) NSString *categoryUnit;


/**
 customer
 */
@property (nonatomic,strong) NSString *customerTime;

@property (nonatomic,strong) NSDictionary *timeDict;
@end
