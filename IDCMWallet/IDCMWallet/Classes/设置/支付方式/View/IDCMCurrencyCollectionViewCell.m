//
//  IDCMCurrencyCollectionViewCell.m
//  IDCMWallet
//
//  Created by IDCM on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMCurrencyCollectionViewCell.h"
#import "IDCMPayMethodModel.h"

@interface IDCMCurrencyCollectionViewCell() {
    
    UIView * backView;
    UILabel *bType;
}
@end

@implementation IDCMCurrencyCollectionViewCell

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
-(void)setModel:(IDCMLocalCurrencyListItemModel *)model{
    
    [self.bTypeImage sd_setImageWithURL:[NSURL URLWithString:model.LocalCurrencyLogo] placeholderImage:nil options:SDWebImageRefreshCached];
    bType.text = model.LocalCurrencyCode;
    if (model.isSelect) {
        self.backGroundColor = [UIColor colorWithHexString:@"#2968B9"];
    }
}

@end






