//
//  IDCMSetPayPassWordSuccessViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMSetPayPassWordSuccessViewModel : IDCMBaseViewModel
/**
 *   标题
 */
@property (copy, nonatomic) NSString *titleVC;
/**
 *   提示语
 */
@property (copy, nonatomic) NSString *hint;
/**
 *   提示语
 */
@property (copy, nonatomic) NSString *remember;
@end
