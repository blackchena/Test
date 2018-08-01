//
//  IDCMDataManager.h
//  IDCMWallet
//
//  Created by BinBear on 2018/4/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCMSysSettingModel.h"
#import "IDCMPrecisionModel.h"
#import "IDCMPrecisionBaseModel.h"

typedef NS_ENUM(NSUInteger, IDCMDataManagerObjectType) {
    kIDCMDataManagerObjectTypeDefault                                      = 1, // 默认,无类型
    kIDCMDataManagerObjectTypeCreatPhrase                                  = 2, // 创建钱包时，进入的备份助记词页面
    kIDCMDataManagerObjectTypeBackupPhrase                                 = 3  // 进入钱包时，进入的备份助记词页面
};

typedef NS_ENUM(NSUInteger, IDCMCurrencyPrecisionType) {
    kIDCMCurrencyPrecisionMarket                                        = 1, // 行情
    kIDCMCurrencyPrecisionAssets                                        = 2, // 资产
    kIDCMCurrencyPrecisionTotalAssets                                   = 3, // 总资产
    kIDCMCurrencyPrecisionQuantity                                      = 4, // 币种数量
    kIDCMCurrencyPrecisionMoney                                         = 5  // 币种法币
};


@interface IDCMDataManager : NSObject

/**
 *  数据类型
 */
@property (assign, nonatomic) IDCMDataManagerObjectType objectType;

/**
 数据管理单例

 @return 但是单例对象
 */
+ (instancetype)sharedDataManager;

@property (strong, nonatomic) NSString *userID;

@property (strong, nonatomic, readonly) RACSubject *oneSecondSubject;

@property (strong, nonatomic, readonly) RACSubject *tenSecondSubject;

@property (strong, nonatomic) IDCMSysSettingModel *settingModel;

@property (assign, nonatomic) NSInteger cancelCount;

@property (strong, nonatomic) IDCMPrecisionModel *precisionModel;

- (NSInteger)getCurrencyPrecisionWithCurrency:(NSString *)currencyUnit withType:(IDCMCurrencyPrecisionType)type;

@end
