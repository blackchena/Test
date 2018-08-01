//
//  IDCMLocalCurrencyModel.h
//  IDCMWallet
//
//  Created by wangpu on 2018/5/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMLocalCurrencyModel : IDCMBaseModel

@property (nonatomic,copy) NSString * currencyID; //法币币种id
@property (nonatomic,copy) NSString * localCurrencyCode; //名称
@property (nonatomic,copy) NSString * currencyLogo; //图标
@property (nonatomic,strong) NSNumber * currencyAmount; //资金量
@property (nonatomic,assign) BOOL isSelect; //是否选中
-(NSString *) localCurrencyCodeUpperString;
@end
