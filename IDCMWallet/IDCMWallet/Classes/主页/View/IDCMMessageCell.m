//
//  IDCMMessageCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/31.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMMessageCell.h"

@interface IDCMMessageCell ()
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoView;
/**
 *  副标题
 */
@property (strong, nonatomic) UILabel *subTitleLabel;
/**
 *  时间
 */
@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation IDCMMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.height.equalTo(@46);
        
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.left.equalTo(self.logoView.mas_right).offset(10);
        make.right.equalTo(self.timeLabel.mas_left).offset(-10);
        make.height.equalTo(@20);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.left.equalTo(self.logoView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.height.equalTo(@17);
    }];
}
- (void)setNewsModel:(IDCMNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    self.titleLabel.text = newsModel.msgTitle;
    self.subTitleLabel.text = newsModel.secondaryTitle;
    self.timeLabel.text = newsModel.customerTime;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:newsModel.logo] placeholderImage:nil options:SDWebImageRefreshCached];
}
#pragma mark - getter
- (UILabel *)titleLabel
{
    return SW_LAZY(_titleLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = textFontPingFangRegularFont(14);
        lable.textColor = textColor333333;
        lable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:lable];
        lable;
    }));
}
- (UILabel *)subTitleLabel
{
    return SW_LAZY(_subTitleLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = textFontPingFangRegularFont(12);
        lable.textColor = textColor666666;
        lable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:lable];
        lable;
    }));
}
- (UILabel *)timeLabel
{
    return SW_LAZY(_timeLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = textFontHelveticaLightFont(12);
        lable.textColor = textColor999999;
        lable.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:lable];
        lable;
    }));
}
- (UIImageView *)logoView
{
    return SW_LAZY(_logoView, ({
        
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        view;
    }));
}
@end
