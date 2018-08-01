//
//  IDCMOTCAcceptanceOrderDetailOfferView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/6/13.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMOfferTextField.h"

@interface IDCMOTCAcceptanceOrderDetailOfferView : UIView
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  副标题
 */
@property (strong, nonatomic) UILabel *subTitleLabel;
/**
 *  法币币种
 */
@property (strong, nonatomic) UILabel *contentLabel;
/**
 *  数量
 */
@property (strong, nonatomic) IDCMOfferTextField *numTextField;
@end
