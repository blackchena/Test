//
//  IDCMTradDetailView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/25.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMTradDetailView.h"


@interface IDCMTradDetailView ()


@end

@implementation IDCMTradDetailView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.feeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@43);
    }];
    [self.blockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feeView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@58);
    }];
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blockView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@43);
    }];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@43);
    }];
    [self.descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@73);
    }];
    
    [self configAttitues:self.descriptionView.textTitleLabel withRange:NSMakeRange(NSLocalizedString(@"2.0_Describe", nil).length+1, NSLocalizedString(@"2.1_Editable", nil).length)];
}
- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    
    self.feeView.contentLabel.text = dataArr[0];
    self.blockView.contentLabel.text = dataArr[1];
    self.confirmView.contentLabel.text = dataArr[2];
    self.timeView.contentLabel.text = dataArr[3];
    self.descriptionView.textField.text = dataArr[4];
}
- (void)configAttitues:(UILabel *)label withRange:(NSRange)range
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:SetColor(153, 153, 153) range:range];
    [attrStr addAttribute:NSFontAttributeName value:SetFont(@"PingFang-SC-Regular",10) range:range];
    label.attributedText = attrStr;
}
#pragma mark - getter
- (IDCMTradDetailInfoView *)feeView
{
    return SW_LAZY(_feeView, ({
        IDCMTradDetailInfoView *view = [IDCMTradDetailInfoView new];
        view.titleLabel.text = NSLocalizedString(@"2.0_MinersCost", nil);
        view.textField.hidden = YES;
        view.textTitleLabel.hidden = YES;
        [self addSubview:view];
        view;
    }));
}
- (IDCMTradDetailInfoView *)blockView
{
    return SW_LAZY(_blockView, ({
        IDCMTradDetailInfoView *view = [IDCMTradDetailInfoView new];
        view.titleLabel.text = NSLocalizedString(@"2.0_ConfirmBlock", nil);
        view.textField.hidden = YES;
        view.textTitleLabel.hidden = YES;
        [self addSubview:view];
        view;
    }));
}
- (IDCMTradDetailInfoView *)confirmView
{
    return SW_LAZY(_confirmView, ({
        IDCMTradDetailInfoView *view = [IDCMTradDetailInfoView new];
        view.titleLabel.text = NSLocalizedString(@"2.0_ConfirmNum", nil);
        view.textField.hidden = YES;
        view.textTitleLabel.hidden = YES;
        [self addSubview:view];
        view;
    }));
}
- (IDCMTradDetailInfoView *)timeView
{
    return SW_LAZY(_timeView, ({
        IDCMTradDetailInfoView *view = [IDCMTradDetailInfoView new];
        view.titleLabel.text = NSLocalizedString(@"2.0_TradTime", nil);
        view.textField.hidden = YES;
        view.textTitleLabel.hidden = YES;
        [self addSubview:view];
        view;
    }));
}
- (IDCMTradDetailInfoView *)descriptionView
{
    return SW_LAZY(_descriptionView, ({
        IDCMTradDetailInfoView *view = [IDCMTradDetailInfoView new];
        view.lineView.hidden = YES;
        view.contentLabel.hidden = YES;
        view.textField.placeholder = SWLocaloziString(@"2.0_LeaveDes");
        view.textTitleLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"2.0_Describe", nil),NSLocalizedString(@"2.1_Editable", nil)];
        [self addSubview:view];
        view;
    }));
}
@end
