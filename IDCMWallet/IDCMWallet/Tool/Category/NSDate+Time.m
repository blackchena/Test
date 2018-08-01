//
//  NSDate+Time.m
//  RMTiOSApp
//
//  Created by Jason on 2016/11/2.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "NSDate+Time.h"

@implementation NSDate (Time)
/**
 *  获取当前时间的时间戳（例子：1464326536）
 *
 *  @return 时间戳字符串
 */
+ (NSString *)dateWithCurrentTimestamp
{
    //获取系统当前的时间NSDate
    NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    //把1970至今的秒数换算成时间
    NSTimeInterval a=[nowDate timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%f", a ];
    NSInteger i = [timeString integerValue];
    NSString *timeStame = [NSString stringWithFormat:@"%ld",(long)i];
    // 转为字符型
    return timeStame;
}

/**
 *  获取取当前北京时间
 *
 *  @param formatter 时间的格式
 *
 *  @return 返回时间字符串
 */

+ (NSString *)dateCurrentStandarTimeWithFormatter:(NSString *)formatter
{
    NSString * locationString= [NSDate dateTimeStampChangesStandarTime:[NSDate dateWithCurrentTimestamp] withFormatter:formatter];
    return locationString;
}


/**
 *  时间戳转换为时间的方法
 *
 *  @param timestamp 时间戳
 *
 *  @return  matter 标准时间字符串
 */
+ (NSString *)dateTimeStampChangesStandarTime:(NSString *)timestamp withFormatter:(NSString *)matter
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:matter];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


/**
 nsdata类型转换成时间字符串
 format:yyyy年MM月dd日  或者 yyyy-MM-dd HH:mm:ss.SSS 等
 */
+ (NSString*)dateToString:(NSString *)format byDate:(NSDate *)date
{
    NSDateFormatter *dateToStringFormatter=[[NSDateFormatter alloc] init];
    [dateToStringFormatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateToStringFormatter setTimeZone:timeZone];
    return [dateToStringFormatter stringFromDate:date];
}


/**
 将秒数转成时分秒
 
 @param totalSeconds 总秒数
 @return 时分秒
 */
+ (NSString *)dateTimeFormatted:(NSInteger)totalSeconds
{
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}


/**
 时间戳转换成 NSDate
 @param timestamp 时间戳
 @return NSDate
 */
+ (NSDate *)dateWithTimestamp:(NSString *)timestamp
{
    //先把时间戳转化成时间
    NSString *timeString=[NSDate dateTimeStampChangesStandarTime:timestamp withFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    return date;
}



/**
 时间字符串转换成NSdate的方法

 @param timeString 时间字符串 20170808 12：00：00
 @param formatter @"yyyyMMdd HHmmss"等
 @return 返回时间
 */
+ (NSDate *)dateWithTimeString:(NSString *)timeString formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   // NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //[dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formatter];
    NSDate *date = [dateFormatter dateFromString:timeString];
    return date;
}


/*2017-12-18T17:27:44+08:00*/
+ (NSString  *)dateTimeZoneWithString:(NSString *)dateString formatter:(NSString *)formatter
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss zz:zz"];
    // 先将"+"替换成@" "
    dateString = [dateString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    //得到的NSDate 转出来的是UTC时间 但是本质就是北京时间
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *dateToStringFormatter=[[NSDateFormatter alloc] init];
    [dateToStringFormatter setDateFormat:formatter];
    
    //所以要将 date 转成 北京时区 不需要 + 8小时
    //如果不加 这句 就会有8小时时差
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateToStringFormatter setTimeZone:GTMzone];

    return [dateToStringFormatter stringFromDate:date];
}

@end
