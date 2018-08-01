//
//  IDCMOTCAcceptanceOrderDetailPriceView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMOTCAcceptancePriceView : UIView
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  副标题
 */
@property (strong, nonatomic) UILabel *subTitleLabel;
/**
 *  法币
 */
@property (strong, nonatomic) UILabel *contentLabel;
/**
 *  数量
 */
@property (strong, nonatomic) IDCMBaseTextField *numTextField;
@end

@interface IDCMOTCAcceptanceOrderDetailPriceView : UIView
/**
 *  绑定数据
 */
@property (strong, nonatomic) RACSubject *dataSubject;
/**
 *  单价
 */
@property (strong, nonatomic) IDCMOTCAcceptancePriceView *unitPriceView;
/**
 *  总价
 */
@property (strong, nonatomic) IDCMOTCAcceptancePriceView *totalPriceView;
@end
