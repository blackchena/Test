//
//  IDCMPINLoginViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPINLoginViewModel.h"

@implementation IDCMPINLoginViewModel

- (void)initialize
{
    [super initialize];
    
    self.verifyPIN = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *password) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
 
            IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
            NSDictionary *para = @{
                                   @"password":password,
                                   @"type":@(1),
                                   @"device_id":model.device_id,
                                   @"newVersion":@"true"
                                   };
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:CheckOriginalPwd_New_URL params:para success:^(NSDictionary *response) {
                
                NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                
                    
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
    
    self.logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *password) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestNotAuth:Exit_URL params:nil success:^(NSDictionary *response) {
                
                NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"] && ![response[@"data"] isKindOfClass:[NSNull class]] && response[@"data"] != nil) {
                    
                    [CommonUtils saveBoolValueInUD:NO forKey:IsLoginkey];
                    [IDCM_APPDelegate setMovieLoginController];
                    [subscriber sendNext:response];
                }
                
                [subscriber sendCompleted];
                
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
}

@end
