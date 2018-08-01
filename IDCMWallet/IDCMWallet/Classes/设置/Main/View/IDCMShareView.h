//
//  IDCMShareView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/2.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMShareView : UIView
/**
 创建一个信息展示的View
 
 @param btnTitle 确认按钮的标题
 @param dataSignal 展示的信息，为一个元组数组
 @param sureBtnInput 确认按钮事件
 @param shareCommand 分享事件信号
 @return 信息展示的View
 */
+ (instancetype)bondSureViewWithSureBtnTitle:(NSString *)btnTitle
                                confidSignal:(RACSignal *)dataSignal
                                sureBtnInput:(CommandInputBlock)sureBtnInput
                                shareCommand:(RACCommand *)shareCommand;
@end
