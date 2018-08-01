//
//  IDCMOTCExchangeSellCurrencyView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IDCMOTCExchangeSellCurrencyViewModel;
typedef NS_OPTIONS(NSInteger, PurchaseType){
    BUYTYPE = 1,
    SELLTYPE = 2
};

@interface IDCMOTCExchangeSellCurrencyView : UIView
/**
 购买类型  买/卖
 */
@property(nonatomic,assign)PurchaseType purchaseType ;

+ (instancetype)OTCSellCurrencyViewViewModel:(IDCMOTCExchangeSellCurrencyViewModel *)viewModel;

@property(nonatomic,strong)RACSubject *subject ;

-(void)resetNewData;
@end
