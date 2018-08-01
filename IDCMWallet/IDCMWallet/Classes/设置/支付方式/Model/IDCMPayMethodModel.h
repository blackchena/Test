//
//  IDCMPayMethodModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"
@class IDCMCurrencyPaytypeListItemModel;

@class IDCMLocalCurrencyListItemModel;

@class IDCMPaytypeListItemModel;


/**
 最外面数据
 */
@interface IDCMPayMethodModel : IDCMBaseModel

@property (nonatomic, copy) NSArray <IDCMCurrencyPaytypeListItemModel *> *CurrencyPaytypeList;///<扩展属性
@property (nonatomic, copy) NSArray <IDCMLocalCurrencyListItemModel *> *LocalCurrencyList;///<支付方式
@property (nonatomic, copy) NSArray <IDCMPaytypeListItemModel *> *PaytypeList;///< 货币币种

@end


@class IDCMAttributesItemModel;

/**
 扩展属性
 
 */
@interface IDCMCurrencyPaytypeListItemModel : IDCMBaseModel

@property (nonatomic, copy) NSArray <IDCMAttributesItemModel *> *Attributes;
@property (nonatomic, copy) NSString *Content;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *LocalCurrencyId;
@property (nonatomic, copy) NSString *PayTypeId;

@end


/**
 支付方式
 */
@interface IDCMLocalCurrencyListItemModel : IDCMBaseModel

@property (nonatomic, copy) NSString *LocalCurrencyCode;
@property (nonatomic, copy) NSString *LocalCurrencyLogo;
@property (nonatomic, strong)NSArray  <IDCMPaytypeListItemModel *>*PaytypeList;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic,assign) BOOL isSelect;

@end


/**
 货币币种
 */
@interface IDCMPaytypeListItemModel : IDCMBaseModel

@property (nonatomic, copy) NSArray <IDCMLocalCurrencyListItemModel *> *LocalCurrencyList;
@property (nonatomic, copy) NSString *PayTypeCode;
@property (nonatomic, copy) NSString *PayTypeLogo;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic,assign) BOOL isSelected;

@end


/**
 属性值
 */
@interface IDCMAttributesItemModel : IDCMBaseModel

@property (nonatomic, copy) NSString *ControlType;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *CreateUserId;
@property (nonatomic, strong) NSString *DefaultValue;
@property (nonatomic, copy) NSString *Field;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic) BOOL IsRequired;
@property (nonatomic) BOOL IsShow;
@property (nonatomic, copy) NSString *LabelLanguageCode;
@property (nonatomic, copy) NSNumber *MaxLength;
@property (nonatomic, strong)NSString  *RegularExpression;
@property (nonatomic, copy) NSNumber *Sort;
@property (nonatomic, copy) NSString *UpdateTime;
@property (nonatomic, copy) NSNumber *UpdateUserId;
@property (nonatomic, strong)NSNumber  *ValueRanges;

@end

