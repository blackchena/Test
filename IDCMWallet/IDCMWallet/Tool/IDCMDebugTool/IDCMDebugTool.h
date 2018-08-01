//
//  IDCMDebugTool.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMDebugTool : NSObject

+ (instancetype)sharedInstance;
- (void)showDebugTool;

@end
