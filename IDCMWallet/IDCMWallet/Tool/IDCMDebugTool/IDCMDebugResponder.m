//
//  IDCMDebugResponder.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMDebugResponder.h"
#import "IDCMDebugManngerController.h"
#import "IDCMDebugServerViewController.h"

@implementation IDCMDebugResponder
#pragma mark - Life Cycle
- (instancetype)init{
    self = [super init];
    if (self) {
        @weakify(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self.navigationController popViewController];
        }];
        _backItem.userInteractionEnabled = YES;
        [_backItem addGestureRecognizer:tap];
        
        [self configItemView];
    }
    return self;
}

#pragma mark - Private Method
- (void)setItems:(NSArray<IDCMDebugItemView *> *)items {
    if (items.count > [IDCMDebugItemView maxCount]) {
        _items = [items subarrayWithRange:NSMakeRange(0, [IDCMDebugItemView maxCount])];
    } else {
        _items = items;
    }
    for (int i = 0; i < MIN(_items.count, _items.count); i++) {
        IDCMDebugItemView *item = _items[i];
        item.position = [IDCMDebugPosition positionWithCount:_items.count index:i];
    }
}
- (void)configItemView {
    NSMutableArray<IDCMDebugItemView *> *itemsArray = [NSMutableArray array];
    IDCMDebugItemView *item =  [IDCMDebugItemView itemWithType:IDCMDebugItemViewTypeText];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [[tap rac_gestureSignal] subscribeNext:^(UIGestureRecognizer *tapGestureRecognizer) {
        @strongify(self);
        [self.navigationController shrink];
        IDCMDebugItemView *item = (IDCMDebugItemView *)tapGestureRecognizer.view;
        if (item.position.index == 0) {
            
            UIViewController *vc = [IDCMUtilsMethod currentViewController];
            if ([vc isKindOfClass:[IDCMDebugServerViewController class]]) {
                return;
            }
            [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMDebugServerViewController"
                                                               withViewModelName:@"IDCMDebugServerViewModel"
                                                                      withParams:@{@"url":@""}];
        }
        
    }];
    item.userInteractionEnabled = YES;
    [item addGestureRecognizer:tap];
    [itemsArray addObject:item];

    self.items = itemsArray;
}

@end
