//
//  IDCMTradingPageNavigationBar.h
//  IDCMWallet
//
//  Created by BinBear on 2018/4/27.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMTradingPageNavigationBar : UIView
/**
 *  币币闪兑
 */
@property (strong, nonatomic) QMUIButton *swapButton;
/**
 *  币币闪兑
 */
@property (strong, nonatomic) QMUIButton *OTCButton;
/**
 *  swap line
 */
@property (strong, nonatomic) UIView *swapLine;
/**
 *  OTC line
 */
@property (strong, nonatomic) UIView *OTCLine;
/**
 *  红点，默认隐藏
 */
@property (strong, nonatomic) UIView *dotView;


/**
 * 显示红点
 */
- (void)showTabBadgePoint;
/**
 * 隐藏红点
 */
- (void)removeTabBadgePoint;
@end
