//
//  RACCommand+Extension.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/13.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "RACCommand.h"
typedef void (^CommandInputBlock)(id input);
typedef RACCommand *(^EmtyCommandBloack)(CommandInputBlock inputBlock);
typedef RACCommand *(^EmtyEnabledCommandBloack)(RACSignal *enabledSignal ,CommandInputBlock inputBlock);
typedef RACCommand *(^CommandBloack)(RACSignal *signal, CommandInputBlock inputBlock);
typedef RACCommand *(^EnabledcommandBloack)(RACSignal *signal,RACSignal *enabledSignal ,CommandInputBlock inputBlock);



@interface RACCommand (Extension)


/**
 空信号的Command

 @return 设值的block
 */
+ (EmtyCommandBloack)emptyCommand;


/**
  空信号的控制enabled的Command

 @return 设值的block
 */
+ (EmtyEnabledCommandBloack)emptyEnabledCommand;


/**
 正常的command

 @return 设值的block
 */
+ (CommandBloack)command;


/**
 正常控制的enabled的Command
 
 @return 设值的block
 */
+ (EnabledcommandBloack)enabledcommand;


// 方法简写
- (RACDisposable *)subscribeNext:(void (^)(id value))nextBlock;
- (RACDisposable *)subscribeError:(void (^)(NSError *error))errorBlock;
- (RACDisposable *)subscribeCompleted:(void (^)(id value))completedBlock;
- (NSArray<RACDisposable *> *)subscribeNext:(void (^)(id value))nextBlock
                                      error:(void (^)(NSError *error))errorBlock
                                  completed:(void (^)(id value))completedBlock;

@end














