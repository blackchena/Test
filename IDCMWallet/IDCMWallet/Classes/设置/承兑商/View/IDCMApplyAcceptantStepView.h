//
//  IDCMApplyAcceptantStepOneView.h
//  IDCMWallet
//
//  Created by wangpu on 2018/4/13.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IDCMAcceptVariableModel;

@interface IDCMApplyAcceptantStepView : UIView
@property (nonatomic,strong) RACSubject * nextSignal;

@property (nonatomic,strong) NSMutableArray< IDCMAcceptVariableModel *> * sectionOneArray;
@property (nonatomic,strong) NSMutableArray <IDCMAcceptVariableModel *> * sectionTwoArray;


@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSArray  * sectionHeaderSubTitles;
@property (nonatomic,strong) NSArray  * sectionHeaderTitles;
@property (nonatomic,strong) RACSubject  * deleteSubject;
@property (nonatomic,strong) RACSubject  * editSubject;
@property (nonatomic,strong) RACSubject  * sectionHeaderSubject;
+ (instancetype)applyAcceptantStepViewWithFrame:(CGRect)frame type:(NSInteger) type  subTitles:(NSArray *)subTitles

                                 completeSignal:(RACSubject *)nextSignal;
-(void)configView;
-(void)reloadView;

@end
