//
//  BTypeCollectionViewCell.h
//  IDCMWallet
//
//  Created by wangpu on 2018/5/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IDCMAlertTypeType) {
    kIDCMCoinType                        = 1,    // 选择币种
    kIDCMCurrencyType                    = 2,    // 选择法币
    kIDCMAcceptantCoinType               = 3     // 承兑商选择承兑币种列表
};

@interface IDCMBTypeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *bTypeImage;
@property (strong,nonatomic) id model;
@property (strong ,nonatomic) UIColor * backGroundColor;

@end
