//
//  IDCMBaseTableSectionModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/23.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseModel.h"
#import "IDCMBaseTableCellModel.h"

@interface IDCMBaseTableSectionModel : IDCMBaseModel

@property (nonatomic,strong) NSMutableArray<IDCMBaseTableCellModel *> *cellModels;
- (instancetype)handleModel;

@end
