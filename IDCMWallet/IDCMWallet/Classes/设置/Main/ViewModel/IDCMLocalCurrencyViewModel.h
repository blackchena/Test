//
//  IDCMLocalCurrencyViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMLocalCurrencyViewModel : IDCMBaseViewModel

@property (nonatomic, strong) RACCommand *setLocalCurrencyCommand;

@end
