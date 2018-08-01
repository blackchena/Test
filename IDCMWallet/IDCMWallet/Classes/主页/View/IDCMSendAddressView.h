//
//  IDCMSendAddressView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMSendAddressView : UIView
/**
 *  接收地址标题
 */
@property (strong, nonatomic) UILabel *reciveAddressTitleLable;
/**
 *  接收地址输入框
 */
@property (strong, nonatomic) UITextField *reciveAddressTextField;
/**
 *  扫描按钮
 */
@property (strong, nonatomic) QMUIButton *scanButton;
/**
 *  line
 */
@property (strong, nonatomic) UIView *reciveLine;
/**
 *  粘贴地址
 */
@property (strong, nonatomic) UIButton *pasterButton;
@end
