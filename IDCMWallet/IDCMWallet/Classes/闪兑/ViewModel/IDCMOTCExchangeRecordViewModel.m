//
//  IDCMOTCExchangeRecordViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCExchangeRecordViewModel.h"
#import "IDCMOTCExchangeRecordModel.h"

@implementation IDCMOTCExchangeRecordViewModel

- (void)initialize {
    
    self.commandGetState = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return  [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestPostAuthNoHUD:OTCAcceptant_URL params:nil success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if (![status isEqualToString:@"1"]) {
                    [subscriber sendError:nil];
                }else {
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

- (tableViewDataAnalyzeBlock)configDataParams {
    return ^ NSDictionary *(id response){
        if ([response isKindOfClass:[NSDictionary class]]) {
            id res = response[@"data"];
            if (!res || [res isKindOfClass:[NSNull class]]) {
                res = @"";
            }
            return @{
                     CellModelClassKey : [IDCMOTCExchangeRecordModel class],
                     CellModelDataKey : res
                     };
        } else {
            return nil;
        }
    };
}

- (NSString *)configRequestUrl {
    return GetOtcOrders_URL;
}

- (NSString *)configServerName {
    return nil;
}

- (requestParamsBlock)configParams {
    return ^id(id input){
        return
        @{@"PageSize" : @(self.pageSize),
          @"PageIndex" : @([self getLoadDataPageNumber])};
    };
}

@end











