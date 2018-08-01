//
//  IDCMAcceptantBondWaterCell.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantBondWaterCell.h"
#import "IDCMAcceptantBondWaterModel.h"

@interface IDCMAcceptantBondWaterCell ()

@property (nonatomic,strong) UIView *customContentView;

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel *leftTopLabel;
@property (nonatomic,strong) UILabel *leftBottomLabel;
@property (nonatomic,strong) UILabel *rightopLabel;
@property (nonatomic,strong) UILabel *rightBottomLabel;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *bottomViewLabel;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIButton *middleBtn;
@property (nonatomic,strong) UIButton *leftBtn;

@property (nonatomic,strong) IDCMAcceptantBondWaterModel * model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end


@implementation IDCMAcceptantBondWaterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initConfigure];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath
                            model:(IDCMAcceptantBondWaterModel *)model {
    IDCMAcceptantBondWaterCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass(self)
                                                                       forIndexPath:indexPath];
    cell.model = model;
    cell.indexPath = indexPath;
    return cell;
}

- (void)reloadCellData {
    [self configUI];
}

- (void)initConfigure {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = viewBackgroundColor;
    self.backgroundColor = viewBackgroundColor;
}

- (void)configUI {
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.bottomView];
    @weakify(self);
    [[self.rightBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSArray <NSString *>*orderIds = [self.model.RelateOrderId componentsSeparatedByString:@","];
        NSString *orderId = orderIds.firstObject;
        [self jumpToDetail:orderId];

    }];
    
    [[self.middleBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSArray <NSString *>*orderIds = [self.model.RelateOrderId componentsSeparatedByString:@","];
        if (orderIds.count > 1) {
            NSString *orderId = [orderIds objectAtIndex:1];
            [self jumpToDetail:orderId];
        }

    }];
    
    
    [[self.leftBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSArray <NSString *>*orderIds = [self.model.RelateOrderId componentsSeparatedByString:@","];
        if (orderIds.count > 2) {
            NSString *orderId = orderIds.lastObject;
            [self jumpToDetail:orderId];
        }

    }];
    
    if (self.model) {
        [self refreshUIWithModel];
    }
}

- (void)jumpToDetail:(NSString *)orderId{
    if (!orderId) {
        return;
    }
    NSDictionary *dict = @{@"orderId" :orderId};
    
    [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMOTCExchangeDetailController"
                                           withViewModelName:@"IDCMOTCExchangeDetailViewModel"
                                                  withParams:dict
                                                    animated:YES];
}

- (void)refreshUIWithModel{
    self.leftBottomLabel.text = self.model.CreateTime;
    
    NSString *rightopSymbol = self.model.PaymentType.integerValue == 1 ? @"+" : @"";

    
    NSString *ChangeBalance = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:self.model.ChangeBalance]] fractionDigits:8];
    ChangeBalance = [IDCMUtilsMethod changeFloat:ChangeBalance];
    NSString *ChangeBalanceStr = [IDCMUtilsMethod separateNumberUseCommaWith:ChangeBalance];
    
    self.rightopLabel.text = [NSString stringWithFormat:@"%@%@ %@",rightopSymbol,ChangeBalanceStr,self.model.CoinCode.uppercaseString];// @"+ 23.23432 BTC";
    
    NSString *Balance = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:[IDCMUtilsMethod precisionControl:self.model.Balance]] fractionDigits:4];
    NSString *BalanceStr = [IDCMUtilsMethod separateNumberUseCommaWith:Balance];
    self.rightBottomLabel.text = [NSString stringWithFormat:@"%@: %@%@",SWLocaloziString(@"3.0_AcceptantBalance"),BalanceStr,self.model.CoinCode.uppercaseString];
    self.bottomViewLabel.text = SWLocaloziString(@"3.0_Acceptant_order_relation");

    self.rightBtn.hidden = YES;
    self.leftBtn.hidden = YES;
    self.middleBtn.hidden = YES;
    
    NSArray <NSString *>*orders = [self.model.RelateOrderNo componentsSeparatedByString:@","];
    if (orders.count == 3) {
        NSString *order1 = orders.firstObject.length > 3 ?
        [NSString stringWithFormat:@"...%@",[orders.firstObject substringFromIndex:orders.firstObject.length - 3]] :
        orders.firstObject;
        [self.rightBtn setTitle:order1 forState:UIControlStateNormal];
        self.rightBtn.hidden = NO;
        
        NSString *order2 = orders[1].length > 3 ?
        [NSString stringWithFormat:@"...%@",[orders[1] substringFromIndex:orders[1].length - 3]] :
        orders[1];
        [self.middleBtn setTitle:order2 forState:UIControlStateNormal];
        self.middleBtn.hidden = NO;
        
        NSString *order3 = orders.lastObject.length > 3 ? [NSString stringWithFormat:@"...%@",[orders.lastObject substringFromIndex:orders.lastObject.length - 3]] : orders.lastObject;
        [self.leftBtn setTitle:order3 forState:UIControlStateNormal];
        self.leftBtn.hidden = NO;

    }
    else if (orders.count == 2) {
        NSString *order1 = orders.firstObject.length > 3 ?
        [NSString stringWithFormat:@"...%@",[orders.firstObject substringFromIndex:orders.firstObject.length - 3]] :
        orders.firstObject ;
        [self.rightBtn setTitle:order1 forState:UIControlStateNormal];
        self.rightBtn.hidden = NO;

        NSString *order2 = orders.lastObject.length > 3 ? [NSString stringWithFormat:@"...%@",[orders.lastObject substringFromIndex:orders.lastObject.length - 3]] : orders.lastObject;
        [self.leftBtn setTitle:order2 forState:UIControlStateNormal];
        self.leftBtn.hidden = NO;
    }
    else if(orders.count == 1){
        NSString *order = self.model.RelateOrderNo.length > 3 ?
        [NSString stringWithFormat:@"...%@",[self.model.RelateOrderNo substringFromIndex:self.model.RelateOrderNo.length - 3]] : self.model.RelateOrderNo;
        [self.rightBtn setTitle:order forState:UIControlStateNormal];
        self.rightBtn.hidden = NO;
    }
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.model.BookTypeLogo]];
    
    NSString *typeString = self.model.BookTypeCode;
    NSString *typeKey = [NSString stringWithFormat:@"3.0_Acceptantcell_type_%@",typeString];
    self.leftTopLabel.text = SWLocaloziString(typeKey) ?: self.model.Remark;

    UIColor *rightopLabelColor = self.model.PaymentType.integerValue == 1 ? SetColor(255, 99, 72) : SetColor(31, 199, 58);
    self.rightopLabel.textColor = rightopLabelColor;
    
    if ([self.model.BookTypeCode isEqualToString:@"In"] || [self.model.BookTypeCode isEqualToString:@"Out"]) {
        self.bottomView.hidden = YES;
    }
    else{
        self.bottomView.hidden = NO;
    }
}

+ (CGFloat)heightForCell:(IDCMAcceptantBondWaterModel *)model{
    if ([model.BookTypeCode isEqualToString:@"In"] || [model.BookTypeCode isEqualToString:@"Out"]) {
        return 68;
    }
    else{
        return 89;
    }
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 63);

        [_topView addSubview:self.leftImageView];
        [_topView addSubview:self.leftTopLabel];
        [_topView addSubview:self.leftBottomLabel];
        [_topView addSubview:self.rightopLabel];
        [_topView addSubview:self.rightBottomLabel];
    }
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.frame = CGRectMake(0, 51, SCREEN_WIDTH, 33);
        [_bottomView addSubview:self.bottomViewLabel];
        [_bottomView addSubview:self.rightBtn];
        [_bottomView addSubview:self.middleBtn];
        [_bottomView addSubview:self.leftBtn];
    }
    return _bottomView;
}

- (UIImageView *)leftImageView {
    return SW_LAZY(_leftImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:@""];
        imageView.size = CGSizeMake(34, 34);
        imageView.left = 12;
        imageView.top = 14;
        imageView;
    }));
}

- (UILabel *)leftTopLabel {
    return SW_LAZY(_leftTopLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(14);
        label.height = 20;
        label.width = (SCREEN_WIDTH - 46) / 2;
        label.top = 12;
        label.left = self.leftImageView.right + 10;
        label;
    }));
}

- (UILabel *)leftBottomLabel {
    return SW_LAZY(_leftBottomLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(12);
        label.height = 17;
        label.width = self.leftTopLabel.width;
        label.left = self.leftTopLabel.left;
        label.top = self.leftTopLabel.bottom + 3;
        label;
    }));
}

- (UILabel *)rightopLabel {
    return SW_LAZY(_rightopLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"#FF6348"];
        label.font = textFontPingFangRegularFont(14);
        label.textAlignment = NSTextAlignmentRight;
        label.height = 20;
        label.width = self.leftTopLabel.width - 30;
        label.right = (SCREEN_WIDTH - 12);
        label.centerY = self.leftTopLabel.centerY;
        label;
    }));
}

- (UILabel *)rightBottomLabel {
    return SW_LAZY(_rightBottomLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.height = 17;
        label.width = self.leftTopLabel.width - 30;
        label.right = (SCREEN_WIDTH - 12);
        label.centerY = self.leftBottomLabel.centerY;
        label;
    }));
}

- (UILabel *)bottomViewLabel {
    return SW_LAZY(_bottomViewLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor999999;
        label.font = textFontPingFangRegularFont(12);
        label.height = 17;
        label.width = 200;
        label.left = self.leftTopLabel.left;
        label.top = 5;
        label;
    }));
}

- (UIButton *)rightBtn {
    return SW_LAZY(_rightBtn, ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.hidden = YES;
        btn.titleLabel.font = textFontPingFangRegularFont(12);
        [btn setTitleColor:[UIColor colorWithHexString:@"#2968B9"] forState:UIControlStateNormal];
        btn.size = CGSizeMake(52, 20);
        btn.right = self.rightBottomLabel.right;
        btn.centerY = self.bottomViewLabel.centerY;
        btn.layer.cornerRadius = 2.0;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#2968B9"].CGColor;
        btn.layer.borderWidth = .5;
        btn.layer.masksToBounds = YES;
        btn;
    }));
}

- (UIButton *)leftBtn {
    return SW_LAZY(_leftBtn, ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.hidden = YES;
        btn.titleLabel.font = textFontPingFangRegularFont(12);
        [btn setTitleColor:[UIColor colorWithHexString:@"#2968B9"] forState:UIControlStateNormal];
        btn.size = CGSizeMake(52, 20);
        btn.right = self.middleBtn.left - 12;
        btn.centerY = self.bottomViewLabel.centerY;
        btn.layer.cornerRadius = 2.0;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#2968B9"].CGColor;
        btn.layer.borderWidth = .5;
        btn.layer.masksToBounds = YES;
        btn;
    }));
}

- (UIButton *)middleBtn {
    return SW_LAZY(_middleBtn, ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.hidden = YES;
        btn.titleLabel.font = textFontPingFangRegularFont(12);
        [btn setTitleColor:[UIColor colorWithHexString:@"#2968B9"] forState:UIControlStateNormal];
        btn.size = CGSizeMake(52, 20);
        btn.right = self.rightBtn.left - 12;
        btn.centerY = self.bottomViewLabel.centerY;
        btn.layer.cornerRadius = 2.0;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#2968B9"].CGColor;
        btn.layer.borderWidth = .5;
        btn.layer.masksToBounds = YES;
        btn;
    }));
}

@end





