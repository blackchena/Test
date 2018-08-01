//
//  IDCMDebugManngerController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMDebugManngerController.h"
#import <objc/runtime.h>

@interface IDCMDebugManngerController ()

@property (nonatomic, strong) NSMutableArray<IDCMDebugPosition *> *pushPosition;
@property (nonatomic, strong) IDCMDebugItemView *contentItem;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, assign) CGPoint contentPoint;
@property (nonatomic, assign) CGFloat contentAlpha;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL show;

@end


@implementation IDCMDebugManngerController

#pragma mark - Life Cycle
- (instancetype)initWithRootViewController:(IDCMDebugResponder *)viewController {
    self = [super init];
    if (self) {
        if (!viewController) {
            viewController = [IDCMDebugResponder new];
        }
        IDCMDebugResponder *rootViewController = viewController;
        rootViewController.navigationController = self;
        _viewControllers = [NSMutableArray arrayWithObject:rootViewController];
        _pushPosition = [NSMutableArray array];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    _contentPoint = [IDCMDebugItemView cotentViewDefaultPoint];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [IDCMDebugItemView itemImageWidth], [IDCMDebugItemView itemImageWidth])];
    _contentView.center = _contentPoint;
    _contentView.layer.cornerRadius = 14;
    [self.view addSubview:_contentView];
    
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _effectView.frame = _contentView.bounds;
    _effectView.layer.cornerRadius = [IDCMDebugItemView cornerRadius];
    _effectView.layer.masksToBounds = YES;
    [_contentView addSubview:_effectView];
    
    _contentItem = [IDCMDebugItemView itemWithType:IDCMDebugItemViewSystem];
    _contentItem.center = _contentPoint;
    [self.view addSubview:_contentItem];
    
    self.view.frame = CGRectMake(0, 0, [IDCMDebugItemView itemImageWidth], [IDCMDebugItemView itemImageWidth]);
    self.contentAlpha = [IDCMDebugItemView inactiveAlpha];
    self.contentPoint = CGPointMake([IDCMDebugItemView itemImageWidth] / 2, [IDCMDebugItemView itemImageWidth] / 2);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *spreadGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spread)];
    UITapGestureRecognizer *shrinkGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shrink)];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.contentItem addGestureRecognizer:spreadGestureRecognizer];
    [self.view addGestureRecognizer:shrinkGestureRecognizer];
    [self.contentItem addGestureRecognizer:panGestureRecognizer];
}
#pragma mark - Bind
- (void)bindViewModel{
    [super bindViewModel];
    
}

#pragma mark - Public Methods

- (void)spread {
    if (self.isShow) {
        return;
    }
    [self stopTimer];
    [self invokeActionBeginDelegate];
    [self setShow:YES];
    NSUInteger count = _viewControllers.firstObject.items.count;
    for (int i = 0; i < count; i++) {
        IDCMDebugItemView *item = _viewControllers.firstObject.items[i];
        item.alpha = 0;
        item.center = _contentPoint;
        [self.view addSubview:item];
        [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
            item.center = [IDCMDebugPosition positionWithCount:count index:i].center;
            item.alpha = 1;
        }];
    }
    
    [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
        _contentView.frame = [IDCMDebugItemView contentViewSpreadFrame];
        _effectView.frame = _contentView.bounds;
        _contentView.alpha = 1;
        _contentItem.center = [IDCMDebugPosition positionWithCount:count index:count - 1].center;
        _contentItem.alpha = 0;
    }];
}

- (void)shrink {
    if (!self.isShow) {
        return;
    }
    [self beginTimer];
    [self setShow:NO];
    for (IDCMDebugItemView *item in _viewControllers.lastObject.items) {
        [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
            item.center = _contentPoint;
            item.alpha = 0;
        }];
    }
    [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
        _viewControllers.lastObject.backItem.center = _contentPoint;
        _viewControllers.lastObject.backItem.alpha = 0;
    }];
    
    [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
        _contentView.frame = CGRectMake(0, 0, [IDCMDebugItemView itemImageWidth], [IDCMDebugItemView itemImageWidth]);
        _contentView.center = _contentPoint;
        _effectView.frame = _contentView.bounds;
        _contentItem.alpha = 1;
        _contentItem.center = _contentPoint;
    } completion:^(BOOL finished) {
        for (IDCMDebugResponder *viewController in _viewControllers) {
            [viewController.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [viewController.backItem removeFromSuperview];
        }
        _viewControllers = [NSMutableArray arrayWithObject:_viewControllers.firstObject];
        [self invokeActionEndDelegate];
    }];
}

- (void)pushViewController:(IDCMDebugResponder *)viewController atPisition:(IDCMDebugPosition *)position {
    IDCMDebugResponder *oldViewController = _viewControllers.lastObject;
    for (IDCMDebugItemView *item in oldViewController.items) {
        [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
            item.alpha = 0;
        }];
    }
    [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
        oldViewController.backItem.alpha = 0;
    }];
    
    NSUInteger count = viewController.items.count;
    for (int i = 0; i < count; i++) {
        IDCMDebugItemView *item = viewController.items[i];
        item.alpha = 0;
        item.center = position.center;
        [self.view addSubview:item];
        [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
            item.center = [IDCMDebugPosition positionWithCount:count index:i].center;
            item.alpha = 1;
        }];
    }
    viewController.backItem.alpha = 0;
    viewController.backItem.center = position.center;
    [self.view addSubview:viewController.backItem];
    [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
        viewController.backItem.center = self.view.center;
        viewController.backItem.alpha = 1;
    }];
    
    viewController.navigationController = self;
    [_viewControllers addObject:viewController];
    [_pushPosition addObject:position];
}

- (void)popViewController {
    if (_pushPosition.count > 0) {
        IDCMDebugPosition *position = _pushPosition.lastObject;
        for (IDCMDebugItemView *item in _viewControllers.lastObject.items) {
            [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
                item.center = position.center;
                item.alpha = 0;
            }];
        }
        [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
            _viewControllers.lastObject.backItem.center = position.center;
            _viewControllers.lastObject.backItem.alpha = 0;
        } completion:^(BOOL finished) {
            [_viewControllers.lastObject.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [_viewControllers.lastObject.backItem removeFromSuperview];
            [_viewControllers removeLastObject];
            [_pushPosition removeLastObject];
            for (IDCMDebugItemView *item in _viewControllers.lastObject.items) {
                [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
                    item.alpha = 1;
                }];
            }
            [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
                _viewControllers.lastObject.backItem.alpha = 1;
            }];
        }];
    }
}


#pragma mark - Privater Methods
- (void)invokeActionBeginDelegate {
    if (!self.isShow && _delegate && [_delegate respondsToSelector:@selector(manngerController:actionBeginAtPoint:)]) {
        [_delegate manngerController:self actionBeginAtPoint:self.contentPoint];
    }
}

- (void)invokeActionEndDelegate {
    if (_delegate && [_delegate respondsToSelector:@selector(manngerController:actionEndAtPoint:)]) {
        [_delegate manngerController:self actionEndAtPoint:self.contentPoint];
    }
}

#pragma mark - Action
- (void)panGestureAction:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    
    static CGPoint pointOffset;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pointOffset = [gestureRecognizer locationInView:self.contentItem];
    });
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self invokeActionBeginDelegate];
        [self stopTimer];
        [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
            self.contentAlpha = 1;
        }];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.contentPoint = CGPointMake(point.x + [IDCMDebugItemView itemImageWidth] / 2 - pointOffset.x, point.y  + [IDCMDebugItemView itemImageWidth] / 2 - pointOffset.y);
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded
               || gestureRecognizer.state == UIGestureRecognizerStateCancelled
               || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
            self.contentPoint = [self stickToPointByHorizontal];
        } completion:^(BOOL finished) {
            [self invokeActionEndDelegate];
            onceToken = NO;
            [self beginTimer];
        }];
    }
}
- (CGPoint)stickToPointByHorizontal {
    CGRect screen = [UIScreen mainScreen].bounds;
    CGPoint center = self.contentPoint;
    if (center.y < center.x && center.y < -center.x + screen.size.width) {
        CGPoint point = CGPointMake(center.x, [IDCMDebugItemView margin] + [IDCMDebugItemView itemImageWidth] / 2);
        point = [self makePointValid:point];
        return point;
    } else if (center.y > center.x + screen.size.height - screen.size.width
               && center.y > -center.x + screen.size.height) {
        CGPoint point = CGPointMake(center.x, CGRectGetHeight(screen) - [IDCMDebugItemView itemImageWidth] / 2 - [IDCMDebugItemView margin]);
        point = [self makePointValid:point];
        return point;
    } else {
        if (center.x < screen.size.width / 2) {
            CGPoint point = CGPointMake([IDCMDebugItemView margin] + [IDCMDebugItemView itemImageWidth] / 2, center.y);
            point = [self makePointValid:point];
            return point;
        } else {
            CGPoint point = CGPointMake(CGRectGetWidth(screen) - [IDCMDebugItemView itemImageWidth] / 2 - [IDCMDebugItemView margin], center.y);
            point = [self makePointValid:point];
            return point;
        }
    }
}

- (CGPoint)makePointValid:(CGPoint)point {
    CGRect screen = [UIScreen mainScreen].bounds;
    if (point.x < [IDCMDebugItemView margin] + [IDCMDebugItemView itemImageWidth] / 2) {
        point.x = [IDCMDebugItemView margin] + [IDCMDebugItemView itemImageWidth] / 2;
    }
    if (point.x > CGRectGetWidth(screen) - [IDCMDebugItemView itemImageWidth] / 2 - [IDCMDebugItemView margin]) {
        point.x = CGRectGetWidth(screen) - [IDCMDebugItemView itemImageWidth] / 2 - [IDCMDebugItemView margin];
    }
    if (point.y < [IDCMDebugItemView margin] + [IDCMDebugItemView itemImageWidth] / 2) {
        point.y = [IDCMDebugItemView margin] + [IDCMDebugItemView itemImageWidth] / 2;
    }
    if (point.y > CGRectGetHeight(screen) - [IDCMDebugItemView itemImageWidth] / 2 - [IDCMDebugItemView margin]) {
        point.y = CGRectGetHeight(screen) - [IDCMDebugItemView itemImageWidth] / 2 - [IDCMDebugItemView margin];
    }
    return point;
}
- (void)beginTimer {
    _timer = [NSTimer timerWithTimeInterval:[IDCMDebugItemView activeDuration] target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)timerFired {
    [UIView animateWithDuration:[IDCMDebugItemView animationDuration] animations:^{
        self.contentAlpha = [IDCMDebugItemView inactiveAlpha];
    }];
    [self stopTimer];
}
#pragma mark - Getter & Setter

- (void)moveContentViewToPoint:(CGPoint)point {
    self.contentPoint = point;
}

- (void)setContentPoint:(CGPoint)contentPoint {
    if (!self.isShow) {
        _contentPoint = contentPoint;
        _contentView.center = _contentPoint;
        _contentItem.center = _contentPoint;
    }
}

- (void)setContentAlpha:(CGFloat)contentAlpha {
    if (!self.isShow) {
        _contentAlpha = contentAlpha;
        _contentView.alpha = _contentAlpha;
        _contentItem.alpha = _contentAlpha;
    }
}

- (void)setViewControllers:(NSMutableArray<IDCMDebugResponder *> *)viewControllers {
    _viewControllers = viewControllers;
}

@end

static const void *navigationControllerKey = &navigationControllerKey;

@implementation IDCMDebugResponder (IDCMDebugManngerControllerItem)

@dynamic navigationController;

- (IDCMDebugManngerController *)navigationController {
    return objc_getAssociatedObject(self, navigationControllerKey);
}
- (void)setNavigationController:(IDCMDebugManngerController *)navigationController {
    objc_setAssociatedObject(self, navigationControllerKey, navigationController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
