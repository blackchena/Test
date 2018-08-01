//
//  IDCMReceiveViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/19.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMReceiveViewModel.h"

@implementation IDCMReceiveViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    
    if (self = [super init]) {
        _marketModel = [params objectForKey:@"marketModel"];
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    [super initialize];
    
    @weakify(self);
    // 接收地址
    self.reciveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            NSString *url = [NSString stringWithFormat:@"%@?currency=%@",GetAccountAddress_URL,[self.marketModel.currency lowercaseString]];
            IDCMURLSessionTask *task = [IDCMRequestList requestGetAuth:url params:nil success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"100"]) {
                    [subscriber sendError:nil];
                }else{
                    [subscriber sendNext:response];
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
