//
//  IDCMBackupMemorizingWordsViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBackupMemorizingWordsViewModel.h"

@implementation IDCMBackupMemorizingWordsViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        self.backupType = params[@"backupType"];
        self.isSetRootViewController = params[@"isSetRootViewController"];
    }
    return self;
}
- (void)initialize {
    
    RACSignal *(^counterSignal)(NSNumber *count) = ^RACSignal *(NSNumber *count) {
        return
        [[[RACSignal interval:1
                   onScheduler:[RACScheduler mainThreadScheduler]]
                 scanWithStart:count reduce:^id(NSNumber *running, id next) {
                     return @(running.integerValue - 1);
             }] takeUntilBlock:^BOOL(NSNumber *x) {
              return x.integerValue < 0;
        }];
    };
    
    self.timerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         return counterSignal(@5);
    }];
    
    @weakify(self);
    self.memorizingWordsCommand =
    [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSString *url = [NSString stringWithFormat:@"%@?newVersion=true&lang=%@",GetRandomList_URL,[IDCMUtilsMethod getPhrasesLanguage]];
            IDCMURLSessionTask *task = [IDCMRequestList requestGetAuth:url params:nil success:^(NSDictionary *response) {
                @strongify(self);
                NSInteger status = [response[@"status"] integerValue];
                IDCMRandomListModel *model = [IDCMRandomListModel new];
                if (status == 1 && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                    
                    model = [IDCMRandomListModel yy_modelWithDictionary:response[@"data"]];
                    self.listModel = model;
                    [subscriber sendNext:model];
                }else if (status == 100){
                    [subscriber sendError:nil];
                }
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }] retry:1];
    }];
}

@end




