//
//  IDCMMaintenanceViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/27.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMMaintenanceViewModel.h"

@implementation IDCMMaintenanceViewModel
#pragma mark - Life Cycle
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.url = params[@"url"];
    }
    return self;
}
- (void)initialize
{
    [super initialize];
}

- (RACSignal *)executeRequestDataSignal:(id)input{
    
    // 区分客户端类型   1:企业分发   3:App Store
    NSString *clientName = [[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey] ? @"1" : @"3";
    NSString *url = [NSString stringWithFormat:@"%@?client=%@&lang=%@",CheckServerMaintenance_URL,clientName,[IDCMUtilsMethod getServiceLanguage]];
    return [RACSignal signalGetNotAuthHUD:url serverName:MaintenanceServerName params:nil handleSignal:^(id response, id<RACSubscriber> subscriber) {
        NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]] && [response[@"data"][@"isMaintenance"] isKindOfClass:[NSNumber class]]) {
            if ([response[@"data"][@"isMaintenance"] integerValue] == 1) { // 还在维护
                
                [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_MaintenanceUpgrading") withPosition:QMUIToastViewPositionTop];
                
            }else{ // 结束维护
                
                [IDCM_APPDelegate setRootViewController];
            }
        }
        [subscriber sendCompleted];
    }];
}
@end
