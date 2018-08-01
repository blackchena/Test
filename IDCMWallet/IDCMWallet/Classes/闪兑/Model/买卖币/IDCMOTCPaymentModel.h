//
//  IDCMOTCPaymentModel.h
//  IDCMWallet
//
//  Created by mac on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMPayAttributesModel : IDCMBaseModel

/**
 AccountNo BankName BankNo 银行卡 的
 */
@property(nonatomic,copy) NSString * AccountNo ; //= Gold;
@property(nonatomic,copy) NSString * BankName ;// = "\U4e2d\U56fd\U5efa\U8bbe\U94f6\U884c";
@property(nonatomic,copy) NSString * BankNo ;// = 8888888888888888888888;
@property(nonatomic,copy) NSString * AccountNoHide ;// = 8888888888888888888888;
@property(nonatomic,copy) NSString * BankNoHide ;// = ****************8888;

/**
 AccountNo UserName  支付宝的
 */
@property(nonatomic,copy) NSString * UserName ;
@end
@interface IDCMOTCPaymentModel : IDCMBaseModel

@property(nonatomic,assign) NSInteger  ID ;// (integer, optional): 主键id ,
@property(nonatomic,copy) NSString * LocalCurrencyId ;// (integer, optional): 法币id ,
@property(nonatomic,copy) NSString * LocalCurrencyCode ;// (string, optional): 法币Code ,
@property(nonatomic,copy) NSString * LocalCurrencyLogo ;// (string, optional): 法币LOGO ,
@property(nonatomic,copy) NSString * PayTypeId ;// (integer, optional): 支付方式id ,
@property(nonatomic,copy) NSString * PayTypeCode;// (string, optional): 支付方式Code ,
@property(nonatomic,copy) NSString * PayTypeLogo ;// (string, optional): 支付方式logo ,

@property(nonatomic,assign)BOOL isSelected ; ///<是否选中状态
@property(nonatomic,strong)IDCMPayAttributesModel *  PayAttributes ;


//ID (integer, optional): 主键id ,
//LocalCurrencyId (integer, optional): 法币id ,
//LocalCurrencyCode (string, optional): 法币Code ,
//LocalCurrencyLogo (string, optional): 法币LOGO ,
//PayTypeId (integer, optional): 支付方式id ,
//PayTypeCode (string, optional): 支付方式Code ,
//PayTypeLogo (string, optional): 支付方式logo ,
@end
