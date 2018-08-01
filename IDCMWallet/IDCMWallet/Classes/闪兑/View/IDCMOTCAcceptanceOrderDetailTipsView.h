//
//  IDCMOTCAcceptanceOrderDetailTipsView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/6/13.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMOTCAcceptanceOrderDetailTipsView : UIView
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  副标题
 */
@property (strong, nonatomic) UILabel *subTitleLabel;
/**
 *  价格
 */
@property (strong, nonatomic) UILabel *contentLabel;
/**
 *  币种
 */
@property (strong, nonatomic) UILabel *currencyLabel;
@end
