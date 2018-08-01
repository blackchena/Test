//
//  IDCMActionTipsView.h
//  IDCMExchange
//
//  Created by BinBear on 2018/6/27.
//  Copyright © 2018年 IDC. All rights reserved.
//

#import <Foundation/Foundation.h>


@class IDCMActionTipViewConfigure, IDCMActionTipViewBtnConfigure;

typedef void(^actionBtnAction)(void);
typedef void(^actionTapAction)(void);

typedef IDCMActionTipViewConfigure *(^actionConfigBlock)(id value);
typedef IDCMActionTipViewConfigure *(^configTapActionBlock)(actionTapAction action);

typedef IDCMActionTipViewBtnConfigure *(^actionBtnConfigBlock)(id value);
typedef IDCMActionTipViewBtnConfigure *(^actionBtnCallbackConfigBlock)(actionBtnAction action);
typedef void (^actionTipViewConfigBlock)(IDCMActionTipViewConfigure *configure);



@interface IDCMActionTipViewBtnConfigure: NSObject
- (id)getBtnTitle;
- (actionBtnAction)getBtnCallback;

- (actionBtnConfigBlock)btnTitle;
- (actionBtnCallbackConfigBlock)btnCallback;
+ (instancetype)btnConfigure;
@end


@interface IDCMActionTipViewConfigure : NSObject
- (id)getImageName;
- (id)getTitle;
- (id)getSubTitle;
- (configTapActionBlock)tapCallback;
- (NSMutableArray<IDCMActionTipViewBtnConfigure *> *)getBtnsConfig;

- (actionConfigBlock)imageName;     // 图片
- (actionConfigBlock)title;         // 标题
- (actionConfigBlock)subTitle;     // 信息内容
- (actionConfigBlock)btnsConfig;
@end



@interface IDCMActionTipsView : NSObject

+ (void)showWithConfigure:(actionTipViewConfigBlock)configure;

@end
