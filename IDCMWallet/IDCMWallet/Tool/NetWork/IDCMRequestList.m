
//
//  IDCMRequestList.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMRequestList.h"
#import "IDCMUserInfoModel.h"


@implementation IDCMRequestList
+ (IDCMURLSessionTask *)requestNotAuth:(NSString *)url params:(id)params success:(IDCMDataSuccess)success fail:(IDCMDataFail)fail
{
    
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSString *auth = [NSString stringWithFormat:@"BasicAuth %@",model.Ticket];
    NSDictionary *authDic = @{@"Authorization":auth,
                              @"language-code":[NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod getServiceLanguage]]
                              };
    [IDCMNetWorking configCommonHttpHeaders:authDic];
    
    IDCMURLSessionTask *session = nil;
    session = [IDCMNetWorking postWithUrl:url refreshCache:YES showHUD:NSLocalizedString(@"Load", nil) params:params success:^(id response,NSURLSessionDataTask *task) {
        
        [IDCMRequestList showPhraseLogin:task];
        
        NSDictionary *dic = response;
        success(dic);
        
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
        if (fail) {
            fail(error,task);
        }
        if (error.code == -999) {
            // 请求取消
        }else{
            [IDCMRequestList showErrorView];
        }
    }];
    
    return session;
}
+ (IDCMURLSessionTask *)requestPostNoHUDAuth:(NSString *)url params:(id)params success:(IDCMDataSuccess)success fail:(IDCMDataFail)fail
{
    
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSString *auth = [NSString stringWithFormat:@"BasicAuth %@",model.Ticket];
    NSDictionary *authDic = @{@"Authorization":auth,
                              @"language-code":[NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod getServiceLanguage]]
                              };
    [IDCMNetWorking configCommonHttpHeaders:authDic];
    
    IDCMURLSessionTask *session = nil;
    
    session = [IDCMNetWorking postWithUrl:url refreshCache:YES params:params success:^(id response,NSURLSessionDataTask *task) {
        
        [IDCMRequestList showPhraseLogin:task];
        
        NSDictionary *dic = response;
        success(dic);
        
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
        if (fail) {
            fail(error,task);
        }
        if (error.code == -999) {
            // 请求取消
        }else{
            [IDCMRequestList showErrorView];
        }
    }];
    
    return session;
}
+ (IDCMURLSessionTask *)requestGetNotAuth:(NSString *)url params:(id)params success:(IDCMDataSuccess)success fail:(IDCMDataFail)fail
{
    
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSString *auth = [NSString stringWithFormat:@"BasicAuth %@",model.Ticket];
    NSDictionary *authDic = @{@"Authorization":auth,
                              @"language-code":[NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod getServiceLanguage]]
                              };
    [IDCMNetWorking configCommonHttpHeaders:authDic];
    
    IDCMURLSessionTask *session = nil;
    session = [IDCMNetWorking getWithUrl:url refreshCache:YES success:^(id response,NSURLSessionDataTask *task) {
        
        [IDCMRequestList showPhraseLogin:task];
        
        NSDictionary *dic = response;
        success(dic);
        
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
        if (fail) {
            fail(error,task);
        }
        if (error.code == -999) {
            // 请求取消
        }else{
            [IDCMRequestList showErrorView];
        }
    }];
    
    return session;
}
+ (IDCMURLSessionTask *)requestGetNotAuthHUD:(NSString *)url params:(id)params success:(IDCMDataSuccess)success fail:(IDCMDataFail)fail
{
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSString *auth = [NSString stringWithFormat:@"BasicAuth %@",model.Ticket];
    NSDictionary *authDic = @{@"Authorization":auth,
                              @"language-code":[NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod getServiceLanguage]]
                              };
    [IDCMNetWorking configCommonHttpHeaders:authDic];
    
    IDCMURLSessionTask *session = nil;
    session = [IDCMNetWorking getWithUrl:url refreshCache:YES showHUD:NSLocalizedString(@"Load", nil) success:^(id response,NSURLSessionDataTask *task) {
        
        [IDCMRequestList showPhraseLogin:task];
        
        NSDictionary *dic = response;
        success(dic);
        
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
        
        if (fail) {
            fail(error,task);
        }
        if (error.code == -999) {
            // 请求取消
        }else{
            [IDCMRequestList showErrorView];
        }
        
    }];
    
    return session;
}
+ (IDCMURLSessionTask *)requestAuth:(NSString *)url params:(id)params success:(IDCMDataSuccess)success fail:(IDCMDataFail)fail
{
    
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSString *auth = [NSString stringWithFormat:@"BasicAuth %@",model.Ticket];
    NSDictionary *authDic = @{@"Authorization":auth,
                              @"language-code":[NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod getServiceLanguage]]
                              };
    [IDCMNetWorking configCommonHttpHeaders:authDic];
    
    IDCMURLSessionTask *session = nil;
    session = [IDCMNetWorking postWithUrl:url refreshCache:YES showHUD:NSLocalizedString(@"Load", nil) params:params success:^(id response,NSURLSessionDataTask *task) {
        
        [IDCMRequestList showPhraseLogin:task];
        
        NSDictionary *dic = response;
        success(dic);
        
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
        if (fail) {
            fail(error,task);
        }
        if (error.code == -999) {
            // 请求取消
        }else{
            [IDCMRequestList showErrorView];
        }
    }];
    
    return session;
}
+ (IDCMURLSessionTask *)requestPostAuthNoHUD:(NSString *)url params:(id)params success:(IDCMDataSuccess)success fail:(IDCMDataFail)fail
{
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSString *auth = [NSString stringWithFormat:@"BasicAuth %@",model.Ticket];
    NSDictionary *authDic = @{@"Authorization":auth,
                              @"language-code":[NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod getServiceLanguage]]
                              };
    [IDCMNetWorking configCommonHttpHeaders:authDic];
    
    IDCMURLSessionTask *session = nil;
    
    session = [IDCMNetWorking postWithUrl:url refreshCache:YES params:params success:^(id response,NSURLSessionDataTask *task) {
        
        [IDCMRequestList showPhraseLogin:task];
        
        NSDictionary *dic = response;
        success(dic);
        
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
        if (fail) {
            fail(error,task);
        }
        if (error.code == -999) {
            // 请求取消
        }else{
            [IDCMRequestList showErrorView];
        }
    }];
    
    return session;
}
+ (IDCMURLSessionTask *)requestGetAuth:(NSString *)url params:(id)params success:(IDCMDataSuccess)success fail:(IDCMDataFail)fail
{
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSString *auth = [NSString stringWithFormat:@"BasicAuth %@",model.Ticket];
    NSDictionary *authDic = @{@"Authorization":auth,
                              @"language-code":[NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod getServiceLanguage]]
                              };
    [IDCMNetWorking configCommonHttpHeaders:authDic];
    
    IDCMURLSessionTask *session = nil;
    
    session = [IDCMNetWorking getWithUrl:url refreshCache:YES showHUD:NSLocalizedString(@"Load", nil) params:params success:^(id response,NSURLSessionDataTask *task) {
        
        [IDCMRequestList showPhraseLogin:task];
        
        NSDictionary *dic = response;
        success(dic);
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
        if (fail) {
            fail(error,task);
        }
        
        if (error.code == -999) {
            // 请求取消
        }else{
            [IDCMRequestList showErrorView];
        }
        
    }];
    return session;
}
+ (IDCMURLSessionTask *)requestGetNoHUDAuth:(NSString *)url params:(id)params success:(IDCMDataSuccess)success fail:(IDCMDataFail)fail
{
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSString *auth = [NSString stringWithFormat:@"BasicAuth %@",model.Ticket];
    NSDictionary *authDic = @{@"Authorization":auth,
                              @"language-code":[NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod getServiceLanguage]]
                              };
    [IDCMNetWorking configCommonHttpHeaders:authDic];
    
    IDCMURLSessionTask *session = nil;
    
    session = [IDCMNetWorking getWithUrl:url refreshCache:YES params:params success:^(id response,NSURLSessionDataTask *task) {
        
        [IDCMRequestList showPhraseLogin:task];
        
        NSDictionary *dic = response;
        success(dic);
        
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
        if (fail) {
            fail(error,task);
        }
        if (error.code == -999) {
            // 请求取消
        }else{
            [IDCMRequestList showErrorView];
        }
    }];
    
    return session;
}

+ (IDCMURLSessionTask *)requestGetAuthNotStatus:(NSString *)url params:(id)params success:(IDCMDataSuccess)success fail:(IDCMDataFail)fail
{
    IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    NSString *auth = [NSString stringWithFormat:@"BasicAuth %@",model.Ticket];
    NSDictionary *authDic = @{@"Authorization":auth,
                              @"language-code":[NSString idcw_stringWithFormat:@"%@",[IDCMUtilsMethod getServiceLanguage]]
                              };
    [IDCMNetWorking configCommonHttpHeaders:authDic];
    
    IDCMURLSessionTask *session = nil;
    
    session = [IDCMNetWorking getWithUrl:url refreshCache:YES showHUD:NSLocalizedString(@"Load", nil) params:params success:^(id response,NSURLSessionDataTask *task) {
        
        [IDCMRequestList showPhraseLogin:task];
        
        NSDictionary *dic = response;
        success(dic);
        
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
        if (fail) {
            fail(error,task);
        }
        if (error.code == -999) {
            // 请求取消
        }else{
            [IDCMRequestList showErrorView];
        }
    }];
    return session;
}
// 展示助记词在另一台设备登录的弹框
+ (void)showPhraseLogin:(NSURLSessionDataTask *)task
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
    NSDictionary *allHeaders = res.allHeaderFields;
    
    for (NSString *key in allHeaders) {
        if ([key isEqualToString:@"multidevice"]) {
            
            [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.2.3_SeedDevices") message:nil buttonArray:@[SWLocaloziString(@"2.0_gongxiButton")] actionBlock:^(NSInteger clickIndex) {}];
        }
    }
}
// 展示网络错误时候的提示框
+ (void)showErrorView
{
 
    if (IDCM_APPDelegate.networkStatus == NotReachable) {
        [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.0_NotNetWork")];
    }else{
        [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.0_RequestError")];
    }
    
    
}
@end
