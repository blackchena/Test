//
//  IDCMSettingMenueListCell.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMTableViewCell.h"
#import "IDCMSettingListModel.h"
@interface IDCMSettingMenueListCell : IDCMTableViewCell
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UIImageView *arrow;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) IDCMSettingListModel *model;
@end
