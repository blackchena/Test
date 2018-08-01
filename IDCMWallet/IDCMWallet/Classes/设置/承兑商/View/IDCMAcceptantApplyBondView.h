//
//  IDCMAcceptantApplyBondView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMAcceptantApplyBondView : UIScrollView

+ (instancetype)bondViewWithFrame:(CGRect)frame
                   completeSignal:(RACSubject *)completeSignal;

@end
