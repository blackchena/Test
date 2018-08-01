//
//  IDCMSettingsViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/25.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMSettingListModel.h"

@interface IDCMSettingsViewModel : IDCMBaseViewModel

/**
 检查版本更新
 */
@property (nonatomic, strong) RACCommand *checkUpdateCommand;
@property (nonatomic, strong) RACCommand *getStatecommand;
@property (nonatomic, strong) NSString   *webLink;

- (NSMutableArray *)getSettingListArray;


@end
