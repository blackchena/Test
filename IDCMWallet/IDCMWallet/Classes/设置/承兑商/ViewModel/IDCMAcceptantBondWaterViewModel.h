//
//  IDCMAcceptantBondWaterViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
@class IDCMAcceptantBondWaterModel;


@interface IDCMAcceptantBondWaterViewModel : IDCMBaseViewModel

@property (nonatomic,strong) NSString *CoinId;///< 币的id
@property (nonatomic,strong) NSString *CoinCode;///< 币的code
@property (nonatomic,strong) NSString *JumpType;///< 跳转 提取成功0 其他1

@property (nonatomic,assign) NSNumber *PageSize;///< 每页多少

@property (nonatomic,assign) NSNumber * PageIndex ;///< 页数下标
@property (nonatomic,assign) NSNumber * totalCount ;///< 全部数量
@property (nonatomic,assign) NSNumber * totalPage ;///< 全部数量

@property (nonatomic,strong) NSArray <IDCMAcceptantBondWaterModel *> *dataList;///< 数据源


@end

