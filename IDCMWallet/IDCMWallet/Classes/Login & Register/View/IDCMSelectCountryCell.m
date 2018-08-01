//
//  IDCMSelectCountryCell.m
//  IDCMExchange
//
//  Created by BinBear on 2017/12/6.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMSelectCountryCell.h"
#import "IDCMCountryListModel.h"


@interface IDCMSelectCountryCell ()
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  时间
 */
@property (strong, nonatomic) UILabel *codeLabel;
/**
 *  线
 */
@property (strong, nonatomic) UIView *lineView;
@end

@implementation IDCMSelectCountryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(IDCMCountryListModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.Name;
    self.codeLabel.text = model.Areacode;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@25);
        make.right.equalTo(self.contentView.mas_right).offset(-50);
    }];

    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@25);
        make.width.equalTo(@(SCREEN_WIDTH*0.5-15));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@1);
        
    }];
}

#pragma mark - getter
- (UILabel *)titleLabel{
    return SW_LAZY(_titleLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Medium", 16);
        lable.textColor = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:lable];
        lable;
    }));
}
- (UILabel *)codeLabel
{
    return SW_LAZY(_codeLabel,({
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Regular", 16);
        lable.textAlignment = NSTextAlignmentRight;
        lable.textColor = [UIColor grayColor];
        [self.contentView addSubview:lable];
        lable;
    }));
}
- (UIView *)lineView
{
    return SW_LAZY(_lineView, ({
        UIView *view = [UIView new];
        view.backgroundColor = KLineColor;
        [self.contentView addSubview:view];
        view;
    }));
}
@end
