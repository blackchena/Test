//
//  IDCMBaseCollectionViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMBaseTableViewModel.h"
#import "IDCMBaseCollectionCellModel.h"
#import "IDCMBaseCollectionSectionModel.h"


typedef NS_ENUM(NSUInteger, IDCMCollectionViewLoadDataType) {
    IDCMCollectionViewLoadDataTypeFirst,   // 一进页面获取数据 有HUD
    IDCMCollectionViewLoadDataTypeNew,    // 下拉刷新 刷新最新数据
    IDCMCollectionViewLoadDataTypeMore,  // 上拉刷新 加载更多
};



@interface IDCMBaseCollectionViewModel : IDCMBaseViewModel
typedef NSDictionary *(^collectionViewDataAnalyzeBlock)(NSDictionary *respose);
typedef RACCommand *(^collectionViewCommandBlock)(IDCMCollectionViewLoadDataType type);


@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic,assign) IDCMCollectionViewLoadDataType currentLoadDataType;
@property (nonatomic, strong) NSMutableArray<IDCMBaseCollectionSectionModel *> *sectionModels;


- (NSString *)configRequestUrl;
- (NSString *)configServerName;
- (NSInteger)getLoadDataPageNumber;
- (requestParamsBlock)configParams;
- (requestCommandBlock)configrequestCommand;
- (collectionViewDataAnalyzeBlock)configDataParams;
- (collectionViewCommandBlock)collectionViewExecuteCommand;

- (IDCMBaseCollectionSectionModel *)getSectionViewModelAtSection:(NSInteger)section;
- (IDCMBaseCollectionCellModel *)getCellViewModelAtIndexPath:(NSIndexPath *)indexPath;

@end
