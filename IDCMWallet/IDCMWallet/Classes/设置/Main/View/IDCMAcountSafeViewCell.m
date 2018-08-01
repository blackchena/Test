//
//  IDCMAcountSafeViewCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/28.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMAcountSafeViewCell
// @abstract <#类的描述#>
// @discussion <#类的功能#>
//
#import "IDCMAcountSafeViewCell.h"

@interface IDCMAcountSafeViewCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;

@end

@implementation IDCMAcountSafeViewCell

#pragma mark - Life Cycle
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        [self initUI];
    }
    return self;
}

#pragma mark - Bind


#pragma mark - Public Methods
- (void)setAcountModel:(IDCMAcountSafeListModel *)acountModel
{
    _acountModel = acountModel;
    
    self.titleLabel.text = acountModel.title;
    self.detailLabel.text = acountModel.detailName;
    if ([acountModel.status isEqualToNumber:@(0)]) {
        self.detailLabel.textColor = textColor999999;
    }else{
        self.detailLabel.textColor = textColor666666;
    }
}

#pragma mark - Privater Methods
- (void)initUI
{
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(50);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@25);
        make.width.greaterThanOrEqualTo(@85);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@6);
        make.height.equalTo(@12);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@25);
        make.width.greaterThanOrEqualTo(@110);
        make.right.equalTo(self.arrow.mas_left).offset(-6);
    }];
    
}

#pragma mark - Action


#pragma mark - NetWork


#pragma mark - Delegate


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
        label.font = textFontPingFangRegularFont(12);
        label.textColor = textColor666666;
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
@end
