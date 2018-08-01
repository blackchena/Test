//
//  IDCMSendSuccessView.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/29.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IDCMSendSuccessFinish)(void);


@interface IDCMSendSuccessView : UIView


+ (instancetype)bondSendSuccessViewWithCurrency:(NSString *)currency
                            sureBtnInput:(CommandInputBlock)sureBtnInput
                             finishBlock:(IDCMSendSuccessFinish)finish;

- (void)bindTimerSignalToHintLabel;
@end
