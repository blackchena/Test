//
//  IDCMOTCAcceptanceOrderDetailHeaderView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMOTCAcceptanceOrderDetailHeaderView : UIView
/**
 *  绑定数据
 */
@property (strong, nonatomic) RACSubject *dataSubject;

@end
