//
//  IDCMNewCurrencyTradingHeaderView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/28.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMNewCurrencyTradingViewModel.h"
#define headerViewTopHeight 285
#define headerViewBottomHeight 40


@interface IDCMNewCurrencyTradingHeaderView : UIView

+ (instancetype)headerViewWithViewModel:(IDCMNewCurrencyTradingViewModel *)viewModel;
- (void)recoveryUI;

@end
