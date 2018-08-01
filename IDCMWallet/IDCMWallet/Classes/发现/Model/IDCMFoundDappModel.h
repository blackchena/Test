//
//  IDCMFoundDappModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/22.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMDappModel : NSObject
/**
 *   id
 */
@property (strong, nonatomic) NSNumber *ID;
/**
 *  图片
 */
@property (copy, nonatomic) NSString *LogoUrl;
/**
 *  标题
 */
@property (copy, nonatomic) NSString *DappName;
/**
 *   跳转链接
 */
@property (copy, nonatomic) NSString *Url;
@end


@interface IDCMFoundDappModel : NSObject
/**
 *  模块标题
 */
@property (copy, nonatomic) NSString *ModuleName;
/**
 *  dapp数组
 */
@property (strong, nonatomic) NSArray<IDCMDappModel *> *DappList;
@end
