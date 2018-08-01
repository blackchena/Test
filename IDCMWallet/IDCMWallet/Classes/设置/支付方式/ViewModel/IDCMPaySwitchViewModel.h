//
//  IDCMPaySwitchViewModel.h
//  IDCMWallet
//
//  Created by IDCM on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMPayMethodModel.h"

@interface IDCMPaySwitchViewModel : IDCMBaseViewModel

@property (nonatomic,strong) NSArray<IDCMPaytypeListItemModel *> * PaytypeList;

@end
