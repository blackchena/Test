//
//  IDCMwithdrawalViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/27.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMThirdPayModel.h"

@interface IDCMwithdrawalViewModel : IDCMBaseViewModel
/**
 *   PIN
 */
@property (copy, nonatomic) NSString *payPassword;
/**
 *   接收地址
 */
@property (copy, nonatomic) NSString *reciveAddress;
/**
 *  数据model
 */
@property (strong, nonatomic) IDCMThirdPayModel *payModel;
/**
 *  验证地址合法性
 */
@property (strong, nonatomic) RACCommand *varifyAddressCommand;
/**
 *  切割地址
 */
@property (strong, nonatomic) RACCommand *validComplicatedAddressCommand;
/**
 *  接收地址
 */
@property (strong, nonatomic) RACCommand *reciveCommand;
/**
 *  地址长度验证
 */
@property (nonatomic, strong) RACSignal *validAddressSignal;
@end
