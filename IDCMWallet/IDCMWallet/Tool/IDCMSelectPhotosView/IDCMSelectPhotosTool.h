//
//  IDCMSelectPhotosTool.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/18.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AnimationCompletionBlock)(NSInteger photoCount);
typedef NSArray<UIImageView *> *(^AnimationImageViewBlock)(NSInteger photoCount);
typedef void(^SelectSiglePhotoBlock)(UIImage *thumbnailPhoto,UIImage *originPhoto);
typedef void(^SelectMultiplePhotoBlock)(NSArray<UIImage *> *thumbnailPhotos,NSArray<UIImage *> *originPhotos);
@interface IDCMSelectPhotosTool : NSObject
+ (instancetype)sharedSelectPhotosTool;




/**
 需要设置动画的配置

 @param animationImageViews 动画源imageview
 @param animationCompletionCallback 动画完成的回调
 */
- (void)setAnimationImageViews:(AnimationImageViewBlock)animationImageViews
   animationCompletionCallback:(AnimationCompletionBlock)animationCompletionCallback;




/**
 选择单张图片

 @param fromCamera 从相机 或者 相册
 @param size 缩略图尺寸
 @param completeCallback 完成回调
 */
- (void)selectSiglePhotoFromCamera:(BOOL)fromCamera
                 thumbnailWithSize:(CGSize)size
                  completeCallback:(SelectSiglePhotoBlock)completeCallback;



/**
 选择多张张图片

 @param maxCount 选择最多张数
 @param size 缩略图尺寸
 @param completeCallback 完成回调
 */
- (void)selectMultiplePhotoWithMaxCount:(NSInteger)maxCount
                      thumbnailWithSize:(CGSize)size
                       completeCallback:(SelectMultiplePhotoBlock)completeCallback;



@end













