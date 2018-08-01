//
//  IDCMManagerObjTool.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMManagerObjTool.h"

static IDCMManagerObjTool *managerObj_Tool;
static dispatch_once_t onceToken;

@implementation IDCMManagerObjTool
/**
 创建一个单例来管理用户信息数据
 
 @return RMTBaseModel 的单例
 */
+ (IDCMManagerObjTool *)manager
{
    dispatch_once(&onceToken, ^{
        managerObj_Tool = [[IDCMManagerObjTool alloc] init];
    });
    return managerObj_Tool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allThirdKeyBord = YES;
    }
    return self;
}
@end
