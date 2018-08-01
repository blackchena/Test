//
//  IDCMOTCPurchaseContentView.h
//  IDCMWallet
//
//  Created by mac on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMOTCPurchaseContentView : UIView

/**
 左边标题
 */
@property(nonatomic,strong)UILabel * LeftLabel;


/**
 右边 部分容器
 */
@property(nonatomic,strong)UIView * rightContentView;

/**
 右边图片  logo Image
 */
@property(nonatomic,strong)UIImageView *  logoImageView;

/**
 右边 文字
 */
@property(nonatomic,strong)UILabel * rightTitleLabel ;

/**
 右边 箭头
 */
@property(nonatomic,strong)UIImageView * rightArrow ;

@property(nonatomic,strong)UIView *  baseLineView ;
@end
