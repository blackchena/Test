//
//  IDCMBindEmailViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMBindEmailViewModel
// @abstract <#类的描述#>
// @discussion <#类的功能#>
//
#import "IDCMBindEmailViewModel.h"

@implementation IDCMBindEmailViewModel

#pragma mark - Life Cycle
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.type = params[@"type"];
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    

    RACSignal *validEmailRegisterSignal = [[RACSignal
                                      combineLatest:@[ RACObserve(self, eamil), RACObserve(self, emailVaeifyCode)]
                                      reduce:^(NSString *email,NSString *emailCode) {
                                          return @( email.length > 0 && emailCode.length > 0 );
                                      }]
                                     distinctUntilChanged];
    

    RACSignal *VerifyCodeSignal   = [[RACSignal
                                        combineLatest:@[ RACObserve(self, eamil)]
                                        reduce:^(NSString *email) {
                                            return @( email.length > 0 );
                                        }]
                                       distinctUntilChanged];
    

    
    
    @weakify(self);
    self.sendEmailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            NSDictionary *parm = @{@"MailAddress":self.eamil,
                                   @"verifyCodeType":@"5",
                                   @"language":[IDCMUtilsMethod getServiceLanguage]
                                   };
            IDCMURLSessionTask *task = [IDCMRequestList requestPostNoHUDAuth:SendMail_URL params:parm success:^(NSDictionary *response) {
                
                
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
    
    self.authButtonCommand = [[RACCommand alloc] initWithEnabled:VerifyCodeSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        @strongify(self);
        return [[[self varildEMSSignal] filter:^BOOL(NSDictionary *response) {
            NSInteger status = [response[@"status"] integerValue];
            if ([response[@"data"] isKindOfClass:[NSNumber class]]) {
                BOOL data = [response[@"data"] boolValue];
                if (data && status == 1) {
                    return YES;
                }else{
                    [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.2.3_AlreadyBindEmail") withPosition:QMUIToastViewPositionBottom];
                    return NO;
                }
            }else{
                return NO;
            }
            
        }]  flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
            
            @strongify(self);
            
            [self.sendEmailCommand execute:nil];
            
            RACSignal *signal = [self retrySendVerifyCodeSignal];
            
            UIButton *button = input;
            
            [[signal deliverOnMainThread] subscribeNext:^(RACTuple *tupe) {
                
                [button setTitle:tupe.first forState:UIControlStateNormal];
            }];
            
            return signal;
        }];
        
    }];
    
    self.bindEmailCommand = [[RACCommand alloc] initWithEnabled:validEmailRegisterSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            NSDictionary *para = @{
                                   @"type":@(1),
                                   @"content":self.eamil,
                                   @"verifyCode":self.emailVaeifyCode
                                   };
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:ModifyUserInfo_URL params:para success:^(NSDictionary *response) {
                
                
                [subscriber sendNext:response];
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

#pragma mark - Public Methods


#pragma mark - Privater Methods
- (RACSignal *)retrySendVerifyCodeSignal {
    static const NSInteger n = 60;
    RACSignal *timer = [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]]
                         map:^id(id value) {
                             return nil;
                         }]
                        startWith:nil];
    
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    for (NSInteger i = n; i >= 0; i--) {
        [numbers addObject:[NSNumber numberWithInteger:i]];
    }
    
    return [[[[numbers.rac_sequence.signal zipWith:timer]
              map:^id(RACTuple *tuple) {
                  
                  NSNumber *number = tuple.first;
                  NSInteger count = number.integerValue;
                  
                  if (count == 0) {
                      return RACTuplePack(NSLocalizedString(@"2.0_GetVerificationCode", nil), [NSNumber numberWithBool:YES]);
                  } else {
                      NSString *title = [NSString stringWithFormat:@"%@ (%ld)",NSLocalizedString(@"2.0_GetNewCode", nil), (long)count];
                      return RACTuplePack(title, [NSNumber numberWithBool:NO]);
                  }
              }]
             takeUntil:[self rac_willDeallocSignal]]
            logCompleted];
}

// 校验邮箱是否绑定
- (RACSignal *)varildEMSSignal
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        @strongify(self);
        
        NSDictionary *parm = @{@"content":self.eamil,
                               @"validType":@"1"
                               };
        IDCMURLSessionTask *task = [IDCMRequestList requestPostNoHUDAuth:ValidUserInfo_URL params:parm success:^(NSDictionary *response) {
            
            
            [subscriber sendNext:response];
            [subscriber sendCompleted];
            
        } fail:^(NSError *error, NSURLSessionDataTask *task) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
        
    }];
}
#pragma mark - NetWork


#pragma mark - Getter & Setter

@end
