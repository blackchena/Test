//
//  IDCMFoundDAPPItemCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/22.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMFoundDAPPItemCell.h"
#import "IDCMFoundDappModel.h"

@interface IDCMFoundDAPPItemCell ()
/**
 *  背景view
 */
@property (strong, nonatomic) UIImageView *icon;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation IDCMFoundDAPPItemCell
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}


#pragma mark - Public Methods


#pragma mark - Privater Methods
- (void)initUI{
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.height.equalTo(@70);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.icon.mas_bottom).offset(8);
        make.height.equalTo(@20);
    }];
}

#pragma mark - Action
- (void)bindViewModel:(id)viewModel{
    
    IDCMDappModel *model = viewModel;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.LogoUrl] placeholderImage:UIImageMake(@"3.0_Found_ItemBg")];
    self.titleLabel.text = model.DappName;
}

#pragma mark - Getter & Setter
- (UILabel *)titleLabel
{
    return SW_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
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
