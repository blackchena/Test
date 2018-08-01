//
//  IDCMAcceptantPickupBondViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantPickupBondViewModel.h"
#import "IDCMAcceptantCoinModel.h"

@implementation IDCMAcceptantPickupBondViewModel
- (void)initialize {
    
    RACSignal *(^enbledSignal)(void) = ^RACSignal *(void){
        return [[[RACSignal combineLatest:@[RACObserve(self, currency),
                                            RACObserve(self, countValue),
                                            RACObserve(self, address),]]
                 reduceEach:^(NSString *currency,
                              NSString *countValue,
                              NSString *address){
                     return @(currency.length &&
                              countValue.length &&
                               address.length);
                 }] distinctUntilChanged];
    };
    
    self.btnToPickupBondcommand =[[RACCommand alloc]
                                  initWithEnabled:enbledSignal()
                                  signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                                      return [RACSignal empty];}];
    
    //提取保证金
    @weakify(self);
    RACSignal *(^pickinRequestSignal)(id input) = ^RACSignal*(id input){
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
            
            NSDictionary *parm = @{ @"CoinId"  :self.selectCoinModel.coinID,
                                    @"Amount":self.countValue,
                                    @"Address":self.address,
                                    @"PIN":input[@"PIN"],
                                    @"DeviceId":model.device_id
                                    };
            
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptantPickUpBalance_URL params:parm success:^(NSDictionary *response) {
                [subscriber sendNext:response];
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    };
    self.pickupBondcommand =  [[RACCommand alloc] initWithSignalBlock:pickinRequestSignal];
    
    self.getOTCListCoincommand =
    [RACCommand commandAuth:OTCAcceptantWithdrawCoinList_URL
                 serverName:nil
                     params:nil
              handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
          if ([status isEqualToString:@"1"] && [response[kData] isKindOfClass:[NSArray class]]) {
              NSMutableArray *coinList = @[].mutableCopy;
              for (NSDictionary *dict in response[kData]) {
                  IDCMAcceptantCoinModel *model = [IDCMAcceptantCoinModel yy_modelWithDictionary:dict];
                  [coinList addObject:model];
              }
              self.coinArray = coinList;
              [subscriber sendNext:coinList];
          }
          else{
              [IDCMShowMessageView showMessageWithCode:status];
          }
          [subscriber sendCompleted];

        
    }];
    
    self.varifyAddressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            IDCMURLSessionTask *task = [IDCMRequestList requestAuth:ValidAddress_URL params:input success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"100"]) {
                    [subscriber sendError:nil];
                }else{
                    [subscriber sendNext:response];
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
    
    self.validComplicatedAddressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            
            IDCMURLSessionTask *task = [IDCMRequestList requestPostAuthNoHUD:ValidComplicatedAddressAsync_URL params:input success:^(NSDictionary *response) {
                
                NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"100"]) {
                    [subscriber sendError:nil];
                }else{
                    [subscriber sendNext:response];
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
    
}

@end
