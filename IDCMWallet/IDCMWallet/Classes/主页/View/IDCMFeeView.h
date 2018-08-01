//
//  IDCMFeeView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepSlider.h"
#import "IDCMSendCoinViewModel.h"

@interface IDCMFeeView : UIView
/**
 *  矿工费标题
 */
@property (strong, nonatomic) UILabel *feeTitleLable;
/**
 *  矿工费标题
 */
@property (strong, nonatomic) UILabel *feeTitleHalfLable;
/**
 *  留言输入框
 */
@property (strong, nonatomic) QMUITextField *feeTextField;
/**
 *  矿工费
 */
@property (strong, nonatomic) UILabel *feeLabel;
/**
 *  line
 */
@property (strong, nonatomic) UIView *feeLine;
/**
 *  留言标题
 */
@property (strong, nonatomic) UILabel *leaveTitleLabel;
/**
 *  滑块
 */
@property (strong, nonatomic) StepSlider *slider;

- (instancetype)initWitdHidn:(IDCMCurrencyLayoutType)type;
@end
