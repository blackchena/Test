//
//  IDCMIntroductionViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMIntroductionViewModel : IDCMBaseViewModel
/**
 *  数据总页数
 */
@property (strong, nonatomic) NSNumber *totalPage;

- (NSString *)getRequsetParmaWithIndex:(NSInteger)index;
@end
