//
//  IDCMAcceptantApplyCompleteView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMAcceptantApplyCompleteView : UIScrollView

+ (instancetype)completeViewWithFrame:(CGRect)frame
                        completeInput:(CommandInputBlock)completeInput;

@end
