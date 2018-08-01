//
//  IDCMExchangeListModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseTableCellModel.h"


@interface IDCMFlashExchangeRecordModel : IDCMBaseTableCellModel

/*
 "Exchange": null,
 "Rate": 0.0,
 "Currency": "btc",
 "ToCurrency": "bch",
 "UserId": 5471,
 "Amount": 1.000,
 "ToAmount": 1.000,
 "CreateTime": "2018-03-28 16:50:48",
 "DateType": "week",
 "Date": 3,
 "Status": 4,
 "StatusDescription": "交易失败",
 "InStatus": 2,
 "TxId": null,
 "ToTxId": null,
 "OutStatus": null,
 "Comment": "",
 "MinCount": null,
 "ConfirmCount": null,
 "ToMinCount": 0,
 "ToConfirmCount": 0,
 "id": 79
 */


// 主键
@property (nonatomic,copy) NSString *ID;
// 用户id
@property (nonatomic,copy) NSString *UserId;


// 交易对
@property (nonatomic,copy) NSString *Exchange;
// 备注
@property (nonatomic,copy) NSString *Comment;
// 状态描述
@property (nonatomic,copy) NSString *StatusDescription;
/*
 * 0是兑出中。
 * 1是兑入中，兑出完成。
 * 2是兑入完成，兑出完成
 * 3是兑入完成，兑出完成
 * 4是兑出失败，兑入失败
 * 5是兑出成功，兑入失败
 * */
@property (nonatomic,copy) NSString *Status;
/*
 public enum ExchangeInStatus
 {
 
 [Description("兑入中")]
 Send = 0,
 
 [Description("兑入确认")]
 SendComplete = 1,
 
 [Description("兑入失败")]
 SendFail = 2
 }
 */
@property (nonatomic,copy) NSString *InStatus;
@property (nonatomic,copy) NSString *OutStatus;

// 原币
@property (nonatomic,copy) NSString *Currency;
// 目标币
@property (nonatomic,copy) NSString *ToCurrency;


// 时间
@property (nonatomic,copy) NSString *Date;
// 时间类型
@property (nonatomic,copy) NSString *DateType;
// 创建时间
@property (nonatomic,copy) NSString *CreateTime;


// 原币数量
@property (nonatomic,strong) NSNumber *Amount;
// 目标币数量
@property (nonatomic,strong) NSNumber *ToAmount;
// 兑入最小确认数
@property (nonatomic,strong) NSNumber *MinCount;
// 兑出最小确认数
@property (nonatomic,strong) NSNumber *ToMinCount;
// 兑入当前确认数
@property (nonatomic,strong) NSNumber *ConfirmCount;
// 兑出当前确认数
@property (nonatomic,strong) NSNumber *ToConfirmCount;
// 汇率
@property (nonatomic,strong) NSNumber *Rate;



// 自定义属性
@property (nonatomic,copy) NSString *customerState;
@property (nonatomic,copy) NSString *customerTime;
@property (nonatomic,copy) NSString *customerCashOut;
@property (nonatomic,copy) NSString *customerCashEnter;


@end



