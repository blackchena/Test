//
//  IDCMBaseCollectionSectionModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseModel.h"
#import "IDCMBaseCollectionCellModel.h"

@interface IDCMBaseCollectionSectionModel : IDCMBaseModel
@property (nonatomic,strong) NSMutableArray<IDCMBaseCollectionCellModel *> *cellModels;
- (instancetype)handleModel;
@end
