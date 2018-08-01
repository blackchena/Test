//
//  IDCMUserStateModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMUserStateModel : IDCMBaseModel
/**
 *   电子邮件
 */
@property (copy, nonatomic) NSString *email;
/**
 *   邮箱是否验证
 */
@property (copy, nonatomic) NSString *emailValid;
/**
 *   手机号
 */
@property (copy, nonatomic) NSString *mobil;
/**
 *   手机号是否验证
 */
@property (copy, nonatomic) NSString *mobilValid;
/**
 *   找回短语是否设置
 */
@property (copy, nonatomic) NSString *wallet_phrase;
/**
 *   支付密码是否设置
 */
@property (copy, nonatomic) NSString *payPassword;
@end
