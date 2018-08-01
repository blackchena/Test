//
//  IDCMPayMethodViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMPaymentListModel.h"

typedef NS_ENUM(NSUInteger, PayMethodViewType) {
    PayMethodViewType_Add,
    PayMethodViewType_Edit
};

typedef NS_ENUM(NSUInteger, PayMethodType) {
    PayMethodType_Network,
    PayMethodType_BankCard_USD,
    PayMethodType_BankCard_CNY,
    PayMethodType_BankCard_VND
};


@interface IDCMPayMethodViewModel : IDCMBaseViewModel

@property (nonatomic,strong) RACCommand *GetPaymentModeCommand;///< 获取支付方式 command

@property (nonatomic,assign) PayMethodViewType viewType;
@property (nonatomic,assign) PayMethodType payMethodType;
@property (nonatomic,strong) IDCMPaymentListModel *editPaymentModel;///< 编辑状态的model，新增没有的

@property (nonatomic,strong) NSAttributedString *currency;
@property (nonatomic,copy) NSAttributedString *method;


@property (nonatomic,strong) NSArray *coinList;///< 法币列表
@property (nonatomic,strong) NSArray *payList;///< 支付列表


//网络方式
@property (nonatomic,copy) NSString *networkMethodAccount;
@property (nonatomic,copy) NSString *networkMethodPeopleName;
@property (nonatomic,strong) NSString *QRCodeURL;///< 上传qrcode
@property (nonatomic,strong) UIImage *QRCodeImg;///< 上传qrcode

//银行卡方式
@property (nonatomic,copy) NSString *bankCardMethodAccount;
@property (nonatomic,copy) NSString *bankCardMethodPeopleName;
@property (nonatomic,copy) NSString *bankCardMethodBankName;
@property (nonatomic,copy) NSString *bankCardMethodSubBankName;
@property (nonatomic,copy) NSString *bankCardMethodBankAddress;
@property (nonatomic,copy) NSString *bankCardMethodBankCity;
@property (nonatomic,copy) NSString *bankCardMethodBankCode;

@property (nonatomic,strong) RACCommand *addNetworkMethodCommand;
@property (nonatomic,strong) RACCommand *addUSDBankCardMethodCommand;
@property (nonatomic,strong) RACCommand *addCNYBankCardMethodCommand;
@property (nonatomic,strong) RACCommand *addVNDBankCardMethodCommand;

@property (nonatomic,strong) RACCommand *editNetworkMethodCommand;
@property (nonatomic,strong) RACCommand *editUSDBankCardMethodCommand;
@property (nonatomic,strong) RACCommand *editCNYBankCardMethodCommand;
@property (nonatomic,strong) RACCommand *editVNDBankCardMethodCommand;

@end















