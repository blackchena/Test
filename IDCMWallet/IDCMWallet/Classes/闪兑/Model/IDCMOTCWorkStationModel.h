//
//  IDCMOTCWorkStationModel.h
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMOTCWorkStationPayType : IDCMBaseModel

@property (nonatomic, strong)NSString  *PayCode;
@property (nonatomic, strong)NSString  *PayLogo;

@end

@interface IDCMOTCWorkStationModel : IDCMBaseModel
/*
 Amount = 25;
 PayTypes = [
 {
 PayCode = "AliPay";
 PayLogo = "http://192.168.1.36:8888//group1/M00/00/00/wKgBJFrv_LyAT9E9AAADHTnwWMQ222.png"
 },
 {
 PayCode = "Bankcard";
 PayLogo = "http://192.168.1.36:8888//group1/M00/00/00/wKgBJFrv_LyAfuDdAAABFsnylhY430.png"
 }
 ];
 AvgPayTime = 114193;
 UserId = 5382;
 QuoteTime = "2018-05-14T15:45:56";
 AvgUploadPayTime = 0;
 AppealCount = 0;
 AvgResponseTime = 12;
 OrderId = 836;
 AcceptantName = "BinBear";
 Price = 6.25;
 QuoteId = 3694;
 AvgConfirmReceiveTime = 0
 */
/// 订单ID
@property (nonatomic, assign)NSInteger OrderId;
/// 用户ID
@property (nonatomic, assign)NSInteger UserId;
/// 报价单ID
@property (nonatomic, assign)NSInteger QuoteId;
/// 报价总金额
@property (nonatomic, strong)NSNumber *Amount;
/// 申报时间
@property (nonatomic, strong)NSString  *QuoteTime ;
/// 承兑商名称
@property (nonatomic, strong)NSString  *AcceptantName;
/// 申诉次数
@property (nonatomic, assign)NSInteger AppealCount;
/// 平均响应时间单位秒
@property (nonatomic, assign)NSInteger  AvgResponseTime;
/// 平均支付时间单位秒
@property (nonatomic, assign)NSInteger  AvgPayTime;
/// 平均上传支付凭证时间单位秒
@property (nonatomic, assign)NSInteger  AvgUploadPayTime;
/// 平均确认时间单位秒
@property (nonatomic, assign)NSInteger  AvgConfirmReceiveTime ;

@property (nonatomic, strong)NSArray   <IDCMOTCWorkStationPayType*>*PayTypes ;


//自己添加
@property(nonatomic, strong)NSString * CurrencyCode;// (string, optional): 法定货币编码 ,
@property(nonatomic, assign)BOOL isSell;// 是否卖出
@end
