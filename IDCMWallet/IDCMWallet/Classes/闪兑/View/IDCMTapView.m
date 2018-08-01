//
//  IDCMTapView.m
//  IDCMWallet
//
//  Created by wangpu on 2018/3/17.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMTapView.h"

@interface IDCMTapView (){

//    UIImageView * iconImageView;
    QMUIButton *  bChooseBtn;
}
@end

@implementation IDCMTapView


-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
       
        
        [self setUI];
    }
    
    return self;
}


-(void) setUI{
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    
    //选择
    bChooseBtn = [QMUIButton new];
    bChooseBtn.imagePosition = QMUIButtonImagePositionRight;
    bChooseBtn.spacingBetweenImageAndTitle = 4;
    
    [bChooseBtn setTitle:@"    " forState:UIControlStateNormal];
    bChooseBtn.titleLabel.font = SetFont(@"PingFangSC-Regular", 14);
    bChooseBtn.tintColorAdjustsTitleAndImage =[UIColor colorWithHexString:@"#333333"] ;
    [bChooseBtn setImage:[UIImage imageNamed:@"3.0_angle"] forState:UIControlStateNormal];
    [bChooseBtn addTarget:self action:@selector(selectIcon:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bChooseBtn];
    
    [bChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.iconImageView.mas_right).offset(6);
//        make.width.mas_greaterThanOrEqualTo(80);
    }];
}


//图片
-(void)setCurrentModel:(IDCMCoinModel *)currentModel{
    
    if (currentModel) {
        [bChooseBtn setTitle:currentModel.coinLabelUppercaseString forState:UIControlStateNormal];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:currentModel.coinUrl] placeholderImage:nil options:SDWebImageRefreshCached];
    }

}
//

-(void)selectIcon:(UIButton *) sender{
    
    if (_callBack) {
        _callBack();
    }
}

@end
