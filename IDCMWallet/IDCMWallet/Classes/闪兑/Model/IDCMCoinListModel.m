//
//  IDCMCoinModel.m
//  IDCMWallet
//
//  Created by wangpu on 2018/3/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMCoinListModel.h"

@implementation IDCMCoinModel


-(NSString *)exchangeMinString{
    NSString *exchangeMinNum = [IDCMUtilsMethod precisionControl:self.exchangeMin];
    NSString *exchangeMin = [NSString stringRoundPlainFromNumber:[NSDecimalNumber decimalNumberWithString:exchangeMinNum] fractionDigits:self.digit];
//    NSString *exchangeMinStr = [IDCMUtilsMethod separateNumberUseCommaWith:exchangeMin];
    return exchangeMin.length >0 ? exchangeMin : @"0.0";
}

-(NSString *)exchangeMaxString{
    
    NSString *exchangeMaxNum = [IDCMUtilsMethod precisionControl:self.exchangeMax];
    NSString *exchangeMax = [NSString stringRoundPlainFromNumber:[NSDecimalNumber decimalNumberWithString:exchangeMaxNum] fractionDigits:self.digit];
//    NSString *exchangeMaxStr = [IDCMUtilsMethod separateNumberUseCommaWith:exchangeMax];
    return exchangeMax.length >0 ? exchangeMax : @"0.0";
}

-(NSString *)exchangeRateString{
    
    NSString *rateNum = [IDCMUtilsMethod precisionControl:self.exchangeRate];
    NSString *rate = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:rateNum] fractionDigits:self.rateDigit];
//    NSString *rateStr = [IDCMUtilsMethod separateNumberUseCommaWith:rate];
    return rate.length >0 ? rate : @"0.0";
}

-(NSDecimalNumber *)exchangeMaxDecimalNumber{
    
    return [NSDecimalNumber decimalNumberWithDecimal:[self.exchangeMax  decimalValue]];
}

-(NSDecimalNumber *)exchangeMinDecimalNumber{
    
    return [NSDecimalNumber decimalNumberWithDecimal:[self.exchangeMin  decimalValue]];
}

-(NSDecimalNumber *)exchangeRateDecimalNumber{
    
    return [NSDecimalNumber decimalNumberWithDecimal:[self.exchangeRate  decimalValue]];
}

- (NSString *)coinLabelUppercaseString{
    
    return [self.coinLabel uppercaseString];
}
- (NSString *)pairCoinLabelUppercaseString{
    
    return [self.pairCoinLabel uppercaseString];
}

-(id)mutableCopy{

    IDCMCoinModel * model = [[IDCMCoinModel alloc] init];
    model.coinLabel = self.coinLabel.copy;
    model.coinUrl = self.coinUrl.copy;
    model.pairCoinLabel = self.pairCoinLabel.copy;
    model.exchangeMax = self.exchangeMax;
    model.exchangeMin = self.exchangeMin;
    model.exchangeRate = self.exchangeRate;
    model.rateDigit = self.rateDigit;
    model.isDefault = self.isDefault;
    model.isMarket = self.isMarket;
    model.isSelect = self.isSelect;
    model.digit = self.digit;
    model.pairDigit = self.pairDigit;
    model.isDirection = self.isDirection;
    return model;
}
@end


@implementation IDCMCoinListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"fromCoin" : @"FromCoin",
             @"fromLogo" : @"FromLogo",
             @"fromExchangeMin" : @"FromExchangeMin",
             @"fromExchangeMax" : @"FromExchangeMax",
             @"fromDigit" : @"FromDigit",
             @"fromIsMarket" : @"FromIsMarket",
             @"fromIsSupportExchange" : @"FromIsSupportExchange",
             @"toCoin" : @"ToCoin",
             @"toLogo" : @"ToLogo",
             @"toExchangeMin" : @"ToExchangeMin",
             @"toExchangeMax" : @"ToExchangeMax",
             @"toDigit" : @"ToDigit",
             @"toIsMarket" : @"ToIsMarket",
             @"toIsSupportExchange" : @"ToIsSupportExchange",
             @"fromExchangeRate" : @"ExchangeRate",
             @"toExchangeRate" : @"ToExchangeRate",
             @"rateDigit" : @"RateDigit",
             @"isDefault" : @"Default",
             
             };
}

-(void)separateFromAndToCoinModel
{

    IDCMCoinModel * leftCoinModel = [[IDCMCoinModel alloc] init];
    leftCoinModel.coinLabel = self.fromCoin;
    leftCoinModel.coinUrl = self.fromLogo;
    leftCoinModel.exchangeRate = self.fromExchangeRate;
    leftCoinModel.exchangeMax = self.fromExchangeMax;
    leftCoinModel.exchangeMin = self.fromExchangeMin;
    
    leftCoinModel.digit = self.fromDigit;
    leftCoinModel.pairDigit = self.toDigit;
    
    
    leftCoinModel.isMarket = self.fromIsMarket;
    leftCoinModel.rateDigit = self.rateDigit;
    leftCoinModel.isDefault = self.isDefault;
    leftCoinModel.pairCoinLabel = self.toCoin;
    leftCoinModel.isDirection = @"true";
    self.fromCoinModel = leftCoinModel;
    
    IDCMCoinModel * rightCoinModel = [[IDCMCoinModel alloc] init];
    rightCoinModel.coinLabel = self.toCoin;
    rightCoinModel.coinUrl = self.toLogo;
    rightCoinModel.exchangeRate = self.toExchangeRate;
    rightCoinModel.exchangeMax = self.toExchangeMax;
    rightCoinModel.exchangeMin = self.toExchangeMin;
    
    rightCoinModel.digit = self.toDigit;
    rightCoinModel.pairDigit = self.fromDigit;
    
    rightCoinModel.isMarket = self.toIsMarket;
    rightCoinModel.rateDigit = self.rateDigit;
    rightCoinModel.isDefault = self.isDefault;
    rightCoinModel.pairCoinLabel = self.fromCoin;
    rightCoinModel.isDirection = @"false";
    self.toCoinModel = rightCoinModel;

}
-(NSString *)fromExchangeMinString{
    
    return [self.fromExchangeMin stringValue] ? :@"0.0";
}

-(NSString *)fromExchangeMaxString{
    
    return [self.fromExchangeMax stringValue] ? :@"0.0";
}

-(NSString *)toExchangeMinString{
    
    return [self.toExchangeMin stringValue] ? :@"0.0";
}

-(NSString *)toExchangeMaxString{
    
    return [self.toExchangeMax stringValue] ? :@"0.0";
}

-(NSString *)fromExchangeRateString{
    
    return [self.fromExchangeRate stringValue] ? :@"0.0";
}

-(NSString *)toExchangeRateString{
    
    return [self.toExchangeRate stringValue] ? : @"0.0";
}
-(NSDecimalNumber *)fromExchangeRateDecimalNumber{
    
    return [NSDecimalNumber decimalNumberWithDecimal:[self.fromExchangeRate  decimalValue]];
}

-(NSDecimalNumber *)fromExchangeMaxDecimalNumber{
    
    return [NSDecimalNumber decimalNumberWithDecimal:[self.fromExchangeMax  decimalValue]];
}

-(NSDecimalNumber *)fromExchangeMinDecimalNumber{
    
    return [NSDecimalNumber decimalNumberWithDecimal:[self.fromExchangeMin  decimalValue]];
}

-(NSDecimalNumber *)toExchangeMaxDecimalNumber{
    
    return [NSDecimalNumber decimalNumberWithDecimal:[self.toExchangeMax  decimalValue]];
}

-(NSDecimalNumber *)toExchangeMinDecimalNumber{
    
    return [NSDecimalNumber decimalNumberWithDecimal:[self.toExchangeMin  decimalValue]];
}

-(NSDecimalNumber *)toExchangeRateDecimalNumber{
    
    return [NSDecimalNumber decimalNumberWithDecimal:[self.toExchangeRate  decimalValue]];
}

- (NSString *)fromLabelUppercaseString{
    
    return [self.fromCoin.uppercaseString isNotBlank] ? self.fromCoin.uppercaseString : @"";
}
- (NSString *)toLabelUppercaseString{
    
    return [self.toCoin.uppercaseString isNotBlank] ? self.toCoin.uppercaseString : @"";
}

//-(NSNumber *)toExchangeRate{
//    
//    double fromRate = [self.fromExchangeRate doubleValue];
//    if (fromRate) {
//        NSNumber * toRate = [NSNumber numberWithDouble:1/fromRate];
//        NSString *rateNum = [IDCMUtilsMethod precisionControl:toRate];
//        NSString *rate = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:rateNum] fractionDigits:self.toDigit];
//        return [NSNumber numberWithDouble:[rate doubleValue]];
//    }
//    return self.fromExchangeRate;
//}

@end
