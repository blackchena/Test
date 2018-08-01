//
//  IDCMShowSelectPhraseView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMShowSelectPhraseView.h"

@interface IDCMShowSelectPhraseView ()
/**
 *  button数组
 */
@property (strong, nonatomic) NSMutableArray *buttonArr;
@end

@implementation IDCMShowSelectPhraseView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    
        [self distributeFixedView];
        [self touchUpButton];
        [self unSelectPhrase];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setListModelArray:(NSArray<IDCMPhraseModel *> *)listModelArray
{
    _listModelArray = listModelArray;
    
    for (NSInteger i = 0; i < self.buttonArr.count; i++) {
        UIButton *btn = [self.buttonArr objectAtIndex:i];
        btn.enabled = YES;
        IDCMPhraseModel *model = [listModelArray objectAtIndex:i];
        [btn setTitle:nilHandleString(model.phrase) forState:UIControlStateNormal];
        [btn setTitle:nilHandleString(model.phrase) forState:UIControlStateDisabled];

    }
}

#pragma mark - Privater Methods
// 创建12个按钮
- (void)distributeFixedView
{
    
    for (NSInteger i = 1; i < 13; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.enabled = NO;
        [button ba_buttonSetBackgroundColor:kSubtopicGrayColor forState:UIControlStateDisabled animated:YES];
        [button ba_buttonSetBackgroundColor:kSubtopicColor forState:UIControlStateNormal animated:YES];
        button.titleLabel.font = textFontPingFangRegularFont(14);
        [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [self.buttonArr addObject:button];
        [self addSubview:button];
    }
    
    [self.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0
                                              fixedLineSpacing:15 fixedInteritemSpacing:20
                                                     warpCount:3
                                                    topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
    
}

#pragma mark - Action
- (void)touchUpButton
{
    for (UIButton *button in  self.buttonArr) {
        @weakify(self);

        [[button rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(UIButton *sender) {
            @strongify(self);

            sender.enabled = NO;
            self.selectIndex = @(sender.tag - 1);

        }];

    }
}
- (void)unSelectPhrase
{
    @weakify(self);
    [[[RACObserve(self, UnSelectModel) deliverOnMainThread] filter:^BOOL(IDCMPhraseModel *model) {
        if (model) {
            return YES;
        }else{
            return NO;
        }
    }] subscribeNext:^(IDCMPhraseModel *model) {
         @strongify(self);
        
         [self.listModelArray enumerateObjectsUsingBlock:^(IDCMPhraseModel *listModel, NSUInteger idx, BOOL * _Nonnull stop) {
             @strongify(self);
             if ([model.phrase isEqualToString:listModel.phrase]) {
                 UIButton *button = self.buttonArr[idx];
                 button.enabled = YES;
             }
         }];
     }];
}
#pragma mark - Getter & Setter
- (NSMutableArray *)buttonArr
{
    return SW_LAZY(_buttonArr, @[].mutableCopy);
}

@end
