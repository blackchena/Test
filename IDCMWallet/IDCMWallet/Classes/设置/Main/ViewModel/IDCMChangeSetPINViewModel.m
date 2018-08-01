//
//  IDCMChangeSetPINViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/28.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChangeSetPINViewModel.h"

@implementation IDCMChangeSetPINViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        self.originalPayPwd = params[@"originalPayPwd"];
        self.newpassword = @"";
    }
    return self;
}
@end
