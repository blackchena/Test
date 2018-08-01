//
//  IDCMIntroductionModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/2/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMIntroductionModel : IDCMBaseModel
/**
 *  id
 */
@property (strong, nonatomic) NSNumber *ID;
/**
 *   版本
 */
@property (copy, nonatomic) NSString *version;
/**
 *   版本名字
 */
@property (copy, nonatomic) NSString *version_name;
/**
 *   客户端
 */
@property (copy, nonatomic) NSString *client;
/**
 *   修改时间
 */
@property (copy, nonatomic) NSString *modifyTime;
/**
 *   修改
 */
@property (copy, nonatomic) NSString *modifyBy;
/**
 *   创建时间
 */
@property (copy, nonatomic) NSString *createTime;
/**
 *   创建
 */
@property (copy, nonatomic) NSString *createBy;
/**
 *   是否更新
 */
@property (strong, nonatomic) NSNumber *isItUpdate;
/**
 *   更新地址
 */
@property (copy, nonatomic) NSString *app_update_url;
/**
 *   更新说明
 */
@property (copy, nonatomic) NSString *version_introduction;
/**
 *   更新说明链接
 */
@property (copy, nonatomic) NSString *version_introduction_url;

/**
 customer
 */
@property (copy, nonatomic) NSString *customerTime;
@end

/*
 "id": 0,
 "version": "string",
 "version_name": "string",
 "client": "string",
 "modifyTime": "2018-02-06T10:00:19.575Z",
 "modifyBy": "string",
 "createTime": "2018-02-06T10:00:19.575Z",
 "createBy": "string",
 "isItUpdate": true,
 "app_update_url": "string",
 "version_introduction": "string",
 "version_introduction_url": "string"
 
 */
