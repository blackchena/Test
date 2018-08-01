//
//  IDCMPINPasswordNumberView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/16.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , IDCMPINNumberType) {
    IDCMPINNumberAdd              = 1, // 点击数字键
    IDCMPINNumberDelete           = 2, // 点击删除键
};

typedef void(^IDCMPINNumberClickBlock)(NSInteger number,IDCMPINNumberType type);


@interface IDCMPINPasswordNumberView : UIView
/**
 *   点击回调
 */
@property (copy, nonatomic) IDCMPINNumberClickBlock PINNumberBlock;
@end
