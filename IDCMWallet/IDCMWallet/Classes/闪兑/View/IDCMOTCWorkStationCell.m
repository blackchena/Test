//
//  IDCMOTCWorkStationCell.m
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/6.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOTCWorkStationCell.h"

@implementation IDCMOTCWorkStationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    self.leftLabel1.text = @"Alex. B";
    self.leftLabel1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.leftLabel1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
//    self.leftLabel2.text = @"被申诉次数：";
    self.leftLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.leftLabel2.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    
//    self.leftLabel3.text = @"平均支付时间: 01:12";
    self.leftLabel3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.leftLabel3.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
//    self.rightLabel.text = @"1200 CNY";
    self.rightLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.rightLabel.textColor = [UIColor colorWithRed:255/255.0 green:134/255.0 blue:47/255.0 alpha:1/1.0];

    self.rightImgView1.layer.cornerRadius = 10;
    self.rightImgView1.layer.masksToBounds = YES;
    
    self.rightImgView2.layer.cornerRadius = 10;
    self.rightImgView2.layer.masksToBounds = YES;
    
    self.rightImgView3.layer.cornerRadius = 10;
    self.rightImgView3.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(IDCMOTCWorkStationModel *)model {
    _model = model;
    self.leftLabel1.text = model.AcceptantName;
    
    self.leftLabel2.text = [NSString stringWithFormat:@"%@: %zd", SWLocaloziString(@"3.0_WorkStation_ComplaintsCount") , model.AppealCount];
    self.leftLabel3.text = model.isSell ? [NSString stringWithFormat:@"%@: %@", SWLocaloziString(@"3.0_WorkStation_AvgResTime") , [IDCMUtilsMethod getTimeWithSeconds:model.AvgResponseTime]] : [NSString stringWithFormat:@"%@: %@", SWLocaloziString(@"3.0_WorkStation_AvgPayTime") , [IDCMUtilsMethod getTimeWithSeconds:model.AvgPayTime]];
    
    NSString *amount = [IDCMUtilsMethod precisionControl:model.Amount];
    NSString *str = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:amount] fractionDigits:4]];
    self.rightLabel.text = [NSString stringWithFormat:@"%@ %@",str, model.CurrencyCode];
    
    self.rightImgView1.image = nil;
    self.rightImgView2.image = nil;
    self.rightImgView3.image = nil;
    if(model.PayTypes.count > 2){
        [self.rightImgView1 sd_setImageWithURL:[NSURL URLWithString:model.PayTypes[0].PayLogo]];
        [self.rightImgView2 sd_setImageWithURL:[NSURL URLWithString:model.PayTypes[1].PayLogo]];
        [self.rightImgView3 sd_setImageWithURL:[NSURL URLWithString:model.PayTypes[2].PayLogo]];
    }
    else if(model.PayTypes.count == 2){
        [self.rightImgView1 sd_setImageWithURL:[NSURL URLWithString:model.PayTypes[0].PayLogo]];
        [self.rightImgView2 sd_setImageWithURL:[NSURL URLWithString:model.PayTypes[1].PayLogo]];
//        [self.rightImgView3 sd_setImageWithURL:[NSURL URLWithString:model.PayTypes[2].PayLogo]];
    }
    else if(model.PayTypes.count == 1){
        [self.rightImgView1 sd_setImageWithURL:[NSURL URLWithString:model.PayTypes[0].PayLogo]];
//        [self.rightImgView2 sd_setImageWithURL:[NSURL URLWithString:model.PayTypes[1].PayLogo]];
//        [self.rightImgView3 sd_setImageWithURL:[NSURL URLWithString:model.PayTypes[2].PayLogo]];
    }
}

@end
