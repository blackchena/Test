//
//  IDCMOptionalCoinViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/6/13.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOptionalCoinViewModel.h"

@implementation IDCMOptionalCoinViewModel

- (void)initialize
{
    [super initialize];
    
    self.addCoinCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:SetCurrencyIsShow_URL params:input success:^(NSDictionary *response) {
                
                
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

// 钱包列表信号
- (RACSignal *)executeRequestDataSignal:(id)input
{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        // 区分客户端类型  GetUserCurrency_URL: 企业分发    GetUserCurrencyForApp_URL: App Store审核
        NSString *url = @"";
        if ([[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey]) {
            url = GetUserCurrency_URL;
        }else{
            url = [NSString idcw_stringWithFormat:@"%@?appStoreVersion=%@",GetUserCurrencyForApp_URL,[CommonUtils getAppVersion]];
        }
        IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:url params:nil success:^(NSDictionary *response) {
            
            @strongify(self);
            NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
            if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSArray class]]) {
                [self.dataArray removeAllObjects];
                [response[@"data"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IDCMCurrencyMarketModel *model = [IDCMCurrencyMarketModel yy_modelWithDictionary:obj];
                    if (model.isShow) {
                        [self.dataArray addObject:model];
                    }
                }];
                [subscriber sendNext:nil];
            }else if ([status isEqualToString:@"100"]){
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
}

- (NSMutableArray *)dataArray {
    return SW_LAZY(_dataArray, ({
        @[].mutableCopy;
    }));
}

@end
