//
//  IDCMSetPINViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/26.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSetPINViewModel.h"

@implementation IDCMSetPINViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        self.newpassword = @"";
        self.confirmPassword = @"";
        self.setPINType = params[@"setPINType"];
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    self.validNextSignal = [[RACSignal
                             combineLatest:@[ RACObserve(self, newpassword),RACObserve(self, confirmPassword)]
                             reduce:^(NSString *password,NSString *confirmpassword) {
                                 
                                 if (password.length == 6 && ![confirmpassword isNotBlank]) {
                                     return [NSNumber numberWithBool:YES];
                                 }else if (password.length == 6 && confirmpassword.length == 6){
                                     return [NSNumber numberWithBool:YES];
                                 }else{
                                     return [NSNumber numberWithBool:NO];
                                 }
                                 
                             }]
                            distinctUntilChanged];
    
    @weakify(self);
    self.setPayPassWordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
            NSDictionary *para = @{
                                   @"newPayPwd":self.newpassword,
                                   @"affirmPayPwd":self.confirmPassword,
                                   @"device_id":model.device_id,
                                   @"newVersion":@"true"
                                   };
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:SetPayPasssword_URL params:para success:^(NSDictionary *response) {
                
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
