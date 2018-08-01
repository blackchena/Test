//
//  IDCMUMShareUtils.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/2.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
#import <UMShare/UMShare.h>
#import <TwitterKit/TwitterKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMSocialManager.h>

@class IDCMUMShareUtils,IDCMUMShareUtilsConfig;

// 分享的类型
typedef NS_ENUM(NSUInteger, IDCMShareType) {
    kIDCMShareTypePlainText                       = 1, // 分享纯文本
    kIDCMShareTypeLocalSingleImage                = 2, // 分享本地单张图片
    kIDCMShareTypeLocalMultipleImage              = 3, // 分享本地多张图片
    kIDCMShareTypeNetworkImage                    = 4, // 分享网络图片
    kIDCMShareTypeTextImage                       = 5, // 分享图片和文字
    kIDCMShareTypeLink                            = 6  // 分享链接
};
// 配置分享信息的Block
typedef IDCMUMShareUtilsConfig *(^shareUtilsObjectBlock)(id value);
typedef IDCMUMShareUtilsConfig *(^shareUtilsTypeBlock)(NSInteger value);
// 提供外部配置Block
typedef void (^shareConfigBlock)(IDCMUMShareUtilsConfig *configure);



/*********  配置类  ***********/
@interface IDCMUMShareUtilsConfig : NSObject
// 分享的第三方平台
- (shareUtilsTypeBlock)sharePlatformType;
// 分享的类型
- (shareUtilsTypeBlock)shareType;
// 分享的文本
- (shareUtilsObjectBlock)shareText;
// 分享的标题
- (shareUtilsObjectBlock)shareTitle;
// 分享的副标题
- (shareUtilsObjectBlock)shareSubTitle;
// 分享的缩略图片
- (shareUtilsObjectBlock)shareThumbImage;
// 分享的大图片
- (shareUtilsObjectBlock)shareImage;
// 分享的网页链接
- (shareUtilsObjectBlock)shareWebLink;
@end


/*********  分享工具类  ***********/
@interface IDCMUMShareUtils : NSObject
/**
 *  配置分享信息
 *
 *  @param configure 配置block
 *
 *  @return 分享工具类
 */
+ (instancetype)shareInfoConfigure:(shareConfigBlock)configure;
/**
 *  配置各平台APPkey以及AppSecret
 */
+ (void)configUMShareInfo;
/**
 *  是否安装客户端（支持平台：微博、微信、QQ、QZone、Facebook）
 *
 *  @param platformType 平台类型
 *
 *  @return YES 已安装，NO 尚未安装
 */
+ (BOOL)isClientInstalled:(UMSocialPlatformType)platformType;
/**
 *  分享
 */
- (void)sharePlatform;
@end
