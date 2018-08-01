//
//  IDCMManagerObjTool.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMManagerObjTool : NSObject
/**
 创建一个单例来管理用户信息数据
 
 @return RMTBaseModel 的单例
 */
+ (IDCMManagerObjTool *)manager;
/**
  是否允许使用第三方键盘
 */
@property (nonatomic,assign) BOOL allThirdKeyBord;

/**
 是否已经在当前的 didShowPasswordView 的界面
 */
@property (nonatomic,assign) BOOL didShowPasswordView;
/**
 开始进入后台的时间
 */
@property (nonatomic,assign) NSInteger startEnterBackgroundTime;
/**
 进入前台的时间
 */
@property (nonatomic,assign) NSInteger didEnterFontgroundTime;

@end
