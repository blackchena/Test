//
//  IDCMMessageViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/31.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMMessageViewModel.h"

@implementation IDCMMessageViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.totalPage = @(1);
        self.pageSize = @(10);
    }
    return self;
}
- (void)initialize
{
    [super initialize];

    self.deleteMessageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:MessageBatchSetting_URL params:input success:^(NSDictionary *response) {
                
                NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"] && ![response[@"data"] isKindOfClass:[NSNull class]] && response[@"data"] != nil) {
                    
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
            
        }] retry:1];
    }];
    
    self.confirmReadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSString *url = [NSString stringWithFormat:@"%@?msgId=%@",ConfirmRead_URL,input];
            IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:url params:nil success:^(NSDictionary *response) {
                
                NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"] && ![response[@"data"] isKindOfClass:[NSNull class]] && response[@"data"] != nil) {
                    
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
            
        }] retry:1];
    }];

}
// 获取消息列表
- (RACSignal *)executeRequestDataSignal:(id)input
{
   
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:input params:nil success:^(NSDictionary *response) {
            
            NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
            if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                double count = [response[@"data"][@"count"] integerValue] / [self.pageSize floatValue];
                self.totalPage = [NSNumber numberWithInteger:(NSInteger)ceil(count)];
                [subscriber sendNext:response];
            }else if ([status isEqualToString:@"100"]){
                [subscriber sendError:nil];
            }else if ([status isEqualToString:@"120"]){
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
}
//获取请求的参数
- (NSString *)getRequsetParmaWithIndex:(NSInteger)index
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?lang=%@&client=ios&pageSize=%@&pageIndex=%@",GetMessageList_URL,[IDCMUtilsMethod getServiceLanguage],self.pageSize,@(index)];
    return urlStr;
}
@end
