//
//  IDCMControllerTool.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMControllerTool.h"
#import "IDCMPINLoginView.h"
#import "NSDate+Time.h"
#import "IDCMUserStateModel.h"

#import "IDCMCustomTipView.h"

#define KeyWindow [UIApplication sharedApplication].keyWindow

@implementation IDCMControllerTool
+ (void)showInputPINNumberController
{
    NSInteger thresholdTimeLong = 600;//10 *60;
    NSInteger backgroundTimeLong = [IDCMManagerObjTool manager].didEnterFontgroundTime - [IDCMManagerObjTool manager].startEnterBackgroundTime;
    
    //未达到时间
    if (thresholdTimeLong > backgroundTimeLong || [IDCMManagerObjTool manager].didShowPasswordView) {
        //重置一下时间
        [IDCMManagerObjTool manager].startEnterBackgroundTime = [[NSDate dateWithCurrentTimestamp] integerValue];
        return;
    }
    IDCMUserStateModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserStatusInfokey];
    if (![CommonUtils getBoolValueInUDWithKey:IsLoginkey] || [model.payPassword isEqualToString:@"0"]) {
        return;
    }
    
    [IDCM_APPDelegate verifyPINViewController];
}


/**
 展示 AlertView的方法
 
 @param title 需要展示的标题  14px PingFangSC-Regular  333333
 @param message 消息提示     12px PingFangSC-Regular  666666
 @param buttonArray 按钮的标题数组
 @param actionBlock 点击按钮的回调 clickIndex点击的下标 MainThread
 */
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonArray:(NSArray *)buttonArray actionBlock:(void(^)(NSInteger clickIndex))actionBlock
{
    [IDCMCustomTipView showWithTitle:title
                      titleConfigure:nil
                             message:message
                    messageConfigure:nil
                    buttonTitleArray:buttonArray
                          colorIndex:nil
                 clickButtonCallback:actionBlock];
}



/**
 展示 AlertView的方法
 @param title 需要展示的标题
 @param titleFont 需要展示的标题的字体
 @param titleColor 需要展示的标题的颜色
 @param message 消息提示
 @param messageFont 消息提示的字体
 @param messageColor 消息提示的颜色
 @param buttonArray 按钮的标题数组
 @param index 需要加背景颜色的按钮
 @param actionBlock 点击按钮的回调 clickIndex点击的下标 MainThread
 */
+ (void)showAlertViewWithTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor message:(NSString *)message messageFont:(UIFont *)messageFont messageColor:(UIColor *)messageColor buttonArray:(NSArray *)buttonArray colorIndex:(NSInteger)index actionBlock:(void(^)(NSInteger clickIndex))actionBlock
{
    
    [IDCMCustomTipView showWithTitle:title
                      titleConfigure:RACTuplePack(titleFont, titleColor)
                             message:message
                    messageConfigure:RACTuplePack(messageFont, messageColor)
                    buttonTitleArray:buttonArray
                          colorIndex:nil
                 clickButtonCallback:actionBlock];
    
}
+ (void)dissmissAlertView{
    
    [IDCMCustomTipView dismissWithCompletion:nil];
}
+ (void)bringToFront{
    
    [IDCMBaseCenterTipView bringSubviewToFrontWithView:KeyWindow];
}
@end
