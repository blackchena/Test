//
//  IDCMChangePayPasswordViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChangePayPasswordViewModel.h"

@implementation IDCMChangePayPasswordViewModel
- (void)initialize
{
    [super initialize];
    
    self.originalPayPwd = @"";

    @weakify(self);
    self.verifyOldCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
            NSDictionary *para = @{
                                   @"password":self.originalPayPwd,
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
