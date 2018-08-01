//
//  IDCMNewsModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/13.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMNewsModel : NSObject
/**
 *  id
 */
@property (strong, nonatomic) NSNumber *ID;
/**
 *  消息id
 */
@property (strong, nonatomic) NSNumber *msId;
/**
 *  类型
 */
@property (strong, nonatomic) NSNumber *msgType;
/**
 *   标题
 */
@property (copy, nonatomic) NSString *msgTitle;
/**
 *   消息内容
 */
@property (copy, nonatomic) NSString *msgContent;
/**
 *   左边按钮文字
 */
@property (copy, nonatomic) NSString *leftButtonTxt;
/**
 *    右边按钮文字
 */
@property (copy, nonatomic) NSString *rightButtonTxt;
/**
 *   左边是否跳转链接
 */
@property (copy, nonatomic) NSString *leftButtonJump;
/**
 *   右边按钮是否跳转链接
 */
@property (copy, nonatomic) NSString *rightButtonJump;
/**
 *   左边按钮跳转url
 */
@property (copy, nonatomic) NSString *leftButtonUrl;
/**
 *   右边按钮跳转url
 */
@property (copy, nonatomic) NSString *rightButtonUrl;
/**
 *    原始币种
 */
@property (copy, nonatomic) NSString *origCurrency;
/**
 *   接收币种
 */
@property (copy, nonatomic) NSString *receiveCurrency;
/**
 *   副标题
 */
@property (copy, nonatomic) NSString *secondaryTitle;
/**
 *   消息未读数
 */
@property (strong, nonatomic) NSNumber *unReadCount;
/**
 *   是否已读  0：未读 1：已读
 */
@property (strong, nonatomic) NSNumber *readed;
/**
 *   logo
 */
@property (copy, nonatomic) NSString *logo;
/**
 *   时间
 */
@property (copy, nonatomic) NSString *startTime;
/**
 *   跳转URL
 */
@property (copy, nonatomic) NSString *contentUrl;


/**
 customer
 */
@property (nonatomic,strong) NSString *customerTime;
@end

/*
 
 "id": 0,
 "msId": 0,
 "msgType": 1,
 "msgTitle": "string",
 "msgContent": "string",
 "leftButtonTxt": "string",
 "rightButtonTxt": "string",
 "leftButtonJump": true,
 "rightButtonJump": true,
 "leftButtonUrl": "string",
 "rightButtonUrl": "string",
 "secondaryTitle": "string",
 "msgTerminal": "string",
 "startTime": "2018-02-01T03:49:24.289Z",
 "origCurrency": "string",
 "receiveCurrency": "string",
 "unReadCount": 0
 "contentUrl": "string"

 "logo": "string",
 "readed": 0, 已读 0 未读 1已读 ,
 */
