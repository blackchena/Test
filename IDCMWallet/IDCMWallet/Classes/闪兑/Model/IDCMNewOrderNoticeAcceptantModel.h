//
//  IDCMNewOrderNoticeAcceptantModel.h
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMNewOrderNoticeAcceptantModel : IDCMBaseModel

/*
 {
 AcceptantId = 4308;
 Amount = 5;
 CoinCode = btc;
 CoinId = 1;
 CoinName = Bitcoin;
 CreateDate = "2018-05-09T17:11:40";
 CreateTimestamp = 0;
 CurrencyId = 1;
 DeadLineSecond = 0;
 DeadLineTime = "2018-05-09T17:14:40";
 DeadLineTimestamp = 0;
 Direction = 1;
 OrderID = 234;
 OrderNO = 20180509171140232400000002;
 PayCode = AliPay;
 PayLogo = "http://192.168.1.36:8888//group1/M00/00/00/wKgBJFrv_LyAT9E9AAADHTnwWMQ222.png";
 UserId = 4303;
 UserAppealCount = 0;
 UserAvgBuyinTime = 0;
 UserAvgConfirmReceiveTime = 0;
 UserAvgPayTime = 0;
 UserAvgSelloutTime = 0;
 UserName = Gold;
 }
 */
@property(nonatomic, assign)NSInteger  AcceptantId;// (integer, optional): 承兑商ID ,
@property(nonatomic, assign)NSInteger  OrderID;// (integer, optional): 定单ID ,
@property(nonatomic, strong)NSString * UserName;// (string, optional): 用户名 ,
@property(nonatomic, assign)NSInteger  UserId;// (integer, optional): 用户ID ,
@property(nonatomic, assign)NSInteger  CoinId;// (integer, optional): 虚拟币ID ,
@property(nonatomic, assign)NSInteger  CurrencyId;// (integer, optional): 法定货币 ,
@property(nonatomic, strong)NSString * CurrencyName;// (string, optional): 法定货币名称 ,
@property(nonatomic, strong)NSString * CurrencyCode;// (string, optional): 法定货币编码 ,
@property(nonatomic, strong)NSString * CoinName;// (string, optional): 虚拟币名称 ,
@property(nonatomic, strong)NSString * CoinCode ;//(string, optional): 虚拟币编码 ,
@property(nonatomic, strong)NSDecimalNumber *Amount;// (number, optional): 总价 ,
@property(nonatomic, strong)NSDecimalNumber *Num;// (number, optional):  数量  ,
@property(nonatomic, strong)NSString * PayCode;// (string, optional): 支付编码 ,
@property(nonatomic, strong)NSString * PayLogo;// (string, optional): 支付方式图标 ,
@property(nonatomic, assign)NSInteger  Direction;// (integer, optional): 交易方向 = ['1', '2'],
@property(nonatomic, strong)NSString * DeadLineTime;// (string, optional): 截止时间 ,
@property(nonatomic, assign)NSInteger  DeadLineTimestamp;// (integer, optional): 截止时间戳 ,
@property(nonatomic, assign)NSInteger  DeadLineSeconds;// (integer, optional): 距离截止时间剩余秒数 ,
@property(nonatomic, strong)NSString * OrderNO;// (string, optional): 订单编号 ,
@property(nonatomic, strong)NSString * CreateDate ;//(string, optional): 报单时间 ,
@property(nonatomic, assign)NSInteger  CreateTimestamp;// (integer, optional): 报单时间戳 ,
// (integer, optional): 报价单状态 = ['1待确认', '2取消', '3待转账', '4完成', '5无效', '6报价被选中', '7已经支付', '8通知承兑商']
@property(nonatomic, assign)NSInteger  Status;
@property(nonatomic, assign)NSInteger  UserAppealCount;// 被申诉次数
@property(nonatomic, assign)NSInteger  UserAvgPayTime;// 平均支付时间
@property(nonatomic, assign)NSInteger  UserAvgBuyinTime;// 平均买入时间
@property(nonatomic, assign)NSInteger  UserAvgConfirmReceiveTime;// 平均响应时间
@property(nonatomic, assign)NSInteger  UserAvgSelloutTime;// 平均收款时间
@property(nonatomic, strong)NSDecimalNumber * Price;// (number, optional): 推荐报价
@property(nonatomic, strong)NSDecimalNumber * LastPrice;// (number, optional): 最新价
@property(nonatomic, strong)NSDecimalNumber * Premium;// (number, optional): 溢价比例
@property(nonatomic, assign)BOOL  IsPremium;// 是否设置了溢价


// 默认剩余秒数
@property(nonatomic, assign)NSInteger  defDeadLineSeconds;

//是否报价
@property(nonatomic, assign)BOOL  didOffer;
//用户是否选中报价
@property(nonatomic, assign)BOOL  didSelected;

@end
