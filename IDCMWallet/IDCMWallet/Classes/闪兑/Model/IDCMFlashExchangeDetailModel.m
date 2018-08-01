//
//  IDCMFlashRecordDetailModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFlashExchangeDetailModel.h"


@implementation IDCMFlashExchangeDetailModel

- (instancetype)handleModel {
    [self handelCashCount];
    [self handleCashStatus];
    [self handleTotalData];
    return self;
}

- (void)handelCashCount {
    self.customerCashOut = [NSString idcw_stringWithFormat:@"%@ %@",
                            [self handleNumber:self.Amount],
                            [self.Currency uppercaseString]];
    
    self.customerCashEnter = [NSString idcw_stringWithFormat:@"%@ %@",
                              [self handleNumber:self.ToAmount],
                              [self.ToCurrency uppercaseString]];
}

- (void)handleCashStatus {
    
    // 对出
    if ([self.InStatus isEqualToString:@"2"]) {
        // 对出失败
        self.customerCashOutState = NSLocalizedString(@"2.2.1_FailedTransfer", nil);
    } else {
        // 对出中
        if ([self.MinCount integerValue] > [self.ConfirmCount integerValue]) {
            self.customerCashOutState = [NSString idcw_stringWithFormat:@"%@ (%zd/%zd %@)",
                                         NSLocalizedString(@"2.1_Ongoing", nil),
                                         [self.ConfirmCount integerValue],
                                         [self.MinCount integerValue],
                                         NSLocalizedString(@"2.1_Confirmed", nil)];
            
        } else {
            // 对出完成
            NSString *str = [NSString stringWithFormat:@"%zd", [self.ConfirmCount integerValue]];
            if ([self.ConfirmCount integerValue] > 1000) {
                str = @"1,000+";
            }
            self.customerCashOutState = [NSString idcw_stringWithFormat:@"%@ (%@ %@)",
                                         NSLocalizedString(@"2.0_Complete", nil),
                                         str,
                                         NSLocalizedString(@"2.1_Confirmed", nil)];
        }
    }
    
     // 对入
    if ([self.OutStatus isEqualToString:@"2"]) {
        // 对入失败
         self.customerCashEnterState = NSLocalizedString(@"2.2.1_FailedTransfer", nil);
    } else {
        // 对入中
        if ([self.ToMinCount integerValue] > [self.ToConfirmCount integerValue]) {
            self.customerCashEnterState = [NSString idcw_stringWithFormat:@"%@ (%zd/%zd %@)",
                                           NSLocalizedString(@"2.1_Ongoing", nil),
                                           [self.ToConfirmCount integerValue],
                                           [self.ToMinCount integerValue],
                                           NSLocalizedString(@"2.1_Confirmed", nil)];
        } else {
            // 对入完成
            NSString *str = [NSString stringWithFormat:@"%zd", [self.ToConfirmCount integerValue]];
            if ([self.ToConfirmCount integerValue] > 1000) {
                str = @"1,000+";
            }
            self.customerCashEnterState = [NSString idcw_stringWithFormat:@"%@ (%@ %@)",
                                           NSLocalizedString(@"2.0_Complete", nil),
                                           str,
                                           NSLocalizedString(@"2.1_Confirmed", nil)];
        }
    }
    
    /*
     * 0是兑出中,      兑入中，
     * 1是兑出完成。   兑入中，
     * 2是兑出完成    兑入完成，
     * 3是兑出完成   兑入完成
     * 4是兑出失败  兑入失败，
     * 5是兑出完成 兑入失败，
     * */
//    switch ([self.Status integerValue]) {
//        case 0:{ // 0是兑出中,      兑入中，
//            self.customerCashOutState = [NSString stringWithFormat:@"%@(%zd/%zd %@)",
//                                         NSLocalizedString(@"2.1_Ongoing", nil),
//                                         [self.ConfirmCount integerValue],
//                                         [self.MinCount integerValue],
//                                         NSLocalizedString(@"2.1_Confirmed", nil)];
//            
//            self.customerCashEnterState = [NSString stringWithFormat:@"%@(%zd/%zd %@)",
//                                           NSLocalizedString(@"2.1_Ongoing", nil),
//                                           [self.ToConfirmCount integerValue],
//                                           [self.ToMinCount integerValue],
//                                           NSLocalizedString(@"2.1_Confirmed", nil)];
//        }break;
//        case 1:{ // 兑出完成。   兑入中，
//            self.customerCashOutState = [NSString stringWithFormat:@"%@(%zd %@)",
//                                         NSLocalizedString(@"2.0_Complete", nil),
//                                         [self.ConfirmCount integerValue],
//                                         NSLocalizedString(@"2.1_Confirmed", nil)];
//            
//            self.customerCashEnterState = [NSString stringWithFormat:@"%@(%zd/%zd %@)",
//                                           NSLocalizedString(@"2.1_Ongoing", nil),
//                                           [self.ToConfirmCount integerValue],
//                                           [self.ToMinCount integerValue],
//                                           NSLocalizedString(@"2.1_Confirmed", nil)];
//        }break;
//        case 2:   // 兑出成功 兑入成功
//        case 3:{ // 是推送交易所成功 整个交易完成
//            self.customerCashOutState = [NSString stringWithFormat:@"%@(%zd %@)",
//                                         NSLocalizedString(@"2.0_Complete", nil),
//                                         [self.ConfirmCount integerValue],
//                                         NSLocalizedString(@"2.1_Confirmed", nil)];
//            
//            self.customerCashEnterState = [NSString stringWithFormat:@"%@(%zd %@)",
//                                           NSLocalizedString(@"2.0_Complete", nil),
//                                           [self.ToConfirmCount integerValue],
//                                           NSLocalizedString(@"2.1_Confirmed", nil)];
//        }break;
//        case 4:{ // 兑出失败 -> 对入失败
//            self.customerCashOutState = NSLocalizedString(@"2.2.1_FailedTransfer", nil);
//            self.customerCashEnterState = NSLocalizedString(@"2.2.1_FailedTransfer", nil);
//            
//        }break;
//        case 5:{ // 兑出成功 兑入失败
//            self.customerCashOutState = [NSString stringWithFormat:@"%@(%zd %@)",
//                                         NSLocalizedString(@"2.0_Complete", nil),
//                                         [self.ConfirmCount integerValue],
//                                         NSLocalizedString(@"2.1_Confirmed", nil)];
//            
//            self.customerCashEnterState = NSLocalizedString(@"2.2.1_FailedTransfer", nil);
//        }break;
//        default:
//        break;
//    }
}

- (void)handleTotalData {
    self.customerExchangeOutFee = [NSString idcw_stringWithFormat:@"%@ %@",
                                  [self handleNumber:self.Fee],
                                  [self.Unit uppercaseString]];
    
    self.customerExchangeRate = [NSString idcw_stringWithFormat:@"1 %@ = %@ %@",
                                 [self.Currency uppercaseString],
                                 [self handleNumber:self.ExchangeRate fractionDigits:[self.RateDigit integerValue]],
                                 [self.ToCurrency uppercaseString]];
    
    self.customerExchangeTime = self.CreateTime;
}

- (NSString *)handleNumber:(NSNumber *)number
            fractionDigits:(NSInteger)fractionDigits {
    
    NSString *precisionControlStr = [IDCMUtilsMethod precisionControl:number];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:precisionControlStr];
    NSString *str = [NSString stringFromNumber:decimalNumber fractionDigits:fractionDigits];
    NSString *bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
    return bitcoinString;
}

- (NSString *)handleNumber:(NSNumber *)number {
    NSString *precisionControlStr = [IDCMUtilsMethod precisionControl:number];
    NSString *bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:precisionControlStr];
    return bitcoinString;
}


@end




