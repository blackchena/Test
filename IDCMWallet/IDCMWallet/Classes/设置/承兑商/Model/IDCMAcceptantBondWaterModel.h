//
//  IDCMAcceptantBondWaterModel.h
//  IDCMWallet
//
//  Created by IDCM on 2018/5/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseModel.h"

typedef NS_ENUM(NSUInteger, IDCMAcceptantBondWaterType) {
    IDCMAcceptantBondWaterType_deposit = 1,
    IDCMAcceptantBondWaterType_recharge,
    IDCMAcceptantBondWaterType_appeal,
    IDCMAcceptantBondWaterType_cancel,
    IDCMAcceptantBondWaterType_buyservice,
    IDCMAcceptantBondWaterType_sellservice,
    IDCMAcceptantBondWaterType_resume
};

@interface IDCMAcceptantBondWaterModel : IDCMBaseModel

@property (nonatomic, copy) NSString *Address; ///<
@property (nonatomic, copy) NSNumber *Balance;
@property (nonatomic, copy) NSNumber *BookType;
@property (nonatomic, copy) NSString *BookTypeCode; ///< 类型 In.提取;Out.充值;Appeal.申诉违约金;CancelOrder.撤销订单违约;Buy.买币服务费;Sell.卖币服务费; ,
@property (nonatomic, copy) NSString *BookTypeLogo;
@property (nonatomic, copy) NSNumber *ChangeBalance;
@property (nonatomic, copy) NSNumber *ChangeFrozenNum;
@property (nonatomic, copy) NSString *CoinCode;
@property (nonatomic, copy) NSNumber *CoinId;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *FlowNo;
@property (nonatomic, copy) NSNumber *FrozenNum;
@property (nonatomic, copy) NSString *Logo;
@property (nonatomic, copy) NSNumber *MinerFee;
@property (nonatomic, copy) NSNumber *OriginalBalance;
@property (nonatomic, copy) NSNumber *OriginalFrozenNum;
@property (nonatomic, copy) NSNumber *PaymentType; ///< 类型 1收入  2支出
@property (nonatomic, copy) NSString *RelateOrderNo;
@property (nonatomic, copy) NSString *RelateOrderId;

@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *TXID;
@property (nonatomic, copy) NSNumber *UserId;
@property (nonatomic, copy) NSString *WithdrawFailure;
@property (nonatomic, copy) NSString *WithdrawGuid;
@property (nonatomic, copy) NSNumber *WaterId;

@end
