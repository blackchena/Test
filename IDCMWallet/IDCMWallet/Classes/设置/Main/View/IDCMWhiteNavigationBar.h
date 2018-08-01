//
//  IDCMWhiteNavigationBar.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMWhiteNavigationBar
// @abstract <#类的描述#>
// @discussion <#类的功能#>
#import <UIKit/UIKit.h>

@interface IDCMWhiteNavigationBar : UIView
/**
 *  退出按钮
 */
@property (strong, nonatomic) UIButton *backButton;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titlelable;

@property (nonatomic,copy) void(^backBtnCallbak)(void);
@end
