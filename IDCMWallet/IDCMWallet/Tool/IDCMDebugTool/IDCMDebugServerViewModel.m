//
//  IDCMDebugServerViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMDebugServerViewModel.h"

@implementation IDCMDebugServerViewModel
#pragma mark - Life Cycle
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    
    
    self.dataSignal = [RACSignal return:[self getDetailData]];
    
    self.selectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(RACTuple *input) {
        
        return [RACSignal return:input];
    }];
}

#pragma mark - Privater Methods
- (NSArray *)getDetailData{
    
    NSString *addStr = [CommonUtils getStrValueInUDWithKey:DebugSetServerAddKey];
    NSArray *langArr = @[@"00",@"01",@"02",@"03",@"04",@"05"];
    NSMutableArray *imageArr = @[@"2.0_weixuanzhong",@"2.0_weixuanzhong",@"2.0_weixuanzhong",@"2.0_weixuanzhong",@"2.0_weixuanzhong",@"2.0_weixuanzhong"].mutableCopy;
    [langArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:addStr]) {
            [imageArr replaceObjectAtIndex:idx withObject:@"2.0_xuanzhong"];
        }
    }];

    NSArray *arr = @[RACTuplePack(@"测试环境",imageArr[0],@"00"),
                     RACTuplePack(@"生产环境",imageArr[1],@"01"),
                     RACTuplePack(@"预发布环境",imageArr[2],@"02"),
                     RACTuplePack(@"开发环境",imageArr[3],@"03"),
                     RACTuplePack(@"灰度环境",imageArr[4],@"04"),
                     RACTuplePack(@"外网映射环境",imageArr[5],@"05")];
    return arr;
}
@end
