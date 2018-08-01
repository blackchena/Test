//
//  IDCMOTCACceptanceOrederDetailViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMNewOrderNoticeAcceptantModel.h"

@interface IDCMOTCACceptanceOrederDetailViewModel : IDCMBaseViewModel
/**
 *  订单model
 */
@property (strong, nonatomic) IDCMNewOrderNoticeAcceptantModel *model;
/**
 *  总价
 */
@property (strong, nonatomic) NSNumber *totalPrice;
/**
 *  单价
 */
@property (strong, nonatomic) NSNumber *unitPrice;
/**
 *  价格是否可用
 */
@property (strong, nonatomic) RACSignal *validPriceSignal;
/**
 *  报价
 */
@property (strong, nonatomic) RACCommand *quotePriceCommand;
@end
