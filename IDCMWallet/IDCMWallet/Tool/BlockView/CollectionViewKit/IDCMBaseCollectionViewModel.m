//
//  IDCMBaseCollectionViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseCollectionViewModel.h"

@interface IDCMBaseCollectionViewModel ()
@property (nonatomic,strong) RACCommand *collectionViewCommand;
@end

@implementation IDCMBaseCollectionViewModel
- (void)initialize {
    self.pageNumber = 1;
    self.pageSize = 10;
}

- (collectionViewCommandBlock)collectionViewExecuteCommand {
    return ^RACCommand *(IDCMCollectionViewLoadDataType type){
        if (!type) { [IDCMHUD show];}
        self.currentLoadDataType = type;
        return self.collectionViewCommand;
    };
}

- (RACCommand *)collectionViewCommand {
    return SW_LAZY(_collectionViewCommand, ({
        [RACCommand commandPostAuthNoHUD:[self configRequestUrl]
                              serverName:[self configServerName]
                                  params:[self configParams]
                           handleCommand:[self configrequestCommand]];
    }));
}

- (requestCommandBlock)configrequestCommand {
    @weakify(self);
    return
    ^(id input, id response, id<RACSubscriber> subscriber) {
        @strongify(self);
        
        if (!subscriber) {return;}
        if (!self ||
            !response ||
            ![response isKindOfClass:[NSDictionary class]]) {
            [subscriber sendError:nil];
            return ;
        }
        
        NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        ([status integerValue] == 100) ?
        ([subscriber sendError:nil])   :
        ({
            NSDictionary *dict = [self configDataParams](response);
            if (!dict) {
                [subscriber sendError:nil];
                return;
            }
            NSArray *keys = dict.allKeys;
            if (!keys.count) {
                [subscriber sendError:nil];
                return;
            }
            
            Class sectionModelClass = [self objectForDict:dict Key:SectionModelClassKey];
            Class cellModelClass = [self objectForDict:dict Key:CellModelClassKey];
            id cellModelData = [self objectForDict:dict Key:CellModelDataKey];
            id sectionModelData = [self objectForDict:dict Key:SectionModelDataKey];
            
            if (sectionModelClass && sectionModelData &&
                [sectionModelData isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *sectionArray = @[].mutableCopy;
                for (NSDictionary *dict in sectionModelData) {
                    
                    IDCMBaseCollectionSectionModel *sectionModel =
                    [[sectionModelClass yy_modelWithDictionary:dict] handleModel];
                    
                    if (cellModelClass && cellModelData &&
                        [cellModelData isKindOfClass:[NSString class]]) {
                        
                        id cellData = [self objectForDict:dict Key:cellModelData];
                        
                        if ([cellData isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *cellDict in cellData) {
                                IDCMBaseCollectionCellModel *cellModel =
                                [[cellModelClass yy_modelWithDictionary:cellDict] handleModel];
                                [sectionModel.cellModels addObject:cellModel];
                            }
                        }
                        if ([cellData isKindOfClass:[NSDictionary class]]) {
                            IDCMBaseCollectionCellModel *cellModel =
                            [[cellModelClass yy_modelWithDictionary:cellData] handleModel];
                            [sectionModel.cellModels addObject:cellModel];
                        }
                    }
                    [sectionArray addObject:sectionModel];
                }
                
                if (self.currentLoadDataType == 0 ||
                    self.currentLoadDataType == 1) {
                    self.pageNumber = 2;
                    self.sectionModels = sectionArray;
                } else {
                    [self.sectionModels addObjectsFromArray:sectionArray];
                    self.pageNumber++;
                }
                [subscriber sendNext:@((sectionArray.count < self.pageSize))]; // 隐藏显示footer
                [subscriber sendCompleted];
            }
            
            if ((!sectionModelClass || !sectionModelData) &&
                cellModelClass && cellModelData) {
                
                NSMutableArray *cellA = @[].mutableCopy;
                id cellData = cellModelData;
                
                if ([cellData isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *cellDict in cellData) {
                        IDCMBaseCollectionCellModel *cellModel =
                        [[cellModelClass yy_modelWithDictionary:cellDict] handleModel];
                        [cellA addObject:cellModel];
                    }
                }
                if ([cellData isKindOfClass:[NSDictionary class]]) {
                    IDCMBaseCollectionCellModel *cellModel =
                    [[cellModelClass yy_modelWithDictionary:cellData] handleModel];
                    [cellA addObject:cellModel];
                }
                
                if (cellA.count) {
                    if (!self.sectionModels.count) {
                        IDCMBaseCollectionSectionModel *sectionModel = [IDCMBaseCollectionSectionModel new];
                        [self.sectionModels addObject:sectionModel];
                    }
                    if (self.currentLoadDataType == 0 ||
                        self.currentLoadDataType == 1) {
                        self.sectionModels.firstObject.cellModels = cellA;
                    } else {
                        [self.sectionModels.firstObject.cellModels addObjectsFromArray:cellA];
                    }
                } else {
                    if (self.currentLoadDataType == 0 ||
                        self.currentLoadDataType == 1) {
                        if (self.sectionModels.count) {
                            [self.sectionModels removeAllObjects];
                        }
                    }
                }
                if (self.currentLoadDataType == 0 ||
                    self.currentLoadDataType == 1) {
                    self.pageNumber = 2;
                } else {
                    self.pageNumber++;
                }
                [subscriber sendNext:@((cellA.count < self.pageSize))]; // 隐藏显示footer
                [subscriber sendCompleted];
            }
            [subscriber sendCompleted];
        });
    };
}

- (NSInteger)getLoadDataPageNumber {
    return self.currentLoadDataType == 2 ? self.pageNumber : 1;
}

- (id)objectForDict:(NSDictionary *)dict
                Key:(NSString *)key {
    __block BOOL haveKey = NO;
    NSString *currentKey = key;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  key,
                                              id  obj,
                                              BOOL * _Nonnull stop) {
        if ([currentKey isEqualToString:key]) {
            haveKey = YES;
            *stop = YES;
        }
    }];
    return haveKey ? [dict objectForKey:currentKey] : nil;
}

- (NSString *)configRequestUrl {
    return @"";
}
- (NSString *)configServerName {
    return  @"";
}
- (requestParamsBlock)configParams {
    return nil;
}

- (tableViewDataAnalyzeBlock)configDataParams {
    return nil;
}

- (NSMutableArray<IDCMBaseCollectionSectionModel *> *)sectionModels {
    return SW_LAZY(_sectionModels, ({
        @[].mutableCopy;
    }));
}

- (IDCMBaseCollectionSectionModel *)getSectionViewModelAtSection:(NSInteger)section {
    if (!self.sectionModels) { return nil;}
    if (section >= self.sectionModels.count) {  return nil;}
    IDCMBaseCollectionSectionModel *sectionViewModel = self.sectionModels[section];
    return sectionViewModel;
}

- (IDCMBaseCollectionCellModel *)getCellViewModelAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.sectionModels) {return nil;}
    IDCMBaseCollectionSectionModel *sectionViewModel = [self getSectionViewModelAtSection:indexPath.section];
    if (!sectionViewModel) { return nil;}
    if (indexPath.row >= sectionViewModel.cellModels.count) {
        return nil;
    }
    IDCMBaseCollectionCellModel *cellViewModel = sectionViewModel.cellModels[indexPath.row];
    return cellViewModel;
}
@end
