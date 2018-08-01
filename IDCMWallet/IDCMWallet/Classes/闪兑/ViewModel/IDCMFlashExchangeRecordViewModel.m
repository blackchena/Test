//
//  IDCMFlashExchangeRecordViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFlashExchangeRecordViewModel.h"
#import "IDCMFlashExchangeRecordModel.h"


@implementation IDCMFlashExchangeRecordViewModel

- (NSString *)configRequestUrl {
    return ExchangeGetExchangeDataList_URL;
}

- (NSString *)configServerName {
    return ExchangeServerName;
}

- (requestParamsBlock)configParams {
   return ^id (id input) {
       return @{@"pageSize" : @(self.pageSize),
                @"pageNum" : @([self getLoadDataPageNumber])};
   };
}

- (tableViewDataAnalyzeBlock)configDataParams {
    return ^ NSDictionary *(id response){
        if ([response isKindOfClass:[NSDictionary class]]) {
            id res = response[@"data"];
            if (!res || [res isKindOfClass:[NSNull class]]) {
                res = @"";
            }
            return @{
                          CellModelClassKey : [IDCMFlashExchangeRecordModel class],
                          CellModelDataKey : res
                    };
        } else {
            return nil;
        }
    };
}

@end






