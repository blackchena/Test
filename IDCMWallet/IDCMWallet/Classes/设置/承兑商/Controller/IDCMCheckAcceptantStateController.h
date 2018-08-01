//
//  IDCMCheckAcceptantStateController.h
//  IDCMWallet
//
//  Created by wangpu on 2018/5/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewController.h"

typedef NS_ENUM(NSUInteger, OTCCheckAcceptantState) {
    
    AcceptantStateNotPass = 1  ,//  未开通
    AcceptantStateCheck,    ////  待审核
    AcceptantStatePass ,////  .已开通
    AcceptantStateFrozen , //已暂停
};

@interface IDCMCheckAcceptantStateController : IDCMBaseViewController

@end
