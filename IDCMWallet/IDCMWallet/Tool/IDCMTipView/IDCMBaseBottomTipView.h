//
//  IDCMBaseBottomTipView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMBaseCenterTipView.h"


@interface IDCMBaseBottomTipView : UIView


+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
              contentView:(UIView *)contentView // view
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha  //透明度
              blackAction:(BOOL)blackAction   // 是否点击背景消失
              contentView:(UIView *)contentView // view
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;



+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
         contentViewClass:(Class)contentViewClass  // Class
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
         contentViewClass:(Class)contentViewClass  // Class
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;



+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
       contentViewNibName:(NSString *)contentViewNibName // // Xib
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
       contentViewNibName:(NSString *)contentViewNibName // // Xib
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;


+ (instancetype)getInstanceWithInView:(UIView *)view;

+ (void)showHUD;
+ (void)dismissHUD;

+ (void)showHudForView:(UIView *)view;
+ (void)dismissHudForView:(UIView *)view;

+ (void)dismissWithCompletion:(void(^)(void))completion;
+ (void)dismissForView:(UIView *)view completion:(void(^)(void))completion;

@end






