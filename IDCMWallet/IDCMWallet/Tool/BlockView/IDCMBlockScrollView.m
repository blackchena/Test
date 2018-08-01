//
//  IDCMBlockScrollView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBlockScrollView.h"

@interface IDCMBlockScrollViewConfigure ()
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidScrollBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidZoomBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewWillBeginDraggingBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewWillBeginDeceleratingBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidEndDeceleratingBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidEndScrollingAnimationBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidScrollToTopBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidChangeAdjustedContentInsetBlock;
@property (nonatomic,copy) ScrollViewBoolBlock scrollViewShouldScrollToTopBlock;
@property (nonatomic,copy) ScrollViewViewBlock viewForZoomingInScrollViewBlock;
@property (nonatomic,copy) ScrollViewBeginZoomingBlock scrollViewWillBeginZoomingBlock;
@property (nonatomic,copy) ScrollViewEndZoomingBlock scrollViewDidEndZoomingBlock;
@property (nonatomic,copy) ScrollViewVelocityBlock scrollViewWillEndDraggingBlock;
@property (nonatomic,copy) ScrollViewDecelerateBlock scrollViewDidEndDraggingBlock;
@end


@implementation IDCMBlockScrollViewConfigure
- (instancetype)scrollViewDidScroll:(ScrollViewVoiBlock)block {
    _scrollViewDidScrollBlock = [block copy];
    return self;
}
- (instancetype)scrollViewDidZoom:(ScrollViewVoiBlock)block {
    _scrollViewDidZoomBlock = [block copy];
    return self;
}
- (instancetype)scrollViewWillBeginDragging:(ScrollViewVoiBlock)block{
    _scrollViewWillBeginDraggingBlock = [block copy];
    return self;
}
- (instancetype)scrollViewWillBeginDecelerating:(ScrollViewVoiBlock)block{
    _scrollViewWillBeginDeceleratingBlock = [block copy];
    return self;
}
- (instancetype)scrollViewDidEndDecelerating:(ScrollViewVoiBlock)block{
    _scrollViewDidEndDeceleratingBlock = [block copy];
    return self;
}
- (instancetype)scrollViewDidEndScrollingAnimation:(ScrollViewVoiBlock)block{
    _scrollViewDidEndScrollingAnimationBlock = [block copy];
    return self;
}
- (instancetype)scrollViewDidScrollToTop:(ScrollViewVoiBlock)block{
    _scrollViewDidScrollToTopBlock = [block copy];
    return self;
}
- (instancetype)scrollViewDidChangeAdjustedContentInset:(ScrollViewVoiBlock)block{
    _scrollViewDidChangeAdjustedContentInsetBlock = [block copy];
    return self;
}
- (instancetype)scrollViewShouldScrollToTop:(ScrollViewBoolBlock)block{
    _scrollViewShouldScrollToTopBlock = [block copy];
    return self;
}
- (instancetype)viewForZoomingInScrollView:(ScrollViewViewBlock)block{
    _viewForZoomingInScrollViewBlock = [block copy];
    return self;
}
- (instancetype)scrollViewWillBeginZooming:(ScrollViewBeginZoomingBlock)block{
    _scrollViewWillBeginZoomingBlock = [block copy];
    return self;
}
- (instancetype)scrollViewDidEndZooming:(ScrollViewEndZoomingBlock)block{
    _scrollViewDidEndZoomingBlock = [block copy];
    return self;
}
- (instancetype)scrollViewWillEndDragging:(ScrollViewVelocityBlock)block{
    _scrollViewWillEndDraggingBlock = [block copy];
    return self;
}
- (instancetype)scrollViewDidEndDragging:(ScrollViewDecelerateBlock)block{
    _scrollViewDidEndDraggingBlock = [block copy];
    return self;
}
@end



@interface IDCMBlockScrollView () <UIScrollViewDelegate>
@property (nonatomic,strong) IDCMBlockScrollViewConfigure *configure;
@end

@implementation IDCMBlockScrollView

+ (instancetype)BlockScrollViewWithFrame:(CGRect)frame
                               configure:(IDCMBlockScrollViewConfigure *)configure {
    IDCMBlockScrollView *scrollView = [[self alloc] init];
    scrollView.configure = configure;
    scrollView.delegate = scrollView;
    return scrollView;
}

+ (instancetype)BlockScrollViewWithFrame:(CGRect)frame
                          configureBlock:(scrollViewConfigureBlock)configureBlock {
    IDCMBlockScrollView *scrollView = [[self alloc] init];
    !configureBlock ?: configureBlock(scrollView.configure);
     scrollView.delegate = scrollView;
    return scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidScrollBlock ?:
     self.configure.scrollViewDidScrollBlock(scrollView);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView  {
    !self.configure.scrollViewDidZoomBlock ?:
     self.configure.scrollViewDidZoomBlock(scrollView);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.configure.scrollViewWillBeginDraggingBlock ?:
     self.configure.scrollViewWillBeginDraggingBlock(scrollView);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    !self.configure.scrollViewWillBeginDeceleratingBlock ?:
    self.configure.scrollViewWillBeginDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidEndDeceleratingBlock ?:
     self.configure.scrollViewDidEndDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidEndScrollingAnimationBlock ?:
    self.configure.scrollViewDidEndScrollingAnimationBlock(scrollView);
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return
    self.configure.viewForZoomingInScrollViewBlock ?
    self.configure.viewForZoomingInScrollViewBlock(scrollView) : nil;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.configure.scrollViewWillEndDraggingBlock ?
    self.configure.scrollViewWillEndDraggingBlock(scrollView, velocity, *targetContentOffset) : nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.configure.scrollViewDidEndDraggingBlock ?
    self.configure.scrollViewDidEndDraggingBlock(scrollView, decelerate) : nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    self.configure.scrollViewWillBeginZoomingBlock ?
    self.configure.scrollViewWillBeginZoomingBlock(scrollView, view) : nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    self.configure.scrollViewDidEndZoomingBlock ?
    self.configure.scrollViewDidEndZoomingBlock(scrollView, view, scale) : nil;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return
    self.configure.scrollViewShouldScrollToTopBlock ?
    self.configure.scrollViewShouldScrollToTopBlock(scrollView) : YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidScrollToTopBlock ?:
    self.configure.scrollViewDidScrollToTopBlock(scrollView);
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidChangeAdjustedContentInsetBlock ?:
    self.configure.scrollViewDidChangeAdjustedContentInsetBlock(scrollView);
}

- (IDCMBlockScrollViewConfigure *)configure {
    return SW_LAZY(_configure, ({
        [[IDCMBlockScrollViewConfigure alloc] init];
    }));
}

@end













