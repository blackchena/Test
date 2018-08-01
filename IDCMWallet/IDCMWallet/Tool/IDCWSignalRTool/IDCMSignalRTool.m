//
//  IDCMSignalRTool.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/15.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSignalRTool.h"
#import <SignalR.h>

@interface IDCMSignalRTool ()<SRConnectionDelegate>

/**
 *  chat
 */
@property (strong, nonatomic) SRHubProxy *chat;
/**
 *  hubConnection
 */
@property (strong, nonatomic) SRHubConnection *hubConnection;
/**
 *   SignalR地址
 */
@property (copy, nonatomic) NSString *signalrUrl;
/**
 *   btc交易对
 */
@property (copy, nonatomic) NSString *btcTradingConfigID;
/**
 *   eth交易对
 */
@property (copy, nonatomic) NSString *ethTradingConfigID;
/**
 *   btc价格
 */
@property (copy, nonatomic) NSString *btcStr;
/**
 *   eth价格
 */
@property (copy, nonatomic) NSString *ethStr;
/**
 *   是否重连
 */
@property (copy, nonatomic) NSString *isReconnection;
/**
 *  网络状态变换Disposable
 */
@property (strong, nonatomic) RACDisposable *netstatusDisposable;
/**
 *  是否关闭SignalR
 */
@property (assign, nonatomic) BOOL isStopSignalR;
@end

@implementation IDCMSignalRTool

+ (instancetype)sharedSignal{
    
    static IDCMSignalRTool *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[IDCMSignalRTool alloc] init];
    });
    
    return _shared;
}

-(instancetype)init {
    if (self = [super init]) {
        [self bindCommandSignal];
    }
    return self;
}
#pragma mark - Public Method
// 获取SignalR地址
- (void)getSignalrUrl{

    @weakify(self);
    [[[RACSignal signalPostNoHUDAuth:@"http://api.idcm.io:8303/api/Trade/GetTradeConfig" serverName:nil params:nil handleSignal:nil] deliverOnMainThread]
     subscribeNext:^(NSDictionary *respose) {
         @strongify(self);
         if ([respose[@"Data"] isKindOfClass:[NSDictionary class]] && [respose[@"Data"][@"VarietyGroupList"] isKindOfClass:[NSArray class]] && [respose[@"Data"][@"Signalr"] isKindOfClass:[NSString class]]) {
             
             @strongify(self);
             self.signalrUrl = [NSString idcw_stringWithFormat:@"%@",respose[@"Data"][@"Signalr"]];
             
             [respose[@"Data"][@"VarietyGroupList"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 
                 @strongify(self);
                 [obj[@"TradeVarietyList"] enumerateObjectsUsingBlock:^(NSDictionary *dataDic, NSUInteger idx, BOOL * _Nonnull stop) {
                     
                     if ([obj[@"Code"] containsString:@"USD"]) {
                         
                         NSString *symbol = [NSString idcw_stringWithFormat:@"%@",dataDic[@"Symbol"]];
                         NSString *newest = [NSString idcw_stringWithFormat:@"%@",dataDic[@"Newest"]];
                         
                         // BTC/USD 交易对
                         if ([symbol containsString:@"BTC"] && [symbol containsString:@"USD"]) {
                             
                             NSString *tradingConfigID = [NSString idcw_stringWithFormat:@"%@",dataDic[@"TradingConfigID"]];
                             if ([tradingConfigID isNotBlank]) {
                                 self.btcTradingConfigID = tradingConfigID;
                             }
                             
                             NSString *str = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:newest] fractionDigits:2]];
                             self.btcStr = [NSString stringWithFormat:@"$ %@",str];
                         }
                         
                         // ETH/USD 交易对
                         if ([symbol containsString:@"ETH"] && [symbol containsString:@"USD"]) {
                             
                             NSString *tradingConfigID = [NSString idcw_stringWithFormat:@"%@",dataDic[@"TradingConfigID"]];
                             if ([tradingConfigID isNotBlank]) {
                                 self.ethTradingConfigID = tradingConfigID;
                             }
                             
                             NSString *str = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:newest] fractionDigits:2]];
                             self.ethStr = [NSString stringWithFormat:@"$ %@",str];
                         }
                     }
                 }];
             }];
             
             // 如果请求到BTC、ETH对USD的价格的话，就发送数据
             if ([self.btcStr isNotBlank] && [self.ethStr isNotBlank]) {
                 [self.realTrendSubject sendNext:RACTuplePack(self.btcStr,self.ethStr)];
             }

             [self initHub];
         }
     }];
}
// 外部关闭SignalR
- (void)closeSignalR{
    
    if(self.chat != nil){
        
        self.isStopSignalR = YES;
        self.chat = nil;
        [self.hubConnection stop];
        self.hubConnection = nil;
        
    }
}

#pragma mark - Privater Method
- (void)bindCommandSignal{
    
    self.isStopSignalR = NO;
    
    // 最新价格推送
    self.realTrendSubject = [RACSubject subject];
    
    @weakify(self);
    // 每隔10秒发出信号
    RACSignal *timeSignal = [[RACSignal interval:10 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal];
    // bufferWithTime设置为0是为了避免同一时刻两个值被同时设置新值导致调用了两次
    // take设置为180是从开始一共取180次信号，每隔10秒取一次，即最多有网状态下尝试重连30分钟
    self.netstatusDisposable = [[[[RACSignal merge: @[RACObserve(IDCM_APPDelegate, networkStatus),timeSignal]]
      bufferWithTime:0 onScheduler: [RACScheduler mainThreadScheduler]] take:180]
     subscribeNext: ^(RACTuple *value) {
         @strongify(self);
         if (IDCM_APPDelegate.networkStatus != NotReachable && [self.isReconnection isEqualToString:@"NO"] && !self.isStopSignalR) {
             [self initHub];
         }
     }];
    
}
// 建立连接
- (void)initHub{
    
    if(self.hubConnection == nil){
        
        if (![self.signalrUrl isNotBlank] || ![self.btcTradingConfigID isNotBlank]) {
            return;
        }
        NSDictionary * parameters = @{@"UserID":@"",
                                      @"GroupID":self.btcTradingConfigID
                                      };
        self.hubConnection = [SRHubConnection connectionWithURLString:self.signalrUrl queryString:parameters];
        self.hubConnection.delegate = self;
        self.chat = (SRHubProxy *)[self.hubConnection createHubProxy:@"ExchangesHub"];
        
        // 注册最新价格推送
        [self.chat on:@"RealTrendCallback" perform:self selector:@selector(RealTrendCallback:)];
        [self.hubConnection start];
    }
}
// 加组
-(void)assignUser{
    
    NSString * GroupID = [self.btcTradingConfigID isNotBlank] ? self.btcTradingConfigID : @"";
    [self.chat invoke:@"addGroup" withArgs:@[GroupID] completionHandler:^(id response, NSError *error) {
        DDLogDebug(@"最新价格addGroup == %@", response);
    }];
}
// 设置精度
- (void)setPrecision{
    
    NSString * GroupID = [self.btcTradingConfigID isNotBlank] ? self.btcTradingConfigID : @"";
    [self.chat invoke:@"SetDisplayPrecision" withArgs:@[GroupID,@(2)] completionHandler:^(id response, NSError *error) {
        DDLogDebug(@"最新价格SetDisplayPrecision = %@",response);
    }];
}
// 内部停止SignalR
- (void)stopSignalp{
    
    if(self.chat != nil){
        
        self.chat = nil;
        [self.hubConnection stop];
        self.hubConnection = nil;
        
    }
}
#pragma mark - SRConnection Delegate
- (void)SRConnectionDidClose:(id<SRConnectionInterface>)connection{
    DDLogDebug(@"最新价格 关闭");
    [self stopSignalp];
    self.isReconnection = @"NO";
    
}
- (void)SRConnectionDidSlow:(id<SRConnectionInterface>)connection{
    DDLogDebug(@"最新价格 连接缓慢");
    [self stopSignalp];
    self.isReconnection = @"NO";
}
- (void)SRConnectionDidOpen:(id<SRConnectionInterface>)connection{
    DDLogDebug(@"最新价格 开启");
    
    self.isStopSignalR = NO;
    self.isReconnection = @"YES";
    [self assignUser];
    [self setPrecision];
}
#pragma mark - 注册的方法
//实时 最新价格 以及涨幅 推送
- (void)RealTrendCallback:(id)response{
    
    if ([response isKindOfClass:[NSArray class]]) {
        
        [response enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *TradingConfigID = [NSString idcw_stringWithFormat:@"%@",obj[@"TradingConfigID"]];
            NSString *newest = [NSString idcw_stringWithFormat:@"%@",obj[@"Newest"]];
            
            if ([TradingConfigID isEqualToString:self.btcTradingConfigID]) {
                
                NSString *str = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:newest] fractionDigits:2]];
                self.btcStr = [NSString stringWithFormat:@"$ %@",str];
            }
            if ([TradingConfigID isEqualToString:self.ethTradingConfigID]) {
                
                NSString *str = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:newest] fractionDigits:2]];
                self.ethStr = [NSString stringWithFormat:@"$ %@",str];
            }
            
            if ([self.btcStr isNotBlank] && [self.ethStr isNotBlank]) {
                [self.realTrendSubject sendNext:RACTuplePack(self.btcStr,self.ethStr)];
            }
            
        }];
    }
}

#pragma mark - delloc
- (void)dealloc{
    
    [self.netstatusDisposable dispose];
}
@end
