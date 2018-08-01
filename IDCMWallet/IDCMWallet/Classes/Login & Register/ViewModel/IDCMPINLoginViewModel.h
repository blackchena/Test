//
//  IDCMPINLoginViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMPINLoginViewModel : IDCMBaseViewModel
@property (nonatomic,strong) RACCommand *verifyPIN;
@property (nonatomic,strong) RACCommand *logoutCommand;
@end
