//
//  IDCMBindEmailViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @abstract <#类的描述#>
// @discussion <#类的功能#>


#import "IDCMBaseViewModel.h"

@interface IDCMBindEmailViewModel : IDCMBaseViewModel

/**
 *   控制器类型标题  0:绑定  1:修改
 */
@property (copy, nonatomic) NSNumber *type;
/**
 *   邮箱
 */
@property (copy, nonatomic) NSString *eamil;
/**
 *   邮箱验证码
 */
@property (copy, nonatomic) NSString *emailVaeifyCode;



@property (nonatomic, strong) RACCommand *sendEmailCommand;

@property (nonatomic, strong) RACCommand *authButtonCommand;

@property (nonatomic, strong) RACCommand *bindEmailCommand;

@end
