//
//  RACCommand+Extension.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/13.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "RACCommand+Extension.h"


typedef RACSignal *(^commandSignalBlock)(id input);
commandSignalBlock commandSignal(RACSignal *signal, CommandInputBlock inputBlock) {
    return ^RACSignal *(id input){
        !inputBlock ?: inputBlock(input);
        return signal ?: [RACSignal empty];
    };
}


@implementation RACCommand (Extension)
+ (EmtyCommandBloack)emptyCommand {
    return ^RACCommand *(CommandInputBlock inputBlock){
        return [[RACCommand alloc] initWithSignalBlock:commandSignal(nil, inputBlock)];
    };
}

+ (EmtyEnabledCommandBloack)emptyEnabledCommand {
    return ^RACCommand *(RACSignal *enabledSignal ,CommandInputBlock inputBlock){
        return [[RACCommand alloc] initWithEnabled:enabledSignal ?: [RACSignal return:@NO]
                                       signalBlock:commandSignal(nil, inputBlock)];
    };
}

+ (CommandBloack)command {
    return ^ RACCommand *(RACSignal *signal, CommandInputBlock inputBlock){
        return [[RACCommand alloc] initWithSignalBlock:commandSignal(signal, inputBlock)];
    };
}

+ (EnabledcommandBloack)enabledcommand {
    return ^RACCommand *(RACSignal *signal,RACSignal *enabledSignal ,CommandInputBlock inputBlock){
        return [[RACCommand alloc] initWithEnabled:enabledSignal ?: [RACSignal return:@NO]
                                       signalBlock:commandSignal(signal, inputBlock)];
    };
}

- (RACDisposable *)subscribeNext:(void (^)(id value))nextBlock {
    return
    [[self.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:nextBlock];
}

- (RACDisposable *)subscribeError:(void (^)(NSError *error))errorBlock {
    return
    [[self.errors deliverOnMainThread] subscribeNext:errorBlock];
}

- (RACDisposable *)subscribeCompleted:(void (^)(id value))completedBlock {
    return
    [[self.executing deliverOnMainThread] subscribeNext:completedBlock];
}

- (NSArray<RACDisposable *> *)subscribeNext:(void (^)(id value))nextBlock
                                      error:(void (^)(NSError *error))errorBlock
                                  completed:(void (^)(id value))completedBlock {
    NSMutableArray *array = @[].mutableCopy;
    if (nextBlock) {
        [array addObject:[self subscribeNext:nextBlock]];
    } if (errorBlock) {
        [array addObject:[self subscribeError:errorBlock]];
    } if (completedBlock) {
        [array addObject:[self subscribeCompleted:completedBlock]];
    }
    return array.copy;
}

@end











