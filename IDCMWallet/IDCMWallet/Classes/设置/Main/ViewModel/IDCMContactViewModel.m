//
//  IDCMContactViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMContactViewModel.h"
#import "IDCMContactListModel.h"

@interface IDCMContactViewModel ()

@end

@implementation IDCMContactViewModel

- (RACSignal *)executeRequestDataSignal:(id)input{
    
    @weakify(self);
    NSString *url = [NSString idcw_stringWithFormat:@"%@?lang=%@",GetAboutUs_URL,[IDCMUtilsMethod getServiceLanguage]];
    return [[RACSignal signalGetNoHUDAuth:url serverName:nil params:nil handleSignal:^(id response, id<RACSubscriber> subscriber) {

        NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *arr = @[].mutableCopy;
            [response[@"data"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IDCMContactListModel *model = [IDCMContactListModel yy_modelWithDictionary:obj];
                [arr addObject:model];
            }];
            [subscriber sendNext:arr];
        }
        
        [subscriber sendCompleted];
    }] doNext:^(NSMutableArray *arr) {
        @strongify(self);
        if (arr.count > 0) {
            self.dataArr = [NSArray arrayWithArray:arr];
        }
    }];
}

@end
