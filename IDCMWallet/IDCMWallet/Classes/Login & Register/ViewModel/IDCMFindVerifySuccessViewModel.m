//
//  IDCMFindVerifySuccessViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/26.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFindVerifySuccessViewModel.h"

@implementation IDCMFindVerifySuccessViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        self.userName = params[@"userName"];
    }
    return self;
}
@end
