//
//  IDCMReceiveNavBarView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/19.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMReceiveNavBarView.h"
#import <UIButton+WebCache.h>
#import "UIView+UIViewController.h"

@interface IDCMReceiveNavBarView ()
/**
 *  返回按钮
 */
@property (strong, nonatomic) UIButton *backButton;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  图标
 */
@property (strong, nonatomic) UIImageView *icon;
@end

@implementation IDCMReceiveNavBarView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self bindData];
    }
    return self;
}


#pragma mark - Public Methods
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(kSafeAreaTop+10);
        make.height.equalTo(@25);
        make.width.equalTo(@60);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(8);
        make.top.equalTo(self.mas_top).offset(kSafeAreaTop+10);
        make.height.equalTo(@25);
        make.width.lessThanOrEqualTo(@200);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.titleLabel.mas_left).offset(-8);
    }];
}

#pragma mark - Privater Methods
- (void)bindData{
    
    self.backgroundColor = UIColorWhite;
    
    self.iconSubject = [RACSubject subject];
    
    @weakify(self);
    [self.iconSubject subscribeNext:^(RACTuple *tupe) {
        @strongify(self);
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",tupe.first,SWLocaloziString(@"2.0_Address")];
        [self.icon sd_setImageWithURL:[NSURL URLWithString:tupe.second] placeholderImage:nil options:SDWebImageRefreshCached];
    }];
    
    // 返回按钮
    [[[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self.navigationController popViewControllerAnimated:YES];
     }];
}

#pragma mark - Action


#pragma mark - Getter & Setter
- (UIButton *)backButton{
    
    return SW_LAZY(_backButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"2.0_fanhuihei"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"2.0_fanhuihei"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:button];
        button;
    }));
}
- (UILabel *)titleLabel{
    
    return SW_LAZY(_titleLabel, ({
        UILabel *lable = [UILabel new];
        lable.textColor = textColor333333;
        lable.font = textFontPingFangRegularFont(16);
        lable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lable];
        lable;
    }));
}
- (UIImageView *)icon{
    
    return SW_LAZY(_icon, ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds =  YES;
        [self addSubview:view];
        view;
    }));
}
@end
