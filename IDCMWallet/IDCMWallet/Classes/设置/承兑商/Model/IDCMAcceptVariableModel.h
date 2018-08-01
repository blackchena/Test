//
//  IDCMAcceptVariableModel.h
//  IDCMWallet
//
//  Created by wangpu on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"
typedef NS_ENUM(NSUInteger, VariableModelType) {
    kAcceptCoinAndLimitationType,
    kAcceptCurrencyAndPayType,
    kAcceptCurrencyAndAmountType,
};

@interface PayAttributeModelAcceptant : IDCMBaseModel

@property (nonatomic,copy) NSString *BankAddress;
@property (nonatomic,copy) NSString *BankBranch;
@property (nonatomic,copy) NSString *AccountNo;
@property (nonatomic,copy) NSString *BankName;
@property (nonatomic,copy) NSString *UserName;
@property (nonatomic,copy) NSString *SwiftCode;
@property (nonatomic,copy) NSString *City;
@end

@interface IDCMAcceptVariableModel : IDCMBaseModel

@property (nonatomic,strong) NSArray *  titleArr;
@property (nonatomic,copy) NSString * coinId;
@property (nonatomic,copy) NSString * coinCode;
@property (nonatomic,copy) NSString * direction;
@property (nonatomic,strong) NSNumber * min;
@property (nonatomic,strong) NSNumber * max;
@property (nonatomic,strong) NSNumber * premium;
@property (nonatomic,strong) NSNumber * amount;

@property (nonatomic,copy) NSString * currencyName;
@property (nonatomic,assign) NSInteger  payModeId;
@property (nonatomic,copy) NSString * payType;
@property (nonatomic,copy) NSString * payTypeID;
@property (nonatomic,copy) NSString * dataID;
@property (nonatomic,copy) NSString * localCurrencyId;
@property (nonatomic,copy) NSString * currencyIconUrl;

@property (nonatomic,assign) BOOL  cellSpread;

@property (nonatomic,strong) PayAttributeModelAcceptant * payAttributes;//支付方式附带信息
@property (nonatomic,assign) VariableModelType  modelType;

-(NSString *)coinCodeUpperString;
-(NSString *)premiumReal;

@end
