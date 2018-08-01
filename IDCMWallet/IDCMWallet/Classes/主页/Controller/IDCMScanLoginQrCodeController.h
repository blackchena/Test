//
//  IDCMScanLoginQrCodeController.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "LBXScanViewController.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"


@interface IDCMScanLoginQrCodeController : LBXScanViewController

@property (copy, nonatomic) void(^scanQRCodeBlock)(NSString *clientId);

@end
