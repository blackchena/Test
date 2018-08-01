//
//  IDCMOfferTextField.m
//  IDCMWallet
//
//  Created by BinBear on 2018/6/13.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOfferTextField.h"

@implementation IDCMOfferTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpUI];
}
- (void)setUpUI
{
    
    UIButton *passwordBtn = [self valueForKey:@"_clearButton"];
    // 修改按钮图片
    [passwordBtn setImage:[UIImage imageNamed:@"2.1_clearButton"] forState:UIControlStateNormal];
    
    
}
//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(0, 3, bounds.size.width, 22);
    return inset;
}

@end
