//
//  IDCMAcceptantHeaderView.h
//  IDCMWallet
//
//  Created by wangpu on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMAcceptantViewModel.h"

@class IDCMAcceptantDepositModel;

typedef void(^AcceptantHeaderCallBackBlock) (void);

@interface IDCMAcceptantHeaderView : UIView

@property (nonatomic,copy) AcceptantHeaderCallBackBlock  leftCallBack;
@property (nonatomic,copy) AcceptantHeaderCallBackBlock  rightCallBack;
@property (nonatomic,strong) IDCMAcceptantViewModel * viewModel;

- (void)scrollToCurrentIndex:(NSInteger)index animation:(BOOL)animation;

//获取当前保证金币种和余额
-(void)requestWithdrawCoinList;

@end


@interface IDCMAcceptantiCarouselCell : UIView

@property (nonatomic,strong) IDCMAcceptantDepositModel  *  model;
@end


