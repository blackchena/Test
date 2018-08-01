//
//  IDCMOTCExchangeDetailModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCExchangeDetailModel.h"
#import "NSDate+Time.h"


@implementation IDCMOTCExchangeDetailPayAttributes
@end
@implementation IDCMOTCExchangeDetailPaymentModel
- (instancetype)handleModel {
    self.payAttributesModel =
    [IDCMOTCExchangeDetailPayAttributes yy_modelWithDictionary:self.PayAttributes];
    return self;
}
@end



@interface IDCMOTCExchangeDetailModel ()
@property (nonatomic,strong) RACDisposable *timeDispos;
@end

@implementation IDCMOTCExchangeDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

- (instancetype)handleModel {
    @weakify(self);
    
    IDCMSysSettingModel *set = [IDCMDataManager sharedDataManager].settingModel;
    self.ConfirmTransferDuration = set.ConfirmTransferDuration;
    self.HandlerAppealDuration = set.HandlerAppealDuration;
    self.ConfirmReceivablesDuration = set.ConfirmReceivablesDuration ;
    
    self.isDelay = self.IsTimeExpand;
    self.exchangeType = self.Direction;
    
    self.customerBuySeller =
    ([[IDCMDataManager sharedDataManager].userID isEqualToString:self.UserId] ?
     self.AcceptantName: self.UserName)?:@"";
    
    self.customerPhone =
    ([[IDCMDataManager sharedDataManager].userID isEqualToString:self.UserId] ?
     self.AcceptantPhone : self.UserPhone)?:@"";
    self.customerPayMethodNo = self.PayCertificateNO ?: @"";
    
    self.customerOrderNo =
    [NSString idcw_stringWithFormat:@"%@: %@",NSLocalizedString(@"3.0_Hy_OTCExchangeDetailOrderNoTitle", nil),
     self.OrderNo];
    
    self.customerBuyCountInfo =
    [NSString idcw_stringWithFormat:@"%@ %@", [self handleNumber:self.Num], [self.CoinCode uppercaseString]];
    
    NSString  *money = [NSString stringFromNumber:self.Amount fractionDigits:4];
    NSString  *moneyStr = [NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod separateNumberUseCommaWith:money]];
    self.customerBuyPayCountInfo = [NSString idcw_stringWithFormat:@"%@ %@", moneyStr, self.LocalCurrencyName];
    
    self.customerOrderTime =
    [NSDate dateToString:@"yyyy-MM-dd HH:mm" byDate:[NSDate dateWithTimeIntervalSince1970:self.CreateTimestamp/1000]];

    if (self.Status == 3) {
        self.Status = 2;
    }
    if (self.Status == 10 || self.Status == 11 || self.Status == 7) {
        self.Status = 8;
    }
    if (self.Status == 1 && self.isDelay) {
        self.Status = 13;
    }
    if (self.exchangeType == OTCExchangeType_Buy) {
        self.exchangeBuyStateType = self.Status;
    } else {
        self.exchangeSellStateType = self.Status;
    }

    for (NSDictionary *dict in self.Payments) {
       IDCMOTCExchangeDetailPaymentModel *model =
        [[IDCMOTCExchangeDetailPaymentModel yy_modelWithDictionary:dict] handleModel];
        model.isSelected = [self.PaymentModeId isEqualToString:model.ID];
        [self.paymentsArray addObject:model];
    }
    
    if (self.exchangeType == OTCExchangeType_Buy) {
        [RACObserve(self, exchangeBuyStateType) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.timeDispos dispose];
            NSInteger state = [x integerValue];
            if (state == OTCExchangeBuyStateType_Doing ||
                state == OTCExchangeBuyStateType_DoingSetDelay ||
                state == OTCExchangeBuyStateType_Payed ||
                state == OTCExchangeBuyStateType_Appeal ||
                state == OTCExchangeBuyStateType_AppealDoing) {
                [self handleCountDownTime];
            }
        }];
    } else {
        [RACObserve(self, exchangeSellStateType) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.timeDispos dispose];
            NSInteger state = [x integerValue];
            if (state == OTCExchangeSellStateType_Doing ||
                state == OTCExchangeSellStateType_DoingSetDelay ||
                state == OTCExchangeSellStateType_Payed ||
                state == OTCExchangeSellStateType_AppealDoing ||
                state == OTCExchangeSellStateType_AppealUploadWaitting) {
                [self handleCountDownTime];
            }
        }];
    }
    return self;
}

- (void)handleCountDownTime {
    @weakify(self);
    
    self.timeCountDown =  self.StatusTimeSeconds;
    if (self.timeCountDown <= 0) {
        [self handelTimeCount];
        [self handleDelay];
    }
    
    if (self.timeCountDown > 0) {
        [self handelTimeCount];
        
        self.timeDispos =
        [[IDCMDataManager sharedDataManager].oneSecondSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            @synchronized(self) {
                self.timeCountDown--;
                [self handelTimeCount];
            }
        }];
        
        [RACObserve(self, timeCountDown) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if ([x integerValue] <= 0) {
                [self handleDelay];
            }
        }];
    }
}

- (void)handleDelay {
    [self handelTimeCount];
    if (self.exchangeType == OTCExchangeType_Buy) {
        if (self.exchangeBuyStateType == OTCExchangeBuyStateType_Doing ||
            self.exchangeBuyStateType == OTCExchangeBuyStateType_DoingSetDelay) {
            self.exchangeBuyStateType = OTCExchangeBuyStateType_DoingDelay;
            [self.timeDispos dispose];
        }
        if (self.exchangeBuyStateType == OTCExchangeBuyStateType_Payed) {
            self.exchangeBuyStateType = OTCExchangeBuyStateType_PayedHandleDelay;
            [self.timeDispos dispose];
        }
        if (self.exchangeBuyStateType == OTCExchangeBuyStateType_Appeal) {
            self.exchangeBuyStateType = OTCExchangeBuyStateType_AppealDelay;
            [self.timeDispos dispose];
        }
        if (self.exchangeBuyStateType == OTCExchangeBuyStateType_AppealDoing) {
            self.exchangeBuyStateType = OTCExchangeBuyStateType_AppealDoingDelay;
            [self.timeDispos dispose];
        }
    } else {
        if (self.exchangeSellStateType == OTCExchangeSellStateType_Doing ||
            self.exchangeSellStateType == OTCExchangeSellStateType_DoingSetDelay) {
            self.exchangeSellStateType = OTCExchangeSellStateType_DoingDelay;
            [self.timeDispos dispose];
        }
        if (self.exchangeSellStateType == OTCExchangeSellStateType_Payed) {
            self.exchangeSellStateType = OTCExchangeSellStateType_PayedHandleDelay;
            [self.timeDispos dispose];
        }
        if (self.exchangeSellStateType == OTCExchangeSellStateType_AppealDoing) {
            self.exchangeSellStateType = OTCExchangeSellStateType_AppealDelay;
            [self.timeDispos dispose];
        }
        if (self.exchangeSellStateType == OTCExchangeSellStateType_AppealUploadWaitting) {
            self.exchangeSellStateType = OTCExchangeSellStateType_AppealUploadWaitDelay;
            [self.timeDispos dispose];
        }
    }
}

- (void)handelTimeCount{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSTimeInterval timeout = self.timeCountDown;
        NSInteger ms = timeout;
        NSInteger ss = 1;
        NSInteger mi = ss * 60;
        NSInteger hh = mi * 60;
        NSInteger dd = hh * 24;
        NSInteger dayNum = ms / dd;// 天
        NSInteger hourNum = (ms - dayNum * dd) / hh;// 时
        NSInteger minuteNum = (ms - dayNum * dd - hourNum * hh) / mi;// 分
        NSInteger secondNum = (ms - dayNum * dd - hourNum * hh - minuteNum * mi) / ss;// 秒
        
        NSString *day = [self handleTimeStr:dayNum];
        NSString *hour = [self handleTimeStr:hourNum];
        NSString *minute = [self handleTimeStr:minuteNum];
        NSString *second = [self handleTimeStr:secondNum];
        
        BOOL canBuy = self.exchangeType == OTCExchangeType_Buy &&
        (self.exchangeBuyStateType == OTCExchangeBuyStateType_Payed ||
         self.exchangeBuyStateType == OTCExchangeBuyStateType_PayedHandleDelay);
        
        BOOL canSell = self.exchangeType == OTCExchangeType_Sell &&
        (self.exchangeSellStateType == OTCExchangeSellStateType_Payed ||
         self.exchangeSellStateType == OTCExchangeSellStateType_PayedHandleDelay);
       
        NSString *timeStr = [NSString stringWithFormat:@"%@:%@", minute, second];
        if (canBuy || canSell) {
            timeStr = [NSString stringWithFormat:@"%@:%@:%@",hour, minute, second];
             if (dayNum > 0) {
                timeStr = [NSString stringWithFormat:@"%@:%@:%@",day, hour,timeStr];
             }
        } else {
            if (dayNum <= 0 && hourNum > 0) {
                timeStr = [NSString stringWithFormat:@"%@:%@",hour,timeStr];
            } else if (dayNum > 0) {
                timeStr = [NSString stringWithFormat:@"%@:%@:%@",day, hour,timeStr];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeCountDownString = timeStr;
        });
    });
}

- (NSString *)handleTimeStr:(NSInteger)time {
    NSString *str = @"00";
    if (time > 0 && time < 10) {
        str = [NSString stringWithFormat:@"0%zd", time];
    }
    if (time >= 10) {
        str = [NSString stringWithFormat:@"%zd", time];
    }
    return str;
}

- (NSString *)handleNumber:(NSNumber *)number {
    NSString *precisionControlStr = [IDCMUtilsMethod precisionControl:number];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:precisionControlStr];
    NSString *str = [NSString stringFromNumber:decimalNumber fractionDigits:4];
    NSString *bitcoinString = [IDCMUtilsMethod separateNumberUseCommaWith:str];
    return bitcoinString;
}

- (void)disposeAllSignal {
    [self.timeDispos dispose];
}

- (NSMutableArray<IDCMOTCExchangeDetailPaymentModel *> *)paymentsArray {
    return SW_LAZY(_paymentsArray, ({
        @[].mutableCopy;
    }));
}

@end
















