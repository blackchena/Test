//
//  IDCMOTCExchangeRecordModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCExchangeRecordModel.h"
#import "NSDate+Time.h"


@implementation IDCMOTCExchangeRecordModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
/*
 WaitQuotePrice = 0,            /// 待报价
 WaitPay = 1,                  /// 待转账
 Transfered = 2,              /// 已转账
 Paied = 3,                  /// 已支付
 Appeal = 4,                /// 申诉中
 UploadPayCertficate = 5,  /// 待上传支付凭证
 WaitApproval = 6,        /// 待审核
 
 CustomerRefund = 7,     /// 客服退回
 CustomerPayCoin = 8,   /// 客服放币
 
 //WaitRefundCoin = 10,  /// 待退币
 //AgreeRefund = 11,   /// 同意退还
 
 Cancel = 9,         /// 取消
 Finish = 12        /// 完成
 */
- (instancetype)handleModel {

    if (self.Direction == 1) {
       self.customerLeftImageName =  @"3.2_OTCBuy";
       self.customerCountCurrey =
        [NSString stringWithFormat:@"+%@ %@",[self handleNumber:self.Num] ,[self.CoinCode uppercaseString]];
    } else {
        self.customerLeftImageName =  @"3.2_OTCSell";
        self.customerCountCurrey =
        [NSString stringWithFormat:@"-%@ %@", [self handleNumber:self.Num], [self.CoinCode uppercaseString]];
    }
    self.customerUserName = ([[IDCMDataManager sharedDataManager].userID integerValue] == self.UserId ? self.AcceptantName: self.UserName)?:@"";
    
    self.customerTime =
    [NSDate dateToString:@"yyyy-MM-dd HH:mm" byDate:[NSDate dateWithTimeIntervalSince1970:self.CreateTimestamp/1000]];
    
    NSInteger status = self.Status;
    NSString * orderStatus = @"";
    switch (status) {
        case 0:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus0");
            break;
        case 1:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus1");
            break;
        case 2:
        case 3:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus2");
            break;
//        case 3:
//            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus3");
//            break;
        case 4:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus4");
            break;
        case 5:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus5");
            break;
        case 6:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus6");
            break;
        case 7:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus7");
            break;
        case 8:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus8");
            break;
        case 9:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus9");
            break;
        case 10:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus10");
            break;
        case 11:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus11");
            break;
        case 12:
            orderStatus = SWLocaloziString(@"3.0_DK_orderStatus12");
            break;
        default:
            break;
    }
    self.customerStatus = orderStatus;// [self getStatus:self.Status];// [NSString stringWithFormat:@"%zd",self.Status];
    return self;
}

- (NSString *)handleNumber:(NSNumber *)number {
    NSString *precisionControlStr = [IDCMUtilsMethod precisionControl:number];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:precisionControlStr];
    NSString *str = [NSString stringFromNumber:decimalNumber fractionDigits:4];
    NSString *bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
    return bitcoinString;
}


@end









