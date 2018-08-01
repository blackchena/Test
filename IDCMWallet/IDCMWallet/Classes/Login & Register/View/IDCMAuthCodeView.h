//
//  IDCMAuthCodeView.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMAuthCodeView : UIView
/**
 *  验证码按钮
 */
@property (strong, nonatomic) UIButton *authButton;
/**
 *  输入框
 */
@property (strong, nonatomic) UITextField *textField;
@end
