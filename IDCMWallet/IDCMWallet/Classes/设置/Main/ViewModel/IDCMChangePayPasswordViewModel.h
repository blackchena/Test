//
//  IDCMChangePayPasswordViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMChangePayPasswordViewModel : IDCMBaseViewModel
/**
 *   原密码
 */
@property (copy, nonatomic) NSString *originalPayPwd;


@property (nonatomic, strong) RACCommand *verifyOldCommand;


@end
