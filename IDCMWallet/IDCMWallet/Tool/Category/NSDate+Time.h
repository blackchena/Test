//
//  NSDate+Time.h
//  RMTiOSApp
//
//  Created by Jason on 2016/11/2.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Time)

/**
 *  获取当前时间的时间戳（例子：1464326536）
 *
 *  @return 时间戳字符串
 */
+ (NSString *)dateWithCurrentTimestamp;

/**
 *  获取取当前北京时间
 *
 *  @param formatter 时间的格式
 *
 *  @return 返回时间字符串
 */

+ (NSString *)dateCurrentStandarTimeWithFormatter:(NSString *)formatter;


/**
 *  时间戳转换为时间的方法
 *
 *  @param timestamp 时间戳
 *
 *  @return  matter 标准时间字符串
 */
+ (NSString *)dateTimeStampChangesStandarTime:(NSString *)timestamp withFormatter:(NSString *)matter;


/**
 nsdata类型转换成时间字符串
 format:yyyy年MM月dd日  或者 yyyy-MM-dd HH:mm:ss.SSS 等
 */
+(NSString*)dateToString:(NSString *)format byDate:(NSDate *)date;


/**
 将秒数转成时分秒
 
 @param totalSeconds 总秒数
 @return 时分秒
 */
+ (NSString *)dateTimeFormatted:(NSInteger)totalSeconds;

/**
 时间戳转换成 NSDate
 @param timestamp 时间戳
 @return NSDate
 */
+ (NSDate *)dateWithTimestamp:(NSString *)timestamp;

/**
 时间字符串转换成NSdate的方法
 
 @param timeString 时间字符串 20170808 12：00：00
 @param formatter @"yyyyMMdd HHmmss"等
 @return 返回时间
 */
+ (NSDate *)dateWithTimeString:(NSString *)timeString formatter:(NSString *)formatter;
/*  ==> 带毫秒 */

/**
 带时区的时间 formatter格式的时间

 @param dateString 2017-12-18T17:27:44+08:00
 @param formatter formatter格式的时间
 @return formatter格式的时间
 */
+ (NSString *)dateTimeZoneWithString:(NSString *)dateString formatter:(NSString *)formatter;
@end
