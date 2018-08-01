//
//  IDCMConfig.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#ifndef IDCMConfig_h
#define IDCMConfig_h

#import <CocoaLumberjack/DDLog.h>

// debug下打印，release下不打印
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
static const int ddLogLevel = DDLogLevelDebug;
#else
#define NSLog(...) {}
static const int ddLogLevel = DDLogLevelOff;
#endif

// 懒加载
#define SW_LAZY(object, assignment) (object = object ?: assignment)

// 返回一个字符串
#define stringify   __STRING

// 设置颜色
#define SetColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define SetAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define KLineColor [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f]
#define KBlueColor [UIColor colorWithRed:59/255.0f green:155/255.0f blue:252/255.0f alpha:1.0f]
#define KRedColor [UIColor colorWithRed:236/255.0f green:92/255.0f blue:69/255.0f alpha:1.0f]
#define KGreenColor [UIColor colorWithRed:0/255.0f green:188/255.0f blue:146/255.0f alpha:1.0f]


// 主色调
#define kThemeColor      SetColor(46, 64, 107)
// 副色调
#define kSubtopicColor   SetColor(41, 104, 185)
// 副灰色调
#define kSubtopicGrayColor   SetColor(153, 159, 165)
// 副黑色调
#define kSubtopicBlackColor   SetColor(51, 51, 51)

#define kThemeGrayColor   SetColor(172, 182, 199)

#define kTabBarHeight            49



//颜色RGB 16进制
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 随机色
#define SWRandomColor SetColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
//黑色
#define textColor333333 UIColorFromRGB(0x333333)
//浅灰色
#define textColor666666 UIColorFromRGB(0x666666)
//淡灰色
#define textColor999999 UIColorFromRGB(0x999999)
//白色
#define textColorFFFFFF UIColorFromRGB(0xffffff)
//黑色
#define textColor000000 UIColorFromRGB(0x000000)

//界面的背景颜色
#define viewBackgroundColor SetColor(247, 247, 247)

//nil的快速处理

#define nilHandleString(string)  string == nil ? @"":string

//
#define debugView(view) view.backgroundColor  = [UIColor redColor];


#define SWLocaloziString(keyString)  NSLocalizedString(keyString, @"")

//字体 Medium
#define textFontPingFangMediumFont(fontsize)  SetFont(@"PingFang-SC-Medium", fontsize)
//字体 Regular
#define textFontPingFangRegularFont(fontsize)  SetFont(@"PingFang-SC-Regular", fontsize)
//字体 Helvetica-Light
#define textFontHelveticaLightFont(fontsize)  SetFont(@"HelveticaNeue-Light", fontsize)
//字体 Helvetica
#define textFontHelveticaMediumFont(fontsize)  SetFont(@"HelveticaNeue", fontsize)


#define kNavigationBarHeight            44
#define kStatusBarHeight                [[UIApplication sharedApplication] statusBarFrame].size.height
#define kStatusBarDifferHeight          (isiPhoneX ? (24) : (0))

#define isiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)


#define kSafeAreaTop        kWindowSafeAreaInset.top
#define kSafeAreaBottom     kWindowSafeAreaInset.bottom

#define kWindowSafeAreaInset \
({\
UIEdgeInsets returnInsets = UIEdgeInsetsMake(20, 0, 0, 0);\
UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;\
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([keyWindow respondsToSelector:NSSelectorFromString(@"safeAreaInsets")] && isiPhoneX) {\
UIEdgeInsets inset = [[keyWindow valueForKeyPath:@"safeAreaInsets"] UIEdgeInsetsValue];\
returnInsets = inset;\
}\
_Pragma("clang diagnostic pop") \
(returnInsets);\
})\


#pragma mark -------调试相关的一些宏定义-------
#ifdef DEBUG
#define SWString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define SWTDebugLog(...) printf("%s 第%d行: %s\n\n", [SWString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define SWTDebugLog(...)
#endif



#define isDictionaryClass(dic)  [dic isKindOfClass:[NSDictionary class]]
#define isArrayClass(array)  [array isKindOfClass:[NSArray class]]
// xgy Eidte end


// 设置字体
#define SetFont(fontName,font)    [UIFont fontWithName:(fontName) size:(font)]

#define isiPhone6Big ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPhone6SBig ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

// 获取屏幕宽度，高度

#define SCREEN_WIDTH_IDCW ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT_IDCW ([UIScreen mainScreen].bounds.size.height)



#define Height (isiPhoneX ? ([[UIScreen mainScreen] bounds].size.height-20):([[UIScreen mainScreen] bounds].size.height))
#define MainScreenRect       [UIScreen mainScreen].bounds
#define Screen_Window  [UIApplication sharedApplication].keyWindow
#define IDCM_APPDelegate  ((IDCMAppDelegate*)[UIApplication sharedApplication].delegate)


#define AutoLayoutHeight   SCREEN_HEIGHT/667
#define AutoLayoutWidth   SCREEN_WIDTH/375


//#ifndef weakify
//#if DEBUG
//#if __has_feature(objc_arc)
//#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
//#else
//#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
//#endif
//#else
//#if __has_feature(objc_arc)
//#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
//#else
//#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
//#endif
//#endif
//#endif
//
//#ifndef strongify
//#if DEBUG
//#if __has_feature(objc_arc)
//#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
//#else
//#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
//#endif
//#else
//#if __has_feature(objc_arc)
//#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
//#else
//#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
//#endif
//#endif
//#endif
#define AdjustWidth(width) [IDCMViewTools WidthAdjust:(width)]
#endif /* IDCMConfig_h */
