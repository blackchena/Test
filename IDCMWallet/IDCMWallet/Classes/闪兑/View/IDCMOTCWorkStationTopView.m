//
//  IDCMOTCWorkStationTopView.m
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/6.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOTCWorkStationTopView.h"

@implementation IDCMOTCWorkStationTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    [super awakeFromNib];
    
//    self.topLabel.text = @"剩余时间";
    self.topLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.topLabel.textColor = [UIColor colorWithRed:188/255.0 green:203/255.0 blue:223/255.0 alpha:1/1.0];
 
//    self.topLabel.text = @"32s";
//    self.topLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:30];
//    self.topLabel.textColor = [UIColor colorWithRed:59/255.0 green:153/255.0 blue:251/255.0 alpha:1/1.0];

//    self.bottomLabel.text = @"买入: 0.0135 BTC";
    self.bottomLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    self.bottomLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

//    [self.leftButton setTitle:@"价格排序" forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.leftButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor colorWithRed:46/255.0 green:64/255.0 blue:107/255.0 alpha:1/1.0] forState:UIControlStateSelected];
    self.leftButton.selected = YES;
    
//    [self.rightButton setTitle:@"平均支付时间排序" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.rightButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithRed:46/255.0 green:64/255.0 blue:107/255.0 alpha:1/1.0] forState:UIControlStateSelected];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:46/255.0 green:64/255.0 blue:107/255.0 alpha:1/1.0];
    line.layer.masksToBounds = YES;
    line.layer.cornerRadius = 1;
    [self.leftButton.superview addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.leftButton).offset(-2);
        make.centerX.equalTo(self.leftButton);
        make.height.equalTo(@(2));
        make.width.equalTo(self.leftButton.titleLabel.mas_width);
    }];
    self.line = line;
    
}

- (IBAction)buttonClick:(UIButton *)sender {
    self.leftButton.selected = [sender isEqual:self.leftButton];
    self.rightButton.selected = [sender isEqual:self.rightButton];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(sender).offset(-2);
            make.centerX.equalTo(sender);
            make.height.equalTo(@(2));
            make.width.equalTo(sender.titleLabel.mas_width);
        }];
        [self.line.superview layoutIfNeeded];
    }];
}

@end
