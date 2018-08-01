//
//  IDCMOTCExchangeDetailModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

/*
WaitQuotePrice = 0,            /// 待报价
WaitPay = 1,                  /// 待转账
Transfered = 2,              /// 已转账
Paied = 3,                  /// 已支付
Appeal = 4,                /// 申诉中
UploadPayCertficate = 5,  /// 待上传支付凭证
WaitApproval = 6,        /// 待审核

CustomerRefund = 7,     /// 客服退回
CustomerPayCoin = 8,   /// 客服放币
 
//WaitRefundCoin = 10,  /// 待退币
//AgreeRefund = 11,   /// 同意退还
 
Cancel = 9,         /// 取消
Finish = 12        /// 完成
 */

typedef NS_ENUM(NSUInteger, OTCExchangeType) {
    OTCExchangeType_Buy = 1,       // 买币
    OTCExchangeType_Sell = 2      // 卖币
};

// 买币
typedef NS_ENUM(NSUInteger, OTCExchangeBuyStateType) {
    OTCExchangeBuyStateType_Doing = 1,                      // 进行中
    OTCExchangeBuyStateType_DoingSetDelay = 13,            // 卖家设置延时
    OTCExchangeBuyStateType_DoingDelay = 14,              // 进行中 超时
    OTCExchangeBuyStateType_Payed = 2,                   // 已转账
    OTCExchangeBuyStateType_PayedHandleDelay = 15,      // 超时
    OTCExchangeBuyStateType_Completed = 12,            // 完成
    OTCExchangeBuyStateType_Cancelled = 9,            // 取消
    OTCExchangeBuyStateType_Appeal = 4,              // 对方提请申诉
    OTCExchangeBuyStateType_AppealDelay = 16,       // 买家申诉处理超时
    OTCExchangeBuyStateType_AppealDoing = 5,       // 申诉上传图片
    OTCExchangeBuyStateType_AppealDoingDelay = 17,// 申诉上传图片超时
    OTCExchangeBuyStateType_AppealCheching = 6,  // 申诉审核中
    OTCExchangeBuyStateType_AppealCheched = 8   // 申诉审核完成
};

// 卖币
typedef NS_ENUM(NSUInteger, OTCExchangeSellStateType) {
    OTCExchangeSellStateType_Doing = 1,                                  // 进行中
    OTCExchangeSellStateType_DoingSetDelay = 13,                        // 已延长时间
    OTCExchangeSellStateType_DoingDelay = 14,                          // 进行中 超时
    OTCExchangeSellStateType_Payed = 2,                               // 对方已经转账
    OTCExchangeSellStateType_PayedHandleDelay = 15,                  // 对方已经转账 处理超时
    OTCExchangeSellStateType_Cancelled = 9,                         // 取消
    OTCExchangeSellStateType_Completed = 12,                       // 交易完成
    OTCExchangeSellStateType_AppealDoing = 4,                     // 申诉中
    OTCExchangeSellStateType_AppealDelay = 16,                   // 申诉超时
    OTCExchangeSellStateType_AppealCheched = 18,                 // 申诉完成
    OTCExchangeSellStateType_AppealUploadWaitting = 5,         // 申诉中 等待对方上传图片
    OTCExchangeSellStateType_AppealUploadWaitDelay = 17,      // 申诉中 等待对方上传图片 超时
    OTCExchangeSellStateType_AppealUploadedCheckPicture = 6, //对方已经上传凭证 等待审核
    OTCExchangeSellStateType_AppealCheckPictureCompleted = 8//审核完成
};


@interface IDCMOTCExchangeDetailPayAttributes : IDCMBaseModel
@property (nonatomic,copy) NSString *BankAddress;
@property (nonatomic,copy) NSString *BankBranch;
@property (nonatomic,copy) NSString *AccountNo;
@property (nonatomic,copy) NSString *BankName;
@property (nonatomic,copy) NSString *UserName;
@property (nonatomic,copy) NSString *SwiftCode;
@property (nonatomic,copy) NSString *City;
@property (nonatomic,copy) NSString *QRCode;
@end


@interface IDCMOTCExchangeDetailPaymentModel : IDCMBaseModel
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *LocalCurrencyId;
@property (nonatomic,copy) NSString *LocalCurrencyCode;
@property (nonatomic,copy) NSString *PayTypeId;
@property (nonatomic,copy) NSString *PayTypeCode;
@property (nonatomic,copy) NSString *PayTypeLogo;
@property (nonatomic,copy) NSDictionary *PayAttributes;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong) IDCMOTCExchangeDetailPayAttributes *payAttributesModel;
- (instancetype)handleModel;
@end


@interface IDCMOTCExchangeDetailModel : IDCMBaseModel
@property (nonatomic,copy) NSString *UserName;
@property (nonatomic,copy) NSString *UserId;  ///< UserId (integer, optional): 用户ID ,
@property (nonatomic,copy) NSString *OrderNo; ///< OrderNo (string, optional): 订单号 ,
@property (nonatomic,assign) NSInteger  Direction; ///< Direction (integer, optional): 1.买入;2.卖出 = ['1', '2'],
@property (nonatomic,strong) NSDecimalNumber  *Num; ///< Num (number, optional): 数量 ,
@property (nonatomic,copy) NSString *CoinId;///< CoinId (integer, optional): 币种ID ,
@property (nonatomic,copy) NSString *CoinName; ///<CoinName (string, optional): 虚拟币名称 ,
@property (nonatomic,copy) NSString *CoinCode; ///< CoinCode (string, optional): 虚拟币编码 ,
@property (nonatomic,copy) NSString *LocalCurrencyName; ///< LocalCurrencyName (string, optional): 法定货币名称 ,
@property (nonatomic,copy) NSString *LocalCurrencySymbol; ///< LocalCurrencySymbol (string, optional): 法定货币符号 ,
@property (nonatomic,copy) NSString *LocalCurrencyId; ///< LocalCurrencyId (integer, optional): 法币ID ,
@property (nonatomic,copy) NSString *AcceptantName; ///< AcceptantName (string, optional): 承兑商名称 ,
@property (nonatomic,copy) NSString *PaymentModeId; ///< PaymentModeId (integer, optional): 支付方式ID ,
@property (nonatomic,strong) NSDictionary *PaymentData; ///< PaymentData (string, optional): 支付信息 ,
@property (nonatomic,assign) NSInteger  PrevStatus; ///< PrevStatus (integer, optional): 订单超时，上一订单状态 = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '8', '9', '10', '11'],
@property (nonatomic,assign) NSInteger  Status; ///< Status (integer, optional): 1.报价中 = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '8', '9', '10', '11'],
@property (nonatomic,assign) NSInteger  StatusTime; ///< StatusTime (string, optional): 当前状态剩余时间，用于倒计时 ,
@property (nonatomic,assign) NSInteger StatusTimeSeconds;
@property (nonatomic,assign) BOOL  IsTimeExpand; ///< IsTimeExpand (boolean, optional): 进行中的订单可以延长时间，延长时间只能使用一次，持币方才有权限延长时间 ,
@property (nonatomic,copy) NSString *AcceptantUserId; ///< AcceptantUserId (integer, optional): 承兑商 ,
@property (nonatomic,copy) NSDecimalNumber *Amount; ///< Amount (number, optional): 总金额 ,
@property (nonatomic,copy) NSString *UploadUserId; ///< UploadUserId (integer, optional): 上传凭证方 ,
@property (nonatomic,strong) NSArray *CertificateImages; ///< CertificateImages (Array[string], optional): 凭证图片信息 ,
@property (nonatomic,copy) NSString *CreateUserId; ///< CreateUserId (integer, optional): 创建人 ,
@property (nonatomic,copy) NSString *CreateTime; ///< CreateTime (string, optional): 创建时间 ,
@property (nonatomic,assign) NSInteger CreateTimestamp;
@property (nonatomic,copy) NSString *UpdateUserId; ///< UpdateUserId (integer, optional): 修改人 ,
@property (nonatomic,copy) NSString *UpdateTime; ///< UpdateTime (string, optional): 修改时间 ,
@property (nonatomic,copy) NSString *RowVersion; ///< RowVersion (string, optional): ,
@property (nonatomic,copy) NSString *OfferOrderId; ///< OfferOrderId (integer, optional): 承兑商报价iD ,
@property (nonatomic,assign) BOOL  IsBreak; ///< IsBreak (boolean, optional): 是否违约 ,
@property (nonatomic,copy) NSString *PayTypeId; ///< PayTypeId (integer, optional): 支付方式 ,
@property (nonatomic,assign) BOOL  IsTimeOut; ///< IsTimeOut (boolean, optional): 当前操作步骤是否超时 ,
@property (nonatomic,copy) NSString *CancelUserID; ///< CancelUserID (integer, optional): 撤单用户 ,
@property (nonatomic,copy) NSString *IsContact; ///< IsContact (boolean, optional): 是否联系客户 ,
@property (nonatomic,assign) BOOL  IsTXOut; ///< IsTXOut (boolean, optional): 虚拟币是否被转出 ,
@property (nonatomic,assign) NSInteger ID; ///< id (integer, optional)
@property (nonatomic,strong) NSArray *Payments;

@property (nonatomic,copy) NSString *UserPhone;
@property (nonatomic,copy) NSString *AcceptantPhone;
@property (nonatomic,copy) NSString *PayCertificateNO;


// 自定义属性
@property (nonatomic,assign) OTCExchangeType exchangeType;
@property (nonatomic,assign) OTCExchangeBuyStateType exchangeBuyStateType;
@property (nonatomic,assign) OTCExchangeSellStateType exchangeSellStateType;
@property (nonatomic,assign) BOOL isDelay;

// 信息字段
@property (nonatomic,assign) NSTimeInterval timeCountDown;
@property (nonatomic,copy) NSString *timeCountDownString;
@property (nonatomic,copy) NSString *customerOrderNo;
@property (nonatomic,copy) NSString *customerOrderTime;

@property (nonatomic,copy) NSString *customerBuyCountInfo;  ///< 买入信息
@property (nonatomic,copy) NSString *customerBuyPayCountInfo;  ///< 付款信息
@property (nonatomic,copy) NSString *customerBuySeller; // 卖家
@property (nonatomic,copy) NSString *customerPayMethodNo; // 付款参考号
@property (nonatomic,copy) NSString *customerPhone;

@property (nonatomic,assign) NSInteger ConfirmTransferDuration;      // 买家确认转账时长 分钟
@property (nonatomic,assign) NSInteger HandlerAppealDuration;       // 卖家提请申述 买家处理时长 分钟
@property (nonatomic,assign) NSInteger ConfirmReceivablesDuration; // 卖家确认收款时长 分钟


@property (nonatomic,strong) NSMutableArray<IDCMOTCExchangeDetailPaymentModel *> *paymentsArray;

- (instancetype)handleModel;
- (void)disposeAllSignal;

@end














