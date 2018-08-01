//
//  IDCMCountDownManger.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMCountDownManger : NSObject
/**
 *  用NSDate日期倒计时
 *
 *  @param startDate     开始的日期
 *  @param finishDate    结束的日期
 *  @param completeBlock 完成的block
 */
-(void)countDownWithStratDate:(NSDate *)startDate finishDate:(NSDate *)finishDate completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;
/**
 *  用时间戳倒计时
 *
 *  @param starTimeStamp   开始的时间戳
 *  @param finishTimeStamp 结束的时间戳
 *  @param completeBlock   完成后的block
 */
-(void)countDownWithStratTimeStamp:(long long)starTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;
/**
 *  间隔时间后计时
 *
 *  @param startDate     开始的日期
 *  @param intervalDate  间隔时间
 *  @param completeBlock 完成的block
 */
-(void)countDownWithStratDate:(NSDate *)startDate intervalDate:(NSInteger)intervalDate completeBlock:(void (^)(void))completeBlock;
/**
 *  每秒走一次，回调block
 */
-(void)countDownWithPER_SECBlock:(void (^)(void))PER_SECBlock;
/**
 *  销毁计时器
 */
-(void)destoryTimer;
@end
