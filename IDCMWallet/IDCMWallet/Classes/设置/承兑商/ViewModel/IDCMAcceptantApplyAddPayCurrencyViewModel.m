//
//  IDCMAcceptantApplyAddPayCurrencyViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyAddPayCurrencyViewModel.h"
#import "IDCMLocalCurrencyModel.h"
@implementation IDCMAcceptantApplyAddPayCurrencyViewModel

- (void)initialize {
    
    @weakify(self);
    
    RACSignal *(^enbledSignal)(void) = ^RACSignal *(void){
        return [[[RACSignal combineLatest:@[RACObserve(self, currency),
                                            RACObserve(self, amountValue)]]
                 reduceEach:^(NSString *currency,
                              NSString *amountValue){
                     return @(currency.length &&
                            amountValue.length);
                 }] distinctUntilChanged];
    };
    
    self.saveCommand =  [[RACCommand alloc] initWithEnabled:enbledSignal()
                                                signalBlock:^RACSignal * _Nonnull(NSDictionary * input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                //请求参数
                NSInteger currencyID = 0;
                for (IDCMLocalCurrencyModel * model in self.currencysList) {
                    if ([model.localCurrencyCode isEqualToString:self.selectModel.localCurrencyCode]) {
                        currencyID = model.currencyID.integerValue;
                    }
                }
                NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
                [params setObject:[NSNumber numberWithInteger:currencyID] forKey:@"LocalCurrencyId"];
                [params setObject:[NSDecimalNumber decimalNumberWithString:self.amountValue] forKey:@"Amount"];
                if (self.pageType == EditCurrencyTypeAndAmount ) {  //编辑
                    NSString * dataID =  self.editDict[@"dataID"] ? : @"";
                    [params setObject:dataID forKey:@"id"];
                }else{
                    
                    [params setObject:@"" forKey:@"id"];
                }
                //添加
                IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantExchangeLocalCurrencyChange_URL params:params success:^(NSDictionary *response) {
                    NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                    if ([status isEqualToString:@"1"]) {
                        
                        [subscriber sendNext:response];
                    }else{
                        
                        if ([status isEqualToString:@"622"]) {
                            
                            [IDCMViewTools ToastView:[UIApplication sharedApplication].delegate.window info:[NSString stringWithFormat:@"%@",SWLocaloziString(@"3.0_AcceptantReAddCoinType")] position:QMUIToastViewPositionBottom];
                        }else{
                            
                            [IDCMShowMessageView showMessageWithCode:status];
                        }
                    }
                    [subscriber sendCompleted];
                    
                } fail:^(NSError *error, NSURLSessionDataTask *task) {
                    [subscriber sendError:error];
                }];
                return [RACDisposable disposableWithBlock:^{
                    [task cancel];
                }];
            }];
    }];
    
    //获取法币币种列表
    self.getOtcLocalCurrencyListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantGetOtcLocalCurrencyList_URL params:input success:^(NSDictionary *response) {
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if (![status isEqualToString:@"1"]) {
                    [IDCMShowMessageView showMessageWithCode:status];
                }else {
                    
                    if([status isEqualToString:@"1"]  && [response[@"data"] isKindOfClass:[NSArray class] ] ){
                        
                        NSArray * data = response[@"data"];
                        NSMutableArray * coinlist = [[NSMutableArray alloc] init];
                        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            IDCMLocalCurrencyModel * model =  [IDCMLocalCurrencyModel yy_modelWithDictionary:obj];
                            [coinlist addObject:model];
                        }];
                        
                        self.currencysList  = coinlist;
                    }
                    [subscriber sendNext:nil];
                }
                [subscriber sendCompleted];
                
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    }];
}


- (NSString *)title {
    return self.pageType ? NSLocalizedString(@"3.0_AcceptantEditCurrencyAndMout", nil) : NSLocalizedString(@"3.0_AcceptantAddCurrencyAndMout", nil);
}

@end
