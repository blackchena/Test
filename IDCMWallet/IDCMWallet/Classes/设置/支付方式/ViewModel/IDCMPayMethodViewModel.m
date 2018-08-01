//
//  IDCMPayMethodViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPayMethodViewModel.h"
#import "IDCMPayMethodModel.h"

@implementation IDCMPayMethodViewModel


- (void)initialize {
    self.QRCodeURL = @"";

    RACSignal *(^networkMethodEnbledSignal)(void) = ^RACSignal *(void){
        return [[[RACSignal combineLatest:@[RACObserve(self, currency),
                                            RACObserve(self, method),
                                            RACObserve(self, networkMethodPeopleName),
                                            RACObserve(self, networkMethodAccount),
                                            RACObserve(self, QRCodeImg)]]
                                 reduceEach:^(NSAttributedString *currency,
                                              NSAttributedString *method,
                                              NSString *networkMethodPeopleName,
                                              NSString *networkMethodAccount,
                                              UIImage *QRCodeImg){
                                     return @(currency.length &&
                                              method.length &&
                                              networkMethodPeopleName.length &&
                                              networkMethodAccount.length &&
                                              QRCodeImg != nil);
                 }] distinctUntilChanged];
    };
    
    RACSignal *(^bankCardMethodUSDEnbledSignal)(void) = ^RACSignal *(void){
        return [[[RACSignal combineLatest:@[RACObserve(self, currency),
                                            RACObserve(self, method),
                                            RACObserve(self, bankCardMethodAccount),
                                            RACObserve(self, bankCardMethodPeopleName),
                                            RACObserve(self, bankCardMethodBankName),
                                            RACObserve(self, bankCardMethodBankAddress),
                                            RACObserve(self, bankCardMethodBankCode)]]
                 reduceEach:^(NSAttributedString *currency,
                              NSAttributedString *method,
                              NSString *bankCardMethodAccount,
                              NSString *bankCardMethodPeopleName,
                              NSString *bankCardMethodBankName,
                              NSString *bankCardMethodBankAddress,
                              NSString *bankCardMethodBankCode){
                     return @(currency.length &&
                             method.length &&
                             bankCardMethodAccount.length &&
                             bankCardMethodPeopleName.length &&
                             bankCardMethodBankName.length &&
                             bankCardMethodBankAddress.length &&
                             bankCardMethodBankCode.length);
                 }] distinctUntilChanged];
    };
    
    RACSignal *(^bankCardMethodCNYEnbledSignal)(void) = ^RACSignal *(void){
        return [[[RACSignal combineLatest:@[RACObserve(self, currency),
                                            RACObserve(self, method),
                                            RACObserve(self, bankCardMethodAccount),
                                            RACObserve(self, bankCardMethodPeopleName),
                                            RACObserve(self, bankCardMethodBankName),
                                            RACObserve(self, bankCardMethodSubBankName)]]
                 reduceEach:^(NSAttributedString *currency,
                              NSAttributedString *method,
                              NSString *bankCardMethodAccount,
                              NSString *bankCardMethodPeopleName,
                              NSString *bankCardMethodBankName,
                              NSString *bankCardMethodSubBankName){
                     return @(currency.length &&
                     method.length &&
                     bankCardMethodAccount.length &&
                     bankCardMethodPeopleName.length &&
                     bankCardMethodBankName.length &&
                     bankCardMethodSubBankName.length);
                 }] distinctUntilChanged];
    };
    
    RACSignal *(^bankCardMethodVNDEnbledSignal)(void) = ^RACSignal *(void){
        return [[[RACSignal combineLatest:@[RACObserve(self, currency),
                                            RACObserve(self, method),
                                            RACObserve(self, bankCardMethodAccount),
                                            RACObserve(self, bankCardMethodPeopleName),
                                            RACObserve(self, bankCardMethodBankName),
                                            RACObserve(self, bankCardMethodBankCity),
                                            RACObserve(self, bankCardMethodSubBankName)]]
                 reduceEach:^(NSAttributedString *currency,
                              NSAttributedString *method,
                              NSString *bankCardMethodAccount,
                              NSString *bankCardMethodPeopleName,
                              NSString *bankCardMethodBankName,
                              NSString *bankCardMethodBankCity,
                              NSString *bankCardMethodSubBankName){
                     return @(currency.length &&
                     method.length &&
                     bankCardMethodAccount.length &&
                     bankCardMethodPeopleName.length &&
                     bankCardMethodBankName.length &&
                     bankCardMethodBankCity.length &&
                     bankCardMethodSubBankName.length);
                 }] distinctUntilChanged];
    };
    
    self.addNetworkMethodCommand =
    [[RACCommand alloc] initWithEnabled:networkMethodEnbledSignal()
                            signalBlock:^RACSignal *(id  input) {
                                return [RACSignal empty];
                            }];
    self.addUSDBankCardMethodCommand =
    [[RACCommand alloc] initWithEnabled:bankCardMethodUSDEnbledSignal()
                            signalBlock:^RACSignal *(id  input) {
                                return [RACSignal empty];
                            }];
    
    self.addCNYBankCardMethodCommand =
    [[RACCommand alloc] initWithEnabled:bankCardMethodCNYEnbledSignal()
                            signalBlock:^RACSignal *(id  input) {
                                return [RACSignal empty];
                            }];
    self.addVNDBankCardMethodCommand =
    [[RACCommand alloc] initWithEnabled:bankCardMethodVNDEnbledSignal()
                            signalBlock:^RACSignal *(id  input) {
                                return [RACSignal empty];
                            }];
    
    self.editNetworkMethodCommand =
    [[RACCommand alloc] initWithEnabled:networkMethodEnbledSignal()
                            signalBlock:^RACSignal *(id  input) {
                                return [RACSignal empty];
                            }];
    self.editUSDBankCardMethodCommand =
    [[RACCommand alloc] initWithEnabled:bankCardMethodUSDEnbledSignal()
                            signalBlock:^RACSignal *(id  input) {
                                return [RACSignal empty];
                            }];
    self.editCNYBankCardMethodCommand =
    [[RACCommand alloc] initWithEnabled:bankCardMethodCNYEnbledSignal()
                            signalBlock:^RACSignal *(id  input) {
                                return [RACSignal empty];
                            }];
    self.editVNDBankCardMethodCommand =
    [[RACCommand alloc] initWithEnabled:bankCardMethodVNDEnbledSignal()
                            signalBlock:^RACSignal *(id  input) {
                                return [RACSignal empty];
                            }];
    

}

- (RACCommand *)GetPaymentModeCommand{
    return SW_LAZY(_GetPaymentModeCommand, ({
        [RACCommand commandAuth:PaymentModeManagement_URL
                        serverName:ExchangeServerName
                            params:nil
                     handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                         
                     NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                     
                     if ([status isEqualToString:@"1"]) {
                         [subscriber sendNext:response];
                     }
                     else{
                         [IDCMShowMessageView showMessageWithCode:status];
                     }
                     [subscriber sendCompleted];
        }];
    }));
}
- (RACSignal *)executeRequestDataSignal:(id)input{

    NSDictionary *inputParams = (NSDictionary *)input;
    NSString *UserName;
    NSString *AccountNo;

    if (self.payMethodType == PayMethodType_Network) {
        UserName = self.networkMethodPeopleName;
        AccountNo = self.networkMethodAccount;
    }
    else{
        UserName = self.bankCardMethodPeopleName;
        AccountNo = [self.bankCardMethodAccount stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    @weakify(self);
    if (self.payMethodType != PayMethodType_Network) {
        return [self configRequestSignal:UserName
                              andAccount:AccountNo
                                  params:inputParams];
    }
    else{
        if (self.editPaymentModel && [self.editPaymentModel.PayAttributes.QRCode isEqualToString:self.QRCodeURL]) {
            return [self configRequestSignal:UserName
                                  andAccount:AccountNo
                                      params:inputParams];

        }else{
            return [[self requestImageUrl:self.QRCodeImg] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
                @strongify(self);
                NSInteger status = [value[@"status"] integerValue];
                if ([value[@"data"] isNotBlank] && status == 1) {
                    NSString *url = [NSString idcw_stringWithFormat:@"%@",value[@"data"]];
                    self.QRCodeURL = url;
                }
                return [self configRequestSignal:UserName
                                      andAccount:AccountNo
                                          params:inputParams];
            }];
        }
    }

}

- (RACSignal *)configRequestSignal:(NSString *)UserName
                        andAccount:(NSString *)AccountNo
                            params:(NSDictionary *)inputParams{
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSDictionary *PayAttributes = @{
                                    @"UserName":UserName,
                                    @"AccountNo":AccountNo,
                                    @"BankName":self.bankCardMethodBankName,
                                    @"SwiftCode":self.bankCardMethodBankCode,
                                    @"City":self.bankCardMethodBankCity,
                                    @"BankAddress":self.bankCardMethodBankAddress,
                                    @"BankBranch":self.bankCardMethodSubBankName,
                                    @"QRCode":self.QRCodeURL
                                    };
    
    NSMutableDictionary *params = inputParams.mutableCopy;
    [params setObject:self.editPaymentModel.ID ? self.editPaymentModel.ID : @"" forKey:@"ID"];
    [params setObject:model.device_id forKey:@"DeviceId"];
    [params setObject:PayAttributes forKey:@"PayAttributes"];
    
    return [RACSignal signalAuth:PaymentModeChange_URL serverName:nil params:params handleSignal:nil];
}


- (RACSignal *)requestImageUrl:(UIImage *)image{
    
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        IDCMURLSessionTask *task = [IDCMNetWorking uploadWithImage:image url:UploadFile_URL filename:nil name:@"CertFacade" mimeType:@"image/jpeg" parameters:nil progress:nil success:^(id response, NSURLSessionDataTask *task) {
            
            [subscriber sendNext:response];
            [subscriber sendCompleted];
            
        } fail:^(NSError *error, NSURLSessionDataTask *task) {
            [IDCMShowMessageView showMessageWithCode:@""];
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
        
    }] retry:1];
}
@end
