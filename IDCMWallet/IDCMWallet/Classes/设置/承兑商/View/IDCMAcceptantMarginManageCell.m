//
//  IDCMAcceptantMarginManageCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/4/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantMarginManageCell.h"

@interface IDCMAcceptantMarginManageCell ()
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoView;
/**
 *  币种标题
 */
@property (strong, nonatomic) UILabel *coinNameLabel;
/**
 *  币种副标题
 */
@property (strong, nonatomic) UILabel *coinSubNameLabel;


@end

@implementation IDCMAcceptantMarginManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.multipleSelectionBackgroundView = [[UIView alloc]init];
        self.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    
        [self configLayout];
    }
    return self;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];
    
    if (editing) {
        
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewCellReorderControl"]) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = UIImageMake(@"2.1_dragSorting");
                        [subview sizeToFit];
                    }
                }
            }
        }
    }
}

- (void)configLayout
{
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.height.equalTo(@38);
        
    }];
    [self.coinNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.logoView.mas_right).offset(10);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    [self.coinSubNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.coinNameLabel.mas_bottom).offset(1);
        make.left.equalTo(self.logoView.mas_right).offset(10);
        make.height.equalTo(@17);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
}
- (void)setMarginModel:(IDCMAcceptMarginManageModel *)marginModel
{
    _marginModel = marginModel;
    
    // logo
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:marginModel.Logo] placeholderImage:nil options:SDWebImageRefreshCached];
    // 币种名称
    self.coinSubNameLabel.text = marginModel.CoinName;
    // 币种名称简写
    self.coinNameLabel.text = [marginModel.CoinCode uppercaseString];
 
}
#pragma mark - getter
- (UILabel *)coinNameLabel{
    return SW_LAZY(_coinNameLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = textFontPingFangMediumFont(14);
        lable.textColor = textColor333333;
        lable.textAlignment = NSTextAlignmentLeft;
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
- (UILabel *)coinSubNameLabel
{
    return SW_LAZY(_coinSubNameLabel, ({
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = textFontPingFangRegularFont(12);
        lable.textAlignment = NSTextAlignmentLeft;
        lable.textColor = textColor333333;
        [self.contentView addSubview:lable];
        lable;
    }));
}
@end
