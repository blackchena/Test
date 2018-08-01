//
//  IDCMServerConfig.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMServerConfig.h"
#import "IDCMConst.h"


static NSString *IDCMConfigEnv;  //环境参数 00: 测试环境, 01: 生产环境, 02: 预发布环境 03: 开发环境  04: 灰度发布环境  05: 测试环境的外网映射
static NSDictionary *IDCMServerDict;  


@implementation IDCMServerConfig

+ (void)initialize {
    IDCMServerDict = @{
        @"ExchangeServerName_URL" : ExchangeServerName_URL,
        @"ExchangeServerName_URL_Test" : ExchangeServerName_URL_Test,
        @"ExchangeServerName_URL_Pre": ExchangeServerName_URL_Pre,
        @"ExchangeServerName_URL_Dev": ExchangeServerName_URL_Dev,
        @"ExchangeServerName_URL_Gray": ExchangeServerName_URL_Gray,
        @"ExchangeServerName_URL_Mapping": ExchangeServerName_URL_Mapping,
        @"MaintenanceServerName_URL" : MaintenanceServerName_URL,
        @"MaintenanceServerName_URL_Test" : MaintenanceServerName_URL_Test,
        @"MaintenanceServerName_URL_Pre": MaintenanceServerName_URL_Pre,
        @"MaintenanceServerName_URL_Dev": MaintenanceServerName_URL_Dev,
        @"MaintenanceServerName_URL_Gray": MaintenanceServerName_URL_Gray,
        @"MaintenanceServerName_URL_Mapping": MaintenanceServerName_URL_Mapping
    };
}

+ (void)setHTConfigEnv:(NSString *)value {
    IDCMConfigEnv = value;
}

+ (NSString *)IDCMConfigEnv {
    return IDCMConfigEnv;
}

//获取服务器地址
+ (NSString *)getIDCMServerAddr{
    
    if ([IDCMConfigEnv isEqualToString:@"00"]) {
        return IDCMURL_Test;
    }else if([IDCMConfigEnv isEqualToString:@"01"]){
        return IDCMURL;
    }else if([IDCMConfigEnv isEqualToString:@"02"]){
        return IDCMURL_Pre;
    }else if([IDCMConfigEnv isEqualToString:@"03"]){
        return IDCMURL_Dev;
    }else if([IDCMConfigEnv isEqualToString:@"04"]){
        return IDCMURL_Gray;
    }else{
        return IDCMURL_Mapping;
    }
}
// 获取Web地址
+ (NSString *)getIDCMWebAddr{
    
    if ([IDCMConfigEnv isEqualToString:@"00"]) {
        return IDCMWebURL_Test;
    }else if([IDCMConfigEnv isEqualToString:@"02"]){
        return IDCMWebURL_Pre;
    }else{
        return IDCMWebURL;
    }
}
+ (NSString *)getIDCMServerAddrWithServerName:(NSString *)serverName {
    
    NSString *key = [NSString stringWithFormat:@"%@_URL", serverName];
    NSString *testkey = [NSString stringWithFormat:@"%@_URL_Test", serverName];
    NSString *prekey = [NSString stringWithFormat:@"%@_URL_Pre", serverName];
    NSString *devkey = [NSString stringWithFormat:@"%@_URL_Dev", serverName];
    NSString *graykey = [NSString stringWithFormat:@"%@_URL_Gray", serverName];
    NSString *mapkey = [NSString stringWithFormat:@"%@_URL_Mapping", serverName];
    if ([IDCMConfigEnv isEqualToString:@"00"]) {
        return IDCMServerDict[testkey];
    }else if([IDCMConfigEnv isEqualToString:@"01"]){
        return IDCMServerDict[key];
    }else if([IDCMConfigEnv isEqualToString:@"02"]){
        return IDCMServerDict[prekey];
    }else if([IDCMConfigEnv isEqualToString:@"03"]){
        return IDCMServerDict[devkey];
    }else if([IDCMConfigEnv isEqualToString:@"04"]){
        return IDCMServerDict[graykey];
    }else{
        return IDCMServerDict[mapkey];
    }
}

@end





