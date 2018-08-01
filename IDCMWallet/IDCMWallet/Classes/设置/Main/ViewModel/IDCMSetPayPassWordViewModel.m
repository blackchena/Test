//
//  IDCMSetPayPassWordVIewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/28.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMSetPayPassWordViewModel.h"

@interface IDCMSetPayPassWordViewModel ()

@end

@implementation IDCMSetPayPassWordViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
    }
    return self;
}

- (void)initialize
{
    [super initialize];
    
    self.verifyOldCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
            NSDictionary *para = @{
                                   @"password":input,
                                   @"type":@(1),
                                   @"device_id":model.device_id,
                                   @"newVersion":@"true"
                                   };
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:CheckOriginalPwd_URL params:para success:^(NSDictionary *response) {
                
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
