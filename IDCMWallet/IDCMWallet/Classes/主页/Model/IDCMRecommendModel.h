//
//  IDCMRecommendModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMRecommendModel : NSObject
/**
 *   慢
 */
@property (copy, nonatomic) NSString *slow;
/**
 *   推荐
 */
@property (copy, nonatomic) NSString *fastFee;
/**
 *   快
 */
@property (copy, nonatomic) NSString *veryFastFee;
@end

/*
 fastFee = "0.0005";
 slow = "0.0005";
 veryFastFee = "0.0005";
 */

