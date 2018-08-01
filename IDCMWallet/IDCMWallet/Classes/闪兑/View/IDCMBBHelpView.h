//
//  IDCMBBHelpView.h
//  IDCMWallet
//
//  Created by wangpu on 2018/3/16.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMBBHelpView : UIView

@property (nonatomic,copy)  NSString * contentStr;

-(instancetype)initWithFrame:(CGRect)frame contentStr:(NSString * ) content;
@end
