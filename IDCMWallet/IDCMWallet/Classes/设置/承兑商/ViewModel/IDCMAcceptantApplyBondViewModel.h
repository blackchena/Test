//
//  IDCMAcceptantApplyBondViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMAcceptantApplyBondViewModel : IDCMBaseViewModel

@property (nonatomic,strong) NSAttributedString *currency;
@property (nonatomic,copy) NSString *countValue;

@property (nonatomic,strong) RACCommand *bondcommand;

@end
