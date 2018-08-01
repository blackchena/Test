//
//  IDCMPTCConfirmQuoteOrderModel.h
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/24.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMPTCConfirmQuoteOrderModel : IDCMBaseModel

@property (nonatomic,assign) NSInteger  OrderId;
@property (nonatomic,assign) NSInteger  AcceptantUserId;
@property (nonatomic,assign) NSInteger  QuoteOrderId;

@end
