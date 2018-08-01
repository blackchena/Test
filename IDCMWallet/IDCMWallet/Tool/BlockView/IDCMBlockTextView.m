//
//  IDCMBlockTextView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBlockTextView.h"


@interface IDCMBlockTextViewConfigure ()
@property (nonatomic,copy) BOOL(^TextViewShouldBeginEditing)(UITextView *textView);
@property (nonatomic,copy) BOOL(^TextViewShouldEndEditing)(UITextView *textView);
@property (nonatomic,copy) void(^TextViewDidBeginEditing)(UITextView *textView);
@property (nonatomic,copy) void(^TextViewDidEndEditing)(UITextView *textView);
@property (nonatomic,copy) void(^TextViewDidChange)(UITextView *textView);
@property (nonatomic,copy) void(^TextViewDidChangeSelection)(UITextView *textView);
@property (nonatomic,copy) BOOL(^TextViewShouldChangeTextInRange)
                              (UITextView *textView, NSRange range, NSString *text);
@end
@implementation IDCMBlockTextViewConfigure
- (instancetype)configTextViewShouldBeginEditing:(BOOL(^)(UITextView *textView))block {
    _TextViewShouldBeginEditing = [block copy];
    return self;
}
- (instancetype)configTextViewShouldEndEditing:(BOOL(^)(UITextView *textView))block {
    _TextViewShouldEndEditing = [block copy];
    return self;
}
- (instancetype)configTextViewDidBeginEditing:(void(^)(UITextView *textView))block {
    _TextViewDidBeginEditing = [block copy];
    return self;
}
- (instancetype)configTextViewDidEndEditing:(void(^)(UITextView *textView))block {
    _TextViewDidEndEditing = [block copy];
    return self;
}
- (instancetype)configTextViewDidChange:(void(^)(UITextView *textView))block {
    _TextViewDidChange = [block copy];
    return self;
}
- (instancetype)configTextViewDidChangeSelection:(void(^)(UITextView *textView))block {
    _TextViewDidChangeSelection = [block copy];
    return self;
}
- (instancetype)configTextViewShouldChangeTextInRange:(BOOL(^)(UITextView *textView, NSRange range, NSString *text))block {
    _TextViewShouldChangeTextInRange = [block copy];
    return self;
}
@end


@interface IDCMBlockTextView () <UITextViewDelegate>
@property (nonatomic,strong) IDCMBlockTextViewConfigure *configure;
@end

@implementation IDCMBlockTextView
+ (instancetype)BlockTextViewWithFrame:(CGRect)frame
                             configure:(IDCMBlockTextViewConfigure *)configure {
    IDCMBlockTextView *textView = [[self alloc] init];
    textView.configure = configure;
    textView.delegate = textView;
    textView.frame = frame;
    return textView;
}

+ (instancetype)BlockTextViewWithFrame:(CGRect)frame
                        configureBlock:(textViewConfigureBlock)configureBlock {
    IDCMBlockTextView *textView = [[self alloc] init];
    !configureBlock ?: configureBlock(textView.configure);
    textView.delegate = textView;
    textView.frame = frame;
    return textView;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return
    !self.configure.TextViewShouldBeginEditing ?:
    self.configure.TextViewShouldBeginEditing(textView);
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return
    !self.configure.TextViewShouldEndEditing ?:
    self.configure.TextViewShouldEndEditing(textView);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    !self.configure.TextViewDidBeginEditing ?:
    self.configure.TextViewDidBeginEditing(textView);
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    !self.configure.TextViewDidEndEditing ?:
    self.configure.TextViewDidEndEditing(textView);
}

- (void)textViewDidChange:(UITextView *)textView {
    !self.configure.TextViewDidChange ?:
    self.configure.TextViewDidChange(textView);
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    !self.configure.TextViewDidChangeSelection ?:
    self.configure.TextViewDidChangeSelection(textView);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
     return
    !self.configure.TextViewShouldChangeTextInRange ?:
    self.configure.TextViewShouldChangeTextInRange(textView, range, text);
}

- (IDCMBlockTextViewConfigure *)configure {
    return SW_LAZY(_configure, ({
        [[IDCMBlockTextViewConfigure alloc] init];
    }));
}

@end







