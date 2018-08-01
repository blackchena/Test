//
//  IDCMSendCoinView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMTextField.h"

@interface IDCMSendCoinView : UIView
/**
 *  发送数量标题
 */
@property (strong, nonatomic) UILabel *sendTitleLable;
/**
 *  发送数量输入框
 */
@property (strong, nonatomic) IDCMTextField *sendTextField;
/**
 *  币种
 */
@property (strong, nonatomic) UILabel *coinTypeLabel;
/**
 *  line
 */
@property (strong, nonatomic) UIView *sendLine;
@end
