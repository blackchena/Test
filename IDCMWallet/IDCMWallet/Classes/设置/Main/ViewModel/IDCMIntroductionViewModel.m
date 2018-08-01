//
//  IDCMIntroductionViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMIntroductionViewModel.h"

@implementation IDCMIntroductionViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.totalPage = @(1);
    }
    return self;
}


- (RACSignal *)executeRequestDataSignal:(id)input
{
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        IDCMURLSessionTask *task = [IDCMRequestList requestGetNotAuth:input params:nil success:^(NSDictionary *response) {
            
            NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
            if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                if ([response[@"data"][@"total"] isKindOfClass:[NSNumber class]]) {
                    double count = [response[@"data"][@"total"] integerValue] / 10.0f;
                    self.totalPage = [NSNumber numberWithInteger:(NSInteger)ceil(count)];
                }
                
                [subscriber sendNext:response];
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
        
    }];
}

//获取请求的参数
- (NSString *)getRequsetParmaWithIndex:(NSInteger)index
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?lang=%@&clientName=1&pageIndex=%@",GetVersionList_URL,[IDCMUtilsMethod getServiceLanguage],@(index)];
    return urlStr;
}
@end
