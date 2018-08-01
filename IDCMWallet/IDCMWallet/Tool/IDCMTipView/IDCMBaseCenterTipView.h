//
//  IDCMBaseTipView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IDCMBaseTipViewShowStatus) {
    IDCMBaseTipViewShowStatusWillShow,  // 即将开始动画显示
    IDCMBaseTiPViewShowStatusDidShow,  // 完成动画显示
    IDCMBaseTipViewShowStatusWillDismiss,  // 即将动画消失
    IDCMBaseTipViewShowStatusDidDismiss   // 完成动画消失
};

typedef NS_ENUM(NSUInteger, IDCMBaseTipViewAnimationStyle) {
    IDCMBaseTipViewAnimationStyleScale,   // 放大缩小动画
    IDCMBaseTipViewAnimationStyleFade,   // 渐变动画
    IDCMBaseTipViewAnimationStyleShake  // 放大抖动动画
};


@interface IDCMBaseCenterTipView : UIView

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
         contentViewClass:(Class)contentViewClass // Class
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha //透明度
              blackAction:(BOOL)blackAction  // 是否点击背景消失
         contentViewClass:(Class)contentViewClass // Class
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;




+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
       contentViewNibName:(NSString *)contentViewNibName // Xib
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback; // Xib

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
       contentViewNibName:(NSString *)contentViewNibName // Xib
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback; // Xib




+ (void)showTipViewToView:(UIView *)view // 传nil 加到KeyWindow
                     size:(CGSize)size
              contentView:(UIView *)contentView // view
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;

+ (void)showTipViewToView:(UIView *)view // 传nil 加到KeyWindow
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
              contentView:(UIView *)contentView // view
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;


+ (instancetype)getInstanceWithInView:(UIView *)view;

+ (void)showHUD;
+ (void)dismissHUD;

+ (void)showHudForView:(UIView *)view;
+ (void)dismissHudForView:(UIView *)view;

+ (void)dismissWithCompletion:(void(^)(void))completion;
+ (void)dismissForView:(UIView *)view completion:(void(^)(void))completion;

+ (void)bringSubviewToFrontWithView:(UIView *)view;

@end









