//
//  IDCMBaseTipView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#define KeyWindow [UIApplication sharedApplication].keyWindow
#import "IDCMBaseCenterTipView.h"


@interface IDCMBaseCenterTipView ()
@property (nonatomic,weak) UIView *inView;
@property (nonatomic,assign) BOOL blackAction;
@property (nonatomic,assign) CGFloat blackAlpha;
@property (nonatomic,strong) UIButton *balckView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) id KeyboardObserver;
@property (nonatomic, assign) BOOL automaticDismiss;
@property (nonatomic,strong)  UIActivityIndicatorView *inDicatorView;
@property (nonatomic, assign, getter=isChangeFrame) BOOL changeFrame;
@property (nonatomic, assign) IDCMBaseTipViewAnimationStyle animationStyle;
@property (nonatomic, copy) void(^tipViewStatusCallback)(IDCMBaseTipViewShowStatus showStatus);
@end


@implementation IDCMBaseCenterTipView
+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
         contentViewClass:(Class)contentViewClass
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                contentView:[[contentViewClass alloc] init]
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}
+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
         contentViewClass:(Class)contentViewClass
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                 blackAlpha:blackAlpha
                blackAction:blackAction
                contentView:[[contentViewClass alloc] init]
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}




+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
       contentViewNibName:(NSString *)contentViewNibName
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    [self showTipViewToView:view
                       size:size
                contentView:[[[NSBundle mainBundle] loadNibNamed:contentViewNibName
                                                           owner:nil
                                                         options:nil] lastObject]
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}
+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
       contentViewNibName:(NSString *)contentViewNibName // Xib
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                 blackAlpha:blackAlpha
                blackAction:blackAction
                contentView:[[[NSBundle mainBundle] loadNibNamed:contentViewNibName
                                                           owner:nil
                                                         options:nil] lastObject]
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}



+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
              contentView:(UIView *)contentView
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                 blackAlpha:((view == KeyWindow) || view == nil) ? 0.5: 0.0
                blackAction:NO
                contentView:contentView
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}

+ (void)showTipViewToView:(UIView *)view // 传nil 加到KeyWindow
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
              contentView:(UIView *)contentView // view
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    UIView *inView = view ?: KeyWindow;
    if ([self getInstanceWithInView:inView]) {
        return;
    }
    
    IDCMBaseCenterTipView *tipView = [[self alloc] init];
    [inView addSubview:tipView];
    tipView.frame = inView.bounds;
    [inView bringSubviewToFront:tipView];
    tipView.inView = inView;
    
    [tipView addSubview:tipView.balckView];
    [tipView addSubview:contentView];
    contentView.size = size;
    contentView.centerX = inView.width / 2;
    contentView.centerY = inView.height / 2;
    
    tipView.contentView = contentView;
    tipView.automaticDismiss = automaticDismiss;
    tipView.animationStyle = animationStyle;
    tipView.tipViewStatusCallback = [tipViewStatusCallback copy];
    [tipView observerKeyboardFrameChange];
    
    tipView.blackAlpha = blackAlpha;
    tipView.blackAction = blackAction;
    
    [tipView show];
}

- (void)blackViewAction {
    if (self.blackAction) {
        [self dismissWithCompletion:nil];
    }
}

- (void)show {
    if (self.animationStyle == IDCMBaseTipViewAnimationStyleScale) {
        [self showAnimationSacle];
    }
    if (self.animationStyle == IDCMBaseTipViewAnimationStyleFade) {
        [self showAnimationFade];
    }
    if (self.animationStyle == IDCMBaseTipViewAnimationStyleShake) {
        [self showAnimationShake];
    }
    if (self.automaticDismiss) {
        [self dismissWithCompletion:nil];
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
    [[self getInstanceWithInView:view] dismissWithCompletion:completion];
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    [self endEditing:YES];
    if (self.animationStyle == IDCMBaseTipViewAnimationStyleScale) {
        [self dismissAnimationSacleWithCompletion:completion];
    }
    if (self.animationStyle == IDCMBaseTipViewAnimationStyleFade) {
        [self dismissAnimationFadeWithCompletion:completion];
    }
    if (self.animationStyle == IDCMBaseTipViewAnimationStyleShake) {
        [self dismissAnimationShakeWithCompletion:completion];
    }
}
+ (void)bringSubviewToFrontWithView:(UIView *)view{
    
    UIView *inputView = [self getInstanceWithInView:view];
    [inputView.superview bringSubviewToFront:inputView];
}
+ (instancetype)getInstanceWithInView:(UIView *)view {
    
    view = view ?: KeyWindow;
    __block IDCMBaseCenterTipView *tipView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:self] ||
            [NSStringFromClass([obj class]) isEqualToString:@"IDCMBaseCenterTipView"]) {
            tipView = (IDCMBaseCenterTipView *)obj;
            *stop = YES;
        }
    }];
    return tipView;
}

- (void)showAnimationSacle {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTipViewShowStatusWillShow) : nil;
    self.contentView.alpha = 0.0;
    [self.contentView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.75
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.contentView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                         self.contentView.alpha = 1.0;
                         self.balckView.alpha = self.blackAlpha;
                     } completion:^(BOOL finished) {
                         self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTiPViewShowStatusDidShow) : nil;
                     }];
}

- (void)showAnimationFade {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTipViewShowStatusWillShow) : nil;
    self.contentView.alpha = 0.0;
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.contentView.alpha = 1.0;
                         self.balckView.alpha = self.blackAlpha;
                     } completion:^(BOOL finished) {
                         self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTiPViewShowStatusDidShow) : nil;
                     }];
}

- (void)showAnimationShake{
    self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTipViewShowStatusWillShow) : nil;
    self.contentView.alpha = 0.0;
    [self.contentView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    [UIView animateWithDuration:0.85
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.contentView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                         self.contentView.alpha = 1.0;
                         self.balckView.alpha = self.blackAlpha;
                     } completion:^(BOOL finished) {
                         self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTiPViewShowStatusDidShow) : nil;
                     }];
}

- (void)dismissAnimationSacleWithCompletion:(void(^)(void))completion {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTipViewShowStatusWillDismiss) : nil;
    [UIView animateWithDuration:0.25
                          delay:self.automaticDismiss ? 2.5 : 0
         usingSpringWithDamping:0.8
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.contentView.alpha = 0;
                         self.balckView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         completion ? completion() : nil;
                         self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTipViewShowStatusDidDismiss) : nil;
                     }];
}

- (void)dismissAnimationFadeWithCompletion:(void(^)(void))completion {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTipViewShowStatusWillDismiss) : nil;
    [UIView animateWithDuration:0.25
                          delay:self.automaticDismiss ? 2.5 : 0
         usingSpringWithDamping:0.8
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.contentView.alpha = 0;
                         self.balckView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         completion ? completion() : nil;
                         self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTipViewShowStatusDidDismiss) : nil;
                     }];
}

- (void)dismissAnimationShakeWithCompletion:(void(^)(void))completion {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(IDCMBaseTipViewShowStatusWillDismiss) : nil;
    [UIView animateWithDuration:0.25
                          delay:self.automaticDismiss ? 2.5 : 0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentView.alpha = 0;
                         self.balckView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         completion ? completion() : nil;
                         self.tipViewStatusCallback ?self.tipViewStatusCallback(IDCMBaseTipViewShowStatusDidDismiss) : nil;
                     }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)observerKeyboardFrameChange {
    self.KeyboardObserver = [[NSNotificationCenter defaultCenter] addObserverForName: UIKeyboardWillChangeFrameNotification
                                                                              object:nil
                                                                               queue: [NSOperationQueue mainQueue]
                                                                          usingBlock:^(NSNotification * _Nonnull note) {
                                                                              
                                                                              CGRect beginKeyboardRect = [[note.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
                                                                              CGRect endKeyboardRect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                                                                              CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
                                                                              
                                                                              CGFloat offset = self.contentView.bottom  - endKeyboardRect.origin.y;
                                                                              if (offset > 0 && endKeyboardRect.origin.y < beginKeyboardRect.origin.y) {
                                                                                  [UIView animateWithDuration:duration animations:^{
                                                                                      self.contentView.transform = CGAffineTransformMakeTranslation(0, -offset);
                                                                                  } completion:^(BOOL finished) {
                                                                                      self.changeFrame = YES;
                                                                                  }];
                                                                              }
                                                                              if (self.isChangeFrame && endKeyboardRect.origin.y >beginKeyboardRect.origin.y) {
                                                                                  [UIView animateWithDuration:duration animations:^{
                                                                                      self.contentView.transform = CGAffineTransformIdentity;
                                                                                  } completion:^(BOOL finished) {
                                                                                      self.changeFrame = NO;
                                                                                  }];
                                                                              }
                                                                          }];
}

- (UIButton *)balckView {
    return SW_LAZY(_balckView, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.inView.bounds;
        btn.backgroundColor = [UIColor blackColor];
        [btn addTarget:self action:@selector(blackViewAction) forControlEvents:UIControlEventTouchUpInside];
        btn.alpha = 0.0;
        btn;
    }));
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.KeyboardObserver];
}

- (void)showActivityIndicator {
    UIActivityIndicatorView *inDicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    inDicatorView.color = kThemeColor;
    [inDicatorView startAnimating];
    [self.contentView addSubview:inDicatorView];
    
    inDicatorView.centerX = self.contentView.width / 2;
    inDicatorView.centerY = self.contentView.height / 2;
    
    self.inDicatorView = inDicatorView;
}

- (void)dismissActivityIndicator {
    [self.inDicatorView stopAnimating];
    [self.inDicatorView removeFromSuperview];
}

@end






