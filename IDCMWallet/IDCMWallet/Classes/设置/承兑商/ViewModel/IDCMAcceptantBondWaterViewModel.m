//
//  IDCMAcceptantBondWaterViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantBondWaterViewModel.h"
#import "IDCMAcceptantBondWaterModel.h"

@implementation IDCMAcceptantBondWaterViewModel
- (void)initialize{
    self.PageSize = @20;
    self.PageIndex = @1;
    self.dataList = @[].mutableCopy;
    
}

- (RACSignal *)executeRequestDataSignal:(id)input{
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];

    NSDictionary *params = @{
                             @"PageSize":self.PageSize,
                             @"PageIndex":self.PageIndex,
                             @"CoinId":self.CoinId,
                             @"UserId":model.userID
                             };
    @weakify(self);
    return [RACSignal signalAuth:OTCAcceptantGetDepositWastebookList_URL serverName:nil params:params handleSignal:^(id response, id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];

        if ([status isEqualToString:@"1"] && [response[kData] isKindOfClass:[NSArray class]]) {
            NSMutableArray *list = self.dataList.mutableCopy;
            if (self.PageIndex.integerValue == 1) {
                [list removeAllObjects];
            }
            for (NSDictionary *dict in response[kData]) {
                IDCMAcceptantBondWaterModel *model = [IDCMAcceptantBondWaterModel yy_modelWithDictionary:dict];
                [list addObject:model];
            }
            self.dataList = list;
            
            if ( [response[@"page"] isKindOfClass:[NSDictionary class]]) {
                self.totalCount = response[@"page"][@"count"];
                NSInteger count = [self.totalCount integerValue];
                NSInteger size = [self.PageSize integerValue];
                NSInteger totalPage = (count % size) == 0 ? (count / size) : (count / size) + 1;
                self.totalPage = [NSNumber numberWithInteger:totalPage];
            }
            
            [subscriber sendNext:nil];
        }
        else{
            [IDCMShowMessageView showMessageWithCode:status];
        }
        
        [subscriber sendCompleted];

    }];
}


@end
