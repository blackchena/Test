//
//  IDCMBaseViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/22.
//  Copyright © 2017年 BinBear. All rights reserved.
//


#import "IDCMBaseViewModel.h"


@interface IDCMBaseViewModel ()
@property (strong, nonatomic, readwrite) RACCommand *requestDataCommand;
@end


@implementation IDCMBaseViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        @weakify(self);
        self.requestDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [[self executeRequestDataSignal:input] takeUntil:self.rac_willDeallocSignal];
        }];

        [self initialize];
    }
    return self;
}


- (instancetype)initWithParams:(NSDictionary *)params {
    return [self init];
}

- (void)initialize{}

- (RACSignal *)executeRequestDataSignal:(id)input {
    return [RACSignal empty];
}

@end


