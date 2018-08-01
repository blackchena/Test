//
//  IDCMBaseCollectionSectionModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseCollectionSectionModel.h"

@implementation IDCMBaseCollectionSectionModel
- (instancetype)handleModel {return self;}
- (NSMutableArray<IDCMBaseCollectionCellModel *> *)cellModels {
    return SW_LAZY(_cellModels, ({
        @[].mutableCopy;
    }));
}
@end
