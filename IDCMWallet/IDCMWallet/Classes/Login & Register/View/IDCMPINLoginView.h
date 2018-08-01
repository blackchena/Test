//
//  IDCMPINLoginView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IDCMPINLoginView : UIView

/**
 *  退出登录按钮
 */
@property (strong, nonatomic) UIButton *logoutButton;
/**
 *  密码
 */
@property (copy, nonatomic) NSString *password;


/**
 抖动原点view
 */
- (void)showShakingMobilePhoneVibrate;

@end
