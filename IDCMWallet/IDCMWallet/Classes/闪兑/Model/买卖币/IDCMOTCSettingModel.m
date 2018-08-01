

//
//  IDCMOTCSettingModel.m
//  IDCMWallet
//
//  Created by mac on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCSettingModel.h"
@interface IDCMOTCSettingModel ()
@property(nonatomic,strong)NSMutableArray * dk_payment ;
@end
@implementation IDCMOTCSettingModel
//+(NSDictionary *)mj_objectClassInArray{
//    return @{@"CoinSettings":@"IDCMOTCCionModel",
//             @"Currencies": @"IDCMOTCCurrencyModel",
//             @"Payments":@"IDCMOTCPaymentModel"
//             };
//}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"CoinSettings":[IDCMOTCCionModel class],
             @"Currencies":[IDCMOTCCurrencyModel class],
             @"Payments":[IDCMOTCPaymentModel class],
             };
}
-(NSMutableArray<IDCMOTCPaymentModel *> *)dk_correspondPayments{
    [self.dk_payment removeAllObjects];
    for (IDCMOTCPaymentModel * paymentModel in self.Payments) {
        
        if ([paymentModel.LocalCurrencyCode isEqualToString:self.selectCurrency]) {
            [self.dk_payment addObject:paymentModel];
        }
    }
    return self.dk_payment;
    
}
-(NSMutableArray *)dk_payment{
    return SW_LAZY(_dk_payment, @[].mutableCopy);
}
@end
