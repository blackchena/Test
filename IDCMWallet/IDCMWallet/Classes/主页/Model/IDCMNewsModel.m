//
//  IDCMNewsModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/13.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMNewsModel.h"

@implementation IDCMNewsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
#pragma mark
#pragma mark  -- getter
-(NSString *)customerTime
{
    if (!_customerTime) {
        
        NSArray *array = [self.startTime componentsSeparatedByString:@"T"];
        
        NSDate *date = [NSDate dateWithString:array[0] format:@"yyyy-MM-dd"];
        
        if ([date isToday]) {
            _customerTime = array[1];
        }else{
            NSString *dateStr = [array[0] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            _customerTime = dateStr;
        }
    }
    
    
    return _customerTime;
}
@end
