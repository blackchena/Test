//
//  IDCMTextField.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMTextField.h"

@implementation IDCMTextField

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
    CGRect inset = CGRectMake(0, 13, bounds.size.width, 22);
    return inset;
}

@end
