//
//  IDCMAlertWindow.h
//  IDCMWallet
//
//  Created by wangpu on 2018/3/16.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMAlertWindow : UIWindow

@property (nonatomic,strong)  UIView   *contentView;

-(void)show:(UIView *)contenView;
-(void)dismiss;
@end
