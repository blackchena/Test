//
//  IDCMNewOrderNoticeAcceptantModel.m
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMNewOrderNoticeAcceptantModel.h"

@implementation IDCMNewOrderNoticeAcceptantModel

-(NSInteger)defDeadLineSeconds {
    return [IDCMDataManager sharedDataManager].settingModel.AllowQuotePriceDuration;
}

@end
