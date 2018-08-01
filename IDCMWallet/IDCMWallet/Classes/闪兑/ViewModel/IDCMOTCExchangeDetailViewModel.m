//
//  IDCMOTCExchangeDetailViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCExchangeDetailViewModel.h"

@interface IDCMOTCExchangeDetailViewModel ()
@property (nonatomic,strong) RACDisposable *signalRDispos;
@end

@implementation IDCMOTCExchangeDetailViewModel
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.orderId = params[@"orderId"];
    }return self;
}

- (void)initialize {
    @weakify(self);
    self.signalRDispos =
    [[[[IDCMOTCSignalRTool sharedOTCSignal] otcOrderStatusChangeSubject] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         /*
          OrderID = 1606;
          Status = 6;
          ExpiredSeconds = -21;
          ExpiredTimestamp = 1526587027673;
          IsDelay = 0;
          ExpiredDate = "2018-05-17T19:57:07";
          CertificateImages = [
          "http://192.168.1.226/group1/M00/00/28/wKgB4lr9bh6ALRzxAFQ7JNfVsSE131.jpg",
          "http://192.168.1.226/group1/M00/00/28/wKgB4lr9biKAfVOzAFQ7JNfVsSE220.jpg",
          "http://192.168.1.226/group1/M00/00/28/wKgB4lr9biiASSIsAFQ7JNfVsSE782.jpg"
          ];
          CancelCount = 0
          }
        */
         @strongify(self);
         if (response &&
             [response isKindOfClass:[NSDictionary class]]) {
             NSInteger OrderID = [response[@"OrderID"] integerValue];
             if (OrderID != 0 && OrderID == self.orderId.integerValue) {
                 NSInteger status = [response[@"Status"] integerValue];
                 if (status == 3) {
                     status = 2;
                 }
                 if (status == 10 || status == 11 || status == 7) {
                     status = 8;
                 }
                 if (status == 1 && [response[@"IsDelay"] boolValue]) {
                     status = 13;
                 }
                 self.detailModel.StatusTimeSeconds = [response[@"ExpiredSeconds"] integerValue];
                 if ([response[@"CertificateImages"] isKindOfClass:[NSArray class]]) {
                    self.detailModel.CertificateImages = response[@"CertificateImages"];
                 }
                 self.detailModel.IsTimeExpand = [response[@"IsDelay"] boolValue];
                 self.detailModel.isDelay = [response[@"IsDelay"] boolValue];
                 self.detailModel.exchangeType == OTCExchangeType_Buy ?
                 ({
                     self.detailModel.exchangeBuyStateType = status;
                 }):({
                     self.detailModel.exchangeSellStateType = status;
                 });
             }
         }
    }];
}

#pragma mark — 获取详情数据
- (RACCommand *)oTCExchangeDetailCommand {
    return SW_LAZY(_oTCExchangeDetailCommand, ({
        @weakify(self);
        [self commandWithUrl:GetOtcOrder_URL completion:^(id response){
            @strongify(self);
            self.detailModel =
            [[IDCMOTCExchangeDetailModel yy_modelWithDictionary:response[kData]] handleModel];
        }];
    }));
}

#pragma mark — 买家取消订单
- (RACCommand *)cancelOrderCommand {
    return SW_LAZY(_cancelOrderCommand, ({
        @weakify(self);
        [self commandWithUrl:OTCAgreeRefund_URL completion:^(id response){
            @strongify(self);
            self.detailModel.exchangeBuyStateType = OTCExchangeBuyStateType_Cancelled;
        }];
    }));
}

#pragma mark — 买家设置已转账
- (RACCommand *)setTransferCommand {
    return SW_LAZY(_setTransferCommand, ({
        @weakify(self);
        [self commandWithUrl:OTCSetTransfer_URL completion:^(id response){
            @strongify(self);
            self.detailModel.exchangeBuyStateType = OTCExchangeBuyStateType_Payed;
        }];
    }));
}
 
#pragma mark — 卖家确认已经到账
- (RACCommand *)confirmArrivedCommand {
    return SW_LAZY(_confirmArrivedCommand, ({
        @weakify(self);
        [self commandWithUrl:OTCConfirmArrived_URL completion:^(id response){
            @strongify(self);
            self.detailModel.exchangeSellStateType = OTCExchangeSellStateType_Completed;
        }];
    }));
}

#pragma mark — 卖家延长时间
- (RACCommand *)setDelayConfirmCommand {
    return SW_LAZY(_setDelayConfirmCommand, ({
        @weakify(self);
        [self commandWithUrl:OTCSetDelayConfirm_URL completion:^(id response){
            @strongify(self);
            self.detailModel.isDelay = YES;
            self.detailModel.exchangeSellStateType = OTCExchangeSellStateType_DoingSetDelay;
        }];
    }));
}

#pragma mark — 买家申请申述 上传凭证中
- (RACCommand *)setAppealingCommand {
    return SW_LAZY(_setAppealingCommand, ({
        @weakify(self);
        [self commandWithUrl:OTCSetAppealing_URL completion:^(id response){
            @strongify(self);
            self.detailModel.exchangeBuyStateType = OTCExchangeBuyStateType_AppealDoing;
        }];
    }));
}

#pragma mark — 卖家提起申述
- (RACCommand *)applyAppealCommand {
    return SW_LAZY(_applyAppealCommand, ({
        @weakify(self);
        [self commandWithUrl:OTCApplyAppeal_URL completion:^(id response){
             @strongify(self);
             self.detailModel.exchangeSellStateType = OTCExchangeSellStateType_AppealDoing;
        }];
    }));
}

#pragma mark —  买家上传凭证
- (RACCommand *)uploadPayCertificateCommand {
    return SW_LAZY(_uploadPayCertificateCommand, ({
        
        @weakify(self);
        [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSArray *images) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [IDCMHUD show];
                IDCMURLSessionTask *task =
                [IDCMNetWorking uploadWithImages:images
                                             url:[self handleOrderUrl:OTCUploadPayCertificate_URL]
                                        filename:nil
                                            name:@"CertFacade"
                                        mimeType:@"image/jpeg"
                                      parameters:nil
                                        progress:nil
                                         success:^(id response, NSURLSessionDataTask *task) {
                                             @strongify(self);
                                             [IDCMHUD dismiss];
                                             NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                                             if ([status integerValue] == 1) {
                                                 self.detailModel.exchangeBuyStateType = OTCExchangeBuyStateType_AppealCheching;
                                                 [subscriber sendCompleted];
                                             } else {
                                                 [IDCMShowMessageView showMessageWithCode:status];
                                                 [subscriber sendError:nil];
                                             }
                                         } fail:^(NSError *error, NSURLSessionDataTask *task) {
                                             [IDCMHUD dismiss];
                                             [subscriber sendError:error];
                                         }];
                return [RACDisposable disposableWithBlock:^{
                    [task cancel];
                }];
            }];
        }];
    }));
}

- (RACCommand *)commandWithUrl:(NSString *)url completion:(void(^)(id response))completion {
    return
    [RACCommand commandAuth:[self handleOrderUrl:url]
                 serverName:nil
                     params:nil
              handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                  NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                  ([status integerValue] == 100) ?
                  ([subscriber sendError:nil]) :
                  ({
                      if ([status integerValue] == 1) {
                          !completion ?: completion(response);
                          [subscriber sendNext:nil];
                          [subscriber sendCompleted];
                      } else {
                          [IDCMShowMessageView showMessageWithCode:status];
                          [subscriber sendError:nil];
                      }
                  });
              }];
}

- (NSString *)handleOrderUrl:(NSString *)url {
    return [NSString stringWithFormat:@"%@?orderId=%@", url, [IDCMUtilsMethod valueString:self.orderId]];
}

- (NSString *)exchangeStateTypeTopTipString {
    
    NSString *str = @"";
    self.detailModel.exchangeType == OTCExchangeType_Buy ?
    ({
        switch (self.detailModel.exchangeBuyStateType) {
            case OTCExchangeBuyStateType_Doing:
            case OTCExchangeBuyStateType_DoingDelay:
            case OTCExchangeBuyStateType_DoingSetDelay:{
                NSString *countStr = [NSString stringWithFormat:@"%zd", self.detailModel.ConfirmTransferDuration];
                str = [NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStateDoing", nil) stringByReplacingOccurrencesOfString:@"[IDCW_HY]" withString:countStr];
            }break;
            case OTCExchangeBuyStateType_Payed: {
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStatePayed", nil);
            }break;
            case OTCExchangeBuyStateType_PayedHandleDelay: {
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStatePayedHandleDelay", nil);
            }break;
            case OTCExchangeBuyStateType_Completed: {
                str = [NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStateCompleted", nil) stringByReplacingOccurrencesOfString:@"[IDCW_HY]" withString:[self.detailModel.CoinCode uppercaseString]];
            }break;
            case OTCExchangeBuyStateType_Cancelled: {
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStateCancelled", nil);
            }break;
            case OTCExchangeBuyStateType_Appeal: {
                NSString *countStr = [NSString stringWithFormat:@"%zd", self.detailModel.HandlerAppealDuration];
                str = [NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStateAppeal", nil) stringByReplacingOccurrencesOfString:@"[IDCW_HY]" withString:countStr];
            }break;
            case OTCExchangeBuyStateType_AppealDelay:
            case OTCExchangeBuyStateType_AppealDoingDelay:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStateAppealDelay", nil);
            }break;
            case OTCExchangeBuyStateType_AppealDoing: {
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStateAppealDoing", nil);
            }break;
            case OTCExchangeBuyStateType_AppealCheching: {
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStateAppealCheching", nil);
            }break;
            case OTCExchangeBuyStateType_AppealCheched: {
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStateAppealCheched", nil);
            }break;
            default:
            break;
        }
    }):({
        switch ( self.detailModel.exchangeSellStateType) {
            case OTCExchangeSellStateType_Doing:
            case OTCExchangeSellStateType_DoingSetDelay:
            case OTCExchangeSellStateType_DoingDelay:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellStateDoing", nil);
            }break;
            case OTCExchangeSellStateType_Payed:{
                NSString *countStr = [NSString stringWithFormat:@"%zd", self.detailModel.ConfirmReceivablesDuration];
                str = [NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellStatePayed", nil) stringByReplacingOccurrencesOfString:@"[IDCW_HY]" withString:countStr];
            }break;
            case OTCExchangeSellStateType_PayedHandleDelay:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStateAppealDelay", nil);
            }break;
            case OTCExchangeSellStateType_Cancelled:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellStateCancelled", nil);
            }break;
            case OTCExchangeSellStateType_Completed:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellStateCompleted", nil);
            }break;
            case OTCExchangeSellStateType_AppealDoing:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellStateAppealDoing", nil);
            }break;
            case OTCExchangeSellStateType_AppealUploadWaitting:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellStateAppealUploadWaitting", nil);
            }break;
            case OTCExchangeSellStateType_AppealUploadWaitDelay:
            case OTCExchangeSellStateType_AppealDelay:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStatePayedHandleDelay", nil);
            }break;
            case OTCExchangeSellStateType_AppealUploadedCheckPicture:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellStateAppealUploadedCheckPicture", nil);
            }break;
            case OTCExchangeSellStateType_AppealCheckPictureCompleted:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyStateAppealCheched", nil);
            }break;
            case OTCExchangeSellStateType_AppealCheched:{
                str = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellStateAppealCheched", nil);
            }break;
            default:
            break;
        }
    });
    return str;
}

- (NSArray<NSString *> *)bottomStateBtnTitles {
    
    NSArray *titles = @[];
    self.detailModel.exchangeType == OTCExchangeType_Buy ?
    ({
        switch ( self.detailModel.exchangeBuyStateType) {
            case OTCExchangeBuyStateType_Doing:
            case OTCExchangeBuyStateType_DoingDelay:
            case OTCExchangeBuyStateType_DoingSetDelay:{
                titles = @[NSLocalizedString(@"3.0_Hy_OTCExchangeDetailCancelOrder", nil),
                           NSLocalizedString(@"3.0_Hy_OTCExchangeDetailPayedOrder", nil)];
            }break;
            case OTCExchangeBuyStateType_Appeal:
            case OTCExchangeBuyStateType_AppealDelay:{
                titles = @[NSLocalizedString(@"3.0_Hy_OTCExchangeDetailCancelOrder", nil),
                           NSLocalizedString(@"3.0_Hy_OTCExchangeDetailUploadTitle", nil)];
            }break;
            case OTCExchangeBuyStateType_AppealDoing:
            case OTCExchangeBuyStateType_AppealDoingDelay: {
                titles = @[NSLocalizedString(@"3.0_Hy_OTCExchangeDetailUploadTip", nil)];
            }break;
            case OTCExchangeBuyStateType_Payed:
            case OTCExchangeBuyStateType_Completed:
            case OTCExchangeBuyStateType_Cancelled:
            case OTCExchangeBuyStateType_PayedHandleDelay:
            case OTCExchangeBuyStateType_AppealCheching:
            case OTCExchangeBuyStateType_AppealCheched: {
                titles = @[];
            }break;
            default:
            break;
        }
    }):({
        switch (self.detailModel.exchangeSellStateType) {
            case OTCExchangeSellStateType_Doing:
            case OTCExchangeSellStateType_DoingDelay:{
                titles = @[NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellSetDelay", nil)];
            }break;
            case OTCExchangeSellStateType_DoingSetDelay:{
                titles =  @[@"", NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellHasSetDelay", nil)];
            }break;
            case OTCExchangeSellStateType_Payed:
            case OTCExchangeSellStateType_PayedHandleDelay:{
                titles = @[NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellAppeal", nil),
                           NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellReciveTitle", nil)];
            }break;
            case OTCExchangeSellStateType_Cancelled:
            case OTCExchangeSellStateType_Completed:
            case OTCExchangeSellStateType_AppealDoing:
             case OTCExchangeSellStateType_AppealUploadWaitting:
            case OTCExchangeSellStateType_AppealUploadedCheckPicture:
            case OTCExchangeSellStateType_AppealCheckPictureCompleted:
            case OTCExchangeSellStateType_AppealDelay:
            case OTCExchangeSellStateType_AppealUploadWaitDelay:
            case OTCExchangeSellStateType_AppealCheched:{
                titles = @[];
            }break;
            default:
            break;
        }
    });
    return titles;
}

- (CGFloat)bottomStateViewHeight {
    CGFloat heith = 0;
    self.detailModel.exchangeType == OTCExchangeType_Buy ?
    ({
        switch ( self.detailModel.exchangeBuyStateType) {
            case OTCExchangeBuyStateType_Doing:
            case OTCExchangeBuyStateType_DoingSetDelay:
            case OTCExchangeBuyStateType_DoingDelay:
            case OTCExchangeBuyStateType_Appeal:
            case OTCExchangeBuyStateType_AppealDelay:{
//                heith = 135;
                heith = 56 + 40 + 35;
            }break;
            case OTCExchangeBuyStateType_Payed:
            case OTCExchangeBuyStateType_PayedHandleDelay:{
                heith = 78.0;
            }break;
            case OTCExchangeBuyStateType_Completed:
            case OTCExchangeBuyStateType_Cancelled:{
                heith = 0.0 + 10;
            }break;
            case OTCExchangeBuyStateType_AppealDoing:
            case OTCExchangeBuyStateType_AppealDoingDelay:{
                CGFloat WH = (SCREEN_WIDTH - 30 - 24 - 20) / 5;
                heith = WH + 35 + 56;
            }break;
            case OTCExchangeBuyStateType_AppealCheching:{
                CGFloat WH = (SCREEN_WIDTH - 30 - 24 - 20) / 5;
                 heith = WH + 35 + 14;
            }break;
            case OTCExchangeBuyStateType_AppealCheched:{
                CGFloat WH = (SCREEN_WIDTH - 30 - 24 - 20) / 5;
                heith = WH + 28;
            }break;
            default:
            break;
        }
    }):({
        switch ( self.detailModel.exchangeSellStateType) {
            case OTCExchangeSellStateType_Doing:
            case OTCExchangeSellStateType_DoingDelay:
            case OTCExchangeSellStateType_Payed:
            case OTCExchangeSellStateType_PayedHandleDelay:{
//                heith = 135;
                heith = 56 + 40 + 35;
            }break;
            case OTCExchangeSellStateType_DoingSetDelay:{
                heith = 111;
            }break;
            case OTCExchangeSellStateType_Cancelled:
            case OTCExchangeSellStateType_Completed:
             case OTCExchangeSellStateType_AppealCheched:{
                heith = 0.0 + 10;
            }break;
            case OTCExchangeSellStateType_AppealDoing:
            case OTCExchangeSellStateType_AppealDelay:
            case OTCExchangeSellStateType_AppealUploadWaitting:
            case OTCExchangeSellStateType_AppealUploadWaitDelay:{
                heith = 78.0;
            }break;
            case OTCExchangeSellStateType_AppealUploadedCheckPicture:{
                CGFloat WH = (SCREEN_WIDTH - 30 - 24 - 20) / 5;
                heith = WH + 35 + 14;
            }break;
            case OTCExchangeSellStateType_AppealCheckPictureCompleted:{
                CGFloat WH = (SCREEN_WIDTH - 30 - 24 - 20) / 5;
                heith = WH + 28;
            }break;
            default:
            break;
        }
    });
    return heith;
}

- (NSArray<RACTuple *> *)orderInfoArray {
    
    NSArray *array = @[];
    self.detailModel.exchangeType == OTCExchangeType_Buy ?
    ({
        switch ( self.detailModel.exchangeBuyStateType) {
            case OTCExchangeBuyStateType_Doing:
            case OTCExchangeBuyStateType_DoingDelay:
            case OTCExchangeBuyStateType_DoingSetDelay:
            case OTCExchangeBuyStateType_Payed:
            case OTCExchangeBuyStateType_PayedHandleDelay:
            case OTCExchangeBuyStateType_AppealDoing:
            case OTCExchangeBuyStateType_AppealDoingDelay:
            case OTCExchangeBuyStateType_Appeal:
            case OTCExchangeBuyStateType_AppealDelay:
            case OTCExchangeBuyStateType_AppealCheching:{
                array = @[RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuy", nil),
                                       self.detailModel.customerBuyCountInfo),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailPay", nil),
                                       self.detailModel.customerBuyPayCountInfo)];
            }break;
            case OTCExchangeBuyStateType_Completed:
            case OTCExchangeBuyStateType_AppealCheched:{
                array = @[RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuy", nil),
                                                    self.detailModel.customerBuyCountInfo),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailPay", nil),
                                       self.detailModel.customerBuyPayCountInfo),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSeller", nil),
                                       self.detailModel.customerBuySeller),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailPayNo", nil),
                                       self.detailModel.customerPayMethodNo)];
            }break;
            case OTCExchangeBuyStateType_Cancelled:{
                array = @[RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuy", nil),
                                       self.detailModel.customerBuyCountInfo),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailPay", nil),
                                       self.detailModel.customerBuyPayCountInfo),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSeller", nil),
                                       self.detailModel.customerBuySeller)];
            }break;
            default:
            break;
        }
    }):({
        switch ( self.detailModel.exchangeSellStateType) {
            case OTCExchangeSellStateType_Doing:
            case OTCExchangeSellStateType_DoingDelay:
            case OTCExchangeSellStateType_DoingSetDelay:
            case OTCExchangeSellStateType_Payed:
            case OTCExchangeSellStateType_PayedHandleDelay:
            case OTCExchangeSellStateType_AppealDoing:
            case OTCExchangeSellStateType_AppealDelay:
            case OTCExchangeSellStateType_AppealUploadWaitting:
            case OTCExchangeSellStateType_AppealUploadWaitDelay:
            case OTCExchangeSellStateType_AppealUploadedCheckPicture:
            case OTCExchangeSellStateType_AppealCheckPictureCompleted:
            case OTCExchangeSellStateType_AppealCheched:{
                array = @[RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSell", nil),
                                       self.detailModel.customerBuyCountInfo),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailRecive", nil),
                                       self.detailModel.customerBuyPayCountInfo),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailReciveNo", nil),
                                       self.detailModel.customerPayMethodNo)];
            }break;
            case OTCExchangeSellStateType_Cancelled:{
                array = @[RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSell", nil),
                                       self.detailModel.customerBuyCountInfo),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailRecive", nil),
                                       self.detailModel.customerBuyPayCountInfo)];
            }break;
            case OTCExchangeSellStateType_Completed: {
                array = @[RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSell", nil),
                                       self.detailModel.customerBuyCountInfo),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailRecive", nil),
                                       self.detailModel.customerBuyPayCountInfo),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailBuyer", nil),
                                       self.detailModel.customerBuySeller),
                          RACTuplePack(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailReciveNo", nil),
                                       self.detailModel.customerPayMethodNo)];
            }break;
            default:
            break;
        }
    });
    return array;
}

- (void)disposeAllSignal {
    [self.signalRDispos dispose];
    [self.detailModel disposeAllSignal];
}

@end






