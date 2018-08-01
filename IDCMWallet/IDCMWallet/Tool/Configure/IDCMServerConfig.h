//
//  IDCMServerConfig.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const serverSign = @"__sserverSign__";

@interface IDCMServerConfig : NSObject

//环境参数 00: 测试环境, 01: 生产环境, 02: 预发布环境 03: 开发环境  04: 灰度发布环境   05: 测试环境的外网映射
+ (void)setHTConfigEnv:(NSString *)value;

//环境参数 00: 测试环境, 01: 生产环境, 02: 预发布环境 03: 开发环境  04: 灰度发布环境   05: 测试环境的外网映射
+ (NSString *)IDCMConfigEnv;

// 获取服务器地址
+ (NSString *)getIDCMServerAddr;

+ (NSString *)getIDCMServerAddrWithServerName:(NSString *)serverName;

// 获取Web地址
+ (NSString *)getIDCMWebAddr;

@end
