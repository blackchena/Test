//
//  IDCMTapView.h
//  IDCMWallet
//
//  Created by wangpu on 2018/3/17.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMCoinListModel.h"


typedef void (^IDCMTaPViewCallBack) (void);

@interface IDCMTapView : UIView

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) IDCMCoinModel  * currentModel;
@property (nonatomic,copy) IDCMTaPViewCallBack  callBack;

@end
