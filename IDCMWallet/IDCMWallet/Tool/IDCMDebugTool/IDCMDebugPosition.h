//
//  IDCMDebugPosition.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/31.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMDebugPosition : NSObject
+ (instancetype)positionWithCount:(NSInteger)count index:(NSInteger)index;
- (instancetype)initWithCount:(NSInteger)count index:(NSInteger)index NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGRect frame;
@end
