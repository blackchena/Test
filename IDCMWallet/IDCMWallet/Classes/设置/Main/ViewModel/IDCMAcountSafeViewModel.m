//
//  IDCMAcountSafeViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/27.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcountSafeViewModel.h"
#import "IDCMAcountSafeListModel.h"


@implementation IDCMAcountSafeViewModel

- (NSMutableArray *)getSettingListArray
{
    NSMutableArray *list = @[].mutableCopy;
    NSMutableArray *listArray = @[].mutableCopy;
    
    IDCMUserInfoModel *userModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
    IDCMUserStateModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserStatusInfokey];
    
    NSString *walletName = @"";
    NSString *mobile = @"";
    NSString *email = @"";
    NSString *backUp = @"";
    NSString *PIN = SWLocaloziString(@"2.2.3_AcountPINSet");
    
    NSNumber *walletNameStatus = @(1);
    NSNumber *mobileStatus ;
    NSNumber *emailNameStatus ;
    NSNumber *backupStatus ;
    NSNumber *PINStatus = @(1);
    
    if ([userModel.user_name isNotBlank]) {
        walletName = userModel.user_name;
    }
    if ([userModel.mobile isNotBlank]) {
        mobile = userModel.mobile;
        mobileStatus = @(1);
    }else{
        mobile = SWLocaloziString(@"2.2.3_AcountNotBind");
        mobileStatus = @(0);
    }
    if ([userModel.email isNotBlank]) {
        email = userModel.email;
        emailNameStatus = @(1);
    }else{
        email = SWLocaloziString(@"2.2.3_AcountNotBind");
        emailNameStatus = @(0);
    }
    if ([model.wallet_phrase isEqualToString:@"1"]) {
        backUp = SWLocaloziString(@"2.2.3_AcountBackUp");
        backupStatus = @(1);
    }else{
        backUp = SWLocaloziString(@"2.2.3_AcountBackUpNot");
        backupStatus = @(0);
    }
    
    
    NSArray *title = @[SWLocaloziString(@"2.2.3_WalletName"),SWLocaloziString(@"2.2.3_AcountMobile"),SWLocaloziString(@"2.2.3_AcountEmail"),SWLocaloziString(@"2.2.3_AcountBackUpSeed"),SWLocaloziString(@"2.2.3_AcountPINManagment")];
    
    NSArray *detailTitle = @[walletName,mobile,email,backUp,PIN];
    
    NSArray *statusArr = @[walletNameStatus,mobileStatus,emailNameStatus,backupStatus,PINStatus];

    NSArray *className = @[@"",@"IDCMBindMobileController",@"IDCMBindEmailController",@"IDCMNowBackupMemorizingWordsController",@"IDCMSetPayPassWordController"];
    NSArray *viewModelName = @[@"",@"IDCMBindMobileViewModel",@"IDCMBindEmailViewModel",@"IDCMBackupMemorizingWordsViewModel",@"IDCMSetPayPassWordViewModel"];
    
    for (NSInteger i = 0; i < 3 ; i++) {

        IDCMAcountSafeListModel *model = [[IDCMAcountSafeListModel alloc] init];
        model.title = title[i];
        model.viewModel = viewModelName[i];
        model.classString = className[i];
        model.detailName = detailTitle[i];
        model.status = statusArr[i];
        [list addObject:model];
    }
    for (NSInteger i = 3; i < 5; i++) {

        IDCMAcountSafeListModel *model = [[IDCMAcountSafeListModel alloc] init];
        model.title = title[i];
        model.viewModel = viewModelName[i];
        model.classString = className[i];
        model.detailName = detailTitle[i];
        model.status = statusArr[i];
        [listArray addObject:model];
    }
    
    return @[list,listArray].mutableCopy;
}
@end

