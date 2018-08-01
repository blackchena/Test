//
//  IDCMHUD.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMHUD : NSObject
+ (void)show;
+ (void)show:(NSString*)message needdismiss:(BOOL)dismiss;
+ (void)dismiss;
+(BOOL) isShow;

@end
