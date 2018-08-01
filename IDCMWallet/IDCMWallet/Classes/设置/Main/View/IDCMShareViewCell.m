//
//  IDCMShareViewCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/2.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMShareViewCell.h"

@interface IDCMShareViewCell ()
/**
 *  背景view
 */
@property (strong, nonatomic) UIImageView *icon;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation IDCMShareViewCell
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}
#pragma mark - Privater Methods
- (void)initUI{
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.height.equalTo(@40);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.icon.mas_bottom).offset(8);
        make.height.equalTo(@20);
    }];
}

#pragma mark - Action
- (void)bindViewModel:(id)viewModel{
    
    RACTuple *tupe = viewModel;
    
    if ([tupe.first isKindOfClass:[UIImage class]]) {
        self.icon.image = tupe.first;
    }else if ([tupe.first isKindOfClass:[NSString class]]){
        if ([tupe.first hasSuffix:@"http"] || [tupe.first hasSuffix:@"https"]) {
            [self.icon sd_setImageWithURL:tupe.first];
        }else{
            self.icon.image = UIImageMake(tupe.first);
        }
    }else{
        DDLogDebug(@"图片类型❌");
    }
    
    if ([tupe.second isKindOfClass:[NSString class]]) {
        self.titleLabel.text = tupe.second;
    }else{
        DDLogDebug(@"标题类型❌");
    }
}

#pragma mark - Getter & Setter
- (UILabel *)titleLabel
{
    return SW_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    }));
}
- (UIImageView *)icon
{
    return SW_LAZY(_icon,({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        view.userInteractionEnabled = YES;
        view;
    }));
}
@end
