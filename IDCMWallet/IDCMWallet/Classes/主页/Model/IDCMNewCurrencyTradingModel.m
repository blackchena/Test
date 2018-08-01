//
//  IDCMNewCurrencyTradingModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/28.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMNewCurrencyTradingModel.h"

@implementation IDCMNewCurrencyTradingModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",@"remark":@"description"};
}

-(NSDictionary *)timeDict {
    if (!_timeDict) {
        _timeDict = @{@"year":@"2.1_Record_Time_Year_key"
                      ,@"month":@"2.1_Record_Time_Month_key"
                      ,@"week":@"2.1_Record_Time_Week_key"
                      ,@"day":@"2.1_Record_Time_Day_key"
                      ,@"hour":@"2.1_Record_Time_Hour_key"
                      ,@"min":@"2.1_Record_Time_Min_key"
                      ,@"sec":@"2.1_Record_Time_Sec_key"
                      };
    }
    return  _timeDict;
}

#pragma mark
#pragma mark  -- getter
-(NSString *)customerTime
{
    if (!_customerTime) {
        //单位
        NSString *unit = SWLocaloziString([self.timeDict objectForKey:self.intervalUnit]);
        //之前
        NSString *later = SWLocaloziString(@"2.1_Record_Time_Later_key");
        if ([self.timeInterval integerValue] > 1) {
            if ([[IDCMUtilsMethod getPreferredLanguage] isEqualToString:@"en"]) {
                unit = [NSString stringWithFormat:@"%@s",unit];
            }else{
                unit = [NSString stringWithFormat:@"%@",unit];
            }
        }
        if ([[IDCMUtilsMethod getPreferredLanguage] isEqualToString:@"zh-Hans"] || [[IDCMUtilsMethod getPreferredLanguage] isEqualToString:@"zh-Hant"]) {
            _customerTime = [NSString stringWithFormat:@"%@%@%@",nilHandleString(self.timeInterval),unit,later];
        }else{
            _customerTime = [NSString stringWithFormat:@"%@ %@ %@",nilHandleString(self.timeInterval),unit,later];
        }
    }
    return _customerTime;
}
@end









