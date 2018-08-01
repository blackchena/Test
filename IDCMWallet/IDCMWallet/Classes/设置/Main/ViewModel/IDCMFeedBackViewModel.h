//
//  IDCMFeedBackViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMFeedBackViewModel : IDCMBaseViewModel
/**
 *   feedText
 */
@property (copy, nonatomic) NSString *feedText;
/**
 *   联系方式
 */
@property (copy, nonatomic) NSString *contactText;

@property (nonatomic, strong) RACSignal *validSubmitSignal;

@end
