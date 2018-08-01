//
//  IDCMPCLoginViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPCLoginViewModel.h"


@implementation IDCMPCLoginViewModel

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.clientId = params[@"clientId"];
        self.invalid = @0;
    }
    return self;
}

- (RACCommand *)authorizedCommand {
    return SW_LAZY(_authorizedCommand, ({
        @weakify(self);
        
        [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                
                IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
                NSDictionary *parm = @{ @"device_Id"  : model.device_id,
                                        @"client_id": self.clientId,
                                        @"type": input};
                
                IDCMURLSessionTask *task = [IDCMRequestList requestPostAuthNoHUD:QrCodeAuthorized_URL params:parm success:^(NSDictionary *response) {
                    
                    NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                    if ([status integerValue] == 1) {
                        NSDictionary *data = response[@"data"];
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            if ([data[@"status"] integerValue] == 3) {
                                self.invalid = @1;
                                [subscriber sendNext:nil];
                            } else {
                                if ([input boolValue]) {
                                    [subscriber sendNext:response];
                                } else {
                                    [subscriber sendNext:nil];
                                }
                            }
                            [subscriber sendCompleted];
                        } else {
                            [subscriber sendError:[NSError new]];
                        }
                        
                    } else {
                        [subscriber sendError:[NSError new]];
                    }
                } fail:^(NSError *error, NSURLSessionDataTask *task) {
                        [subscriber sendError:error];
                }];
                return [RACDisposable disposableWithBlock:^{
                    [task cancel];
                }];
            }];
        }];
    }));
}

@end






