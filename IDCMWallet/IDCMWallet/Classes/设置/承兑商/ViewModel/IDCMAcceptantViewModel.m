//
//  IDCMAcceptantViewModel.m
//  IDCMWallet
//
//  Created by wangpu on 2018/5/12.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMAcceptantViewModel.h"

@implementation IDCMAcceptantViewModel

- (void)initialize
{
    [super initialize];
    
    //获取保证金
    _OTCGetStateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //请求余额
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptant_URL params:nil success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"]) {
                    [subscriber sendNext:response];
                }else{
                    [IDCMShowMessageView showMessageWithCode:status];
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


@implementation IDCMAcceptantDepositModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"dataID":@"id",
             @"coinID":@"CoinId",
             @"coinCode":@"CoinCode",
             @"coinName":@"CoinName",
             @"logo":@"Logo",
             @"useAmount":@"UseNum",
             @"precision":@"Precision",
             @"sort":@"Sort",
             };
}
-(NSString *) useAmountStr{
    
    return  [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:self.useAmount]] fractionDigits:4] ;
    
}

-(NSString *)coinNameUpperStr{
    return self.coinCode.uppercaseString;
}
@end
