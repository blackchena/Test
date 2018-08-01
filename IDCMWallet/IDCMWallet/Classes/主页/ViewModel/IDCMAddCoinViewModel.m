//
//  IDCMAddCoinViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/25.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMAddCoinViewModel.h"
#import "IDCMCurrencyMarketModel.h"

@implementation IDCMAddCoinViewModel
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
        
        // 区分客户端类型  GetUserAllCurrency_URL: 企业分发    GetUserAllCurrency_URL + appStoreVersion: App Store审核
        NSString *url = @"";
        if ([[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey]) {
            url = GetUserAllCurrency_URL;
        }else{
            url = [NSString idcw_stringWithFormat:@"%@?appStoreVersion=%@",GetUserAllCurrency_URL,[CommonUtils getAppVersion]];
        }
        IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:url params:nil success:^(NSDictionary *response) {
            
            @strongify(self);
            NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
            if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSArray class]]) {
                
                [response[@"data"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    IDCMCurrencyMarketModel *model = [IDCMCurrencyMarketModel yy_modelWithDictionary:obj];
                    [self.walletListData addObject:model];
                }];
                [subscriber sendNext:self.walletListData];
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
#pragma mark - getter
- (NSMutableArray *)walletListData
{
    return SW_LAZY(_walletListData, @[].mutableCopy);
}
@end
