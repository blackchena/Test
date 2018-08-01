//
//  IDCMTradDetailInfoCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/30.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMTradDetailInfoCell.h"


@interface IDCMTradDetailInfoCell ()
/**
 *   标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  右侧文本
 */
@property (strong, nonatomic) UILabel *contentLabel;
/**
 *  line
 */
@property (strong, nonatomic) UIView *line;
@end


@implementation IDCMTradDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.equalTo(@(22));
        make.width.equalTo(@110);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.equalTo(@0.5);
    }];
}
- (void)setDealModel:(IDCMNewCurrencyTradingModel *)model WithRow:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            if ([model.currency isNotBlank]) {
                double txFee = [model.tx_fee doubleValue];
                if (txFee<0) {
                    txFee = fabs(txFee);
                }
                
                NSString *tx_fee = @"";
                if (model.isToken) {
                    tx_fee = [NSString stringWithFormat:@"%@ %@",[IDCMUtilsMethod separateNumberUseCommaWith:[IDCMUtilsMethod precisionControl:model.tx_fee]],[model.categoryUnit uppercaseString]];
                }else{
                    tx_fee = [NSString stringWithFormat:@"%@ %@",[IDCMUtilsMethod separateNumberUseCommaWith:[IDCMUtilsMethod precisionControl:model.tx_fee]],[model.currency uppercaseString]];
                }
                
                if ([model.tx_fee isEqualToNumber:@(0)]) {
                    tx_fee = @"--";
                }
                self.contentLabel.text = tx_fee;
            }
            self.titleLabel.text = SWLocaloziString(@"2.0_MinersCost");
        }
            break;
        case 1:
        {
            if (model) {
                NSString *blockHash = model.blockhash;
                self.contentLabel.text = blockHash;
            }
            self.titleLabel.text = SWLocaloziString(@"2.0_ConfirmBlock");
        }
            break;
        case 2:
        {
            if (model) {
                NSString *confirmations  = @"";
                if ([model.confirmations integerValue] > 1000) {
                    confirmations  = @"1,000+";
                }else{
                    confirmations  = [IDCMUtilsMethod separateNumberUseCommaWith:model.confirmations];
                }
                self.contentLabel.text = confirmations;
            }
            self.titleLabel.text = SWLocaloziString(@"2.0_ConfirmNum");
        }
            break;
        default:
        {
            if (model) {
                NSString *dateStr = [model.create_time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                self.contentLabel.text = dateStr;
            }
            self.titleLabel.text = SWLocaloziString(@"2.0_TradTime");
        }
            break;
    }
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
- (UILabel *)contentLabel
{
    return SW_LAZY(_contentLabel, ({
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Regular", 12);
        lable.textAlignment = NSTextAlignmentRight;
        lable.textColor = SetColor(51, 51, 51);
        lable.numberOfLines = 0;
        [self.contentView addSubview:lable];
        lable;
    }));
}
- (UIView *)line
{
    return SW_LAZY(_line, ({
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(221, 221, 221);
        [self.contentView addSubview:view];
        view;
    }));
}
@end
