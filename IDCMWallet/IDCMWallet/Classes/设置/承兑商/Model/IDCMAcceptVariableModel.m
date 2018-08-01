//
//  IDCMAcceptVariableModel.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptVariableModel.h"
@implementation PayAttributeModelAcceptant
@end

@implementation IDCMAcceptVariableModel

+ (NSDictionary *)modelCustomPropertyMapper {
                        
    return @{
             @"dataID":@"id",
             @"coinId":@"CoinId",
             @"coinCode":@"CoinCode",
             @"direction":@"Direction",
             @"min":@"Min",
             @"max":@"Max",
             @"premium":@"Premium",
             @"amount":@"Amount",
             @"currencyIconUrl":@"Logo",
             @"localCurrencyId":@"LocalCurrencyId",
             @"currencyName":@"LocalCurrencyCode",
             @"payTypeID":@"PayTypeId",
             @"payType":@"PayTypeCode",
             @"payModeId":@"PayModeId",
             @"payAttributes":@"PayAttributes",
             };
}

-(NSArray *)titleArr{
    
    NSArray * arr = nil;
    if (self.modelType == kAcceptCoinAndLimitationType) {
    
        NSString  * p = [self premiumReal];
        if ([p floatValue]>0) {
            p = [NSString stringWithFormat:@"%@%@",@"+",p];
        }
        NSString * limitation = [NSString stringWithFormat:@"%@-%@",[IDCMUtilsMethod separateNumberUseCommaWith:[IDCMUtilsMethod getStringFrom:self.min]],[IDCMUtilsMethod separateNumberUseCommaWith:[IDCMUtilsMethod getStringFrom:self.max]]];
        NSString * premium =[NSString stringWithFormat:@"%@%@",p,@"%"];
        arr = @[self.coinCodeUpperString ,limitation,premium];
    }else if(self.modelType == kAcceptCurrencyAndAmountType) {
        
        NSString  * value = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringWithFormat:@"%.2f",[IDCMUtilsMethod getStringFrom:self.amount].doubleValue]];
        arr = @[self.currencyNameUpperstring,value];
    }else{
        arr = @[self.currencyNameUpperstring,self.payType];
    }
    return arr;
}
-(NSString *)coinCodeUpperString{
    
    return  [self.coinCode.uppercaseString isNotBlank] ? self.coinCode.uppercaseString : @"";
}
-(NSString *)currencyNameUpperstring{
    
    return  [self.currencyName.uppercaseString isNotBlank] ? self.currencyName.uppercaseString : @"";
}

-(NSString *)premiumReal{
    
    NSString *pre = [IDCMUtilsMethod precisionControl:self.premium];
    NSDecimalNumber * num =  [NSDecimalNumber decimalNumberWithString:pre];
    NSDecimalNumber * num2 = [num decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[@100  decimalValue]]];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:num2];
}
@end
