//
//  IDCMDebugServerViewCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMDebugServerViewCell.h"

@interface IDCMDebugServerViewCell ()
/**
 *  图标
 */
@property (strong, nonatomic) UIImageView *icon;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  选中的icon
 */
@property (strong, nonatomic) UIImageView *selectIcon;
/**
 *  line
 */
@property (strong, nonatomic) UIView *line;
@end

@implementation IDCMDebugServerViewCell

#pragma mark - Life Cycle
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    return self;
}
#pragma mark - Privater Methods
- (void)initUI{
    
//    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.left.equalTo(self.contentView.mas_left).offset(15);
//        make.width.equalTo(@22);
//        make.height.equalTo(@14);
//    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.greaterThanOrEqualTo(@50);
        make.height.equalTo(@20);
    }];
    [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.height.equalTo(@14);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - Action
- (void)bindViewModel:(id)viewModel{
    
    RACTuple *tupe = viewModel;
    
    self.titleLabel.text = tupe.first;
    self.selectIcon.image = UIImageMake(tupe.second);
}

#pragma mark - Getter & Setter
- (UILabel *)titleLabel
{
    return SW_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UIImageView *)icon
{
    return SW_LAZY(_icon,({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:view];
        view;
    }));
}
- (UIImageView *)selectIcon{
    
    return SW_LAZY(_selectIcon,({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:view];
        view;
    }));
}
- (UIView *)line
{
    return SW_LAZY(_line, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(244, 244, 244);
        [self.contentView addSubview:view];
        view;
    }));
}
@end
