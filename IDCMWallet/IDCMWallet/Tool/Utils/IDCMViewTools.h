//
//  IDCMViewTool.h
//  IDCMWallet
//
//  Created by wangpu on 2018/3/17.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

//用于处理 View 相关

@interface IDCMViewTools : NSObject


+ (IDCMViewTools *)share;

//ui以 iphone6 为基准
//高度 宽度 相对调整
+ (CGFloat)WidthAdjust:(CGFloat) width;

//字体大小 适配屏幕
//6S以上 字体 大一号

+(UIFont *)FontAdjust:(CGFloat)fontSize fontName:(NSString *) fontName;


//弹框
+(void)ToastView:(UIView *) targetView  info:(NSString *) info position:(QMUIToastViewPosition) position;

//计算文字宽高
+ (CGRect)boundsWithFontSize:(UIFont *) font text:(NSString *)text size:(CGSize) size ;

@end
