//
//  IDCMSysSettingModel.h
//  IDCMWallet
//
//  Created by mac on 2018/5/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMSysSettingModel : IDCMBaseModel

@property(nonatomic,assign)NSInteger AllowCancelOrderCount ;///< (integer, optional): 允许取消订单次数 ,
@property(nonatomic,assign)NSInteger AllowCancelOrderDuration ;///< (integer, optional): 多长时间内取消订单限制,单位小时 ,
@property(nonatomic,assign)NSInteger CancelOrderForbidTradeDuration ;///<(integer, optional): 撤销禁止交易时长，单位小时 ,
@property(nonatomic,assign)NSInteger AppealFailForbidTradeDuration;///< (integer, optional): 申诉失败禁止交易时长，单位小时 ,
@property(nonatomic,assign)NSInteger AllowQuotePriceDuration ;///<(integer, optional): 允许接受报价时长，单位秒 ,
@property(nonatomic,assign)NSInteger ConfirmTransferDuration ;///<(integer, optional): 确认转账时长，单位分钟 ,
@property(nonatomic,assign)NSInteger AllowDelayDuration ;///<(integer, optional): 允许延时时常,单位分钟 ,
@property(nonatomic,assign)NSInteger ConfirmReceivablesDuration ;///<(integer, optional): 确认收款时长,单位分钟 ,
@property(nonatomic,assign)NSInteger HandlerAppealDuration ;///<(integer, optional): 处理申诉时长 ,
@property(nonatomic,assign)NSInteger UploadCertificateDuration ;///<(integer, optional): 上传收据时长，单位分钟 ,
@property(nonatomic,assign)NSInteger MaxHandlerOrderCount ;///<(integer, optional): 承兑商最大允许处理订单数，超过该数字有新单来将不会推送
@end
