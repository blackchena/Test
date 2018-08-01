//
//  IDCMCenterTipView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseCenterTipView.h"


typedef NS_ENUM(NSUInteger, IDCMCenterTipViewBtnType) {
    IDCMCenterTipViewBtnType_white, // 白色背景 主题色边框和文字
    IDCMCenterTipViewBtnType_theme, // 主题色背景 白色文字
};

@class IDCMCenterTipViewConfigure, IDCMCenterTipViewBtnConfigure;

typedef void(^btnAction)(void);
typedef IDCMCenterTipViewConfigure *(^configBlock)(id value);
typedef IDCMCenterTipViewBtnConfigure *(^btnConfigBlock)(id value);
typedef IDCMCenterTipViewBtnConfigure *(^btnCallbackConfigBlock)(btnAction action);
typedef void (^centerTipViewConfigBlock)(IDCMCenterTipViewConfigure *configure);



@interface IDCMCenterTipViewBtnConfigure: NSObject
- (id)getBtnTitle;
- (IDCMCenterTipViewBtnType)getBtnType;
- (btnAction)getBtnCallback;

- (btnConfigBlock)btnTitle;
- (btnConfigBlock)btnType;
- (btnCallbackConfigBlock)btnCallback;
+ (instancetype)btnConfigure;
@end


@interface IDCMCenterTipViewConfigure : NSObject
- (id)getTopTitle;
- (id)getTitle;
- (id)getSubTitle;
- (id)getImage;
- (NSMutableArray<IDCMCenterTipViewBtnConfigure *> *)getBtnsConfig;

- (configBlock)topTitle;       // 上面标题
- (configBlock)title;         // 标题
- (configBlock)subTitle;     // 信息内容
- (configBlock)image;       // 图片
- (configBlock)btnsConfig; // 数组 按钮的配置(btnTitle, btnType, btnCallback)
@end




@interface IDCMCenterTipView : IDCMBaseCenterTipView

+ (void)showWithConfigure:(centerTipViewConfigBlock)configure;

+ (void)showToView:(UIView *)view
         configure:(centerTipViewConfigBlock)configure;

+ (void)showToView:(UIView *)view
         configure:(centerTipViewConfigBlock)configure
    animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle;

+ (void)showToView:(UIView *)view configure:(centerTipViewConfigBlock)configure
                           automaticDismiss:(BOOL)automaticDismiss
                             animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
                      tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback;

@end







