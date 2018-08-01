//
//  IDCMHUD+EmptyView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMHUD.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EmptyViewPositon) {
    EmptyViewPositon_Center,    // 中间
    EmptyViewPositon_Top,      //  顶部开始
//    EmptyViewPositon_Bottom,//   可以多选
};


@interface IDCMHUDConfigure : NSObject
typedef IDCMHUDConfigure *(^instancetypeBlock)(id value);

- (instancetypeBlock)backgroundImage;
- (instancetypeBlock)image;
- (instancetypeBlock)title;
- (instancetypeBlock)subTitle;
- (instancetypeBlock)btnTitle;
- (instancetypeBlock)btnImage;
- (instancetypeBlock)btnBackgroundImage;
- (instancetypeBlock)contentFrame;
- (instancetypeBlock)positionConfigure;
@end



typedef void(^configureBlock)(IDCMHUDConfigure *configure);
typedef void (^reloadBlock)(void);
@interface IDCMHUD (EmptyView)


/**
 类方法初始化缺省View

 @param view 将要加到的view
 @param configure 一些配置属性
 @param reloadCallback 按钮点击的回调 当是nil的时候 按钮将会隐藏
 */
+ (void)showEmptyViewToView:(UIView *)view
                  configure:(configureBlock)configure
             reloadCallback:(reloadBlock)reloadCallback;



/**
 消除缺省View

 @param view 之前加载到的view
 */
+ (void)dismissEmptyViewForView:(UIView *)view;




@end





