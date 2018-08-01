//
//  IDCMSetPINViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/26.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMSetPINViewModel : IDCMBaseViewModel

/**
 *   新PIN
 */
@property (copy, nonatomic) NSString *newpassword;
/**
 *   确认PIN
 */
@property (copy, nonatomic) NSString *confirmPassword;

@property (nonatomic, strong) RACSignal *validNextSignal;
@property (nonatomic, strong) RACCommand *setPayPassWordCommand;

/**
 *  设置PIN的类型  0:作为跟控制器时设置  1：备份助记词后设置
 */
@property (strong, nonatomic) NSNumber *setPINType;

@end
