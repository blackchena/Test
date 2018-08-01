//
//  IDCMBaseTableSectionModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/23.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseTableSectionModel.h"

@implementation IDCMBaseTableSectionModel
- (instancetype)handleModel {return self;}
- (NSMutableArray<IDCMBaseTableCellModel *> *)cellModels {
    return SW_LAZY(_cellModels, ({
        @[].mutableCopy;
    }));
}
@end
