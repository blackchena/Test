//
//  IDCMExchangeDetailInfoView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/14.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDCMOTCExchangeDetailViewModel;
@interface IDCMExchangeDetailInfoView : UIView

@property (nonatomic,strong) RACSubject *heigthChangeSignal;
@property (nonatomic,assign) BOOL  isClickResignFirstResponse;
+ (instancetype)detailInfoViewWithViewModel:(IDCMOTCExchangeDetailViewModel *)viewModel;
- (BOOL)upAnimation;
- (void)photoScorllToCenter;
@end
