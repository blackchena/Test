//
//  IDCMBlockTextView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IDCMBlockTextViewConfigure : NSObject

- (instancetype)configTextViewShouldBeginEditing:(BOOL(^)(UITextView *textView))block;
- (instancetype)configTextViewShouldEndEditing:(BOOL(^)(UITextView *textView))block;
- (instancetype)configTextViewDidBeginEditing:(void(^)(UITextView *textView))block;
- (instancetype)configTextViewDidEndEditing:(void(^)(UITextView *textView))block;
- (instancetype)configTextViewDidChange:(void(^)(UITextView *textView))block;
- (instancetype)configTextViewDidChangeSelection:(void(^)(UITextView *textView))block;

- (instancetype)configTextViewShouldChangeTextInRange:(BOOL(^)(UITextView *textView, NSRange range, NSString *text))block;

@end


typedef void(^textViewConfigureBlock)(IDCMBlockTextViewConfigure *configure);
@interface IDCMBlockTextView : UITextView

/**
 创建方式
 
 @param frame frame
 @param configure configure
 @return IDCMBlockTextField
 */
+ (instancetype)BlockTextViewWithFrame:(CGRect)frame
                             configure:(IDCMBlockTextViewConfigure *)configure;


/**
 block 创建方式
 
 @param frame frame
 @param configureBlock configureBlock
 @return IDCMBlockTextField
 */
+ (instancetype)BlockTextViewWithFrame:(CGRect)frame
                        configureBlock:(textViewConfigureBlock)configureBlock;


@end













