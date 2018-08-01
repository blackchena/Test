//
//  IDCMDataManager.m
//  IDCMWallet
//
//  Created by BinBear on 2018/4/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMDataManager.h"

@interface IDCMDataManager()
@property (nonatomic, assign) NSUInteger time;

//@property (strong, nonatomic) NSString *userID;

@property (strong, nonatomic) RACSubject *oneSecondSubject;

@property (strong, nonatomic) RACSubject *tenSecondSubject;
@end

@implementation IDCMDataManager
+ (instancetype)sharedDataManager
{
    static IDCMDataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[IDCMDataManager alloc] init];
        _sharedManager.objectType = kIDCMDataManagerObjectTypeDefault;
    });
    
    return _sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
        self.userID = model.userID;
        self.oneSecondSubject = [RACSubject subject];
        self.tenSecondSubject = [RACSubject subject];
        [self setupTime];
    }
    return self;
}

- (void)setupTime{
    @weakify(self);
    [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        [self.oneSecondSubject sendNext:@(1)];
        self.time += 1;
        if (self.time >= 10){
            self.time = 0;
            [self.tenSecondSubject sendNext:nil];
        }
    }];
}
- (NSInteger)getCurrencyPrecisionWithCurrency:(NSString *)currencyUnit withType:(IDCMCurrencyPrecisionType)type{
    
    NSArray *arr ;
    switch (type) {
        case kIDCMCurrencyPrecisionMarket: // 行情
        {
            arr = self.precisionModel.Market;
        }
            break;
        case kIDCMCurrencyPrecisionAssets: // 资产
        {
            arr = self.precisionModel.Assets;
        }
            break;
        case kIDCMCurrencyPrecisionTotalAssets: // 总资产
        {
            arr = self.precisionModel.TotalAssets;
        }
            break;
        case kIDCMCurrencyPrecisionQuantity: // 币种数量
        {
            arr = self.precisionModel.CurrencyQuantity;
        }
            break;
        default: // 币种法币
        {
            arr = self.precisionModel.CurrencyMoney;
        }
            break;
    }
    
    __block NSInteger precison = 4;
    [arr enumerateObjectsUsingBlock:^(IDCMPrecisionBaseModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (type == kIDCMCurrencyPrecisionTotalAssets) {
            precison = model.accuracy;
        }else{
            
            if (![currencyUnit isKindOfClass:[NSString class]] || ![currencyUnit isNotBlank]) {
                
                if (type == kIDCMCurrencyPrecisionQuantity) {
                    precison = 4;
                }else{
                    precison = 2;
                }
                
            }else{
                
                if ([model.currency isEqualToString:currencyUnit]) {
                    precison = model.accuracy;
                }
            }
            
        }
    }];
    
    return precison;
}
@end
