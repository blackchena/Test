//
//  IDCMCheckPINView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/15.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMCheckPINView : UIView


/**
 类方法实例化

 @param title 中间标题
 @param suceessCallback PIN验证成功回调
 @param closeCallback 关闭消失过后的回调
 */
+ (void)showWithContentTitle:(NSString *)title
             suceessCallback:(void(^)(NSString *pinPassword))suceessCallback
               closeCallback:(void(^)(void))closeCallback;



/**
 主动消失PINView
 
 @param completion 消失完成的回调
 */
+ (void)dismissWithCompletion:(void(^)(void))completion;



/**
 是否已经show

 @return BOOL
 */
+ (BOOL)hasShow;



@end




