//
//  IDCMOrderResultModel.h
//  IDCMWallet
//
//  Created by mac on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMOrderResultModel : IDCMBaseModel

@property(nonatomic,assign)NSInteger OrderId;///<(integer, optional): 订单ID ,
@property(nonatomic,copy)NSString * OrderNO ;///<(string, optional): 订单编号 ,
@property(nonatomic,copy)NSString * QuoteOrderExpired ;///<(string, optional): 承兑商报价到期时间 ,
@property(nonatomic,assign)NSInteger QuoteOrderTimestamp ;///<integer, optional, read only): 承兑商报价到期时间戳 ,
@property(nonatomic,assign)NSInteger QuoteOrderSeconds;// (integer, optional, read only): 承兑商报价到期时间,剩余秒数 ,
@property(nonatomic,copy)NSString * ForbidExpired ;///<string, optional): 解禁下单时间 ,
@property(nonatomic,assign)NSInteger ForbidExpiredTimestamp ;///<integer, optional, read only): 解禁下单时间戳
@property(nonatomic,assign)NSInteger ForbidExpiredSeconds;// (integer, optional, read only): 解禁下单,剩余秒数
@end
