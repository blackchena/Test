//
//  IDCMOTCChatModel.m
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCChatModel.h"


@implementation IDCMOTCChatObjectId

@end
@implementation IDCMOTCChatModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"Id":[IDCMOTCChatObjectId class],
             };
}

//是否是发送
- (BOOL )j_send{
    return [self.SendUserID isKindOfClass:[NSString class]] && [self.SendUserID isEqualToString:[IDCMDataManager sharedDataManager].userID];
}
//是否是文本
- (BOOL )j_isText{
    return [self.Message isKindOfClass:[NSString class]] && self.Message.length > 0;
}

@end
