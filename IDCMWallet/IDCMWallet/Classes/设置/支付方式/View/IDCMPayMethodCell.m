//
//  IDCMPayMethodCell.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPayMethodCell.h"
@implementation IDCMDeleteCellBtn
- (void)layoutSubviews {
    [super layoutSubviews];

    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.frame = CGRectMake(0, 0, self.width, self.height);
    self.imageView.clipsToBounds = NO;
    self.clipsToBounds = NO;
    self.titleLabel.height = 20;
    self.titleLabel.width = self.width;
    self.titleLabel.left = 0;
    self.titleLabel.centerY = self.imageView.top + self.imageView.height / 2  ;
}
@end



@interface IDCMPayMethodCell () 
@property (nonatomic,strong) UIView *customContentView;
@property (nonatomic,strong) UIImageView *contentImageView;
@property (nonatomic,strong) UILabel *methodCountryLabel;
@property (nonatomic,strong) UIImageView *methodIconImageView;
@property (nonatomic,strong) UILabel *methodNameLabel;
@property (nonatomic,strong) UILabel *methodAcountLabel;

@property (nonatomic,strong) IDCMPaymentListModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end


@implementation IDCMPayMethodCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initConfigure];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath
                            model:(IDCMPaymentListModel *)model {
    IDCMPayMethodCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass(self)
                                                          forIndexPath:indexPath];
    cell.model = model;
    cell.indexPath = indexPath;
    return cell;
}

- (void)reloadCellData {
    if ([self.model.PayTypeCode isEqualToString:@"AliPay"]) {
        self.contentImageView.image = UIImageMake(@"3.2_pay_list_ali_Back");
        self.methodIconImageView.image = UIImageMake(@"3.2_pay_ali_cycle");
        self.methodNameLabel.text = NSLocalizedString(@"3.0_paylist_ali", nil);
        self.methodAcountLabel.text = self.model.PayAttributes.AccountNo;
    }
    else if ([self.model.PayTypeCode isEqualToString:@"WeChat"]) {
        self.contentImageView.image = UIImageMake(@"3.2_pay_list_wechat_Back");
        self.methodIconImageView.image = UIImageMake(@"3.2_pay_wechat_cycle");
        self.methodNameLabel.text = NSLocalizedString(@"3.0_paylist_wechat", nil);
        self.methodAcountLabel.text = self.model.PayAttributes.AccountNo;
    }
    else{
        self.contentImageView.image = UIImageMake(@"3.2_pay_list_bank_Back");
        self.methodIconImageView.image = UIImageMake(@"3.2_pay_bank_cycle");
        self.methodNameLabel.text = self.model.PayAttributes.BankName;
        self.methodAcountLabel.text = self.model.PayAttributes.BankNoHide;
    }
    self.methodCountryLabel.text = self.model.LocalCurrencyCode;
}

- (void)initConfigure {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = viewBackgroundColor;
    [self.contentView addSubview:self.customContentView];
}

- (UIView *)customContentView {
    if (!_customContentView) {
        _customContentView = [[UIView alloc] init];
        _customContentView.backgroundColor = viewBackgroundColor;
        _customContentView.frame = CGRectMake(12, 0, SCREEN_WIDTH - 24, 86);
        _customContentView.layer.cornerRadius = 4.0;
        _customContentView.layer.masksToBounds = YES;
        
        [_customContentView addSubview:self.contentImageView];
        [_customContentView addSubview:self.methodCountryLabel];
        [_customContentView addSubview:self.methodIconImageView];
        [_customContentView addSubview:self.methodNameLabel];
        [_customContentView addSubview:self.methodAcountLabel];

    }
    return _customContentView;
}

- (UIImageView *)contentImageView {
    return SW_LAZY(_contentImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:@""];
        imageView.frame = _customContentView.bounds;
        imageView;
    }));
}

- (UILabel *)methodCountryLabel {
    return SW_LAZY(_methodCountryLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorWhite;
        label.font = textFontPingFangRegularFont(12);
        label.text = @"CNY";
        label.height = 17;
        label.width = 26;
        label.top = 18;
        label.left = 14;
        label;
    }));
}

- (UIImageView *)methodIconImageView {
    return SW_LAZY(_methodIconImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:@""];
        imageView.size = CGSizeMake(28.5, 28.5);
        imageView.centerY = self.methodCountryLabel.centerY;
        imageView.left = self.methodCountryLabel.right + 14;
        imageView;
    }));
}

- (UILabel *)methodNameLabel {
    return SW_LAZY(_methodNameLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorWhite;
        label.font = textFontPingFangRegularFont(14);
        label.height = 20;
        label.width =  140;//_customContentView.width - self.methodIconImageView.right - 14 - 12;
        label.left = self.methodIconImageView.right + 14;
        label.centerY = self.methodIconImageView.centerY;
        label;
    }));
}

- (UILabel *)methodAcountLabel {
    return SW_LAZY(_methodAcountLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorWhite;
        label.font = textFontPingFangRegularFont(12);
        label.height = 27;
        label.width = 200;
        label.left = self.methodNameLabel.left;
        label.top = self.methodNameLabel.bottom + 6;
        label;
    }));
}

@end



