//
//  IDCMFlashExchangeViewModel.h
//  IDCMWallet
//
//  Created by wangpu on 2018/3/19.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IDCMBaseViewModel.h"

@class IDCMCoinListModel;
@class IDCMCoinModel;
@interface IDCMFlashExchangeViewModel : IDCMBaseViewModel

@property (nonatomic,strong) RACCommand * commandGetCoinList;
@property (nonatomic,strong) RACCommand * commandGetCoinRate;
@property (nonatomic,strong) RACCommand * commandExchangeIn;

@property (nonatomic,strong) RACCommand * commandGetBalance;
@property (nonatomic,strong) NSDecimalNumber *  realityBalance;

@property (nonatomic,strong) NSArray<NSDictionary *> *sortListArray;
@property (nonatomic,strong) NSMutableArray <IDCMCoinListModel *> *coinListData;
@property (nonatomic,strong) NSMutableDictionary *  allKeyCoinDataDict;
@property (nonatomic,strong) IDCMCoinListModel *  defaultCoinListModel;

@property (nonatomic,strong) NSMutableArray <IDCMCoinModel *> * allCoinModelArr;

@property (nonatomic,copy) NSString *pinPassWord;


-(NSString *) realityBalanceString;

-(IDCMCoinModel *)getCurrentCoinPair:(NSString *) left withRight:(NSString *) right;

@end
