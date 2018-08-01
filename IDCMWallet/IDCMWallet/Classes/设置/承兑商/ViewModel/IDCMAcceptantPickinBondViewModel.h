//
//  IDCMAcceptantPickinBondViewModel.h
//  IDCMWallet
//
//  Created by IDCM on 2018/5/10.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"
@class IDCMAcceptantCoinModel;

@interface IDCMAcceptantPickinBondViewModel : IDCMBaseViewModel

@property (nonatomic,strong) NSArray <IDCMAcceptantCoinModel *> *coinArray;///< 币列表

@property (nonatomic,strong) IDCMAcceptantCoinModel *selectCoinModel;///< 选中的货币
@property (nonatomic,strong) NSAttributedString *currency;
@property (nonatomic,copy) NSString *countValue;
@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *withdrawAmount; //可提取余额

@property (nonatomic,strong) RACCommand *btnToPickinBondcommand;///< 点击按钮

@property (nonatomic,strong) RACCommand *pickinBondcommand;///< pos请求 充值
@property (nonatomic,strong) RACCommand *getOTCCoincommand;///< post请求 获取币列表
@property (nonatomic,strong) RACCommand *getBalanceByCoinCommand;///< get请求 获取余额
@end
