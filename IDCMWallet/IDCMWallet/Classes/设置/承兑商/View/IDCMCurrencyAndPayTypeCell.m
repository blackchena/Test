//
//  IDCMCurrencyAndPayeTypeCell.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMCurrencyAndPayTypeCell.h"
#import "IDCMAcceptVariableModel.h"

@interface IDCMCurrencyAndPayTypeCell()


@property (nonatomic,strong) UILabel * currencyNameLabel;
@property (nonatomic,strong) UIButton * deleteBtn;
@property (nonatomic,strong) UILabel * payTypeLabel;
@property (nonatomic,strong) UIImageView * payTypeImageView;
//@property (nonatomic,strong) UIView  * lineView;
@end

@implementation IDCMCurrencyAndPayTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
 
        [self.contentView addSubview:self.currencyNameLabel];
        [self.contentView addSubview:self.payTypeLabel];
        [self.contentView addSubview:self.payTypeImageView];
        [self.contentView addSubview:self.deleteBtn];
        [self setupConstraints];
         @weakify(self);
        
        [[self.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.cellCallBack) {
                self.cellCallBack();
            }
        }];
    }
    return self;
}

- (void)updateWithModel:(IDCMAcceptVariableModel *)model{
 
    self.model = model;
    if ([model.payType isEqualToString:@"AliPay"] ||[model.payType isEqualToString:@"WeChat"] ) { //支付宝
        self.currencyNameLabel.text = model.currencyName;
        self.payTypeLabel.text =  [model.payType isEqualToString:@"WeChat"] ? SWLocaloziString(@"3.0_paylist_wechat"):SWLocaloziString(@"3.0_DK_otcAlipay");
        [self.payTypeImageView sd_setImageWithURL:[NSURL URLWithString:model.currencyIconUrl] placeholderImage:nil options:SDWebImageRefreshCached];
    }
    if ([model.payType isEqualToString:@"Bankcard"]) { //银行卡
        
        self.currencyNameLabel.text = model.currencyName;
        self.payTypeLabel.text = model.payAttributes.BankName;
        [self.payTypeImageView sd_setImageWithURL:[NSURL URLWithString:model.currencyIconUrl] placeholderImage:nil options:SDWebImageRefreshCached];
    }
}

-(void)setupConstraints{
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 20));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView);
    }];
    
    [self.currencyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.264);
    }];
    
    [self.payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currencyNameLabel.mas_right);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.payTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payTypeLabel.mas_right).offset(8);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

#pragma mark - Getter

-(UILabel *)currencyNameLabel{
    if (!_currencyNameLabel) {
        _currencyNameLabel = [[UILabel alloc] init];
        _currencyNameLabel.textAlignment = NSTextAlignmentLeft;
        _currencyNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _currencyNameLabel.font = SetFont(@"PingFangSC-Regular", 12);
    }
    return _currencyNameLabel;
}

-(UILabel *)payTypeLabel{
    if (!_payTypeLabel) {
        _payTypeLabel = [[UILabel alloc] init];
        _payTypeLabel.textAlignment = NSTextAlignmentLeft;
        _payTypeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _payTypeLabel.font = SetFont(@"PingFangSC-Regular", 12);
    }
    return _payTypeLabel;
}

-(UIImageView *)payTypeImageView{
    
    if (!_payTypeImageView) {
        _payTypeImageView = [[UIImageView alloc] init];
        _payTypeImageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    return _payTypeImageView;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}
@end
