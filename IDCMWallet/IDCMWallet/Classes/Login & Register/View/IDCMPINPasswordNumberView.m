//
//  IDCMPINPasswordNumberView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/16.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPINPasswordNumberView.h"

#define ButtonTag   110

@interface IDCMPINPasswordNumberView ()
/**
 *  数字1到9的容器view
 */
@property (strong, nonatomic) UIView *containerView;
/**
 *  数字0
 */
@property (strong, nonatomic) UIButton *zeroButton;
/**
 *  删除按钮
 */
@property (strong, nonatomic) UIButton *deleteButton;
/**
 *  button数组
 */
@property (strong, nonatomic) NSMutableArray *buttonArr;
@end

@implementation IDCMPINPasswordNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self distributeFixedView];
        [self touchUpButton];
    }
    return self;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat space = SCREEN_WIDTH*40/375;
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@180);
    }];
    
    [self.containerView.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0
                                                            fixedLineSpacing:0 fixedInteritemSpacing:0
                                                                   warpCount:3
                                                                  topSpacing:0 bottomSpacing:0 leadSpacing:space tailSpacing:space];
    
    CGFloat buttonWidth = (SCREEN_WIDTH-space*2)/3 ;
    [self.zeroButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(60);
        make.top.equalTo(self.containerView.mas_bottom);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-space);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(60);
        make.top.equalTo(self.containerView.mas_bottom);
    }];
}
// 创建数字1到9的按钮
- (void)distributeFixedView
{
    
    for (NSInteger i = 1; i < 10; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+ButtonTag;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = textFontHelveticaMediumFont(24);
        [button setTitle:[NSString stringWithFormat:@"%ld",(long)i] forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [button setTitleColor:UIColorWhite forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:kThemeColor size:CGSizeMake(50, 50)] forState:UIControlStateHighlighted];
        [self.buttonArr addObject:button];
        [self.containerView addSubview:button];
    }
    
    [self.buttonArr addObject:self.zeroButton];
    [self.buttonArr addObject:self.deleteButton];
    
}

- (void)touchUpButton
{
    for (UIButton *button in  self.buttonArr) {
        @weakify(self);
        @weakify(button);
        [[button rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(UIButton * x) {
            @strongify(self);
            @strongify(button);
            if (button.tag == 10000) {
                if (self.PINNumberBlock) {
                    self.PINNumberBlock(ButtonTag, IDCMPINNumberDelete);
                }
            }else{
                if (self.PINNumberBlock) {
                    self.PINNumberBlock(button.tag-ButtonTag, IDCMPINNumberAdd);
                }
            }
            
            for (UIButton *onebtn in self.buttonArr) {
                if(onebtn != button){
                    onebtn.enabled = NO;
                }
            }
        }];
        
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel] subscribeNext:^(UIButton * x) {
            @strongify(self);;
            for (UIButton *onebtn in self.buttonArr) {
                onebtn.enabled = YES;
            }
        }];
    }
}
#pragma mark - getter
- (UIView *)containerView
{
    return SW_LAZY(_containerView, ({
        UIView *view = [UIView new];
        [self addSubview:view];
        view;
    }));
}
- (UIButton *)zeroButton
{
    return SW_LAZY(_zeroButton, ({ 
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.tag = ButtonTag;
        button.titleLabel.font = textFontHelveticaMediumFont(24);
        [button setTitle:@"0" forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [button setTitleColor:UIColorWhite forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:kThemeColor size:CGSizeMake(50, 50)] forState:UIControlStateHighlighted];
        [self addSubview:button];
        button;
    }));
}
- (UIButton *)deleteButton
{
    return SW_LAZY(_deleteButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.tag = 10000;
        [button setImage:UIImageMake(@"2.2.1_PINDeleteHighlight") forState:UIControlStateHighlighted];
        [button setImage:UIImageMake(@"2.2.1_PINDeleteNormal") forState:UIControlStateNormal];
        [button setImage:UIImageMake(@"2.2.1_PINDeleteNormal") forState:UIControlStateDisabled];
        [button setBackgroundImage:[UIImage imageWithColor:kThemeColor size:CGSizeMake(50, 50)] forState:UIControlStateHighlighted];
        [self addSubview:button];
        button;
    }));
}
- (NSMutableArray *)buttonArr
{
    return SW_LAZY(_buttonArr, @[].mutableCopy);
}
@end
