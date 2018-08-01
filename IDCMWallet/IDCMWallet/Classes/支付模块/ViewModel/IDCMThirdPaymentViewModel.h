//
//  IDCMThirdPaymentViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMThirdPayModel.h"

@interface IDCMThirdPaymentViewModel : IDCMBaseViewModel
/**
 *  数据model
 */
@property (strong, nonatomic) IDCMThirdPayModel *payModel;
/**
 *   PIN
 */
@property (copy, nonatomic) NSString *payPassword;
/**
 *   商户名
 */
@property (copy, nonatomic) NSString *companyName;
/**
 *  获取客户信息
 */
@property (strong, nonatomic) RACCommand *getInfoCommand;
@end


