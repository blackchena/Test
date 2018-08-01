//
//  IDCMAcceptantPickinBondView.h
//  IDCMWallet
//
//  Created by IDCM on 2018/5/10.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMAcceptantPickinBondView : UIScrollView
+ (instancetype)bondViewWithFrame:(CGRect)frame
                   completeSignal:(RACSubject *)completeSignal;
@end
