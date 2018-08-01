//
//  IDCMBaseViewController.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/22.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ControllerBackGestureState) {
    ControllerBackGestureState_No,
    ControllerBackGestureState_Begin,
    ControllerBackGestureState_Change,
    ControllerBackGestureState_SuccessPop,
    ControllerBackGestureState_FailPop
};

typedef void(^CompletionBlock)(NSDictionary *para);

@class IDCMBaseViewModel;

@interface IDCMBaseViewController : UIViewController
/**
 *  viewModel
 */
@property (strong, nonatomic, readonly) IDCMBaseViewModel *viewModel;
@property (nonatomic,assign) ControllerBackGestureState  backGestureState;
@property (nonatomic,copy) CompletionBlock completion;///< 完成回调
- (void)hookControllerBackGestureWithState:(ControllerBackGestureState)state;
- (void)handleBackGestureViewWillAppear;
- (void)handleBackGestureViewDidAppear;

- (instancetype)initWithViewModel:(IDCMBaseViewModel *)viewModel;
- (void)bindViewModel;
+ (void)popCallBack:(NSDictionary *)para;

//右侧的按钮
- (UIBarButtonItem *)createRightBarButtonItem:(NSString *)title target:(id)obj selector:(SEL)selector ImageName:(NSString*)imageName;

@end
