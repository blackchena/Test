//
//  IDCMSetPayPassWordVIewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/28.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMSetPayPassWordViewModel : IDCMBaseViewModel
/**
 *   账号密码
 */
@property (copy, nonatomic) NSString *newpassword;

@property (nonatomic, strong) RACCommand *verifyOldCommand;

@end
