//
//  IDCMCoinModel.h
//  IDCMWallet
//
//  Created by wangpu on 2018/3/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCMBaseModel.h"

@interface IDCMCoinModel : IDCMBaseModel

@property (nonatomic,copy)   NSString *coinLabel;
@property (nonatomic,copy)   NSString *coinUrl;
@property (nonatomic,copy)   NSString *pairCoinLabel;

@property (nonatomic,strong) NSNumber *exchangeMax;
@property (nonatomic,strong) NSNumber *exchangeMin;
@property (nonatomic,strong) NSNumber *exchangeRate;


@property (nonatomic,assign) NSInteger digit;
@property (nonatomic,assign) NSInteger rateDigit;
@property (nonatomic,assign) NSInteger pairDigit;
@property (nonatomic,assign) BOOL isDefault;

@property (nonatomic,assign) BOOL isMarket;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,copy)   NSString * isDirection;
@property (nonatomic,assign) NSInteger arrIndex;


-(NSString *)exchangeMinString;
-(NSString *)exchangeMaxString;
-(NSString *)exchangeRateString;

-(NSDecimalNumber *)exchangeMaxDecimalNumber;
-(NSDecimalNumber *)exchangeMinDecimalNumber;
-(NSDecimalNumber *)exchangeRateDecimalNumber;

- (NSString *)coinLabelUppercaseString;
- (NSString *)pairCoinLabelUppercaseString;
@end

@interface IDCMCoinListModel : IDCMBaseModel

@property (nonatomic,copy)     NSString *     fromCoin;
@property (nonatomic,copy)     NSString *     fromLogo;
@property (nonatomic,strong)   NSNumber *     fromExchangeMin;
@property (nonatomic,strong)   NSNumber *     fromExchangeMax;
@property (nonatomic,assign)   NSInteger      fromDigit;
@property (nonatomic,assign)   BOOL           fromIsMarket;
@property (nonatomic,assign)   BOOL           fromIsSupportExchange;

@property (nonatomic,copy)     NSString *     toCoin;
@property (nonatomic,copy)     NSString *     toLogo;
@property (nonatomic,strong)   NSNumber *     toExchangeMin;
@property (nonatomic,strong)   NSNumber *     toExchangeMax;
@property (nonatomic,assign)   NSInteger      toDigit;
@property (nonatomic,assign)   BOOL           toIsMarket;
@property (nonatomic,assign)   BOOL           toIsSupportExchange;

@property (nonatomic,strong)   NSNumber *     fromExchangeRate;
@property (nonatomic,strong)   NSNumber *     toExchangeRate;
@property (nonatomic,assign)   NSInteger      rateDigit;
@property (nonatomic,assign)   BOOL           isDefault;


@property (nonatomic,strong)   IDCMCoinModel *  fromCoinModel;
@property (nonatomic,strong)   IDCMCoinModel *  toCoinModel;

-(NSString *)fromExchangeMinString;
-(NSString *)fromExchangeMaxString;
-(NSString *)toExchangeMinString;
-(NSString *)toExchangeMaxString;
-(NSString *)fromExchangeRateString;
-(NSString *)toExchangeRateString;

-(NSDecimalNumber *)fromExchangeMinDecimalNumber;
-(NSDecimalNumber *)fromExchangeMaxDecimalNumber;
-(NSDecimalNumber *)toExchangeMinDecimalNumber;
-(NSDecimalNumber *)toExchangeMaxDecimalNumber;
-(NSDecimalNumber *)fromExchangeRateDecimalNumber;
-(NSDecimalNumber *)toExchangeRateDecimalNumber;

- (NSString *)fromLabelUppercaseString;
- (NSString *)toLabelUppercaseString;

-(void)separateFromAndToCoinModel;
@end


