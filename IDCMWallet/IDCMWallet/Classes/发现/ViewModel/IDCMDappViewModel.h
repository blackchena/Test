//
//  IDCMDappViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/28.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMDappViewModel : IDCMBaseViewModel
/**
 *  请求地址
 */
@property (copy, nonatomic) NSString *requestURL;
/**
 *  标题
 */
@property (copy, nonatomic) NSString *title;
@end
