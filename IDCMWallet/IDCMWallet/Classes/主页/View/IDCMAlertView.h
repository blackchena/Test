//
//  IDCMAlertView.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/19.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , IDCMShowType) {
    IDCMShowNotBackups           = 1, // 未备份恢复短语
    IDCMShowNotSetPayPw          = 2, // 未设置支付密码
    IDCMShowReciveCoin           = 3, // 接收
};

typedef void(^IDCMAlertViewBlock)(void);
typedef void(^IDCMAlertViewDismissBlock)(void);

@interface IDCMAlertView : UIView
/**
 确定回调
 */
@property (nonatomic,copy) IDCMAlertViewBlock alertViewBlock;
/**
 取消回调
 */
@property (nonatomic,copy) IDCMAlertViewDismissBlock dismissBlock;
/**
 展示的信息
 */
@property (nonatomic,copy) NSDictionary *showInfo;

// 获得一个CheckManager对象
+ (instancetype)sharedCheckManager;
// 根据type显示提示View
-(void)showViewWithType:(IDCMShowType)type;
// 显示提示View
-(void)showAlertView;

@end
