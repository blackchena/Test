//
//  IDCMBaseViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/22.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMBaseViewModel : NSObject
/**
 *  数据请求
 */
@property (strong, nonatomic, readonly) RACCommand *requestDataCommand;


- (instancetype)initWithParams:(NSDictionary *)params;
- (void)initialize;

- (RACSignal *)executeRequestDataSignal:(id)input;
@end
