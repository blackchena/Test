//
//  IDCMSettingMemorizingWordsViewModel.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMSettingMemorizingWordsViewModel : IDCMBaseViewModel

@property (copy, nonatomic) NSString *oneText;
@property (copy, nonatomic) NSString *twoText;
@property (copy, nonatomic) NSString *threeText;
@property (copy, nonatomic) NSString *fourText;
@property (copy, nonatomic) NSString *fiveText;
@property (copy, nonatomic) NSString *sixText;
@property (copy, nonatomic) NSString *sevenText;
@property (copy, nonatomic) NSString *eightText;
@property (copy, nonatomic) NSString *nineText;
@property (copy, nonatomic) NSString *tenText;
@property (copy, nonatomic) NSString *elevenText;
@property (copy, nonatomic) NSString *twelveText;

@property (nonatomic,strong) RACCommand *sureCommand;
@property (nonatomic,strong) void(^endEditingCallback)(void);

// 仅供开发调试使用（debug）
@property (nonatomic,strong) RACCommand *testCommand;
@end
