//
//  IDCMBindMobileViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMBindMobileViewModel : IDCMBaseViewModel
/**
 *   控制器类型 0:绑定  1:修改
 */
@property (copy, nonatomic) NSNumber *type;
/**
 *   国家
 */
@property (copy, nonatomic) NSString *countryName;
/**
 *   手机区号
 */
@property (copy, nonatomic) NSString *moblieCode;
/**
 *   手机号
 */
@property (copy, nonatomic) NSString *moblie;
/**
 *   手机验证码
 */
@property (copy, nonatomic) NSString *moblieVaeifyCode;


@property (nonatomic, strong) RACCommand *sendSmsCommand;

@property (nonatomic, strong) RACCommand *authButtonCommand;

@property (nonatomic, strong) RACCommand *bindMobileCommand;

@end
