//
//  IDCMPayMethodsManagerViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMPaymentListModel.h"

@interface IDCMPayMethodsManagerViewModel : IDCMBaseViewModel

@property (nonatomic,strong) RACCommand *payMethodsDataCommand;
@property (nonatomic,strong) RACCommand *payMethodsDeleteCommand;

@property (nonatomic,strong) NSMutableArray<IDCMPaymentListModel *> *dataArray;

@end
