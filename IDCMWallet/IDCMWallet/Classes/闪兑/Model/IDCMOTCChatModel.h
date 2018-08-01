//
//  IDCMOTCChatModel.h
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMOTCChatObjectId : IDCMBaseModel
@property (nonatomic,assign) NSInteger Timestamp;// (integer, optional, read only),
@property (nonatomic,assign) NSInteger Machine;// (integer, optional, read only),
@property (nonatomic,assign) NSInteger Pid;// (integer, optional, read only),
@property (nonatomic,assign) NSInteger Increment;// (integer, optional, read only),
@property (nonatomic,copy)   NSString *CreationTime;// (string, optional, read only)
@end

@interface IDCMOTCChatModel : IDCMBaseModel

@property (nonatomic,copy)   NSString *SendUserID;// (string, optional),
@property (nonatomic,copy)   NSString *UserID;// (string, optional),
@property (nonatomic,copy)   NSString *GroupName;// (string, optional),
@property (nonatomic,assign) NSInteger ChatObjectCategory;// (integer, optional) = ['0', '1'],
@property (nonatomic,copy)   NSString *Message;// (string, optional),
@property (nonatomic,copy)   NSString *FileUrl;// (string, optional),
@property (nonatomic,copy)   IDCMOTCChatObjectId *Id;// (ObjectId, optional),
@property (nonatomic,copy)   NSString *State;// (string, optional),
@property (nonatomic,copy)   NSString *CreateTime;// (string, optional),
@property (nonatomic,copy)   NSString *UpdateTime;// (string, optional)
@property (nonatomic,assign) NSInteger TimeStamp;//时间戳

@property (nonatomic,assign)   BOOL  sendFail;
@property (nonatomic,assign)   BOOL  showTime;

//是否是发送
- (BOOL )j_send;
//是否是文本
- (BOOL )j_isText;
@end
