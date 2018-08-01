//
//  IDCMBaseTableViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMBaseTableCellModel.h"
#import "IDCMBaseTableSectionModel.h"
#define CellModelDataKey @"cellModelData"
#define CellModelClassKey @"cellModelClass"
#define SectionModelDataKey @"sectionModelData"
#define SectionModelClassKey @"sectionModelClass"


typedef NS_ENUM(NSUInteger, IDCMTableViewLoadDataType) {
    IDCMTableViewLoadDataTypeFirst,   // 一进页面获取数据 有HUD
    IDCMTableViewLoadDataTypeNew,    // 下拉刷新 刷新最新数据
    IDCMTableViewLoadDataTypeMore,  // 上拉刷新 加载更多
};


@interface IDCMBaseTableViewModel : IDCMBaseViewModel
typedef NSDictionary *(^tableViewDataAnalyzeBlock)(NSDictionary *respose);
typedef RACCommand *(^tableViewCommandBlock)(IDCMTableViewLoadDataType type);


@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) IDCMTableViewLoadDataType currentLoadDataType;
@property (nonatomic, strong) NSMutableArray<IDCMBaseTableSectionModel *> *sectionModels;



- (NSString *)configRequestUrl;
- (NSString *)configServerName;
- (NSInteger)getLoadDataPageNumber;
- (requestParamsBlock)configParams;
- (requestCommandBlock)configrequestCommand;
- (tableViewDataAnalyzeBlock)configDataParams;
- (tableViewCommandBlock)tableViewExecuteCommand;

- (IDCMBaseTableSectionModel *)getSectionViewModelAtSection:(NSInteger)section;
- (IDCMBaseTableCellModel *)getCellViewModelAtIndexPath:(NSIndexPath *)indexPath;

@end



















