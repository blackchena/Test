//
//  IDCMSegment.h
//  IDCMWallet
//
//  Created by wangpu on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMSegmentProcessView : UIView

@property (nonatomic, strong) NSArray * _Nonnull titles;
@property (nonatomic, assign) NSInteger stepIndex;

- (instancetype)initWithFrame:(CGRect)frame titles:( NSArray *) titles;
- (void)setStepIndex:(NSInteger)stepIndex animation:(BOOL)animation;

@end
