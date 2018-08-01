//
//  IDCMOTCExchangeDetailViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMOTCExchangeDetailModel.h"



@interface IDCMOTCExchangeDetailViewModel : IDCMBaseViewModel

@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,strong) IDCMOTCExchangeDetailModel *detailModel;

@property (nonatomic,strong) RACCommand *oTCExchangeDetailCommand;         ///< 获取详情数据
/**********************  买家接口  *************************/
@property (nonatomic,strong) RACCommand *setTransferCommand;            ///< 买家设置已转账
@property (nonatomic,strong) RACCommand *cancelOrderCommand;           ///< 买家取消订单
@property (nonatomic,strong) RACCommand *setAppealingCommand;         ///< 买家申请申述 上传凭证中
@property (nonatomic,strong) RACCommand *uploadPayCertificateCommand;///< 买家上传凭证
/**********************  卖家接口  *************************/
@property (nonatomic,strong) RACCommand *applyAppealCommand;       ///< 卖家申请申诉
@property (nonatomic,strong) RACCommand *confirmArrivedCommand;   ///< 卖家确认已经到账
@property (nonatomic,strong) RACCommand *setDelayConfirmCommand; ///< 卖家延长时间

// 自定义属性
- (void)disposeAllSignal;
@property (nonatomic,copy) NSString *exchangeStateTypeTopTipString;      ///< 上面提示语
@property (nonatomic,strong) NSArray<NSString *> *bottomStateBtnTitles; ///< 按钮标题数组
@property (nonatomic,assign) CGFloat bottomStateViewHeight;            ///< 底部状态高度
@property (nonatomic,strong) NSArray<RACTuple *> *orderInfoArray;     ///<订单信息数组

@end




