//
//  IDCMWebViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMWebViewModel.h"

@implementation IDCMWebViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        self.requestURL = params[@"requestURL"];
        self.title = params[@"title"];
    }
    return self;
}
@end
