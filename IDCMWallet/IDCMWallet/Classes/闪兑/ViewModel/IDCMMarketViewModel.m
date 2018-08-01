//
//  IDCMMarketViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/12.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBioMetricAuthenticator.h"
#import "IDCMMarketViewModel.h"
#import "IDCMUserStateModel.h"
#import "IDCMUserInfoModel.h"
#import "IDCMCheckPINView.h"


@implementation IDCMMarketViewModel

+ (RACSignal *(^)(id))flashExchangeCheckSignalFlattenMap {
    
    return ^RACSignal *(id value) {
        
        NSNumber *checkResult = @0;
        
        IDCMUserStateModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserStatusInfokey];
        if ([model.payPassword isEqualToString:@"0"]) {             // 没有设置PIN
            checkResult = @(FlashExchangeCheckSignalType_NoSetPIN);
            
        } else {
            
            ([IDCMBioMetricAuthenticator canAuthenticate]    &&
            [self checkTouchIDKeyReturnPinPassword].length)  ?
            (checkResult = @(FlashExchangeCheckSignalType_HasIDTouch)) :         // 设置了PIN 设置了指纹首选
            (checkResult = @(FlashExchangeCheckSignalType_HasSetPIN))  ;        // 没有设置指纹首选 设置了PIN
        }
        return [RACSignal return:checkResult];
    };
}


+ (flashExchangeSuber)flashExchangeCheckSignalSuberWithCompletionAction:(completionAction)action {
    
    return ^(NSNumber *value){

        NSInteger signaltype = [value integerValue];
        switch (signaltype) {
            case FlashExchangeCheckSignalType_NoSetPIN: {
                [IDCMShowMessageView
                 showErrorWithMessage:NSLocalizedString(@"2.0_PleaseSetPayWord", nil)];
            }break;
                
            case FlashExchangeCheckSignalType_HasIDTouch:
            case FlashExchangeCheckSignalType_HasSetPIN : {
                
                NSString *title = NSLocalizedString(@"3.0_FlashExchangeCheckPINTip", nil);
                [IDCMCheckPINView showWithContentTitle:title
                                       suceessCallback:action
                                         closeCallback:nil];

                if (signaltype == FlashExchangeCheckSignalType_HasIDTouch) {
   
                    // 消失Pin过后的回调
                    typedef void(^block)(void);
                    block (^dismissPinViewCompletion)(completionAction action) = ^block (completionAction action){
                        return ^{ action([self checkTouchIDKeyReturnPinPassword]); };
                    };
                    // 消失PinView
                    block dismissPinView = ^{
                        [IDCMCheckPINView dismissWithCompletion:dismissPinViewCompletion(action)];
                    };
                    // 延时执行的动作 -> 指纹弹框 -> 成功主动消失PinView -> 消失完成回调pinPassword
                    block schedule = ^{
                         [self showIDTouchWithSuccessAction:dismissPinView];
                    };
                    
                    [[RACScheduler mainThreadScheduler] afterDelay:.05 schedule:schedule];
                }
            }break;
            default:
            break;
        }
    };
}

// 系统指纹弹框
+ (void)showIDTouchWithSuccessAction:(void(^)(void))action  {
    
    NSString *reason = isiPhoneX ?
    NSLocalizedString(@"2.0_VerifyFaceID", nil) :
    NSLocalizedString(@"2.0_VerifyTouchID", nil);
    [IDCMBioMetricAuthenticator authenticateWithBioMetricsOfReason:reason
                                                      successBlock:action
                                                      failureBlock:nil];
}

//验证指纹 返回pin密码
+ (NSString *)checkTouchIDKeyReturnPinPassword {
    
    __block NSString *pinPassword = nil;
    NSMutableDictionary *dataDic = [IDCMUtilsMethod getKeyedArchiverWithKey:FaceIDOrTouchIDKey];
    if ([dataDic count] > 0 && dataDic) {
        IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
        [dataDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if ([model.user_name isEqualToString:key]) {
                NSString *PIN = obj;
                pinPassword = aesDecryptString(PIN,AESLockPINKey);
                *stop = YES;
            }
        }];
    }
    return pinPassword;
}

@end






