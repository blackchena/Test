//
//  IDCMCustomTipView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/26.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMCustomTipView : IDCMBaseCenterTipView

+ (void)showWithTitle:(NSString *)title
       titleConfigure:(RACTuple *)titleConfigure
              message:(NSString *)message
     messageConfigure:(RACTuple *)messageConfigure
     buttonTitleArray:(NSArray<NSString *>*)buttonTitleArray
           colorIndex:(NSNumber *)index
  clickButtonCallback:(void(^)(NSInteger clickIndex))clickButtonCallback;


@end
