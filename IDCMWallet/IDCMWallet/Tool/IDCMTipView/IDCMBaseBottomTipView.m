//
//  IDCMBaseBottomTipView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//


#define KeyWindow [UIApplication sharedApplication].keyWindow
#import "IDCMBaseBottomTipView.h"


@interface IDCMBaseBottomTipView ()
@property (nonatomic,weak) UIView *inView;
@property (nonatomic,weak) UIView *contentView;
@property (nonatomic,strong) UIButton *blackView;
@property (nonatomic,assign) CGFloat blackAlpha;
@property (nonatomic,assign) BOOL blackAction;
@property (nonatomic,strong)  UIActivityIndicatorView *inDicatorView;
@property (nonatomic, copy) void(^tipViewStatusCallback)(IDCMBaseTipViewShowStatus showStatus);
@end


@implementation IDCMBaseBottomTipView
+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
         contentViewClass:(Class)contentViewClass
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                contentView:[[contentViewClass alloc] init]
      tipViewStatusCallback:tipViewStatusCallback];
}
+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
         contentViewClass:(Class)contentViewClass  // Class
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                 blackAlpha:blackAlpha
                blackAction:blackAction
                contentView:[[contentViewClass alloc] init]
      tipViewStatusCallback:tipViewStatusCallback];
}



+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
       contentViewNibName:(NSString *)contentViewNibName
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                contentView:[[[NSBundle mainBundle] loadNibNamed:contentViewNibName
                                                           owner:nil
                                                         options:nil] lastObject]
      tipViewStatusCallback:tipViewStatusCallback];
}
+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
       contentViewNibName:(NSString *)contentViewNibName // // Xib
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                 blackAlpha:blackAlpha
                blackAction:blackAction
                contentView:[[[NSBundle mainBundle] loadNibNamed:contentViewNibName
                                                           owner:nil
                                                         options:nil] lastObject]
      tipViewStatusCallback:tipViewStatusCallback];
}



+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
              contentView:(UIView *)contentView
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                 blackAlpha:((view == KeyWindow) || view == nil) ? 0.5 : 0.0
                blackAction:NO
                contentView:contentView
      tipViewStatusCallback:tipViewStatusCallback];
}
+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
              contentView:(UIView *)contentView // view
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    UIView *inView = view ?: KeyWindow;
    
    if ([self getInstanceWithInView:inView]) {
        return;
    }
    
    IDCMBaseBottomTipView *tipView = [[self alloc] init];
    tipView.backgroundColor = [UIColor clearColor];
    tipView.contentView = contentView;
    tipView.tipViewStatusCallback = [tipViewStatusCallback copy];
    
    tipView.frame = inView.bounds;
    [inView addSubview:tipView];
    [inView bringSubviewToFront:tipView];
    tipView.inView = inView;
    
    [tipView addSubview:tipView.blackView];
    [tipView addSubview:contentView];
    contentView.size = size;
    contentView.top = inView.height;
    contentView.centerX = inView.width / 2;
    
    tipView.blackAlpha = blackAlpha;
    tipView.blackAction = blackAction;
    
    [tipView show];
}

- (void)blackViewAction {
    if (self.blackAction) {
        [self dismissCompleteAction:nil];
    }
}

+ (void)showHUD {
    [[self getInstanceWithInView:KeyWindow] showActivityIndicator];
}

+ (void)dismissHUD {
    [[self getInstanceWithInView:KeyWindow] dismissActivityIndicator];
}

+ (void)showHudForView:(UIView *)view {
    [[self getInstanceWithInView:view] showActivityIndicator];
}

+ (void)dismissHudForView:(UIView *)view {
    [[self getInstanceWithInView:view] dismissActivityIndicator];
}

+ (void)dismissWithCompletion:(void(^)(void))completion {
    [self dismissForView:KeyWindow completion:completion];
}

+ (void)dismissForView:(UIView *)view completion:(void(^)(void))completion {
    [[self getInstanceWithInView:view] dismissCompleteAction:completion];
}

+ (instancetype)getInstanceWithInView:(UIView *)view {
    __block IDCMBaseBottomTipView *tipView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:self] ||
            [NSStringFromClass([obj class]) isEqualToString:@"IDCMBaseBottomTipView"]) {
            tipView = (IDCMBaseBottomTipView *)obj;
            *stop = YES;
        }
    }];
    return tipView;
}

- (void)show {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTipViewShowStatusWillShow) : nil;
    CGFloat transfromH = self.contentView.height;
    self.contentView.alpha = 0.0;
    [UIView animateWithDuration: .35
                          delay: .0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.contentView.transform = CGAffineTransformMakeTranslation(0, -transfromH);
                         self.blackView.alpha = self.blackAlpha;
                         self.contentView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         self.tipViewStatusCallback ?
                         self.tipViewStatusCallback(IDCMBaseTiPViewShowStatusDidShow) : nil;
                     }];
}

- (void)dismissCompleteAction:(void(^)(void))completeAction {
    self.tipViewStatusCallback ?
    self.tipViewStatusCallback(IDCMBaseTipViewShowStatusWillDismiss) : nil;
    [UIView animateWithDuration:.25
                     animations:^{
                            self.contentView.transform = CGAffineTransformIdentity;
                            self.blackView.alpha = 0;
                     } completion:^(BOOL finished) {
                         completeAction ? completeAction() : nil;
                         self.tipViewStatusCallback ?
                         self.tipViewStatusCallback(IDCMBaseTipViewShowStatusDidDismiss) : nil;
                         [self removeFromSuperview];
                     }];
}

- (UIButton *)blackView {
    return SW_LAZY(_blackView, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.inView.bounds;
        btn.backgroundColor = [UIColor blackColor];
        [btn addTarget:self action:@selector(blackViewAction) forControlEvents:UIControlEventTouchUpInside];
        btn.alpha = 0.0;
        btn;
    }));
}

- (void)showActivityIndicator {
    UIActivityIndicatorView *inDicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    inDicatorView.color = kThemeColor;
    [inDicatorView startAnimating];
    [self.contentView addSubview:inDicatorView];
    
    inDicatorView.centerX = self.contentView.width / 2;
    inDicatorView.centerY = self.contentView.height / 2 - kSafeAreaBottom;
    
    self.inDicatorView = inDicatorView;
}

- (void)dismissActivityIndicator {
    [self.inDicatorView stopAnimating];
    [self.inDicatorView removeFromSuperview];
}

@end
