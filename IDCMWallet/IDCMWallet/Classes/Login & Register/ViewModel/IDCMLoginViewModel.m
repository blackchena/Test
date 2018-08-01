//
//  IDCMLoginViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/23.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMLoginViewModel.h"
#import "IDCMUserInfoModel.h"

@implementation IDCMLoginViewModel

- (void)initialize
{
    [super initialize];
    
    
    self.validMobileLoginSignal = [[RACSignal
                              combineLatest:@[ RACObserve(self, countryName), RACObserve(self, moblie) ,RACObserve(self, mobliePassword)]
                              reduce:^(NSString *country, NSString *moblieNum,NSString *mobliePW) {
                                  return @(country.length > 0 && mobliePW.length > 0 && moblieNum.length > 2 && moblieNum.length < 12 && [CommonUtils isValidateNumber:moblieNum]);
                              }]
                             distinctUntilChanged];
    
    self.validEmailLoginSignal = [[RACSignal
                                    combineLatest:@[ RACObserve(self, eamil), RACObserve(self, eamilPassword)]
                                    reduce:^(NSString *email,NSString *emailPW) {
                                        return @( email.length > 0 && emailPW.length > 0);
                                    }]
                                   distinctUntilChanged];

    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            
            IDCMURLSessionTask *task = [IDCMRequestList requestNotAuth:Login_URL params:input success:^(NSDictionary *response) {
            
//                IDCMUserInfoModel *model = [IDCMUserInfoModel yy_modelWithDictionary:response[@"data"]];
                [subscriber sendNext:response];
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
