//
//  IDCMLoginViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/23.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMLoginViewModel : IDCMBaseViewModel

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
 *   手机密码
 */
@property (copy, nonatomic) NSString *mobliePassword;

/**
 *   邮箱
 */
@property (copy, nonatomic) NSString *eamil;
/**
 *   邮箱密码
 */
@property (copy, nonatomic) NSString *eamilPassword;


@property (nonatomic, strong) RACSignal *validMobileLoginSignal;
@property (nonatomic, strong) RACSignal *validEmailLoginSignal;



@property (nonatomic, strong) RACCommand *loginCommand;
@end
