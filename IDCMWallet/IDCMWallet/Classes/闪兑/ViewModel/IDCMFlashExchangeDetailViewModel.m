//
//  IDCMFlashExchangeDetailViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFlashExchangeDetailViewModel.h"
#import "IDCMFlashExchangeDetailModel.h"


@implementation IDCMFlashExchangeDetailViewModel

- (NSString *)configRequestUrl {
    return ExchangeGetExchangeDetail_URL;
}

- (NSString *)configServerName {
    return ExchangeServerName;
}

- (requestParamsBlock)configParams {
    return ^id (id input) {
        return  @{ @"id" : (self.ID ?: @"")};
    };
}

- (tableViewDataAnalyzeBlock)configDataParams {
    return ^ NSDictionary * (id response){
        if ([response isKindOfClass:[NSDictionary class]]) {
            id res = response[@"data"];
            if (!res || [res isKindOfClass:[NSNull class]]) {
                res = @"";
            }
            return @{
                     CellModelClassKey : [IDCMFlashExchangeDetailModel class],
                     CellModelDataKey : res
                     };
        } else {
            return nil;
        }
    };
}

- (RACCommand *)editCommand {
    return SW_LAZY(_editCommand, ({
        
        id(^paramsBlock)(NSNumber *input) = ^(NSNumber *input) {
            IDCMFlashExchangeDetailModel *model = (IDCMFlashExchangeDetailModel *)
            [self getCellViewModelAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            id string = model.Comment;
            if (!string || [string isKindOfClass:[NSNull class]] || ![string isNotBlank]) {
                string = @"";
            }
            return @{ @"id"     :(model.Id ?: @""),
                      @"comment": string,
                   };
        };

        [RACCommand commandAuth:ExchangeEditComment_URL
                    serverName:nil
                        params:paramsBlock
                 handleCommand:nil];
    }));
}


@end





