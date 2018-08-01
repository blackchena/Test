//
//  IDCMVerifyPhrasesOrderViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMVerifyPhrasesOrderViewModel.h"
#import "IDCMShowPhraseView.h"
#import "IDCMShowSelectPhraseView.h"

@implementation IDCMVerifyPhrasesOrderViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.listModel = params[@"listModel"];
        self.backupType = params[@"backupType"];
        
        //乱序
        _listModelArray = (NSMutableArray<IDCMPhraseModel *> *)[IDCMVerifyPhrasesOrderViewModel resetArrayOderWithArray:self.listModel.RandomWord];
    }
    return self;
}

// 验证
- (RACSignal *)executeRequestDataSignal:(id)input
{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        
        
        //模型数组转字典数组
        NSArray *RandomWord = [IDCMPhraseModel mj_keyValuesArrayWithObjectArray:self.userSelectedModelArray];
        NSArray *VerinfyWord = [IDCMPhraseModel mj_keyValuesArrayWithObjectArray:self.listModel.VerinfyWord];
        NSDictionary *para = @{@"RandomWord":RandomWord,
                               @"VerinfyWord":VerinfyWord,
                               @"newVersion":@"true"
                               };
        
        IDCMURLSessionTask *task = [IDCMRequestList requestAuth:SavePhrases_URL params:para success:^(NSDictionary *response) {
            
            NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
            if ([status isEqualToString:@"100"]) {
                [subscriber sendError:nil];
            }else{
                [subscriber sendNext:response];
            }
            
            [subscriber sendCompleted];
            
        } fail:^(NSError *error, NSURLSessionDataTask *task) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
        
    }] retry:1];
}

/**
 打乱数组的顺序
 
 @param array 需要打乱的数据源
 @return 打乱后的数据
 */
+ (NSArray<IDCMPhraseModel *> *)resetArrayOderWithArray:(NSArray<IDCMPhraseModel *> *)array
{
    NSArray *result =  [array sortedArrayUsingComparator:^NSComparisonResult(IDCMPhraseModel *obj1, IDCMPhraseModel *obj2) {
        if (arc4random_uniform(2) == 0)
        { return [obj2.serial_number compare:obj1.serial_number]; }
        else
        { return [obj1.serial_number compare:obj2.serial_number]; }
    }];
    return result;
}
@end
