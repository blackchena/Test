//
//  IDCMInputNoTitleView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/25.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMInputNoTitleView : UIView
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
