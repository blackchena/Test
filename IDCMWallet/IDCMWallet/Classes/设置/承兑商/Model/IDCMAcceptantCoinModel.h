//
//  IDCMAcceptantCoinModel.h
//  IDCMWallet
//
//  Created by wangpu on 2018/5/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMAcceptantCoinModel : IDCMBaseViewModel

@property (nonatomic,copy) NSString * coinID;
@property (nonatomic,copy) NSString * coinCode;
@property (nonatomic,copy) NSString * conLogo;
@property (nonatomic,strong) NSNumber * minAmount;
@property (nonatomic,strong) NSNumber * maxAmount;
@property (nonatomic,strong) NSString * premium;
@property (nonatomic,copy) NSString * sysWalletAddress;
@property (nonatomic,copy) NSNumber * DepositBanlance; //提取保证金的余额显示
@property (nonatomic,assign) BOOL isSelect;

-(NSString *) coinCodeUpperString;
@end
