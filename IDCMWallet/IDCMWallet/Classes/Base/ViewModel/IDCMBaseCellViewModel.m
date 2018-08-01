//
//  IDCMBaseCellViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/16.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseCellViewModel.h"

@implementation IDCMBaseCellViewModel
- (instancetype)init {
    if (self = [super init]) {
        
        [self initialize];
    }
    return self;
}


- (instancetype)initWithParams:(NSDictionary *)params {
    return [self init];
}

- (void)initialize{}
@end
