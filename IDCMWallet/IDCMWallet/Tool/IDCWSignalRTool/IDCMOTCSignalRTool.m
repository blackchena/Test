//
//  IDCMOTCSignalRTool.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/4.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCSignalRTool.h"
#import <SignalR.h>

@interface IDCMOTCSignalRTool ()<SRConnectionDelegate>

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
 *   组名称，即订单号
 */
@property (copy, nonatomic) NSString *groupName;
/**
 *   UserID
 */
@property (copy, nonatomic) NSString *UserID;
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

@implementation IDCMOTCSignalRTool
+ (instancetype)sharedOTCSignal{
    
    static IDCMOTCSignalRTool *_sharedOTC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedOTC = [[IDCMOTCSignalRTool alloc] init];
    });
    return _sharedOTC;
}
-(instancetype)init {
    if (self = [super init]) {
        [self bindCommandSignal];
    }
    return self;
}
#pragma mark - Public Method
- (void)getSignalrUrl{
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    self.UserID = model.userID;
    
    @weakify(self);
    [[[RACSignal signalPostAuthNoHUD:GetSignalrUrl_URL serverName:nil params:nil handleSignal:nil] deliverOnMainThread]
     subscribeNext:^(NSDictionary *respose) {
         @strongify(self);
         NSInteger  StatusCode = [respose[@"status"] integerValue];
         NSString *url = [NSString idcw_stringWithFormat:@"%@",respose[@"data"]];
         if (StatusCode == 1 && [url isNotBlank]) {
             self.signalrUrl = url;
             [self initHub];
         }
     }];
}
// 建立连接
- (void)initHub{
    
    if(self.hubConnection == nil){
        
        if (![self.signalrUrl isNotBlank]) {
            return;
        }
        self.signalState = kIDCMOTCSignalRStateClose;
        NSDictionary * parameters = @{@"UserID":self.UserID?:@""};
        self.hubConnection = [SRHubConnection connectionWithURLString:self.signalrUrl queryString:parameters];
        self.hubConnection.delegate = self;
        self.chat = (SRHubProxy *)[self.hubConnection createHubProxy:@"WalletHub"];
        
        // 注册聊天信息方法
        [self.chat on:@"otcChatMessage" perform:self selector:@selector(otcChatMessage:)];
        // 推送用户确认报价信息
        [self.chat on:@"confirmQuoteOrderMessage" perform:self selector:@selector(confirmQuoteOrderMessage:)];
        // 下单推送到承兑商
        [self.chat on:@"otcNewestOrder" perform:self selector:@selector(otcNewestOrder:)];
        // 订单状态变更通知到承兑商
        [self.chat on:@"otcOrderStatusChange" perform:self selector:@selector(otcOrderStatusChange:)];
        // 系统通知
        [self.chat on:@"otcNotification" perform:self selector:@selector(otcNotification:)];
        // 承兑商报价通知客户
        [self.chat on:@"quotePriceNotification" perform:self selector:@selector(quotePriceNotification:)];
        [self.hubConnection start];
    }
}
// 加入聊天组
- (void)addChatGroup:(NSString *)orderNum {
    
    if (![orderNum isNotBlank]) {
        DDLogDebug(@"订单号不能为空");
        return;
    }
    self.groupName = orderNum;
    @weakify(self);
    [self.chat invoke:@"JoinGroup" withArgs:@[self.groupName?:@""] completionHandler:^(id response, NSError *error) {
        @strongify(self);
        DDLogDebug(@"加入聊天 %@== %@",self.groupName, response);
        if ([response isKindOfClass:[NSString class]] && [response isEqualToString:@"success"]) {
            self.signalState = kIDCMOTCSignalRStateAdd;
        }
    }];
}
// 退出聊天组
- (void)leaveChatGroup{
    
    @weakify(self);
    NSString *orderID = [self.groupName copy];
    self.groupName = @"";
    [self.chat invoke:@"LeaveGroup" withArgs:@[orderID?:@""] completionHandler:^(id response, NSError *error) {
        @strongify(self);
        DDLogDebug(@"退出聊天 %@== %@",self.groupName, response);
        
        if ([response isKindOfClass:[NSString class]] && [response isEqualToString:@"success"]) {
            self.signalState = kIDCMOTCSignalRStateLeave;
        }
    }];
    
}
// 外部退出SignalR
- (void)closeSignalR{
    
    if(self.chat != nil){
        
        self.isStopSignalR = YES;
        self.chat = nil;
        [self.hubConnection stop];
        self.hubConnection = nil;
    }
}
// 发送消息
- (void)sendChatType:(IDCMOTCChatType)type andWithContent:(id)content completionHandler:(completionHandler)block{
    
    if (type == kIDCMOTCChatMessageType) {
        if (![content isKindOfClass:[NSString class]]) {
            DDLogDebug(@"内容必须为NSString");
            return;
        }
        RACSignal *signal = [self sendMessageWithType:0 andContent:content];
        block(signal);
    }else{
        if (![content isKindOfClass:[UIImage class]]) {
            DDLogDebug(@"内容必须为UIImage");
            return;
        }
        @weakify(self);
        RACSignal *signal = [[self requestImageUrl:content] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
            @strongify(self);
            NSInteger status = [value[@"status"] integerValue];
            NSString *url = [NSString idcw_stringWithFormat:@"%@",value[@"data"]];
            if ([url isNotBlank] && status == 1) {
                return [self sendMessageWithType:1 andContent:url];
            }else{
                return [RACSignal return:nil];
            }
        }];
        block(signal);
    }
}
#pragma mark - Privater Method
- (void)bindCommandSignal{
    
    self.isStopSignalR = NO;
    
    // 获取聊天信息信号
    self.otcChatMessageSubject = [RACSubject subject];
    // 推送用户确认报价信号
    self.confirmQuoteOrderSubject = [RACSubject subject];
    // 下单推送到承兑商信号
    self.otcNewestOrderSubject = [RACSubject subject];
    // 订单状态变更通知到承兑商信号
    self.otcOrderStatusChangeSubject = [RACSubject subject];
    // 系统通知信号
    self.ootcNotificationSubject = [RACSubject subject];
    // 承兑商报价通知客户
    self.quotePriceNotificationSubject = [RACSubject subject];

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
- (void)stopSignalp{
    
    if(self.chat != nil){
        
        self.chat = nil;
        [self.hubConnection stop];
        self.hubConnection = nil;
        
    }
}
#pragma mark - NetWork
- (RACSignal *)requestImageUrl:(UIImage *)image{
    
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        IDCMURLSessionTask *task = [IDCMNetWorking uploadWithImage:image url:UploadFile_URL filename:nil name:@"CertFacade" mimeType:@"image/jpeg" parameters:nil progress:nil success:^(id response, NSURLSessionDataTask *task) {
            
            [subscriber sendNext:response];
            [subscriber sendCompleted];
            
        } fail:^(NSError *error, NSURLSessionDataTask *task) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
        
    }] retry:1];
}
- (RACSignal *)sendMessageWithType:(NSInteger)type andContent:(NSString *)content{
    
    NSArray *arr;
    if (type == 0) { // 发送消息
        arr = @[self.groupName?:@"",content,@""];
    }else{ // 发送图片
        arr = @[self.groupName?:@"",@"",content];
    }
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [self.chat invoke:@"Send" withArgs:arr completionHandler:^(id response, NSError *error) {

            NSString *status = [NSString idcw_stringWithFormat:@"%@",response];
            if (response && [status isEqualToString:@"success"]) {
                [subscriber sendNext:response];
                [subscriber sendCompleted];
            }else if (error){
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{}];
    }];
}
#pragma mark - SRConnection Delegate
- (void)SRConnectionDidClose:(id<SRConnectionInterface>)connection{
    DDLogDebug(@"OTC 关闭");
    [self stopSignalp];
    self.signalState = kIDCMOTCSignalRStateClose;
    self.isReconnection = @"NO";
    
}
- (void)SRConnectionDidSlow:(id<SRConnectionInterface>)connection{
    DDLogDebug(@"OTC 连接缓慢");
    [self stopSignalp];
    self.signalState = kIDCMOTCSignalRStateClose;
    self.isReconnection = @"NO";
}
- (void)SRConnectionDidOpen:(id<SRConnectionInterface>)connection{
    DDLogDebug(@"OTC 开启");
    self.isStopSignalR = NO;
    self.signalState = kIDCMOTCSignalRStateOpen;
    self.isReconnection = @"YES";
    if ([self.groupName isNotBlank]) {
        [self addChatGroup:self.groupName];
    }
}
#pragma mark - Registered Method
// 1 获取聊天信息
- (void)otcChatMessage:(id)response{
    DDLogDebug(@"otcChatMessage(聊天信息) = %@",response);
    [self.otcChatMessageSubject sendNext:response];
}

// 5系统通知
- (void)otcNotification:(id)response{
    DDLogDebug(@"otcNotification(系统通知) = %@",response);
    [self.ootcNotificationSubject sendNext:response];
}

// 3 下单推送到承兑商
- (void)otcNewestOrder:(id)response{
    DDLogDebug(@"otcNewestOrder(用户下单推送到承兑商) = %@",response);
    [self.otcNewestOrderSubject sendNext:response];
}

// 6 承兑商报价通知客户
- (void)quotePriceNotification:(id)response{
    DDLogDebug(@"quotePriceNotification(承兑商报价通知用户) = %@",response);
    [self.quotePriceNotificationSubject sendNext:response];
}

// 2 推送用户确认报价信息
- (void)confirmQuoteOrderMessage:(id)response{
    DDLogDebug(@"confirmQuoteOrderMessage(用户确认报价推送到承兑商) = %@",response);
    [self.confirmQuoteOrderSubject sendNext:response];
}

// 4 订单状态变更通知到承兑商
- (void)otcOrderStatusChange:(id)response{
    DDLogDebug(@"otcOrderStatusChange(订单状态变更通知到承兑商) = %@",response);
    [self.otcOrderStatusChangeSubject sendNext:response];
}

#pragma mark - delloc
- (void)dealloc{
    
    [self.netstatusDisposable dispose];
}
@end
