//
//  IDCMAddCoinCell.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMAddCoinCell.h"
#import "IDCMCurrencyMarketModel.h"

@interface IDCMAddCoinCell ()

/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoView;
/**
 *  价格
 */
@property (strong, nonatomic) UILabel *coinNameLabel;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation IDCMAddCoinCell

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
        
        if ([self.reuseIdentifier isEqualToString:@"IDCMAddCoinCell"]) {
            
            for (UIControl *control in self.subviews){
                if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                    for (UIView *v in control.subviews)
                    {
                        if ([v isKindOfClass: [UIImageView class]]) {
                            UIImageView *img=(UIImageView *)v;
                            if (self.selected) {
                                img.image = UIImageMake(@"2.0_xuanzhong");
                            }else
                            {
                                img.image = UIImageMake(@"2.0_weixuanzhong");
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.reuseIdentifier isEqualToString:@"IDCMAddCoinCell"]) {
        
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews)
                {
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img=(UIImageView *)v;
                        if (self.selected) {
                            img.image = UIImageMake(@"2.0_xuanzhong");
                        }else
                        {
                            img.image = UIImageMake(@"2.0_weixuanzhong");
                        }
                    }
                }
            }
        }
    }
}
- (void)setMakketModel:(IDCMCurrencyMarketModel *)makketModel
{
    _makketModel = makketModel;
    
    // logo
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:makketModel.logo_url] placeholderImage:nil options:SDWebImageRefreshCached];
    // 币种名称简写
    self.titleLabel.text = [makketModel.currency uppercaseString];
    // 币种名称
    self.coinNameLabel.text = makketModel.currencyName;
    
}
- (void)configLayout
{
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.height.equalTo(@38);
        
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.left.equalTo(self.logoView.mas_right).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@300);
    }];
    [self.coinNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
        make.left.equalTo(self.logoView.mas_right).offset(10);
        make.height.equalTo(@17);
        make.width.equalTo(@300);
    }];
}
#pragma mark - getter

- (UILabel *)titleLabel{
    return SW_LAZY(_titleLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Medium", 14);
        lable.textColor = SetColor(51, 51, 51);
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
- (UILabel *)coinNameLabel
{
    return SW_LAZY(_coinNameLabel, ({
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Regular", 12);
        lable.textAlignment = NSTextAlignmentLeft;
        lable.textColor = SetColor(51, 51, 51);
        [self.contentView addSubview:lable];
        lable;
    }));
}

@end

