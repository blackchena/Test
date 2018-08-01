//
//  IDCMMediatorAction.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VKMsgSend.h"

typedef void (^IDCMPopViewControllerCompletion)(__kindof UIViewController *popViewController);

@interface IDCMMediatorAction : NSObject

+ (instancetype)sharedInstance;

/**
 *  远程调用入口(服务器下发)
 */
- (void)performActionWithUrl:(NSString *)url animated:(BOOL)animated;
/**
 *  本地组件调用入口
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName;




@end
