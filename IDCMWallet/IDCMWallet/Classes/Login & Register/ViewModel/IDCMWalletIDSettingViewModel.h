//
//  IDCMWalletIDSettingViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMWalletIDSettingViewModel : IDCMBaseViewModel

@property (nonatomic,copy) NSString *wallteID;
@property (nonatomic,copy) NSString *inviteCode;
@property (nonatomic,strong) RACCommand *verifyAccountCommand;
@property (nonatomic,strong) void(^endEditingCallback)(void);

@property (nonatomic, strong) RACCommand *registerCommand;
@end
