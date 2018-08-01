//
//  IDCMPaymentListModel.h
//  IDCMWallet
//
//  Created by IDCM on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"
@class IDCMPayListAttributesModel;

@interface IDCMPaymentListModel : IDCMBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *LocalCurrencyCode;
@property (nonatomic, copy) NSString *LocalCurrencyId;
@property (nonatomic, copy) NSString *LocalCurrencyLogo;
@property (nonatomic, strong) IDCMPayListAttributesModel *PayAttributes;
@property (nonatomic, copy) NSString *PayTypeCode;
@property (nonatomic, copy) NSString *PayTypeId;
@property (nonatomic, copy) NSString *PayTypeLogo;

@end


@interface IDCMPayListAttributesModel : IDCMBaseModel

@property (nonatomic, copy) NSString *AccountNo;
@property (nonatomic, copy) NSString *BankNoHide;
@property (nonatomic, copy) NSString *BankAddress;
@property (nonatomic, copy) NSString *BankBranch;
@property (nonatomic, copy) NSString *BankName;
@property (nonatomic, copy) NSString *City;
@property (nonatomic, copy) NSString *SwiftCode;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *QRCode;
@end
