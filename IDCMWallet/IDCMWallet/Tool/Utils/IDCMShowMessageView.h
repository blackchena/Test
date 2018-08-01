//
//  IDCMShowMessageView.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMShowMessageView : NSObject

/**
 *  展示错误信息
 *
 *  @param message 信息内容
 */
+ (void)showErrorWithMessage:(NSString *)message;
/**
 *  展示错误信息
 *
 *  @param message  信息内容
 *  @param position 展示的位置.位置根据不同枚举修改过
 */
+ (void)showErrorWithMessage:(NSString *)message withPosition:(QMUIToastViewPosition)position;
/**
 *  展示信息
 *
 *  @param message  信息内容
 *  @param position 展示的位置，默认枚举的位置
 */
+ (void)showMessage:(NSString *)message withPosition:(QMUIToastViewPosition)position;
/**
 *  根据code码展示相应的信息
 *
 *  @param code  信息内容 ,展示的位置，默认中间
 */
+ (void)showMessageWithCode:(NSString *)code;

/**
 *  根据code码展示相应的信息
 *
 *  @param code  信息内容
 *  @param position 展示的位置
 */
+ (void)showMessageWithCode:(NSString *)code withPosition:(QMUIToastViewPosition)position;
@end
