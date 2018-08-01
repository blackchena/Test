//
//  IDCMChartsHeaderView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChartsHeaderView.h"

@interface IDCMChartsHeaderView ()
/**
 *  默认标题
 */
@property (strong, nonatomic) UILabel *defaultLabel;
/**
 *  资产标题
 */
@property (strong, nonatomic) UILabel *assetLabel;
/**
 *  价格标题
 */
@property (strong, nonatomic) UILabel *priceLabel;
@end

@implementation IDCMChartsHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = viewBackgroundColor;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    [self.assetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-100);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_right);
    }];
}
#pragma mark - getter
- (UILabel *)defaultLabel
{
    return SW_LAZY(_defaultLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = textFontPingFangRegularFont(12);
        lable.textColor = textColor666666;
        lable.textAlignment = NSTextAlignmentLeft;
        lable.text = SWLocaloziString(@"2.1_DefaulView");
        [self addSubview:lable];
        lable;
    }));
}
- (UILabel *)assetLabel
{
    return SW_LAZY(_assetLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = textFontPingFangRegularFont(12);
        lable.textColor = textColor666666;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = SWLocaloziString(@"2.1_Asset");
        [self addSubview:lable];
        lable;
    }));
}
- (UILabel *)priceLabel
{
    return SW_LAZY(_priceLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = textFontPingFangRegularFont(12);
        lable.textColor = textColor666666;
        lable.textAlignment = NSTextAlignmentLeft;
        lable.text = SWLocaloziString(@"2.1_Price");
        [self addSubview:lable];
        lable;
    }));
}
@end
