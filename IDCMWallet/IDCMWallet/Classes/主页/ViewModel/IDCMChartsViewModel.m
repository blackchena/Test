//
//  IDCMChartsViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChartsViewModel.h"
#import "IDCMChartModel.h"

@implementation IDCMChartsViewModel
- (void)initialize
{
    [super initialize];
    
    
    self.configChartCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:SettingConfig_URL params:input success:^(NSDictionary *response) {
                
                
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
    
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        
        IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:GetConfig_URL params:nil success:^(NSDictionary *response) {
            
            
            NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
            if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                IDCMChartModel *model = [IDCMChartModel yy_modelWithDictionary:response[@"data"]];
                [subscriber sendNext:model];
                
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
@end
