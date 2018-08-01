//
//  RACSubject+Extension.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "RACSubject.h"
typedef void (^subscribeBlock)(id value);
typedef RACSubject *(^subjectBlock)(subscribeBlock subscribe);

@interface RACSubject (Extension)

+ (subjectBlock)createSubject;

@end
