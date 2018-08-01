//
//  IDCMOTCCurrencyModel.h
//  IDCMWallet
//
//  Created by mac on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMOTCCurrencyModel : IDCMBaseModel

@property(nonatomic,assign) NSInteger  Id ;///<(integer, optional),
@property(nonatomic,copy) NSString * Name;///< (string, optional): 名称 ,
@property(nonatomic,copy) NSString * Symbol ;///<(string, optional): 符号 ,
@property(nonatomic,copy) NSString * Sort ;///<(integer, optional): 排序 ,
@property(nonatomic,strong) NSNumber * Precision ;///<(number, optional): 精度 ,
@property(nonatomic,copy) NSString * IsSupportOtc;///< (boolean, optional): 是否在otc使用
@property(nonatomic,copy) NSString * Logo ;///< (string, optional): logo ,
@property(nonatomic,copy) NSString * Digit ;///< (integer, optional): 小数位数


/**
 是否是选中状态
 */
@property(nonatomic,assign)BOOL isSelect ;
@end
