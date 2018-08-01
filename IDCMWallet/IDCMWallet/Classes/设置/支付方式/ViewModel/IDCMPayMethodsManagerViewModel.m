//
//  IDCMPayMethodsManagerViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPayMethodsManagerViewModel.h"
@interface IDCMPayMethodsManagerViewModel()

@end

@implementation IDCMPayMethodsManagerViewModel
- (void)initialize {
    self.dataArray = @[].mutableCopy;
    self.payMethodsDeleteCommand = [RACCommand commandAuth:PaymentModeRemove_URL serverName:nil params:^id(id input) {
        return @{@"ID":input};
    } handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
        [subscriber sendNext:RACTuplePack(input, response)];
        [subscriber sendCompleted];
    }];
}
- (RACSignal *)executeRequestDataSignal:(id)input{
    return [RACSignal signalPostAuthNoHUD:PaymentModeList_URL serverName:nil params:nil handleSignal:nil];
}
@end

