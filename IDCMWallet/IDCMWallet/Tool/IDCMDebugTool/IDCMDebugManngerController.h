//
//  IDCMDebugManngerController.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewController.h"
#import "IDCMDebugResponder.h"

@class IDCMDebugManngerController;

@protocol IDCMDebugManngerControllerDelegate <NSObject>

@optional;
- (void)manngerController:(IDCMDebugManngerController *)navigationController actionBeginAtPoint:(CGPoint)point;
- (void)manngerController:(IDCMDebugManngerController *)navigationController actionEndAtPoint:(CGPoint)point;

@end

@interface IDCMDebugManngerController : IDCMBaseViewController

- (instancetype)initWithRootViewController:(nullable IDCMDebugResponder *)viewController NS_DESIGNATED_INITIALIZER;

- (void)spread;
- (void)shrink;
- (void)pushViewController:(IDCMDebugResponder *)viewController atPisition:(IDCMDebugPosition *)position;
- (void)popViewController;

- (void)moveContentViewToPoint:(CGPoint)point;

@property (nonatomic, strong, readonly) NSMutableArray<IDCMDebugResponder *> *viewControllers;
@property (nonatomic, assign, readonly, getter=isShow) BOOL show;
@property (nonatomic, assign) id<IDCMDebugManngerControllerDelegate> delegate;

@end


@interface IDCMDebugResponder (IDCMDebugManngerControllerItem)

@property (nonatomic, assign) IDCMDebugManngerController *navigationController;

@end
