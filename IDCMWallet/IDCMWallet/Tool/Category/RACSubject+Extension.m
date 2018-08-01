//
//  RACSubject+Extension.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "RACSubject+Extension.h"


@implementation RACSubject (Extension)

+ (subjectBlock)createSubject {
    return ^RACSubject *(subscribeBlock subscribe){
        RACSubject *subject = [RACSubject subject];
        [subject subscribeNext:subscribe];
        return subject;
    };
}

@end
