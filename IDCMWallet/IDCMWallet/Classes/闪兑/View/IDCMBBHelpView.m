//
//  IDCMBBHelpView.m
//  IDCMWallet
//
//  Created by wangpu on 2018/3/16.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBBHelpView.h"
#import "IDCMAlertWindow.h"
@interface IDCMBBHelpView (){
    
    UITextView * contentView;
}
@end

@implementation IDCMBBHelpView


-(instancetype)initWithFrame:(CGRect)frame contentStr:(NSString * ) content{
    
    
   self =  [super initWithFrame:frame];
   

    if (self) {
        _contentStr = content;
        [self setUI];
    }
    
    return self;
}

-(void)setUI{
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
    self.clipsToBounds =YES;
    
    UIButton * dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [dismissBtn setImage:[UIImage imageNamed:@"3.0_groupclose"] forState:UIControlStateNormal];
    
    [self addSubview:dismissBtn];

    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.right.equalTo(self.mas_right).offset(-12);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];


    UIImageView *  logoImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_exchagne"]];
    logoImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(47, 22));
    }];

    contentView = [[UITextView alloc] init];
    contentView.userInteractionEnabled = NO;
    contentView.textColor = [UIColor colorWithHexString:@"#333333"];
    contentView.font =SetFont(@"PingFangSC-Regular", 14);
    contentView.textAlignment = NSTextAlignmentLeft;
    contentView.editable = NO;
    contentView.selectable = NO;
    contentView.text = _contentStr;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(50);
        make.left.equalTo(self.mas_left).offset(7);
        make.right.equalTo(self.mas_right).offset(-7);
        make.bottom.equalTo(self.mas_bottom).offset(-24);
    }];

  
}

-(void)dismiss:(UIButton *) sender{
    
    if ( [[UIApplication sharedApplication].keyWindow isKindOfClass:[IDCMAlertWindow class]]) {
        [[UIApplication sharedApplication].keyWindow performSelector:@selector(dismiss)];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
