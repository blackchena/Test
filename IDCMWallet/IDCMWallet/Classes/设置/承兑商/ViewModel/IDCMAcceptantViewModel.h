//
//  IDCMAcceptantViewModel.h
//  IDCMWallet
//
//  Created by wangpu on 2018/5/12.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMAcceptantViewModel : IDCMBaseViewModel

@property (nonatomic,strong) RACCommand *OTCGetStateCommand; //获取当前保证金币种和余额

@end

@interface IDCMAcceptantDepositModel : IDCMBaseViewModel

@property (nonatomic,copy) NSString * dataID;//(integer, optional): 保证金id
@property (nonatomic,copy) NSString * coinID;//(integer, optional): 币种ID
@property (nonatomic,copy) NSString * coinCode;
@property (nonatomic,copy) NSString * coinName;
@property (nonatomic,copy) NSString * logo;
@property (nonatomic,strong) NSNumber * useAmount;//(number, optional): 可用余额
@property (nonatomic,strong) NSNumber * precision;
@property (nonatomic,strong) NSString * premium;//(number, optional): 精度
@property (nonatomic,copy) NSString * sort;
@property (nonatomic,assign) BOOL isSelect;

-(NSString *) useAmountStr;
-(NSString *)coinNameUpperStr;
@end
