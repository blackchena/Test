//
//  IDCMSetPayPassWordSuccessViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMSetPayPassWordSuccessViewModel.h"
#import "IDCMUserStateModel.h"

@implementation IDCMSetPayPassWordSuccessViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.titleVC = params[@"titleVC"];
        self.hint = params[@"hint"];
        self.remember = params[@"remember"];
    }
    return self;
}
- (RACSignal *)executeRequestDataSignal:(id)input
{
    
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:input params:nil success:^(NSDictionary *response) {
            
            NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
            IDCMUserStateModel *model = [IDCMUserStateModel new];
            if ([status isEqualToString:@"1"] && ![response[@"data"] isKindOfClass:[NSNull class]] && response[@"data"] != nil) {
                
                model.email = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"email_valid"][@"email"]];
                model.emailValid = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"email_valid"][@"valid"]];
                
                model.mobil = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"mobile_valid"][@"mobile"]];
                model.mobilValid = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"mobile_valid"][@"valid"]];
                
                model.wallet_phrase = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"wallet_phrase"]];
                model.payPassword = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"payPassword"][@"valid"]];
                [subscriber sendNext:model];
                [IDCMUtilsMethod keyedArchiverWithObject:model withKey:UserStatusInfokey];
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
