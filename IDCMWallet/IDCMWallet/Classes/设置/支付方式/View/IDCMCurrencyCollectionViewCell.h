//
//  IDCMCurrencyCollectionViewCell.h
//  IDCMWallet
//
//  Created by IDCM on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMChooseBTypeView.h"

@class IDCMLocalCurrencyListItemModel;

@interface IDCMCurrencyCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *bTypeImage;
@property (strong,nonatomic) IDCMLocalCurrencyListItemModel * model;
@property (strong ,nonatomic) UIColor * backGroundColor;

@end
