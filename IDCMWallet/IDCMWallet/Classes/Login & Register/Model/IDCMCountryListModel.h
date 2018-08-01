//
//  IDCMCountryListModel.h
//  IDCMExchange
//
//  Created by BinBear on 2017/12/6.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseModel.h"

@interface IDCMCountryListModel : IDCMBaseModel
/**
 *   国家名
 */
@property (copy, nonatomic) NSString *Name;
/**
 *   国家代码
 */
@property (copy, nonatomic) NSString *ID;
/**
 *   区号
 */
@property (copy, nonatomic) NSString *Areacode;
@end

/*
 
 "CountryList": null,
 "Name": "中国",
 "Code": "CN",
 "Areacode": "+86",
 "LanguageType": "zh-CN",
 "SortNumber": 1,
 "ID": "2a233f8804432143",
 "CreatorID": null,
 "CreateTime": "2016-06-01T00:00:00",
 "LastUpdateUserID": "FFFFFFFFFFFFFFFF",
 "LastUpdateTime": "2016-06-01T13:58:50"
 
 */

