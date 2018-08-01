//
//  IDCMAcceptantApplyAddPayCurrencyViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@class  IDCMLocalCurrencyModel;

typedef NS_ENUM(NSUInteger, AcceptantAddCurrencyWithAmountType) {
    AddCurrencyTypeAndAmount,       // 添加
    EditCurrencyTypeAndAmount,       // 编辑
};
@interface IDCMAcceptantApplyAddPayCurrencyViewModel : IDCMBaseViewModel

@property (nonatomic,strong) NSAttributedString *currency; //法币币种
@property (nonatomic,strong) NSString *selectCurrency; //选中的currency
@property (nonatomic,copy) NSString *amountValue; //资金量
@property (nonatomic,copy) NSString *title; //当前控制器 标题

@property (nonatomic,strong) IDCMLocalCurrencyModel * selectModel; //

@property (nonatomic,strong) RACCommand *saveCommand; ////添加法币和数量
@property (nonatomic,strong) RACCommand * getOtcLocalCurrencyListCommand;//获取法币币种
@property (nonatomic,strong) NSDictionary *editDict; //编辑 跳转传参
@property (nonatomic,strong) NSMutableArray< IDCMLocalCurrencyModel *>  * currencysList; //法币币种列表
@property (nonatomic, assign) AcceptantAddCurrencyWithAmountType pageType; //页面类型 编辑 或者 添加


@end
