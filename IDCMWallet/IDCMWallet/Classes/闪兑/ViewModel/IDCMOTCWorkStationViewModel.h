//
//  IDCMOTCWorkStationViewModel.h
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/4.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMOrderResultModel.h"
#import "IDCMOTCCionModel.h"
#import "IDCMOTCCurrencyModel.h"
#import "IDCMOTCPaymentModel.h"

@interface IDCMOTCWorkStationViewModel : IDCMBaseViewModel

@property (nonatomic, strong)IDCMOrderResultModel *orderModel;

@property (nonatomic, strong)IDCMOTCCionModel *otcCoinModel;
@property (nonatomic, strong)IDCMOTCCurrencyModel *otcCurrencyModel;
@property (nonatomic, strong)IDCMOTCPaymentModel *paymentModel;
@property (nonatomic, strong)NSString *amount;
@property (nonatomic, strong)NSNumber *type;
@property (nonatomic, strong)NSNumber *cancelCount;


@property (nonatomic, strong)RACCommand *cancelOrderCommand;

@property (nonatomic, strong)RACCommand *confirmOfferOrderCommand;


@end
