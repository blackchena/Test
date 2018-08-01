//
//  IDCMAppDotNetAPIClient.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMAppDotNetAPIClient.h"

@implementation IDCMAppDotNetAPIClient
+ (instancetype)sharedClient {
    static IDCMAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[IDCMAppDotNetAPIClient alloc] init];
    });
    
    return _sharedClient;
}
@end
