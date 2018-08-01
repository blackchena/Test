//
//  IDCMBaseTableViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseTableViewModel.h"
#import "IDCMNewCurrencyTradingModel.h"


@interface IDCMBaseTableViewModel ()
@property (nonatomic, strong) RACCommand *tableViewCommand;
@end


@implementation IDCMBaseTableViewModel
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.pageNumber = 1;
        self.pageSize = 10;
    }
    return self;
}

- (tableViewCommandBlock)tableViewExecuteCommand {
    return ^RACCommand *(IDCMTableViewLoadDataType type){
        if (!type) { [IDCMHUD show];}
        self.currentLoadDataType = type;
//        if (type == IDCMTableViewLoadDataTypeMore && !self.sectionModels.count) {
//            self.currentLoadDataType = IDCMTableViewLoadDataTypeNew;
//        }
        return self.tableViewCommand;
    };
}

- (RACCommand *)tableViewCommand {
    return SW_LAZY(_tableViewCommand, ({
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
                    
                    IDCMBaseTableSectionModel *sectionModel =
                    [[sectionModelClass yy_modelWithDictionary:dict] handleModel];
                    
                    if (cellModelClass && cellModelData &&
                        [cellModelData isKindOfClass:[NSString class]]) {
                        
                        id cellData = [self objectForDict:dict Key:cellModelData];
                        
                        if ([cellData isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *cellDict in cellData) {
                                IDCMBaseTableCellModel *cellModel =
                                [[cellModelClass yy_modelWithDictionary:cellDict] handleModel];
                                [sectionModel.cellModels addObject:cellModel];
                            }
                        }
                        if ([cellData isKindOfClass:[NSDictionary class]]) {
                            IDCMBaseTableCellModel *cellModel =
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
                        IDCMBaseTableCellModel *cellModel =
                        [[cellModelClass yy_modelWithDictionary:cellDict] handleModel];
                        [cellA addObject:cellModel];
                    }
                }
                if ([cellData isKindOfClass:[NSDictionary class]]) {
                    IDCMBaseTableCellModel *cellModel =
                    [[cellModelClass yy_modelWithDictionary:cellData] handleModel];
                    [cellA addObject:cellModel];
                }
                
                if (cellA.count) {
                    if (!self.sectionModels.count) {
                        IDCMBaseTableSectionModel *sectionModel = [IDCMBaseTableSectionModel new];
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

//    return ^ NSDictionary * (id response){
//        return @{
//                 SectionModelDataKey : response[@"data"],
//                 SectionModelNameKey : @"IDCMBaseTableSectionModel",
//                 cellModelName    : @"IDCMBaseTableCellModel",
//                 CellModelDataKey : @"cell"
//                };
//    };

//    return ^ NSDictionary * (id response){
//        return @{
//                 cellModelName : @"IDCMBaseTableCellModel",
//                 CellModelDataKey : @"cell"
//                };
//    };
- (tableViewDataAnalyzeBlock)configDataParams {
    return nil;
}

- (NSMutableArray<IDCMBaseTableSectionModel *> *)sectionModels {
    return SW_LAZY(_sectionModels, ({
        @[].mutableCopy;
    }));
}

- (IDCMBaseTableSectionModel *)getSectionViewModelAtSection:(NSInteger)section {
    if (!self.sectionModels) { return nil;}
    if (section >= self.sectionModels.count) {  return nil;}
    IDCMBaseTableSectionModel *sectionViewModel = self.sectionModels[section];
    return sectionViewModel;
}

- (IDCMBaseTableCellModel *)getCellViewModelAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.sectionModels) {return nil;}
    IDCMBaseTableSectionModel *sectionViewModel = [self getSectionViewModelAtSection:indexPath.section];
    if (!sectionViewModel) { return nil;}
    if (indexPath.row >= sectionViewModel.cellModels.count) {
        return nil;
    }
    IDCMBaseTableCellModel *cellViewModel = sectionViewModel.cellModels[indexPath.row];
    return cellViewModel;
}

@end














