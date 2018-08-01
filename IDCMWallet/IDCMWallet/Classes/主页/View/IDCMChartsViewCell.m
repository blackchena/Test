//
//  IDCMChartsViewCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChartsViewCell.h"


@interface IDCMChartsViewCell ()
/**
 *  logo
 */
@property (strong, nonatomic) UIImageView *logoView;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  资产选项
 */
@property (strong, nonatomic) UIButton *assetButton;
/**
 *  走势选项
 */
@property (strong, nonatomic) UIButton *chartButton;
@end

@implementation IDCMChartsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        @weakify(self);
        // 点击资产按钮
        [[[self.assetButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
         subscribeNext:^(__kindof UIControl * _Nullable x) {
             @strongify(self);
             if (self.didSelectChartsBlock) {
                 self.didSelectChartsBlock(IDCMDidSelectAssets);
             }
         }];
        // 点击行情按钮
        [[[self.chartButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
         subscribeNext:^(__kindof UIControl * _Nullable x) {
             @strongify(self);
             if (self.didSelectChartsBlock) {
                 self.didSelectChartsBlock(IDCMDidSelectCharts);
             }
         }];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.height.equalTo(@38);
        
    }];
    
    [self.assetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.height.equalTo(@16);
    }];
    [self.chartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-70);
        make.width.height.equalTo(@16);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.logoView.mas_right).offset(8);
        make.height.equalTo(@20);
        make.right.equalTo(self.assetButton.mas_left).offset(-5);
    }];
}
- (void)setChartDataArr:(NSMutableArray *)dataArr withIndex:(NSInteger)index withShowType:(NSInteger)showType
{
    IDCMTrendChartModel *model = dataArr[index];
    
    if (index == 0) {
        self.logoView.image = UIImageMake(@"2.1_TotalAsset");
        self.titleLabel.text = SWLocaloziString(@"2.0_Amount");
        self.chartButton.hidden = YES;
    }else{

        self.chartButton.hidden = NO;
        // logo
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:model.logo_url] placeholderImage:nil options:SDWebImageRefreshCached];
        // 币种名称
        self.titleLabel.text = [model.currency uppercaseString];
    }
    if (model.isDefault) {
        if (showType == 0) { // 资产走势
            [self.assetButton setBackgroundImage:UIImageMake(@"2.0_xuanzhong") forState:UIControlStateNormal];
            [self.chartButton setBackgroundImage:UIImageMake(@"2.0_weixuanzhong") forState:UIControlStateNormal];
        }else{ // 行情走势
            [self.assetButton setBackgroundImage:UIImageMake(@"2.0_weixuanzhong") forState:UIControlStateNormal];
            [self.chartButton setBackgroundImage:UIImageMake(@"2.0_xuanzhong") forState:UIControlStateNormal];
        }
    }else{
        [self.assetButton setBackgroundImage:UIImageMake(@"2.0_weixuanzhong") forState:UIControlStateNormal];
        [self.chartButton setBackgroundImage:UIImageMake(@"2.0_weixuanzhong") forState:UIControlStateNormal];
    }
}

#pragma mark - getter

- (UILabel *)titleLabel{
    return SW_LAZY(_titleLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = textFontPingFangRegularFont(14);
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
- (UIButton *)assetButton
{
    return SW_LAZY(_assetButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:UIImageMake(@"2.0_weixuanzhong") forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        button;
    }));
}
- (UIButton *)chartButton
{
    return SW_LAZY(_chartButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:UIImageMake(@"2.0_weixuanzhong") forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        button;
    }));
}
@end
