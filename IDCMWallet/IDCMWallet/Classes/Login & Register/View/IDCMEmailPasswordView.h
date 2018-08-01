//
//  IDCMEmailPasswordView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMEmailPasswordView : UIView
/**
 *  输入框
 */
@property (strong, nonatomic) UITextField *textField;
/**
 *  线
 */
@property (strong, nonatomic) UIView *lineView;
/**
 *  icon
 */
@property (strong, nonatomic) UIButton *iconButton;
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoImageView;
@end
