//
//  IDCMFlashExchangeViewModel.m
//  IDCMWallet
//
//  Created by wangpu on 2018/3/19.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFlashExchangeViewModel.h"
#import "IDCMCoinListModel.h"

@interface IDCMFlashExchangeViewModel ()

@end


@implementation IDCMFlashExchangeViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
    }
    return self;
}

- (void)initialize
{
    [super initialize];
    @weakify(self);
    _commandGetCoinList  = [RACCommand commandPostAuthNoHUD:ExchangeGetNewCoinList_NewURL serverName:ExchangeServerName params:nil handleCommand:^(id input,NSDictionary * response, id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        
        if ([status isEqualToString:@"100"]) {
            [subscriber sendError:nil];
        }else{
            
            if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * data = response[@"data"];
                if (![data[@"CoinList"] isKindOfClass:[NSArray class]] ||
                    ![data[@"SortList"] isKindOfClass:[NSArray class]]) {
                     [subscriber sendError:nil];
                    
                } else {
                    NSMutableArray *coinList = [NSMutableArray arrayWithArray:data[@"CoinList"]] ;
                    NSMutableArray *sortList = [NSMutableArray arrayWithArray:data[@"SortList"]] ;
                    
                    //处理数组 分左右边
                    if (coinList.count == 0 || sortList.count == 0) {
                        [subscriber sendError:nil];
                    } else {
              
                        self.defaultCoinListModel = nil;//置空
                        //排序数组
                        self.sortListArray  = sortList;
                        //coin处理
                        NSMutableArray * arr = [[NSMutableArray alloc] init];
                        [coinList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            IDCMCoinListModel * coinListModel =  [IDCMCoinListModel yy_modelWithDictionary:obj];
                            if (coinListModel.isDefault) {
                                self.defaultCoinListModel = coinListModel;
                            }
                            [coinListModel separateFromAndToCoinModel];
                            [arr addObject:coinListModel];
                        }];
                        self.coinListData = arr;
                        //将coin数组分成key对应的一个数组的字典
                        [self dealCoinListData];
                        
                        //设置默认
                        if (!self.defaultCoinListModel) {
                            NSArray *filterArray;
                            for (NSDictionary *dict in self.sortListArray) {
                                filterArray =
                                [self.coinListData filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(IDCMCoinListModel *model, NSDictionary<NSString *,id> *bindings) {
                                    return [model.fromCoin isEqualToString:[dict[@"Coin"] lowercaseString]];
                                }]];
                                if (filterArray.count) { break ;}
                            }
                            if (!filterArray.count) {
                                [subscriber sendError:nil];
                            } else {
                                self.defaultCoinListModel = filterArray.firstObject;
                            }
                        }
                        [subscriber sendNext:nil];
                    }
                }
               
            }
        }
        
        [subscriber sendCompleted];
        
    }];
    
    _commandGetBalance = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //请求余额
        @strongify(self);
        return [self getBalanceByCoinName:input];
        
    }];
    
    _commandExchangeIn = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [self exhangeIn:input];
    }];
}

//兑换

- (RACSignal *)exhangeIn:(id) input
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        IDCMURLSessionTask *task = [IDCMRequestList  requestPostAuthNoHUD:ExchangeExchangeIn_URL serverName:ExchangeServerName  params:input success:^(NSDictionary *response) {
            
            NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
            
            if ([status isEqualToString:@"100"]) {
                [subscriber sendError:nil];
            }else{
                [subscriber sendNext:response];
            }
            
            [subscriber sendCompleted];
            
        } fail:^(NSError *error, NSURLSessionDataTask *task) {
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
        
    }] ;
}


//请求余额

- (RACSignal *)getBalanceByCoinName:(NSString *) label
{
     @weakify(self);
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        
        @strongify(self);
        NSString *url = [NSString idcw_stringWithFormat:@"%@?currency=%@",ExchangeGetBalance_URL,[label lowercaseString]] ;
        IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:url params:nil success:^(NSDictionary *response) {
            

            
            NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
            if (![status isEqualToString:@"1"]) {
                [subscriber sendError:nil];
            }else {
                
                if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                    
                    // 当前可用的余额
                    NSString *currentBalance = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"currentBalance"]];
                    NSString *current = [IDCMUtilsMethod precisionControl:[NSDecimalNumber decimalNumberWithString:currentBalance]];
                    NSString *currentStr = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:current] fractionDigits:4];
                    self.realityBalance = [NSDecimalNumber decimalNumberWithString:currentStr];
                    
                }
                [subscriber sendNext:nil];
            }
            [subscriber sendCompleted];
            
        } fail:^(NSError *error, NSURLSessionDataTask *task) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
        
    }] retry:1];
}

-(void)dealCoinListData{

    //取得所有的coin 有重复
    NSMutableArray<IDCMCoinModel *> *allModelArray = [[NSMutableArray alloc] init];
    [self.coinListData enumerateObjectsUsingBlock:^(IDCMCoinListModel *obj,
                                                    NSUInteger idx,
                                                    BOOL *stop) {
        [allModelArray addObject:obj.fromCoinModel];
        [allModelArray addObject:obj.toCoinModel];
    }];
    
    //去除重复 并排序
    NSMutableArray * allKeyArray = [[NSMutableArray alloc] init];
    NSMutableArray < IDCMCoinModel *>  * allModels = [[NSMutableArray alloc] init];
    [allModelArray enumerateObjectsUsingBlock:^(IDCMCoinModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![allKeyArray containsObject:obj.coinLabel]) {
            [allKeyArray addObject:obj.coinLabel];
            [allModels addObject:obj];
        }
    }];
    NSMutableArray < IDCMCoinModel *>  * newAllModels = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<self.sortListArray.count; i++) {
        NSDictionary * keyDict = self.sortListArray[i];
        NSString * key = [keyDict[@"Coin"] lowercaseString];
        [allModels enumerateObjectsUsingBlock:^(IDCMCoinModel *obj,
                                                    NSUInteger idx,
                                                    BOOL *stop) {
            if ([obj.coinLabel isEqualToString:key]) {
                [newAllModels addObject:obj];
            }
        }];
    }
    self.allCoinModelArr = newAllModels;

    //按给定的coin名称排序，给所有的 coin 拍序
    NSMutableDictionary *  dict = [NSMutableDictionary new];
    for (NSInteger i=0; i<self.sortListArray.count; i++) {
        NSDictionary * keyDict = self.sortListArray[i];
        NSString * key = [keyDict[@"Coin"] lowercaseString];

        NSMutableArray<IDCMCoinModel *> *mArray = @[].mutableCopy;
        [allModelArray enumerateObjectsUsingBlock:^(IDCMCoinModel *obj,
                                                    NSUInteger idx,
                                                    BOOL *stop) {
            if ([obj.pairCoinLabel isEqualToString:key]) {
                [mArray addObject:obj];
            }
        }];
        //
        NSMutableArray< IDCMCoinModel *> *newArray = @[].mutableCopy;
        for (NSInteger j=0; j<self.sortListArray.count; j++){
            NSString * keyString = self.sortListArray[j][@"Coin"];
            for (IDCMCoinModel * model in mArray) {
                if ([model.coinLabel isEqualToString:[keyString lowercaseString]]) {
                    [newArray addObject:model];
                }
            }
        }

        [dict setObject:newArray forKey:key];
    }
    self.allKeyCoinDataDict = dict;
}

-(NSString *)realityBalanceString{
    
    NSString *realNum = [IDCMUtilsMethod precisionControl:self.realityBalance];
    NSString *rate = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:realNum] fractionDigits:4];
    if (rate.length>0) {
        return rate;
    }
    return  @"0.0000";
}


-(IDCMCoinModel *)getCurrentCoinPair:(NSString *) left withRight:(NSString *) right{

    NSArray<IDCMCoinModel *> * coinArr = self.allKeyCoinDataDict[right];
   __block IDCMCoinModel * model = nil;
    [coinArr enumerateObjectsUsingBlock:^(IDCMCoinModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.coinLabel isEqualToString:left]) {
            model = obj;
        }
    }];
    return model;
}
@end
