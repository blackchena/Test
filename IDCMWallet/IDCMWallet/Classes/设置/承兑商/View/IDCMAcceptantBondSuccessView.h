//
//  IDCMAcceptantBondSuccessView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/13.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IDCMAcceptantBondSuccessView : UIView

+ (instancetype)bondSuccessViewTitle:(id)title
                            subTitle:(id)subTitle
                            btnTitle:(NSString *)btnTitle
                       completeInput:(CommandInputBlock)completeInput;

@end
