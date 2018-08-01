//
//  IDCMIntroductionModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMIntroductionModel.h"

@implementation IDCMIntroductionModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
#pragma mark
#pragma mark  -- getter
-(NSString *)customerTime
{
    if (!_customerTime) {
        
        NSArray *array = [self.createTime componentsSeparatedByString:@"T"];
        
        _customerTime = array[0];
    }
    
    
    return _customerTime;
}
@end
