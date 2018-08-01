//
//  IDCMDebugResponder.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMDebugItemView.h"

@interface IDCMDebugResponder : UIResponder

@property (nonatomic, strong) IDCMDebugItemView *backItem;
@property (nonatomic, strong) NSArray<IDCMDebugItemView *> *items;

@end
