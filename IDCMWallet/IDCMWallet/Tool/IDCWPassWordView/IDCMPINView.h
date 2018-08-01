//
//  IDCMPINView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , IDCMPINButtonImageType) {
    IDCMPINButtonImageCloseType              = 1, // 按钮为关闭样式
    IDCMPINButtonImageBackType               = 2, // 按钮为返回样式
};

typedef void(^IDCMPayFinish)(NSString *password);

@interface IDCMPINView : UIView

/**
 创建一个PINView

 @param buttonType 关闭按钮背景图片的类型
 @param closeBtnInput 关闭的回调
 @param PINFinish 完成回调
 @return 返回PINView
 */
+ (instancetype)bindPINViewType:(IDCMPINButtonImageType)buttonType
                  closeBtnInput:(CommandInputBlock)closeBtnInput
                 PINFinishBlock:(IDCMPayFinish)PINFinish;

/**
 移除密码框

 @param isShake 是否需要震动
 */
- (void)removePasseword:(BOOL)isShake;

@end
