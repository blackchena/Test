//
//  IDCMBannerModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/23.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMBannerModel : NSObject
/**
 *   id
 */
@property (strong, nonatomic) NSNumber *ID;
/**
 *  图片
 */
@property (copy, nonatomic) NSString *ImageUrl;
/**
 *  标题
 */
@property (copy, nonatomic) NSString *Title;
/**
 *   跳转链接
 */
@property (copy, nonatomic) NSString *Url;
/**
 *  是否有跳转链接
 */
@property (assign, nonatomic) BOOL IsHaveUrl;
@end

/*
 Id = 6;
 ImageUrl = "http://192.168.1.36:8888/group1/M00/00/01/wKgBJFr9OWyAG_syAAGPLfk_ASA211.jpg";
 IsHaveUrl = 1;
 Title = sdfds;
 Url = "http://www.baoidu.com";
 */
