//
//  IDCMFoundBannerView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/22.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMFoundBannerView : UIView


/**

 @param source 数据信号
 @param didSelectionCommand item选中信号
 */
- (void) bindingBannerViewForSourceSignal:(RACSignal *)source
                         selectionCommand:(RACCommand *)didSelectionCommand;


/**
 重启定时器
 */
- (void)startTimerWhenAutoScroll;
/**
 停止定时器
 */
- (void)invalidateTimerWhenAutoScroll;

/**
 解决卡屏
 */
- (void)adjustBannerViewWhenCardScreen;
@end
