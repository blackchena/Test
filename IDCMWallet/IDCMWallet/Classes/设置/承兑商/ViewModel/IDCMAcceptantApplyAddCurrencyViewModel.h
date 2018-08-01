//
//  IDCMAcceptantApplyAddCurrencyViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"


typedef NS_ENUM(NSUInteger, AddCurrencyType) {
    AddCurrencyType_Buy ,       // 买币
    AddCurrencyType_Sell,       // 卖币
    AddCurrencyType_BuyEdit,     //买编辑
    AddCurrencyType_SellEdit// 卖编辑
};
@class IDCMAcceptantCoinModel;

@interface IDCMAcceptantApplyAddCurrencyViewModel : IDCMBaseViewModel
@property (nonatomic,copy)  NSAttributedString *currency; // 承兑币种
@property (nonatomic,copy)  NSString *maxValue; // 承兑上限
@property (nonatomic,copy)  NSString *minValue; // 承兑下限
@property (nonatomic,copy)  NSString *premiumPrice; // 承兑溢价
@property (nonatomic,copy)  NSString *title; // 当前控制器nav标题
@property (nonatomic,strong) RACCommand * saveCommand;
@property (nonatomic,strong) RACCommand * getOtcCoinListCommand;//获取承兑币种
@property (nonatomic,assign) AddCurrencyType  currencyType;
@property (nonatomic,strong) NSDictionary *editDict;
@property (nonatomic,strong) IDCMAcceptantCoinModel * selectModel;

@property (nonatomic,strong) NSMutableArray <IDCMAcceptantCoinModel *>  * acceptantCoinList; // 承兑币种列表

@end
