//
//  UIWindow+Extension.m
//  RMTiOSApp
//
//  Created by Jason on 2016/11/18.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "UIWindow+Extension.h"

@implementation UIWindow (Extension)
- (UIImage *)screenshot
{
    return [self screenshotWithRect:self.bounds];
}

- (UIImage *)screenshotWithRect:(CGRect)rect
{

    CGSize imageSize = CGSizeZero;
    CGFloat width = rect.size.width, height = rect.size.height;
    CGFloat x = rect.origin.x, y = rect.origin.y;
    
    imageSize = CGSizeMake(width, height);
    x = rect.origin.x;
    y = rect.origin.y;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.center.x, self.center.y);
    CGContextConcatCTM(context, self.transform);
    CGContextTranslateCTM(context, -self.bounds.size.width * self.layer.anchorPoint.x, -self.bounds.size.height * self.layer.anchorPoint.y);
    
      CGContextTranslateCTM(context, -x, -y);
    
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    else
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
