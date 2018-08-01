//
//  IDCMFlashExchangeController.h
//  IDCMWallet
//
//  Created by wangpu on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewController.h"

@interface IDCMFlashExchangeController : IDCMBaseViewController



@property (nonatomic,assign) BOOL netRequestDone;

//获取余额 开启轮询
-(void)requestBalanceAndCoinList;
-(void)refreshBalance:(BOOL)isHUD;
@end
