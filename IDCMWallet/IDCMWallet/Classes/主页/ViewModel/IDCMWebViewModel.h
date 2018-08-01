//
//  IDCMWebViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMWebViewModel : IDCMBaseViewModel
/**
 *  请求地址
 */
@property (copy, nonatomic) NSString *requestURL;
/**
 *  标题
 */
@property (copy, nonatomic) NSString *title;
@end
