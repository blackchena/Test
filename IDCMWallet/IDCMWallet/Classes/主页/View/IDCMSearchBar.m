//
//  IDCMSearchBar.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/27.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSearchBar.h"

@interface IDCMSearchBar()<UITextFieldDelegate>

// placeholder 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;
@end

// icon宽度
static CGFloat const searchIconW = 20.0;
// icon与placeholder间距
static CGFloat const iconSpacing = 10.0;


@implementation IDCMSearchBar

- (instancetype)init
{
    if (self = [super init]) {

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    for (UIView *view in [self.subviews lastObject].subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;

            // 设置searchField上的搜索图标
            UIImageView *iView = [[UIImageView alloc] initWithImage:UIImageMake(@"2.1_sousuo")];
            iView.frame = CGRectMake(0, 0, 16, 16);
            field.leftView = iView;
            
            // 设置占位文字字体颜色
            [field setValue:SetColor(153, 153, 153) forKeyPath:@"_placeholderLabel.textColor"];
            [field setValue:textFontPingFangRegularFont(15) forKeyPath:@"_placeholderLabel.font"];
            
            if (@available(iOS 11.0, *)) {
                // 先默认居中placeholder
                [self setPositionAdjustment:UIOffsetMake((field.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
            }
        }
    }
}

// 开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 继续传递代理方法
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}
// 结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [self.delegate searchBarShouldEndEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}

// 计算placeholder、icon、icon和placeholder间距的总宽度
- (CGFloat)placeholderWidth {
    if (!_placeholderWidth) {
        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFontPingFangRegularFont(15)} context:nil].size;
        _placeholderWidth = size.width + iconSpacing + searchIconW;
    }
    return _placeholderWidth;
}

@end
