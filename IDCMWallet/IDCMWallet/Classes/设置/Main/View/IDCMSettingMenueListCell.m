//
//  IDCMSettingMenueListCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSettingMenueListCell.h"

@implementation IDCMSettingMenueListCell

#pragma mark - Life Cycle
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}


#pragma mark - Public Methods
-(void)setModel:(IDCMSettingListModel *)model
{
    _model = model;
    if ([model.imageName hasPrefix:@"http"] || [model.imageName hasPrefix:@"https"]) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:model.imageName]];
    }else{
        self.icon.image = UIImageMake(model.imageName);
    }
    self.titleLabel.text = [NSString idcw_stringWithFormat:@"%@",model.title];
    self.detailLabel.text = [NSString idcw_stringWithFormat:@"%@",model.detailTitle];
}

#pragma mark - Privater Methods
- (void)createUI
{
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@22);
        make.width.greaterThanOrEqualTo(@100);
        make.left.equalTo(self.icon.mas_right).offset(10);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.titleLabel.mas_left);
    }];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@6);
        make.height.equalTo(@12);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@22);
        make.width.greaterThanOrEqualTo(@100);
        make.right.equalTo(self.arrow.mas_left).offset(-6);
    }];
}
#pragma mark - Getter & Setter
- (UIView *)line
{
    return SW_LAZY(_line, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(221, 221, 221);
        [self.contentView addSubview:view];
        view;
    }));
}
- (UILabel *)titleLabel
{
    return SW_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UILabel *)detailLabel
{
    return SW_LAZY(_detailLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor999999;
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UIImageView *)arrow
{
    return SW_LAZY(_arrow,({
        UIImageView *arrow = [UIImageView new];
        arrow.image = UIImageMake(@"2.2.3_Arrow");
        arrow.contentMode = UIViewContentModeScaleAspectFill;
        arrow.clipsToBounds = YES;
        [self.contentView addSubview:arrow];
        arrow;
    }));
}
- (UIImageView *)icon
{
    return SW_LAZY(_icon,({
        UIImageView *arrow = [UIImageView new];
        arrow.contentMode = UIViewContentModeScaleAspectFill;
//        arrow.clipsToBounds = YES;
        [self.contentView addSubview:arrow];
        arrow;
    }));
}
@end
