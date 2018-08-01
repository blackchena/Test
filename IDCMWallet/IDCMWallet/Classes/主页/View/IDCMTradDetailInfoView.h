//
//  IDCMTradDetailInfoView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/25.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMTradDetailInfoView : UIView
/**
 *   标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *   标题
 */
@property (strong, nonatomic) UILabel *textTitleLabel;
/**
 *  输入框
 */
@property (strong, nonatomic) QMUITextView *textField;
/**
 *  右侧文本
 */
@property (strong, nonatomic) UILabel *contentLabel;
/**
 *  线
 */
@property (strong, nonatomic) UIView *lineView;
@end
