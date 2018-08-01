//
//  IDCMPCLoginViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMPCLoginViewModel : IDCMBaseViewModel


@property (nonatomic,strong) NSNumber *invalid;
@property (nonatomic,copy) NSString *clientId;
@property (nonatomic,strong) RACCommand *authorizedCommand;

@end
