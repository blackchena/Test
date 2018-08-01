//
//  IDCMHomeHeaderView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDCMNewsModel;

typedef NS_ENUM(NSInteger , IDCMMarqueeDismissType) {
    IDCMSMarqueeDismissPush         = 1, // 点击横幅跳转
    IDCMMarqueeDismissClose         = 2, // 点击关闭按钮
};

typedef void(^IDCMMarqueeDismissBlock)(IDCMMarqueeDismissType type);

@interface IDCMHomeHeaderView : UIView
/**
 跳转回调
 */
@property (nonatomic,copy) IDCMMarqueeDismissBlock marqueeDismissBlock;
/**
 *  数据源
 */
@property (strong, nonatomic) NSDictionary *data;
/**
 *  是否显示横幅
 */
@property (assign, nonatomic) BOOL isShowLabel;
/**
 *  横幅model
 */
@property (copy, nonatomic) IDCMNewsModel *newsModel;
/**
 *  增加币种
 */
@property (strong, nonatomic) UIButton *addCoin;
@end
