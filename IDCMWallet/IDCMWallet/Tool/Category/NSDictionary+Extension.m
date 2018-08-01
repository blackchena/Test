//
//  NSDictionary+Extension.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/10.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (void)idcw_objectForKey:(NSString *)key
              objectClass:(Class)objectClass
               completion:(objectBlock)completion {
    
    __block BOOL suceess = NO;
    [self enumerateKeysAndObjectsUsingBlock:^(id    obj,
                                              id    idx,
                                              BOOL *stop) {
        if ([key isEqualToString:obj]) {
            suceess = YES;
            *stop = YES;
        }
    }];
    
    id value = nil;
    if (suceess) {
        value = [self objectForKey:key];
        if (![value isKindOfClass:objectClass]) {
            value = nil;
            suceess = NO;
        }
    }
    !completion ?: completion(value, suceess);
}


- (void)createPropertyCode {
    
    NSMutableString *codes = [NSMutableString string];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSString *code;
        if ([value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSNull class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        } else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign)  %@;",key];
        } else if ([value isKindOfClass:[NSArray class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
        }
        [codes appendFormat:@"\n%@",code];
    }];
    DDLogDebug(@"%@",codes);
}



@end















