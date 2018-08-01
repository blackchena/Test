//
//  IDCMHomeViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/22.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMHomeViewModel.h"
#import "IDCMAmountModel.h"
#import "IDCMCurrencyMarketModel.h"
#import "IDCMUserStateModel.h"

@implementation IDCMHomeViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {

    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    // 获取钱包列表 包含币种名称及logo
    @weakify(self);
    self.walletListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSString *walletListUrl = [NSString stringWithFormat:@"%@?added=true",GetWalletList_URL];
        return [[RACSignal signalGetNoHUDAuth:walletListUrl
                                   serverName:nil
                                       params:nil
                                 handleSignal:^(id response, id<RACSubscriber> subscriber) {
                                     
                                     NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                                     NSMutableArray *arr = @[].mutableCopy;
                                     
                                     if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSArray class]]) {
                                         [response[@"data"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                             IDCMCurrencyMarketModel *model = [IDCMCurrencyMarketModel yy_modelWithDictionary:obj];
                                             [arr addObject:model];
                                         }];
                                         [subscriber sendNext:arr];
                                     }
                                     [subscriber sendCompleted];
                                     
                                 }] doNext:^(NSMutableArray *arr) {
                                     @strongify(self);
                                     if (arr.count > 0) {
                                         self.walletListData = [NSArray arrayWithArray:arr];
                                     }
                                 }];
    }];
    // 获取七天历史金额数据
    self.trendDataCommand = [RACCommand commandGetNoHUDAuth:GetTrendChartData_URL
                                                 serverName:nil
                                                     params:nil
                                              handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                                                  
                                                  NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                                                  NSDictionary *dic = @{};
                                                  if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                                                      dic = response[@"data"];
                                                      [subscriber sendNext:dic];
                                                  }
                                                  [subscriber sendCompleted];
                                              }];

    // 获取用户信息
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSString *userInfoUrl = [NSString stringWithFormat:@"%@?device_id=%@&newVersion=true",GetSetingsState_URL,model.device_id];
    self.getUserSateCommand = [RACCommand commandGetNoHUDAuth:userInfoUrl
                                                   serverName:nil
                                                       params:nil
                                                handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                                                    
                                                    NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                                                    IDCMUserStateModel *model = [IDCMUserStateModel new];
                                                    if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                                                        
                                                        model.email = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"email_valid"][@"email"]];
                                                        model.emailValid = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"email_valid"][@"valid"]];
                                                        
                                                        model.mobil = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"mobile_valid"][@"mobile"]];
                                                        model.mobilValid = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"mobile_valid"][@"valid"]];
                                                        
                                                        model.wallet_phrase = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"wallet_phrase"]];
                                                        model.payPassword = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"payPassword"][@"valid"]];
                                                        [subscriber sendNext:model];
                                                    }
                                                    [subscriber sendCompleted];
                                                }];

    // 获取最新的横幅消息
    NSString *messageUrl = [NSString stringWithFormat:@"%@?lang=%@&client=ios",GetNewMessage_New_URL,[IDCMUtilsMethod getServiceLanguage]];
    self.getNewMessageCommand = [RACCommand commandGetNoHUDAuth:messageUrl
                                                     serverName:nil
                                                         params:nil
                                                  handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                                                      
                                                      NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                                                      if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                                                          [subscriber sendNext:response];
                                                      }
                                                      [subscriber sendCompleted];
                                                  }];
    
    // 横幅消息已读
    self.confirmReadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSString *url = [NSString stringWithFormat:@"%@?msgId=%@",ConfirmRead_URL,input];
            IDCMURLSessionTask *task = [IDCMRequestList requestGetNoHUDAuth:url params:nil success:^(NSDictionary *response) {
                
                NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"] && ![response[@"data"] isKindOfClass:[NSNull class]] && response[@"data"] != nil) {
                    
                    [subscriber sendNext:response];
                }else if ([status isEqualToString:@"100"]){
                    [subscriber sendError:nil];
                }
                
                [subscriber sendCompleted];
                
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }] retry:1];
    }];

    // 领币
    self.getCoinCommand = [RACCommand commandAuth:GetCoin_URL
                                       serverName:nil
                                           params:nil
                                    handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                                        NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                                        if ([status isEqualToString:@"1"] && ![response[@"data"] isKindOfClass:[NSNull class]] && response[@"data"] != nil) {
                                            [subscriber sendNext:response];
                                        }
                                        [subscriber sendCompleted];
                                    }];
    
    // 跳转command
    self.selectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(IDCMCurrencyMarketModel *input) {
        
        @strongify(self);
        NSMutableArray *dataArr = @[].mutableCopy;
        [self.walletListData enumerateObjectsUsingBlock:^(IDCMCurrencyMarketModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([input.currency_unit isEqualToString:model.currency_unit]) {
                model.isSelect = YES;
                model.currentSelect = YES;
            }else{
                model.isSelect = NO;
                model.currentSelect = NO;;
            }
            NSString *realelyBalance = [IDCMUtilsMethod precisionControl:model.realityBalance];
            NSString *currentBlance = [IDCMUtilsMethod precisionControl:model.balance];
            NSString *balanceForToken = [IDCMUtilsMethod precisionControl:model.ethBalanceForToken];
            
            NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:currentBlance];
            NSDecimalNumber *balanceNum = [NSDecimalNumber decimalNumberWithString:[NSString stringFromNumber:num fractionDigits:4]];
            model.balance = balanceNum;
            
            NSDecimalNumber *realnum = [NSDecimalNumber decimalNumberWithString:realelyBalance];
            NSDecimalNumber *realityNum = [NSDecimalNumber decimalNumberWithString:[NSString stringFromNumber:realnum fractionDigits:4]];
            model.realityBalance = realityNum;
            
            NSDecimalNumber *tokenNum = [NSDecimalNumber decimalNumberWithString:balanceForToken];
            NSDecimalNumber *tokenForNum = [NSDecimalNumber decimalNumberWithString:[NSString stringFromNumber:tokenNum fractionDigits:4]];
            model.ethBalanceForToken = tokenForNum;
            
            [dataArr addObject:model];
        }];
        
        [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMNewCurrencyTradingController"
                                                           withViewModelName:@"IDCMNewCurrencyTradingViewModel"
                                                                  withParams: @{@"currencyListData":dataArr}];
        
        return [RACSignal empty];
    }];
    
    // 获取币种精度
    self.getCurrencyPrecisionCommand = [RACCommand commandGetNoHUDAuth:GetCurrencyAccuracy_URL
                                                            serverName:nil
                                                                params:nil
                                                         handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                                                             
                                                             NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                                                             if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]] && [response[@"data"][@"list"] isKindOfClass:[NSDictionary class]]) {
                                                                 IDCMPrecisionModel *model = [IDCMPrecisionModel yy_modelWithDictionary:response[@"data"][@"list"]];
                                                                 [IDCMDataManager sharedDataManager].precisionModel = model;
                                                                 [subscriber sendNext:model];
                                                             }
                                                             [subscriber sendCompleted];
                                                         }];
}

#pragma mark
#pragma mark - 私有方法
- (void)cancelRefreshRequest
{
    NSString *walletListUrl = [NSString stringWithFormat:@"%@?added=true",GetWalletList_URL];
    [IDCMNetWorking cancelRequestWithURL:walletListUrl];
    [IDCMNetWorking cancelRequestWithURL:GetTrendChartData_URL];
}
@end
