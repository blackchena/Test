//
//  IDCMOTCCionModel.h
//  IDCMWallet
//
//  Created by mac on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMOTCCionModel : IDCMBaseModel

@property(nonatomic,assign) NSInteger CoinId ; ///< (integer, optional): 虚拟币ID ,
@property(nonatomic,copy) NSString *  CoinName ;///< (string, optional): 虚拟币名称 ,
@property(nonatomic,copy) NSString *  CoinCode ;///< (string, optional): 虚拟币编码 ,
@property(nonatomic,copy) NSString *  Logo ;///< (string, optional): 虚拟币图标 ,
@property(nonatomic,copy) NSString *  Sort ;///< (integer, optional): 排序 ,
@property(nonatomic,strong)NSNumber * Precision;///< (number, optional): 单位精度 ,
@property(nonatomic,copy) NSString *  CreateTime ;///<(string, optional): 创建时间 ,
@property(nonatomic,copy) NSString *  CreateUserId ;///<(integer, optional): 创建者 ,
@property(nonatomic,copy) NSString *  UpdateTime ;///<(string, optional): 更新时间 ,
@property(nonatomic,copy) NSString *  UpdateUserId;///< (integer, optional): 更新者 ,
@property(nonatomic,copy) NSString *  MinConfirms ;///<(integer, optional): 最小确认数 ,
@property(nonatomic,strong) NSNumber *  MinBuyQuantity;///< (number, optional): 最小买入数量 ,
@property(nonatomic,strong) NSNumber *  MaxBuyQuantity ;///<(number, optional): 最大买入数量 ,
@property(nonatomic,strong) NSNumber *  MinSellQuantity;///< (number, optional): 最小卖出数量 ,
@property(nonatomic,strong) NSNumber *  MaxSellQuantity ;///<(number, optional): 最大卖出数量 ,
@property(nonatomic,copy) NSString *  coin_id ;///<(integer, optional)
@property(nonatomic,copy) NSString *  Digit ;///<(integer, optional): 小数位数 ,

@property (nonatomic,assign) BOOL isSelect;///<是否选中状态
-(NSString *)dk_uppercaseLetter;
@end
