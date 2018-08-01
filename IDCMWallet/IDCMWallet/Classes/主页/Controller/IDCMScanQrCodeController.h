//
//  IDCMScanQrCodeController.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/20.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "LBXScanViewController.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"

typedef void (^IDCMScanQRCode)(NSString *scanStr);

@interface IDCMScanQrCodeController : LBXScanViewController
/**
 *   扫描回调
 */
@property (copy, nonatomic) IDCMScanQRCode scanQRCodeBlock;
@end
