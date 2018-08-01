//
//  UIImageView+Extension.m
//  RMTiOSApp
//
//  Created by Jason on 2016/12/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)




/**
 快速创建imageView
 @param  superView 父视图
 @param contentMode contentMode
 @param clipsToBounds 是否裁剪
 */
+ (UIImageView *)createImageViewWithSuperView:(UIView *)superView contentMode:(UIViewContentMode)contentMode image:(UIImage *)image clipsToBounds:(BOOL)clipsToBounds
;
{
    UIImageView *mageView =  [[UIImageView alloc] init];
    mageView.contentMode = contentMode;
    mageView.clipsToBounds = clipsToBounds;
    
    if (superView) {
        [superView addSubview:mageView];
    }
    if (image) {
        mageView.image = image;
    }
  
    
    return mageView;
    
}


@end
