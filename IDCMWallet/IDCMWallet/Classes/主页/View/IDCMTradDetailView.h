//
//  IDCMTradDetailView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/25.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMTradDetailInfoView.h"
@interface IDCMTradDetailView : UIView
/**
 *  矿工费
 */
@property (strong, nonatomic) IDCMTradDetailInfoView *feeView;
/**
 *  区块哈希
 */
@property (strong, nonatomic) IDCMTradDetailInfoView *blockView;
/**
 *  确认数
 */
@property (strong, nonatomic) IDCMTradDetailInfoView *confirmView;
/**
 *  转汇时间
 */
@property (strong, nonatomic) IDCMTradDetailInfoView *timeView;
/**
 *  描述
 */
@property (strong, nonatomic) IDCMTradDetailInfoView *descriptionView;
/**
 *  数据源
 */
@property (strong, nonatomic) NSArray *dataArr;
@end
