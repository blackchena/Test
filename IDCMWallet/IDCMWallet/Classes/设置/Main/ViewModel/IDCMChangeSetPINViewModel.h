//
//  IDCMChangeSetPINViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/28.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMChangeSetPINViewModel : IDCMBaseViewModel
/**
 *   原密码
 */
@property (copy, nonatomic) NSString *originalPayPwd;
/**
 *   新密码
 */
@property (copy, nonatomic) NSString *newpassword;


@end
