//
//  IDCMAcceptantApplyReadViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyReadViewModel.h"


@implementation IDCMAcceptantApplyReadViewModel

- (timerComandBlock)timerCommand {
    return ^RACCommand *(NSNumber *count){
        
        RACSignal *(^counterSignal)(NSNumber *count) = ^RACSignal *(NSNumber *count) {
            return
            [[[[RACSignal interval:1
                       onScheduler:[RACScheduler mainThreadScheduler]]
               startWith:[NSDate date]]
              scanWithStart:count reduce:^id(NSNumber *running, id next) {
                  return @(running.integerValue - 1);
              }] takeUntilBlock:^BOOL(NSNumber *x) {
                  return x.integerValue < 0;
              }];
        };
        
        return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *input) {
            RACSignal *timerSignal = counterSignal(count);
            id (^counterSignalMap)(NSNumber *value) = ^(NSNumber *value){
                return [NSString stringWithFormat:@"%@(%@s)",NSLocalizedString(@"3.0_AcceptantApplyRead", nil), value];
            };
            RACSignal *counterStringSignal = [timerSignal map:counterSignalMap];
            
            __block id<RACSubscriber> saveSubscriber = nil;
            RACSignal *resetStringSignal =
            [RACSignal createSignal:^RACDisposable *(id<RACSubscriber>  subscriber) {
                saveSubscriber = subscriber;
                return nil;
            }];
            
            @weakify(input);
            [timerSignal subscribeCompleted:^{
                @strongify(input);
                input.enabled = YES;
                [saveSubscriber sendNext:NSLocalizedString(@"3.0_AcceptantApplyRead", nil)];
                [saveSubscriber sendCompleted];
            }];
        
            [input rac_liftSelector:@selector(setTitle:forState:)
                        withSignals:[RACSignal merge:@[counterStringSignal, resetStringSignal]],
                                    [RACSignal return:@(UIControlStateNormal)], nil];
            
            return timerSignal;
        }];
    };
}


@end
