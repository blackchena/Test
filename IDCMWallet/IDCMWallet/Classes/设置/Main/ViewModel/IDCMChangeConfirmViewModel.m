//
//  IDCMChangeConfirmViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/28.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChangeConfirmViewModel.h"

@implementation IDCMChangeConfirmViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        self.originalPayPwd = params[@"originalPayPwd"];
        self.newpassword = params[@"newpassword"];
        self.confirmPassword = @"";
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    
    @weakify(self);
    self.setPayPassWordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
            NSDictionary *para = @{@"originalPayPwd":self.originalPayPwd,
                                   @"type":@(0),
                                   @"newPayPwd":self.newpassword,
                                   @"affirmPayPwd":self.confirmPassword,
                                   @"verifyCode":@"",
                                   @"verifyUser":@"",
                                   @"device_id":model.device_id,
                                   @"newVersion":@"true"
                                   };
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:RestPayPassword_URL params:para success:^(NSDictionary *response) {
                
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
