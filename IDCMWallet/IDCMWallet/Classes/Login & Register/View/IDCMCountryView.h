//
//  IDCMCountryView.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMCountryView : UIView
/**
 *   标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  国家
 */
@property (strong, nonatomic) UITextField *countryLabel;
/**
 *  线
 */
@property (strong, nonatomic) UIView *lineView;
/**
 *  下拉按钮
 */
@property (strong, nonatomic) UIButton *downButton;
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoImageView;
@end
