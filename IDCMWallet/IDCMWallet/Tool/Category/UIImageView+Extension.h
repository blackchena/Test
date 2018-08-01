//
//  UIImageView+Extension.h
//  RMTiOSApp
//
//  Created by Jason on 2016/12/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)




/**
 快速创建imageView
 @param  superView 父视图
 @param contentMode contentMode
 @param clipsToBounds 是否裁剪
 */
+ (UIImageView *)createImageViewWithSuperView:(UIView *)superView contentMode:(UIViewContentMode)contentMode image:(UIImage *)image clipsToBounds:(BOOL)clipsToBounds;
@end
