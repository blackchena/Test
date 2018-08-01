//
//  IDCMShowPhraseView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMShowPhraseView
// @abstract <#类的描述#>
// @discussion <#类的功能#>
#import "IDCMShowPhraseView.h"

@interface IDCMShowPhraseView ()
/**
 *  button数组
 */
@property (strong, nonatomic) NSMutableArray *buttonArr;

@end

@implementation IDCMShowPhraseView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.selectArr = [KVOMutableArray new];
        
        [self distributeFixedView];
        [self touchUpButton];
        [self selectPhrase];
    }
    return self;
}

#pragma mark - Public Methods


#pragma mark - Privater Methods
// 创建12个按钮
- (void)distributeFixedView
{
    
    for (NSInteger i = 1; i < 13; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 0.5;
        button.enabled = NO;
        button.layer.borderColor = kSubtopicColor.CGColor;
        button.titleLabel.font = textFontPingFangRegularFont(14);
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [self.buttonArr addObject:button];
        [self addSubview:button];
    }
    
    
    [self.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0
                                              fixedLineSpacing:12 fixedInteritemSpacing:12
                                                     warpCount:3
                                                    topSpacing:12 bottomSpacing:12 leadSpacing:12 tailSpacing:12];
    
}

#pragma mark - Action
- (void)touchUpButton
{
    for (UIButton *button in  self.buttonArr) {
        @weakify(self);
        
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
            @strongify(self);

            [self.selectArr enumerateObjectsUsingBlock:^(IDCMPhraseModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                @strongify(self);
                if ([sender.currentTitle isEqualToString:model.phrase]) {
                    self.UnSelectModel = model;
                    [self.selectArr removeObjectAtIndex:idx];
                    *stop = YES;
                }
            }];
            
            sender.enabled = NO;
            [sender setTitle:@"" forState:UIControlStateNormal];

        }];

    }
}
- (void)selectPhrase
{
    @weakify(self);
    [[[RACObserve(self, selectModel) deliverOnMainThread] filter:^BOOL(IDCMPhraseModel *model) {
        if (model) {
            return YES;
        }else{
            return NO;
        }
    }] subscribeNext:^(IDCMPhraseModel *model) {
         @strongify(self);
         
         [self.buttonArr enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
             
             if (![button.currentTitle isNotBlank]) {
                 button.enabled = YES;
                 [button setTitle:nilHandleString(model.phrase) forState:UIControlStateNormal];
                 [self.selectArr insertObject:model atIndex:idx];
                 *stop = YES;
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
