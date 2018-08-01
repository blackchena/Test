//
//  IDCMBaseModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@implementation IDCMBaseModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}
- (NSUInteger)hash {
    return [self yy_modelHash];
}
- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}
- (NSString *)description {
    return [self yy_modelDescription];
}
@end
