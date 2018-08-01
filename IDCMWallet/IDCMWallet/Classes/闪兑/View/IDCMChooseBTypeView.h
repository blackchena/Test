//
//  IDCMChooseBTypeView.h
//  IDCMWallet
//
//  Created by wangpu on 2018/3/15.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMOTCSettingModel.h"
#import "IDCMBTypeCollectionViewCell.h"
@class IDCMChooseBTypeView;

@protocol IconWindowDelegate <NSObject>
@optional;
- (void)iconWindow:(IDCMChooseBTypeView *) iconView clickedButtonAtIndex:(NSIndexPath *) index selectIndex:(NSIndexPath *) select;
@end

@interface IDCMChooseBTypeView : UIView

@property (nonatomic,weak) UIImageView *converImageView;
@property (nonatomic,strong) NSArray * bTypeArrs;
@property (nonatomic,weak) id<IconWindowDelegate> delegate;

//币币闪兑页面用
-(instancetype) initWithFrame:(CGRect)frame bTypes:(NSArray *) types position:(NSInteger) position exchange:(BOOL) exchange;
//otc页面用
-(instancetype) initWithFrame:(CGRect)frame bTypes:(NSArray *) types title:(NSString *) title;
//OTC 弹窗
-(instancetype) initWithFrame:(CGRect)frame bTypes:(NSArray *)types title:(NSString *)title withType:(IDCMAlertTypeType)type;
@end


