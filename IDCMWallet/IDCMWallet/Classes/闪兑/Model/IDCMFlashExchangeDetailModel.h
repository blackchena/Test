//
//  IDCMFlashExchangeDetailModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseTableCellModel.h"

@interface IDCMFlashExchangeDetailModel : IDCMBaseTableCellModel

/*
 data =     {
 Amount = 1;
 BlockViewUrl = "https://www.blocktrail.com/BTC/tx/";
 Comment = "";
 CompleteTime = "<null>";
 ConfirmCount = "<null>";
 CreateTime = "2018-03-28 17:15:21";
 Currency = btc;
 Direction = "<null>";
 ExchangeRate = "0.11";
 FailReason = "<null>";
 Fee = 0;
 Id = 82;
 InStatus = 2;
 Logo = "http://file.idcw.io//upload/coin/ico_btc.png";
 MinCount = "<null>";
 OutStatus = "<null>";
 RateDigit = 3;
 ReceiveConfirmTime = "<null>";
 SearchEndTime = "<null>";
 SearchStartTime = "<null>";
 SendConfirmTime = "<null>";
 Status = 4;
 StatusDescription = "\U4ea4\U6613\U5931\U8d25";
 ToAmount = 1;
 ToBlockViewUrl = "https://blockchair.com/bitcoin-cash/transaction/";
 ToConfirmCount = "<null>";
 ToCurrency = bch;
 ToFee = 0;
 ToLogo = "http://file.idcw.io//upload/coin/ico_bch.png";
 ToMinCount = "<null>";
 ToTxId = "<null>";
 TxId = "<null>";
 UserId = 5471;
 };
 */

// 用户ID
@property (nonatomic,copy) NSString *UserId;
// 交易Id
@property (nonatomic,copy) NSString *Id;

// 兑入TxId
@property (nonatomic,copy) NSString *TxId;
// 兑出TxId
@property (nonatomic,copy) NSString *ToTxId;

// 区块链浏览器url
@property (nonatomic,copy) NSString *BlockViewUrl;
@property (nonatomic,copy) NSString *ToBlockViewUrl;
@property (nonatomic,strong) NSNumber *RateDigit;

// 创建时间
@property (nonatomic,copy) NSString *CreateTime;
// 发送确认时间
@property (nonatomic,copy) NSString *SendConfirmTime;
// 接收确认时间
@property (nonatomic,copy) NSString *ReceiveConfirmTime;
// 完成时间
@property (nonatomic,copy) NSString *CompleteTime;
// 兑入币种
@property (nonatomic,copy) NSString *Currency;
// 兑出币种
@property (nonatomic,copy) NSString *ToCurrency;

// 兑入数量
@property (nonatomic,strong) NSNumber *Amount;
// 兑出数量
@property (nonatomic,strong) NSNumber *ToAmount;

//  兑入币logo
@property (nonatomic,copy) NSString *Logo;
// 兑出币logo
@property (nonatomic,copy) NSString *ToLogo;

// 兑出最小确认数
@property (nonatomic,strong) NSNumber *MinCount;
// 兑出当前确认数
@property (nonatomic,strong) NSNumber *ConfirmCount;
// 兑入最小确认数
@property (nonatomic,strong) NSNumber *ToMinCount;

// 兑入当前确认数
@property (nonatomic,strong) NSNumber *ToConfirmCount;

// 兑入矿工费
@property (nonatomic,strong) NSNumber *Fee;
// 兑出矿工费
@property (nonatomic,strong) NSNumber *ToFee;
// 兑换汇率
@property (nonatomic,strong) NSNumber *ExchangeRate;

@property (nonatomic,copy) NSString *Unit;


/*

 
 public enum ExchangeStatus
 {

 [Description("进行中")]
 Start = 0,

 [Description("已完成")]
 End = 1,

 [Description("退还成功")]
 ReturnSuccess = 2,

 [Description("退还失败")]
 ReturnFail = 3,

 [Description("交易失败")]
 Fail = 4
 }
 
 public enum ExchangeInStatus
 {

 [Description("兑入中")]
 Send = 0,

 [Description("兑入确认")]
 SendComplete = 1,

 [Description("兑入失败")]
 SendFail = 2
 }
 
 public enum ExchangeOutStatus
 {

 [Description("兑出中")]
 Recive = 0,

 [Description("兑出确认")]
 ReciveComplete = 1,

 [Description("兑出失败")]
 ReciveFail = 2
 }
 */

/*

 * 0是兑出中。
 * 1是兑入中，兑出完成。
 * 2是兑入完成，兑出完成
 * 3是兑入完成，兑出完成
 * 4是兑出失败，兑入失败
 * 5是兑出成功，兑入失败
 * */


@property (nonatomic,copy) NSString *OutStatus;
@property (nonatomic,copy) NSString *InStatus;


@property (nonatomic,copy) NSString *Status;
@property (nonatomic,copy) NSString *StatusDescription; // 状态描述
@property (nonatomic,copy) NSString *SearchStartTime;
@property (nonatomic,copy) NSString *SearchEndTime;
@property (nonatomic,copy) NSString *Comment;


// 自定义属性
@property (nonatomic,copy) NSString *customerCashOut;
@property (nonatomic,copy) NSString *customerCashOutState;

@property (nonatomic,copy) NSString *customerCashEnter;
@property (nonatomic,copy) NSString *customerCashEnterState;

@property (nonatomic,copy) NSString *customerExchangeOutFee;
@property (nonatomic,copy) NSString *customerExchangeRate;
@property (nonatomic,copy) NSString *customerExchangeTime;


@end





