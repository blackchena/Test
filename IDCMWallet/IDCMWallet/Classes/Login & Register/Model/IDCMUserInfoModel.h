//
//  IDCMUserInfoModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMUserInfoModel : IDCMBaseModel
/**
 *   id
 */
@property (copy, nonatomic) NSString *userID;
/**
 *   guid
 */
@property (copy, nonatomic) NSString *guid;
/**
 *   用户名
 */
@property (copy, nonatomic) NSString *user_name;
/**
 *   mobile
 */
@property (copy, nonatomic) NSString *mobile;
/**
 *   邮箱
 */
@property (copy, nonatomic) NSString *email;
/**
 *   手机号
 */
@property (copy, nonatomic) NSString *telphone;
/**
 *   验证加密串
 */
@property (copy, nonatomic) NSString *Ticket;
/**
 *   语言包标识
 */
@property (copy, nonatomic) NSString *language_url;
/**
 *   本地货币id
 */
@property (copy, nonatomic) NSNumber *local_currency;
/**
 *  是否设置支付密码 0:未设置  1：已设置
 */
@property (strong, nonatomic) NSNumber *payPasswordFlag;
/**
 *   本地货币名称
 */
@property (copy, nonatomic) NSString *local_currency_name;
/**
 *   device_id
 */
@property (copy, nonatomic) NSString *device_id;
@end

/*
 "id": 3145,
 "guid": "44354cf8-52e8-4e1b-92e1-705e116e09eb",
 "user_name": "binbin",
 "mobile": "8613528429673",
 "email": "",
 "telphone": "8613528429673",
 "Ticket": "C414AFA39800546837D75E4CA13C473BACF0F9FBA45E498E83FCA6EF65246186544E21420620D725102D279848EF28633C22FFE11F58DFABD1D8AD22109358A1DCE72606F44174AFD28E2779565D4E0A31B09D37F06E1CE86D0A1BA612C8F2DCE00573862C59866F381DBB6761D22FA43968BF86A990EDB98D5EC550FF1FC8C06646A79ECB1AECCB97F0CBA33A8319B6E108712E7345766629AABF5B9ABBB1BBFAF096B7A268E4D4ED508F76839791AE7C8AD9DCA0B1CF5C53A29B1A8A7D0803CBD770278EEDDBBF1EC89AD28155FB4C121C318DEA6ACBB5B2888F6A8904DF635C4E56DF7598B19E84ACD118D4C610582FE5D991BA191A15AC4B81F2B0F40C3E6F2366694A5978BDF85249A84E378D5B",
 "language_url": "en",
 payPasswordFlag = 0;
 "local_currency": 0,
 "local_currency_name": "USD"
 */
