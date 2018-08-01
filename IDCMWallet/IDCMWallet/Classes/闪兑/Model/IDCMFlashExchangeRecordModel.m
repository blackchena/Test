//
//  IDCMExchangeListModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFlashExchangeRecordModel.h"
#import "IDCMUtilsMethod.h"


@interface IDCMFlashExchangeRecordModel ()
@property (nonatomic,strong) NSDictionary *timeDict;
@end


@implementation IDCMFlashExchangeRecordModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

- (instancetype)handleModel {
    [self handleCashTime];
    [self handleCashCount];
    [self handleCashStatus];
    return self;
}

- (void)handleCashStatus {
    /*
     public enum ExchangeInStatus
     {
     [Description("兑入中")]
     Send = 0,
     
     [Description("兑入确认")]
     SendComplete = 1,
     
     [Description("兑入失败")]
     SendFail = 2
     }
     */
    
    // 对入
    if ([self.OutStatus isEqualToString:@"2"]) {
        // 对入失败
        self.self.customerState = NSLocalizedString(@"2.2.1_FailedTransfer", nil);
    } else {
        // 对入中
        if ([self.ToMinCount integerValue] > [self.ToConfirmCount integerValue]) {
            self.self.customerState = [NSString idcw_stringWithFormat:@"%@ (%zd/%zd %@)",
                                           NSLocalizedString(@"2.1_Ongoing", nil),
                                           [self.ToConfirmCount integerValue],
                                           [self.ToMinCount integerValue],
                                           NSLocalizedString(@"2.1_Confirmed", nil)];
        } else {
            // 对入完成
            NSString *str = [NSString stringWithFormat:@"%zd", [self.ToConfirmCount integerValue]];
            if ([self.ToConfirmCount integerValue] > 1000) {
                str = @"1,000+";
            }
            self.self.customerState = [NSString idcw_stringWithFormat:@"%@ (%@ %@)",
                                           NSLocalizedString(@"2.0_Complete", nil),
                                           str,
                                           NSLocalizedString(@"2.1_Confirmed", nil)];
        }
    }
}

- (void)handleCashCount {
    self.customerCashOut = [NSString idcw_stringWithFormat:@"%@ %@",
                            [self handleNumber:self.Amount],
                            [self.Currency uppercaseString]];
    
    self.customerCashEnter = [NSString idcw_stringWithFormat:@"%@ %@",
                              [self handleNumber:self.ToAmount],
                              [self.ToCurrency uppercaseString]];
}

- (void)handleCashTime {
    //单位
    NSString *unit = SWLocaloziString([self.timeDict objectForKey:self.DateType]);
    //之前
    NSString *later = SWLocaloziString(@"2.1_Record_Time_Later_key");
    if ([self.Date integerValue] > 1) {
        
        if ([[IDCMUtilsMethod getPreferredLanguage] isEqualToString:@"en"]) {
            unit = [NSString idcw_stringWithFormat:@"%@s",unit];
        }else{
            unit = [NSString idcw_stringWithFormat:@"%@",unit];
        }
    }
    
    if ([[IDCMUtilsMethod getPreferredLanguage] isEqualToString:@"zh-Hans"] ||
        [[IDCMUtilsMethod getPreferredLanguage] isEqualToString:@"zh-Hant"]) {
        self.customerTime = [NSString idcw_stringWithFormat:@"%@%@%@",nilHandleString(self.Date),unit,later];
    }else{
        self.customerTime = [NSString idcw_stringWithFormat:@"%@ %@ %@",nilHandleString(self.Date),unit,later];
    }
}

- (NSString *)handleNumber:(NSNumber *)number
            fractionDigits:(NSInteger)fractionDigits {
    
    NSString *precisionControlStr = [IDCMUtilsMethod precisionControl:number];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:precisionControlStr];
    NSString *str = [NSString stringFromNumber:decimalNumber fractionDigits:fractionDigits];
    NSString *bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
    return bitcoinString;
}

- (NSString *)handleNumber:(NSNumber *)number {
    NSString *precisionControlStr = [IDCMUtilsMethod precisionControl:number];
    NSString *bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:precisionControlStr];
    return bitcoinString;
}


- (NSDictionary *)timeDict {
    return SW_LAZY(_timeDict, ({
        NSDictionary *dict = @{@"year":@"2.1_Record_Time_Year_key"
                               ,@"month":@"2.1_Record_Time_Month_key"
                               ,@"week":@"2.1_Record_Time_Week_key"
                               ,@"day":@"2.1_Record_Time_Day_key"
                               ,@"hour":@"2.1_Record_Time_Hour_key"
                               ,@"min":@"2.1_Record_Time_Min_key"
                               ,@"sec":@"2.1_Record_Time_Sec_key"
                               }; dict;
    }));
}

@end







