//
//  IDCMAppDotNetAPIClient.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface IDCMAppDotNetAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
