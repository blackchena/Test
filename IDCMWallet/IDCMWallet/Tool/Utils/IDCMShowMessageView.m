//
//  IDCMShowMessageView.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMShowMessageView.h"


@interface IDCMShowMessageView ()

@end

@implementation IDCMShowMessageView
+ (void)showErrorWithMessage:(NSString *)message
{

    QMUITips *tips = [QMUITips showWithText:message inView:DefaultTipsParentView hideAfterDelay:1.5];
    tips.userInteractionEnabled = NO;
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.textLabel.font = textFontPingFangRegularFont(12);
    QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
    backgroundView.cornerRadius =  3;
    backgroundView.styleColor = UIColorMakeWithRGBA(0, 0, 0, 0.9);
    tips.marginInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
}
+ (void)showErrorWithMessage:(NSString *)message withPosition:(QMUIToastViewPosition)position
{
    QMUITips *tips = [QMUITips showWithText:message inView:DefaultTipsParentView hideAfterDelay:1.5];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.textLabel.font = textFontPingFangRegularFont(12);
    QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
    backgroundView.cornerRadius =  3;
    backgroundView.styleColor = UIColorMakeWithRGBA(0, 0, 0, 0.9);
    tips.marginInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    if (position == QMUIToastViewPositionBottom) {
        
        if ([QMUIKeyboardManager isKeyboardVisible]) {
            tips.offset = CGPointMake(0, 140);
        }else{
            tips.offset = CGPointMake(0, 70);
        }
    }else if(position == QMUIToastViewPositionTop){
        tips.offset = CGPointMake(0, -60);
    }else{
        tips.toastPosition = position;
    }
}
+ (void)showMessage:(NSString *)message withPosition:(QMUIToastViewPosition)position
{
    QMUITips *tips = [QMUITips showWithText:message inView:DefaultTipsParentView hideAfterDelay:1.5];
    tips.userInteractionEnabled = NO;
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.textLabel.font = textFontPingFangRegularFont(12);
    QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
    backgroundView.cornerRadius =  3;
    backgroundView.styleColor = UIColorMakeWithRGBA(0, 0, 0, 0.9);
    tips.marginInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    tips.toastPosition = position;
    if (position == QMUIToastViewPositionBottom) {
        
        tips.offset = CGPointMake(0, -100-kSafeAreaBottom);
    }
}
+ (void)showMessageWithCode:(NSString *)code
{
    NSString *message = [IDCMUtilsMethod getAlertMessageWithCode:code];
    QMUITips *tips = [QMUITips showWithText:message inView:DefaultTipsParentView hideAfterDelay:1.5];
    tips.userInteractionEnabled = NO;
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.textLabel.font = textFontPingFangRegularFont(12);
    QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
    backgroundView.cornerRadius =  3;
    backgroundView.styleColor = UIColorMakeWithRGBA(0, 0, 0, 0.9);
    tips.marginInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    tips.toastPosition = QMUIToastViewPositionCenter;
}

+ (void)showMessageWithCode:(NSString *)code withPosition:(QMUIToastViewPosition)position
{
    NSString *message = [IDCMUtilsMethod getAlertMessageWithCode:code];
    QMUITips *tips = [QMUITips showWithText:message inView:DefaultTipsParentView hideAfterDelay:1.5];
    tips.userInteractionEnabled = NO;
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.textLabel.font = textFontPingFangRegularFont(12);
    QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
    backgroundView.cornerRadius =  3;
    backgroundView.styleColor = UIColorMakeWithRGBA(0, 0, 0, 0.9);
    tips.marginInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    tips.toastPosition = position;
    if (position == QMUIToastViewPositionBottom) {
        
        tips.offset = CGPointMake(0, -100-kSafeAreaBottom);
    }
}
@end
