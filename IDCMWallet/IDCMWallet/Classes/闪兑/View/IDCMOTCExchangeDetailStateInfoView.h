//
//  IDCMOTCExchangeDetailStateInfoView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoHighlightedButton : UIButton
@end
@class IDCMOTCExchangeDetailViewModel;
@interface IDCMOTCExchangeDetailStateInfoView : UIView


@property (nonatomic,strong) NoHighlightedButton *bottomBtn;
+ (instancetype)detailStateInfoViewWithViewModel:(IDCMOTCExchangeDetailViewModel *)viewModel
                                animationCommand:(RACCommand *)animationCommand
                           refreshInfoViewSignal:(RACSubject *)refreshInfoViewSignal;

- (void)photoScorllToCenter;

@end















