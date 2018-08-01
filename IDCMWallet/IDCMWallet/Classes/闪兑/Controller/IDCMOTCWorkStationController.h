//
//  IDCMOTCWorkStationController.h
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/4.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewController.h"
typedef void(^POPBackBlock)(void);
@interface IDCMOTCWorkStationController : IDCMBaseViewController
@property(nonatomic,copy) POPBackBlock popBackBlock ;
@end

