//
//  IDCMBlockScrollView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ScrollViewVoiBlock)(UIScrollView *scrollView);
typedef BOOL(^ScrollViewBoolBlock)(UIScrollView *scrollView);
typedef UIView *(^ScrollViewViewBlock)(UIScrollView *scrollView);
typedef void (^ScrollViewDecelerateBlock)(UIScrollView *scrollView, BOOL willDecelerate);
typedef void (^ScrollViewBeginZoomingBlock)(UIScrollView *scrollView, UIView *view);
typedef void (^ScrollViewEndZoomingBlock)(UIScrollView *scrollView, UIView *view, CGFloat scale);
typedef void (^ScrollViewVelocityBlock)(UIScrollView *scrollView,
                                        CGPoint velocity,
                                        CGPoint targetContentOffset);

@interface IDCMBlockScrollViewConfigure : NSObject
// 属性给子类用
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidScrollBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidZoomBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewWillBeginDraggingBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewWillBeginDeceleratingBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidEndDeceleratingBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidEndScrollingAnimationBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidScrollToTopBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidChangeAdjustedContentInsetBlock;
@property (nonatomic,copy, readonly) ScrollViewBoolBlock scrollViewShouldScrollToTopBlock;
@property (nonatomic,copy, readonly) ScrollViewViewBlock viewForZoomingInScrollViewBlock;
@property (nonatomic,copy, readonly) ScrollViewBeginZoomingBlock scrollViewWillBeginZoomingBlock;
@property (nonatomic,copy, readonly) ScrollViewEndZoomingBlock scrollViewDidEndZoomingBlock;
@property (nonatomic,copy, readonly) ScrollViewVelocityBlock scrollViewWillEndDraggingBlock;
@property (nonatomic,copy, readonly) ScrollViewDecelerateBlock scrollViewDidEndDraggingBlock;

- (instancetype)scrollViewDidScroll:(ScrollViewVoiBlock)block;
- (instancetype)scrollViewDidZoom:(ScrollViewVoiBlock)block;
- (instancetype)scrollViewWillBeginDragging:(ScrollViewVoiBlock)block;
- (instancetype)scrollViewWillBeginDecelerating:(ScrollViewVoiBlock)block;
- (instancetype)scrollViewDidEndDecelerating:(ScrollViewVoiBlock)block;
- (instancetype)scrollViewDidEndScrollingAnimation:(ScrollViewVoiBlock)block;
- (instancetype)scrollViewDidScrollToTop:(ScrollViewVoiBlock)block;
- (instancetype)scrollViewDidChangeAdjustedContentInset:(ScrollViewVoiBlock)block;
- (instancetype)scrollViewShouldScrollToTop:(ScrollViewBoolBlock)block;
- (instancetype)viewForZoomingInScrollView:(ScrollViewViewBlock)block;
- (instancetype)scrollViewWillBeginZooming:(ScrollViewBeginZoomingBlock)block;
- (instancetype)scrollViewDidEndZooming:(ScrollViewEndZoomingBlock)block;
- (instancetype)scrollViewWillEndDragging:(ScrollViewVelocityBlock)block;
- (instancetype)scrollViewDidEndDragging:(ScrollViewDecelerateBlock)block;
@end



typedef void(^scrollViewConfigureBlock)(IDCMBlockScrollViewConfigure *configure);
@interface IDCMBlockScrollView : UIScrollView


/**
 创建方式
 
 @param frame frame
 @param configure configure
 @return IDCMBlockTextField
 */
+ (instancetype)BlockScrollViewWithFrame:(CGRect)frame
                               configure:(IDCMBlockScrollViewConfigure *)configure;


/**
 block 创建方式
 
 @param frame frame
 @param configureBlock configureBlock
 @return IDCMBlockTextField
 */
+ (instancetype)BlockScrollViewWithFrame:(CGRect)frame
                          configureBlock:(scrollViewConfigureBlock)configureBlock;



@end



















