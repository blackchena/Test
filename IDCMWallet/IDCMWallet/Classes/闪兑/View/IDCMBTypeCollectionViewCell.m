//
//  BTypeCollectionViewCell.m
//  IDCMWallet
//
//  Created by wangpu on 2018/5/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBTypeCollectionViewCell.h"
#import "IDCMAcceptantCoinModel.h"
#import "IDCMLocalCurrencyModel.h"
#import "IDCMCoinListModel.h"
#import "IDCMOTCSettingModel.h"
@interface IDCMBTypeCollectionViewCell() {
    UIView * backView;
    UILabel *bType;
}
@end

@implementation IDCMBTypeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backGroundColor =[UIColor whiteColor];
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backView.backgroundColor =[UIColor whiteColor];
        backView.layer.cornerRadius = 10;
        backView.layer.borderWidth = 0.5;
        backView.layer.borderColor = [UIColor colorWithHexString:@"#E1E7F7"].CGColor;
        backView.clipsToBounds = YES;
        [self.contentView addSubview:backView];
        self.bTypeImage  = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-18, 8, 36, 36)];
        self.bTypeImage.backgroundColor = [UIColor  whiteColor];
        [backView addSubview:self.bTypeImage];
        bType = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-24, frame.size.width, 20)];
        bType.textAlignment = NSTextAlignmentCenter;
        bType.textColor = [UIColor colorWithHexString:@"#333333"];
        bType.font = SetFont(@"PingFangSC-Regular", 14);
        [backView addSubview:bType];
    }
    return self;
}

-(void)setBackGroundColor:(UIColor *)backGroundColor{
    _backGroundColor=backGroundColor;
    backView.backgroundColor = _backGroundColor;
    self.bTypeImage.backgroundColor = _backGroundColor;
    bType.textColor = [UIColor whiteColor];
}

-(void)setModel:(id) model {
    _model = model;
    NSString * urlStr = nil;
    NSString * iconName = nil;
    if ([model isKindOfClass:[IDCMOTCCionModel class]]) {
        IDCMOTCCionModel * temp = (IDCMOTCCionModel *) model;
        urlStr = temp.Logo;
        iconName = temp.dk_uppercaseLetter;
    }
    if ([model isKindOfClass:[IDCMAcceptantCoinModel class]]) {
        IDCMAcceptantCoinModel * temp = (IDCMAcceptantCoinModel *) model;
        urlStr = temp.conLogo;
        iconName = temp.coinCodeUpperString;
    }
    if ([model isKindOfClass:[IDCMOTCCurrencyModel class]]) {
        IDCMOTCCurrencyModel * temp = (IDCMOTCCurrencyModel *) model;
        urlStr = temp.Logo;
        iconName = temp.Name;
    }
    if ([model isKindOfClass:[IDCMCoinModel class]]) {//币币闪兑
        IDCMCoinModel * temp = (IDCMCoinModel *) model;
        urlStr = temp.coinUrl;
        iconName = temp.coinLabelUppercaseString;
    }
    if ([model isKindOfClass:[IDCMLocalCurrencyModel class]]) { //承兑商 法币选择
        IDCMLocalCurrencyModel * temp = (IDCMLocalCurrencyModel *) model;
        urlStr = temp.currencyLogo;
        iconName = temp.localCurrencyCodeUpperString;
    }
    [self.bTypeImage sd_setImageWithURL:[[NSURL alloc] initWithString:urlStr] placeholderImage:nil options:SDWebImageRefreshCached];
    bType.text = iconName;
    //是否选中
    if ([[model valueForKey:@"isSelect"] boolValue]) {
        self.backGroundColor = [UIColor colorWithHexString:@"#2968B9"];
    }
}
@end
