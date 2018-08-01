//
//  IDCMOTCExchangeRecordModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseTableCellModel.h"

@interface IDCMOTCExchangeRecordModel : IDCMBaseTableCellModel

@property(nonatomic, assign)NSInteger UserId;// (integer, optional): 用户ID ,
@property(nonatomic, strong)NSString *UserName;
@property(nonatomic, strong)NSString *OrderNo;// (string, optional): 订单号 ,
@property(nonatomic, assign)NSInteger Direction;// (integer, optional): 1.买入;2.卖出 = ['1', '2'],
@property(nonatomic, strong)NSNumber *Num;// (number, optional): 数量 ,
@property(nonatomic, assign)NSInteger CoinId;// (integer, optional): 币种ID ,
@property(nonatomic, strong)NSString *CoinName;// (string, optional): 虚拟币名称 ,
@property(nonatomic, strong)NSString *CoinCode;// (string, optional): 虚拟币编码 ,
@property(nonatomic, strong)NSString *LocalCurrencyName;// (string, optional): 法定货币名称 ,
@property(nonatomic, strong)NSString *LocalCurrencySymbol;// (string, optional): 法定货币符号 ,
@property(nonatomic, assign)NSInteger LocalCurrencyId;// (integer, optional): 法币ID ,
@property(nonatomic, strong)NSString *AcceptantName;// (string, optional): 承兑商名称 ,
@property(nonatomic, assign)NSInteger PaymentModeId;// (integer, optional): 支付方式ID ,
@property(nonatomic, strong)NSString *PaymentData;// (string, optional): 支付信息 ,
@property(nonatomic, assign)NSInteger PrevStatus;// (integer, optional): 订单超时，上一订单状态 = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '8', '9', '10', '11'],

/**
 ['0', '1', '2', '3', '4', '5', '6', '7', '8', '8', '9', '10', '11'],
 0  待报价
 1  待转账
 2  已转账
 3  已支付
 4  申诉中
 5  待上传支付凭证
 6  待审核
 7  客服退回
 8  客服放币
 9  取消
 10 待退币
 11 同意退还
 12 完成
 */
@property(nonatomic, assign)NSInteger Status;// (integer, optional): 1.报价中 = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '8', '9', '10', '11'],
@property(nonatomic, strong)NSString *StatusTime;// (string, optional): 当前状态剩余时间，用于倒计时 ,
@property(nonatomic, assign)BOOL IsTimeExpand;// (boolean, optional): 进行中的订单可以延长时间，延长时间只能使用一次，持币方才有权限延长时间 ,
@property(nonatomic, assign)NSInteger AcceptantUserId;// (integer, optional): 承兑商 ,
@property(nonatomic, strong)NSNumber *Amount;// (number, optional): 总金额 ,
@property(nonatomic, assign)NSInteger UploadUserId;// (integer, optional): 上传凭证方 ,
@property(nonatomic, strong)NSArray <NSString*>*CertificateImages;// (Array[string], optional): 凭证图片信息 ,
@property(nonatomic, assign)NSInteger CreateUserId;// (integer, optional): 创建人 ,
@property(nonatomic, strong)NSString *CreateTime;// (string, optional): 创建时间 ,
@property (nonatomic,assign) NSInteger CreateTimestamp;
@property(nonatomic, assign)NSInteger UpdateUserId;// (integer, optional): 修改人 ,
@property(nonatomic, strong)NSString *UpdateTime;// (string, optional): 修改时间 ,
@property(nonatomic, strong)NSString *RowVersion;// (string, optional): ,
@property(nonatomic, assign)NSInteger OfferOrderId;// (integer, optional): 承兑商报价iD ,
@property(nonatomic, assign)BOOL IsBreak;// (boolean, optional): 是否违约 ,
@property(nonatomic, assign)NSInteger PayTypeId;// (integer, optional): 支付方式 ,
@property(nonatomic, assign)BOOL IsTimeOut;// (boolean, optional): 当前操作步骤是否超时 ,
@property(nonatomic, assign)NSInteger CancelUserID;// (integer, optional): 撤单用户 ,
@property(nonatomic, assign)BOOL IsContact;// (boolean, optional): 是否联系客户 ,
@property(nonatomic, assign)BOOL IsTXOut;// (boolean, optional): 虚拟币是否被转出 ,
@property(nonatomic, assign)NSString *ID;// (integer, optional)



// 自定义属性
@property (nonatomic,copy) NSString *customerLeftImageName;
@property (nonatomic,copy) NSString *customerUserName;
@property (nonatomic,copy) NSString *customerTime;
@property (nonatomic,copy) NSString *customerCountCurrey;
@property (nonatomic,copy) NSString *customerStatus;
@end



