//
//  IDCMNewCurrencyTradingViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/28.
//  Copyright © 2018年 IDCM. All rights reserved.
//


#import "IDCMNewCurrencyTradingModel.h"
#import "IDCMCurrencyMarketModel.h"
#import "IDCMBaseTableViewModel.h"


@interface IDCMNewCurrencyTradingViewModel : IDCMBaseTableViewModel

@property (nonatomic,assign) NSInteger tradeType;
@property (nonatomic,strong) NSDictionary *blanceDict;
@property (strong, nonatomic) IDCMCurrencyMarketModel *marketModel;
@property (strong, nonatomic) NSMutableArray<IDCMCurrencyMarketModel *> *currencyListData;


- (void)cancelAllRequest;
@end
