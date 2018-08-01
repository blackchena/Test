//
//  IDCMScrollViewPageTipView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#define KeyWindow [UIApplication sharedApplication].keyWindow
#import "IDCMScrollViewPageTipView.h"

static UIView *_toView;
static NSString *_baseClassStr;
typedef void(^Action)(void);
Action completionHandle(Action action) {
    return ^{
        !action ?: action();
        _baseClassStr =  nil;
        _toView = nil;
    };
}

@interface IDCMScrollViewPageTipView ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) ScrollViewPageTipViewPositionType positionType;
@property (nonatomic,assign) NSInteger initialPageIndex;
@property (nonatomic,strong) NSArray<UIView *> *contentViews;
@property (nonatomic,strong) NSArray *contentSizes;
@property (nonatomic,assign) BOOL scrollEnabled;
@end


@implementation IDCMScrollViewPageTipView
+ (void)showTipViewToView:(UIView *)toView
             contentViews:(NSArray<UIView *> *)contentViews
             contentSizes:(NSArray *)contentSizes
         initialPageIndex:(NSInteger)initialPageIndex
            scrollEnabled:(BOOL)scrollEnabled
             positionType:(ScrollViewPageTipViewPositionType)positionType {
    
    if (!contentSizes.count || !contentViews.count) { return;}
    if (contentViews.count != contentSizes.count && contentSizes.count != 1) {
        return;
    }
    
    IDCMScrollViewPageTipView *tipView = [[self alloc] init];
    tipView.positionType = positionType;
    tipView.initialPageIndex = initialPageIndex;
    tipView.contentViews = contentViews;
    tipView.contentSizes = contentSizes;
    tipView.scrollEnabled = scrollEnabled;
    
    __block CGFloat width = 0.0;
    __block CGFloat heigth = 0.0;
    [contentSizes enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL *stop) {
        CGSize size = [obj CGSizeValue];
        if (size.width > width) {
            width = size.width;
        }
        if (size.height > heigth) {
            heigth = size.height;
        }
    }];
    width = (width >= toView.width)  ? width : toView.width;
    CGSize tipViewSize = CGSizeMake(width, heigth);
    tipView.size = tipViewSize;
    [tipView initConfigre];
    _toView = toView ?: KeyWindow;
    
    if (positionType == ScrollViewPageTipViewPositionType_Center) {
        _baseClassStr = @"IDCMBaseCenterTipView";
        [IDCMBaseCenterTipView showTipViewToView:toView
                                            size:tipViewSize
                                     contentView:tipView
                                automaticDismiss:NO
                                  animationStyle:1
                           tipViewStatusCallback:nil];
        
    } else {
        _baseClassStr = @"IDCMBaseBottomTipView";
        [IDCMBaseBottomTipView showTipViewToView:toView
                                            size:tipViewSize
                                     contentView:tipView
                           tipViewStatusCallback:nil];
    }
}

+ (void)showHUD {
    if ([_baseClassStr isEqualToString:@"IDCMBaseCenterTipView"]) {
        [IDCMBaseCenterTipView showHudForView:_toView];
    } else {
        [IDCMBaseBottomTipView showHudForView:_toView];
    }
}

+ (void)dismissHUD {
    if ([_baseClassStr isEqualToString:@"IDCMBaseCenterTipView"]) {
        [IDCMBaseCenterTipView dismissHudForView:_toView];
    } else {
        [IDCMBaseBottomTipView dismissHudForView:_toView];
    }
}

+ (void)dismissWithComletion:(void(^)(void))completion {
    if ([_baseClassStr isEqualToString:@"IDCMBaseCenterTipView"]) {
        [IDCMBaseCenterTipView dismissForView:_toView completion:completionHandle(completion)];
    } else {
        [IDCMBaseBottomTipView dismissForView:_toView completion:completionHandle(completion)];
    }
}

+ (void)scrollToLastPage {
    IDCMScrollViewPageTipView *tipView  = [self getInstance];
    if (!tipView) {return;}
    [self scrollToPageIndex:[tipView getCurrentPageIndex] - 1];
}

+ (void)scrollToNextPage {
    IDCMScrollViewPageTipView *tipView  = [self getInstance];
    if (!tipView) {return;}
    [self scrollToPageIndex:[tipView getCurrentPageIndex] + 1];
}

+ (void)scrollToPageIndex:(NSInteger)pageIndex {
    IDCMScrollViewPageTipView *tipView  = [self getInstance];
    if (!tipView) {return;}
    if (pageIndex < 0 || pageIndex >  tipView.contentViews.count - 1) {
        return;
    }
    
    NSInteger currentPageIndex = [tipView getCurrentPageIndex];
    UIView *currentView = tipView.contentViews[currentPageIndex];
    NSInteger offsetPageIndex = abs((int)(currentPageIndex - pageIndex));
    if (offsetPageIndex < 2) {
        
        [tipView.scrollView
         setContentOffset:CGPointMake(pageIndex * tipView.scrollView.width, 0) animated:YES];
    } else {
        
        NSInteger noAnimatedPageIndex =
        (currentPageIndex > pageIndex) ? (pageIndex + 1) : (pageIndex - 1);
        tipView.scrollView.userInteractionEnabled = NO;
        
        [tipView.scrollView
         setContentOffset:CGPointMake(noAnimatedPageIndex * tipView.scrollView.width, 0) animated:NO];
        
        UIView *noAnimatedPageIndexView = tipView.contentViews[noAnimatedPageIndex];
        CGFloat noAnimatedPageIndexViewTransForm = -(currentPageIndex - noAnimatedPageIndex) * tipView.scrollView.width;
        currentView.transform = CGAffineTransformMakeTranslation(noAnimatedPageIndexViewTransForm, 0);
        noAnimatedPageIndexView.transform = CGAffineTransformMakeTranslation(-noAnimatedPageIndexViewTransForm, 0);
        
        [tipView.scrollView
         setContentOffset:CGPointMake(pageIndex * tipView.scrollView.width, 0) animated:YES];
        [[RACScheduler mainThreadScheduler] afterDelay:.3 schedule:^{
            currentView.transform =
            noAnimatedPageIndexView.transform = CGAffineTransformIdentity;
            tipView.scrollView.userInteractionEnabled = YES;
        }];
    }
}

+ (void)reSetScrollEnabled:(BOOL)scrollEnabled {
    IDCMScrollViewPageTipView *tipView  = [self getInstance];
    if (!tipView) {return;}
    tipView.scrollView.scrollEnabled = YES;
}

+ (instancetype)getInstance {
    __block IDCMScrollViewPageTipView *tipView = nil;
    [_toView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:_baseClassStr]) {
            [obj.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[self class]] ||
                    [NSStringFromClass([obj class]) isEqualToString:@"IDCMScrollViewPageTipView"]) {
                    tipView = (IDCMScrollViewPageTipView *)obj;
                    *stop = YES;
                }
            }];
            *stop = YES;
        }
    }];
    return tipView;
}

- (void)initConfigre {
    [self configUI];
}

- (void)configUI {
    [self addSubview:self.scrollView];
    if (self.initialPageIndex >=0 && self.initialPageIndex < self.contentViews.count) {
        [self.scrollView
         setContentOffset:CGPointMake(self.initialPageIndex * self.scrollView.width, 0) animated:YES];
    }
}

- (NSInteger)getCurrentPageIndex {
  return  (NSInteger)(self.scrollView.contentOffset.x / self.scrollView.width);
}

- (UIScrollView *)scrollView {
    return SW_LAZY(_scrollView, ({
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 0, self.width, self.height);
        scrollView.clipsToBounds = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollEnabled = self.scrollEnabled;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.contentSize = CGSizeMake(self.contentViews.count * self.width, 0);
        for (UIView *view in self.contentViews) {
            NSInteger index = [self.contentViews indexOfObject:view];
            [scrollView addSubview:view];
            if (self.contentSizes.count == 1) {
                view.size = [self.contentSizes.firstObject CGSizeValue];
            } else {
                view.size = [self.contentSizes[index] CGSizeValue];
            }
            view.left = scrollView.width * index + (scrollView.width - view.size.width) / 2;
            view.top = (scrollView.height - view.size.height) / 2;
        }
        scrollView;
    }));
}

@end







