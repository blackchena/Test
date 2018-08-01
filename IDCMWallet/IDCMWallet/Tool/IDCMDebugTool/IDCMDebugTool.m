//
//  IDCMDebugTool.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMDebugTool.h"
#import "IDCMDebugManngerController.h"
@interface IDCMDebugTool ()<IDCMDebugManngerControllerDelegate>
@property (nonatomic, strong) UIWindow *assistiveWindow;
@property (nonatomic, assign) CGPoint assistiveWindowPoint;
@property (nonatomic, assign) CGPoint coverWindowPoint;
@property (nonatomic, strong) IDCMDebugManngerController *navigationController;
@end

@implementation IDCMDebugTool

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        IDCMDebugResponder *rootViewController = [IDCMDebugResponder new];
        _navigationController = [[IDCMDebugManngerController alloc] initWithRootViewController:rootViewController];
        _assistiveWindowPoint = [IDCMDebugItemView cotentViewDefaultPoint];

        @weakify(self);
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
            @strongify(self);
            [self keyboardWillChangeFrame:x];
        }];
        [[self
          rac_signalForSelector:@selector(manngerController:actionBeginAtPoint:)
          fromProtocol:@protocol(IDCMDebugManngerControllerDelegate)]
         subscribeNext:^(RACTuple *tuple) {
             @strongify(self);
             [self beginAtPoint];
         }];
        [[self
          rac_signalForSelector:@selector(manngerController:actionEndAtPoint:)
          fromProtocol:@protocol(IDCMDebugManngerControllerDelegate)]
         subscribeNext:^(RACTuple *tuple) {
             @strongify(self);
              CGPoint point = [tuple.second CGPointValue];
             [self endAtPoint:point];
         }];
        _navigationController.delegate = self;
    }
    return self;
}

#pragma mark - Public Methods
- (void)showDebugTool {
    _assistiveWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [IDCMDebugItemView itemImageWidth], [IDCMDebugItemView itemImageWidth])];
    _assistiveWindow.center = _assistiveWindowPoint;
    _assistiveWindow.windowLevel = CGFLOAT_MAX;
    _assistiveWindow.backgroundColor = [UIColor clearColor];
    _assistiveWindow.rootViewController = _navigationController;
    _assistiveWindow.layer.masksToBounds = YES;
    [self makeVisibleWindow];
}

#pragma mark - Privater Methods
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    /*因为动画过程中不能实时修改_assistiveWindowRect,
     *所以如果执行点击操作的话,_assistiveTouchView位置会以动画之前的位置为准.
     *如果执行拖动操作则会有跳动效果.所以需要禁止操作.*/
    _assistiveWindow.userInteractionEnabled = NO;
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //根据实时位置计算于键盘的间距
    CGFloat yOffset = endKeyboardRect.origin.y - CGRectGetMaxY(_assistiveWindow.frame);
    
    //如果键盘弹起给_coverWindowPoint赋值
    if (endKeyboardRect.origin.y < CGRectGetHeight([UIScreen mainScreen].bounds)) {
        _coverWindowPoint = _assistiveWindowPoint;
    }
    
    //根据间距计算移动后的位置viewPoint
    CGPoint viewPoint = _assistiveWindow.center;
    viewPoint.y += yOffset;
    //如果viewPoint在原位置之下,将viewPoint变为原位置
    if (viewPoint.y > _coverWindowPoint.y) {
        viewPoint.y = _coverWindowPoint.y;
    }
    //如果_assistiveWindow被移动,将viewPoint变为移动后的位置
    if (CGPointEqualToPoint(_coverWindowPoint, CGPointZero)) {
        viewPoint.y = _assistiveWindow.center.y;
    }
    
    //根据计算好的位置执行动画
    [UIView animateWithDuration:duration animations:^{
        _assistiveWindow.center = viewPoint;
    } completion:^(BOOL finished) {
        //将_assistiveWindowRect变为移动后的位置并恢复用户操作
        _assistiveWindowPoint = _assistiveWindow.center;
        _assistiveWindow.userInteractionEnabled = YES;
        //使其遮盖键盘
        if ([[UIDevice currentDevice].systemVersion integerValue] < 10) {
            [self makeVisibleWindow];
        }
    }];
}
- (void)makeVisibleWindow {
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    [_assistiveWindow makeKeyAndVisible];
    if (keyWindows) {
        [keyWindows makeKeyWindow];
    }
}
- (void)beginAtPoint{
    _coverWindowPoint = CGPointZero;
    _assistiveWindow.frame = [UIScreen mainScreen].bounds;
    _navigationController.view.frame = [UIScreen mainScreen].bounds;
    [_navigationController moveContentViewToPoint:_assistiveWindowPoint];
}
- (void)endAtPoint:(CGPoint)point{
    _assistiveWindowPoint = point;
    _assistiveWindow.frame = CGRectMake(0, 0, [IDCMDebugItemView itemImageWidth], [IDCMDebugItemView itemImageWidth]);
    _assistiveWindow.center = _assistiveWindowPoint;
    CGPoint contentPoint = CGPointMake([IDCMDebugItemView itemImageWidth] / 2, [IDCMDebugItemView itemImageWidth] / 2);
    [_navigationController moveContentViewToPoint:contentPoint];
}

@end
