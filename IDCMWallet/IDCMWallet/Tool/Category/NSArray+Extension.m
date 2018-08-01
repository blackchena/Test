//
//  NSArray+Extension.m
//  IDCMWallet
//
//  Created by wangpu on 2018/3/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)


- (instancetype)yy_modelListWithModelClass:(Class) modelClass {
    
    return !self.count  ?  nil :
    ({
        NSMutableArray *arr = @[].mutableCopy;
        [self enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [arr addObject:[modelClass yy_modelWithDictionary:obj]];
        }];
        arr.copy;
    });
}
@end

@implementation NSMutableArray (Extension)


- (instancetype)yy_modelListWithModelClass:(Class) modelClass {
    
   return !self.count  ?  nil :
    ({
        NSMutableArray *arr = @[].mutableCopy;
        [self enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [arr addObject:[modelClass yy_modelWithDictionary:obj]];
        }];
        arr;
    });
}
@end
