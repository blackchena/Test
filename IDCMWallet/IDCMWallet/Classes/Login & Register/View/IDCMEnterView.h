//
//  IDCMEnterView.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMEnterView : UIView
/**
 *   标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  输入框
 */
@property (strong, nonatomic) UITextField *textField;
/**
 *  线
 */
@property (strong, nonatomic) UIView *lineView;
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoImageView;
@end
