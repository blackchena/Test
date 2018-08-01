//
//  IDCMChatTextView.m
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/5.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMChatTextView.h"

@interface IDCMChatTextView ()

@end

@implementation IDCMChatTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self jsq_configureTextView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self jsq_configureTextView];
}

- (void)dealloc
{
    [self jsq_removeTextViewNotificationObservers];
}


#pragma mark - Initialization

- (void)jsq_configureTextView
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    CGFloat cornerRadius = 6.0f;

    self.backgroundColor = [UIColor whiteColor];
//    self.layer.borderWidth = 0.5f;
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.layer.cornerRadius = cornerRadius;

    self.scrollIndicatorInsets = UIEdgeInsetsMake(cornerRadius, 0.0f, cornerRadius, 0.0f);

    self.textContainerInset = UIEdgeInsetsMake(4.0f, 2.0f, 4.0f, 2.0f);
    self.contentInset = UIEdgeInsetsMake(1.0f, 0.0f, 1.0f, 0.0f);

    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;

    self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textColor = [UIColor blackColor];
    self.textAlignment = NSTextAlignmentNatural;

    self.contentMode = UIViewContentModeRedraw;
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDefault;

    self.text = nil;
    
    [self jsq_addTextViewNotificationObservers];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // calculate size needed for the text to be visible without scrolling
    CGSize sizeThatFits = [self sizeThatFits:self.frame.size];
    float newHeight = sizeThatFits.height;
    
    newHeight = MIN(self.maxHeight, MAX(newHeight, self.minHeight));

    // update the height constraint
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = newHeight;
        }
    }
}

#pragma mark - UITextView overrides


- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    if (self.contentSize.height <= self.bounds.size.height + 1){
        self.contentOffset = CGPointZero; // Fix wrong contentOfset
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)jsq_addTextViewNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self];
}

- (void)jsq_removeTextViewNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:self];
}

- (void)jsq_didReceiveTextViewNotification:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

@end
