//
//  IDCMAlertWindow.m
//  IDCMWallet
//
//  Created by wangpu on 2018/3/16.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAlertWindow.h"
@interface IDCMAlertWindow (){
    
    UIButton * dimissBackView;
}

@end
@implementation IDCMAlertWindow

-(instancetype)init{
    
    self=  [super init];
    
    if (self) {
        self.frame = (CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size};
        [self setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.4]];
        self.windowLevel = UIWindowLevelNormal;
        
        [self setDimissBackView];
    }
    return self;
}

-(void)setDimissBackView{
    
    dimissBackView= [UIButton buttonWithType:UIButtonTypeCustom];
    [dimissBackView setFrame:[UIScreen mainScreen].bounds];
    [dimissBackView setBackgroundColor:[UIColor clearColor]];
    [dimissBackView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dimissBackView];
}


-(void)dismiss{
    
    [dimissBackView removeFromSuperview];
    [_contentView removeFromSuperview];
    _contentView =nil;
    self.hidden =YES;
    [self resignKeyWindow];
}

-(void)show:(UIView *)goalView{
    
    _contentView = goalView;
    [self addSubview:dimissBackView];
    [self addSubview:goalView];
    self.hidden =NO;
    [self becomeKeyWindow];
    [self makeKeyAndVisible];
}
@end
