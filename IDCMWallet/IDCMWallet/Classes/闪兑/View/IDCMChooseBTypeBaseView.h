//
//  IDCMChooseBTypeBaseView.h
//  IDCMWallet
//
//  Created by wangpu on 2018/5/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDCMChooseBTypeBaseView;

@protocol IconWindowDelegate <NSObject>
- (void)iconWindow:(IDCMChooseBTypeBaseView *) iconView clickedButtonAtIndex:(NSIndexPath *) index selectIndex:(NSIndexPath *) select;
@end

@interface IDCMChooseBTypeBaseView : UIView

@property (nonatomic,weak) UIImageView *converImageView;
@property (nonatomic,weak) id<IconWindowDelegate> delegate;
@property (nonatomic,assign) double  delatCoinName;
@property (nonatomic,assign) double  delatTime;
@property (nonatomic,copy) NSString * currentStr;
@property (nonatomic,copy) NSString * selectedStr;
@property (nonatomic,strong) NSIndexPath * selectIndex;
@property (nonatomic,strong) NSArray * iconsArr;
//
-(instancetype) initWithFrame:(CGRect)frame bTypes:(NSArray *) types title:(NSString *) title;
- (void)createImageViewWithIndexPath:(NSIndexPath *)indexPath;
//设置UI
-(void)setUpView:(NSString *)viewTitle;
@end



