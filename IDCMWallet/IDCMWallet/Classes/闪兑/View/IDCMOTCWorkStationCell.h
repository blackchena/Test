//
//  IDCMOTCWorkStationCell.h
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/6.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMOTCWorkStationModel.h"

@interface IDCMOTCWorkStationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel1;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel2;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel3;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView1;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView2;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView3;


@property (nonatomic, strong) IDCMOTCWorkStationModel *model;

@end
