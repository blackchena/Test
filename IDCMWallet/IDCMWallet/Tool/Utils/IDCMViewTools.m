//
//  IDCMViewTool.m
//  IDCMWallet
//
//  Created by wangpu on 2018/3/17.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMViewTools.h"

@implementation IDCMViewTools


static IDCMViewTools *viewTools = nil;
static dispatch_once_t onceToken;

+ (IDCMViewTools *)share
{
    dispatch_once(&onceToken, ^{
        viewTools = [[IDCMViewTools alloc] init];
    });
    return viewTools;
}


+ (CGFloat)WidthAdjust:(CGFloat) width{
    
    //
    CGFloat autoSizeScale = 1.0;
    
//    if (SCREEN_WIDTH == 320.0) {
//
//         autoSizeScale = 0.90;
//
//    }else if (SCREEN_WIDTH == 375){
//
//         autoSizeScale = 1.0;
//        
//    }else if (SCREEN_WIDTH == 414){
//
//          autoSizeScale = 1.1;
//    }

    return  width * autoSizeScale;
}

+(UIFont *)FontAdjust:(CGFloat)fontSize fontName:(NSString *) fontName
{
    //6p 以上 +1
//    if (SCREEN_WIDTH == 414) {
//        fontSize+=1;
//        return SetFont(fontName, fontSize);
//    }
//    else
//    {
        return  SetFont(fontName, fontSize);
//    }

    
}

//显示 提示
+(void)ToastView:(UIView *) targetView  info:(NSString *) info position:(QMUIToastViewPosition) position {
    
    QMUITips * toastView = [[QMUITips alloc] initWithView:targetView];
    QMUIToastBackgroundView  * backView = (QMUIToastBackgroundView *) toastView.backgroundView;
    backView.cornerRadius = 5;
    toastView.toastPosition = position;
    toastView.removeFromSuperViewWhenHide = YES;
    toastView.offset = CGPointMake(0, -60);
    [targetView addSubview:toastView];
    QMUIToastContentView * contentView = (QMUIToastContentView *) toastView.contentView;
    contentView.insets = UIEdgeInsetsMake(8, 12, 8, 12);
    contentView.detailTextLabel.text = info;
    contentView.detailTextLabel.font = SetFont(@"PingFangSC-Regular", 12);
    [toastView showAnimated:YES];
    [toastView hideAnimated:YES afterDelay:1.5];
}

//计算文字宽高
+ (CGRect)boundsWithFontSize:(UIFont *) font text:(NSString *)text size:(CGSize) size
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //style.lineSpacing = lineSpacing;
    style.alignment = NSTextAlignmentLeft;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect =  [attributeString boundingRectWithSize:size options:options context:nil];
    return rect;
    
}
//调整行间距
+ (NSMutableAttributedString *)atttibutedStringForString:(NSString *)string LineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    return attributedString;
    
}
@end
