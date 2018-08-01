//
//  IDCMWalletIDSettingViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMWalletIDSettingViewModel.h"

@implementation IDCMWalletIDSettingViewModel

- (void)initialize {
    @weakify(self);
    
    RACSignal *(^enbledSignal)(void) = ^RACSignal *(void){
        return [RACObserve(self, wallteID) map:^NSNumber *(NSString *value) {
                @strongify(self);
                return @(self.wallteID.length > 0);
            }];
    };
    
    RACSignal *(^verifyAccountSignal)(id input) = ^RACSignal *(id input){
        @strongify(self);
        
        if (![IDCMUtilsMethod isValidateUserName:self.wallteID]) {
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.1_UserNameFormat", nil)];
            return [RACSignal empty];
        }
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            NSDictionary *parm = @{ @"content"  :self.wallteID,
                                    @"validType":[NSNumber numberWithInteger:2]};
            IDCMURLSessionTask *task = [IDCMRequestList requestNotAuth:ValidUserInfo_URL params:parm success:^(NSDictionary *response) {
                [subscriber sendNext:response];
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    };
    
    RACSignal *(^registerSignal)(id input) = ^RACSignal *(id input){
        @strongify(self);
        
        
        if (![IDCMUtilsMethod isValidateUserName:self.wallteID]) {
              [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.1_UserNameFormat", nil)];
            return [RACSignal empty];
        }
        
        self.endEditingCallback ? self.endEditingCallback() : nil;
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            
            // 区分客户端类型  企业分发: registerSoucre类型为3    App Store审核: registerSoucre类型为4,且增加appversion字段
            NSDictionary *parm ;
            if ([[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey]) {
                parm = @{ @"user_name":self.wallteID,
                          @"language":[IDCMUtilsMethod getServiceLanguage],
                          @"localCurrencyName":@"USD",
                          @"registerSoucre":@(3),
                          @"client":@"app",
                          @"invite_code":[self.inviteCode isNotBlank] ? self.inviteCode : @""
                          };
            }else{
                
                parm = @{ @"user_name":self.wallteID,
                          @"language":[IDCMUtilsMethod getServiceLanguage],
                          @"localCurrencyName":@"USD",
                          @"registerSoucre":@(4),
                          @"client":@"app",
                          @"appversion":[CommonUtils getAppVersion],
                          @"invite_code":[self.inviteCode isNotBlank] ? self.inviteCode : @""
                          };
            }
            
            IDCMURLSessionTask *task = [IDCMRequestList requestNotAuth:Register_URL params:parm success:^(NSDictionary *response) {
                [subscriber sendNext:response];
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    };
    
    self.verifyAccountCommand = [[RACCommand alloc] initWithEnabled:enbledSignal()
                                                        signalBlock:verifyAccountSignal];
    self.verifyAccountCommand.allowsConcurrentExecution = YES;
    
    self.registerCommand = [[RACCommand alloc] initWithEnabled:enbledSignal()
                                                   signalBlock:registerSignal];
    self.registerCommand.allowsConcurrentExecution = YES;
}

@end





