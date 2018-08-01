//
//  IDCMTradDetailDescriptionViewCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/30.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMTradDetailDescriptionViewCell.h"

@interface IDCMTradDetailDescriptionViewCell ()



@end

@implementation IDCMTradDetailDescriptionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.equalTo(@(22));
        make.width.equalTo(@125);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];

}
- (void)setModel:(IDCMNewCurrencyTradingModel *)model
{
    _model = model;
    
    self.textView.text = model.remark;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"2.0_Describe", nil),NSLocalizedString(@"2.1_Editable", nil)];
    [self configAttitues:self.titleLabel withRange:NSMakeRange(NSLocalizedString(@"2.0_Describe", nil).length+1, NSLocalizedString(@"2.1_Editable", nil).length)];
}
- (void)configAttitues:(UILabel *)label withRange:(NSRange)range
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:SetColor(153, 153, 153) range:range];
    [attrStr addAttribute:NSFontAttributeName value:SetFont(@"PingFang-SC-Regular",10) range:range];
    label.attributedText = attrStr;
}
#pragma mark - getter
- (UILabel *)titleLabel
{
    return SW_LAZY(_titleLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Regular", 12);
        lable.textAlignment = NSTextAlignmentLeft;
        lable.textColor = SetColor(102, 102, 102);
        [self.contentView addSubview:lable];
        lable;
    }));
}
- (QMUITextView *)textView
{
    return SW_LAZY(_textView, ({
        QMUITextView *textField = [[QMUITextView alloc] init];
        textField.textAlignment = NSTextAlignmentRight;
        textField.maximumTextLength = 50;
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = SWLocaloziString(@"2.0_LeaveDes");
        textField.font = SetFont(@"PingFang-SC-Regular", 12);
        textField.textColor = SetColor(51, 51, 51);
        textField.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.contentView addSubview:textField];
        textField;
    }));
}

@end
