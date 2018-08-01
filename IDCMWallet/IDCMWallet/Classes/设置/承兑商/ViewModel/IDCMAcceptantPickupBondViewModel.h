//
//  IDCMAcceptantPickupBondViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
@class IDCMAcceptantCoinModel;

@interface IDCMAcceptantPickupBondViewModel : IDCMBaseViewModel
@property (nonatomic,strong) NSArray <IDCMAcceptantCoinModel *> *coinArray;///< 币列表
@property (nonatomic,strong) IDCMAcceptantCoinModel *selectCoinModel;///< 选中的货币

@property (nonatomic,copy) NSString *withdrawAmount; //可提取余额


@property (nonatomic,strong) NSAttributedString *currency;
@property (nonatomic,copy) NSString *countValue;
@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong) RACCommand *pickupBondcommand;///< pos请求 提取
@property (nonatomic,strong) RACCommand *btnToPickupBondcommand;///< 点击按钮
@property (nonatomic,strong) RACCommand *getOTCListCoincommand;///< post请求 获取币列表


/**
 *  验证地址合法性
 */
@property (strong, nonatomic) RACCommand *varifyAddressCommand;
/**
 *  切割地址
 */
@property (strong, nonatomic) RACCommand *validComplicatedAddressCommand;
@end
