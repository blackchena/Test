//
//  IDCMUtilsMethod.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBXScanViewStyle;

@interface IDCMUtilsMethod : NSObject
/**
 *  归档
 *  @return  是否归档成功
 */
+ (BOOL)keyedArchiverWithObject:(id)object withKey:(NSString *)key;
/**
 *  反归档
 *  @return  反归档对象
 */
+ (id)getKeyedArchiverWithKey:(NSString *)key;

/**
 *  用户名验证
 *  @return  是否
 */
+(BOOL)isValidateUserName:(NSString *)userName;
/**
 *  密码验证
 *  @return  是否
 */
+(BOOL)isValidatePassword:(NSString *)password;
/**
 删除小数点后面多余的0

 @param stringFloat 要删除的原字符串
 @return 删除成功后的字符串
 */
+ (NSString *)changeFloat:(NSString *)stringFloat;

/**
 解决服务器返回数据精度丢失问题

 @param balance 金额
 @return 返回正常精度数据
 */
+ (NSString *)precisionControl:(NSNumber *)balance;

/**
 获取本地货币名称

 @return 本地货币名称
 */
+ (NSString *)getLocalCurrencyName;

/**
 获取语言包名称

 @return 语言包名称
 */
+ (NSString *)getPreferredLanguage;
/**
 获取服务器语言代码
 
 @return 语言代码
 */
+ (NSNumber *)getServiceLanguage;

/**
 根据本地语言获取H5需要的语言包

 @return 返回H5语言包
 */
+ (NSString*)getH5Language;
/**
 获取生成助记词时要传的语言
 
 @return 语言
 */
+ (NSString *)getPhrasesLanguage;
/**
 获取国家列表路径
 
 @return 路劲
 */
+ (NSString *)getLanguagePath;
+ (NSString *)stringWithString:(NSDate *)stringDate Format:(NSString *)format locale:(NSLocale *)locale;
// 将数字转为每隔3位整数由逗号“,”分隔的字符串
+ (NSString *)separateNumberUseCommaWith:(NSString *)number;

/**
 中间有省略号的字符串

 @param encryptStr 转换前的字符串
 @param frontLen 前面保留的位数
 @param backLen 后面保留的位数
 @return 返回转换后的字符串
 */
+ (NSString *)encryptStringWithStar:(NSString *)encryptStr andFrontLength:(NSInteger)frontLen andBackLength:(NSInteger)backLen;
/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;

/**
 返回截屏

 @param inputView 截屏的view
 @return 返回的view
 */
+ (UIView *)customSnapshoFromView:(UIView *)inputView;

/**
 返回十进制下的字符串

 @param numberString 需要转换的字符串
 @return 转换后的字符串
 */
+ (NSString *)getStringFrom:(NSNumber *)numberString;

/**
 展示版本更新弹框


 @param response 后台返回数据
 @param type 调用类型  0:启动的时候调用  1: 点击检查更新按钮调用
 */
+ (void)checkVersonWithResponse:(NSDictionary *)response withType:(NSString *)type;

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController;

/**
 比较版本号

 @param appVersion 服务器版本号
 @return 是否需要更新
 */
+ (BOOL)compareAppVersion:(NSString *)appVersion;

/**
 退出钱包
 */
+ (void)logoutWallet;

/**
 返回分秒格式

 @param time 总秒数
 @return 返回的格式
 */
+ (NSString *)getTimeWithSeconds:(NSInteger)time;

/**
 获取错误码

 @param codeStr 对应的code
 @return 对应错误码提示
 */
+ (NSString *)getAlertMessageWithCode:(NSString *)codeStr;

/**
 获取字符串数值对应的DecimalNumber，如果是DecimalNumber是NaN，那返回0
 
 @param value 对应的数值字符串
 @return 转换好的DecimalNumber
 */
+ (NSDecimalNumber *)getStringDecimalNumber:(NSString *)value;

/**
 获取bundleIdentifier

 @return bundleIdentifier
 */
+ (NSString *)getBundleIdentifier;

/**
 配置扫一扫控制器的样式

 @return 扫描控制器样式
 */
+ (LBXScanViewStyle *)scanStyleWith:(CGFloat)centerPostion andWithBorderColor:(UIColor *)color;

+ (NSString *)addSpaceByString:(NSString *)string separateCount:(NSInteger)separateCount;
+ (NSString *)valueString:(NSString *)string;

@end

