//
//  IDCMVerifyPhrasesOrderViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/22.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseViewModel.h"
#import "IDCMRandomListModel.h"
#import "IDCMPhraseModel.h"

@interface IDCMVerifyPhrasesOrderViewModel : IDCMBaseViewModel
/**
 *  listModel
 */
@property (strong, nonatomic) NSMutableArray<IDCMPhraseModel *> *listModelArray;
/**
 *  listModel
 */
@property (strong, nonatomic) IDCMRandomListModel *listModel;


/**
 选中的备份短语
 */
@property (nonatomic,strong) NSMutableArray <IDCMPhraseModel *> *userSelectedModelArray;


/**
 打乱数组的顺序

 @param array 需要打乱的数据源
 @return 打乱后的数据
 */
+ (NSArray<IDCMPhraseModel *> *)resetArrayOderWithArray:(NSArray<IDCMPhraseModel *> *)array;

/**
 *  备份的类型  0:创建钱包时备份  1：进入应用是备份  2：老用户备份
 */
@property (strong, nonatomic) NSNumber *backupType;

@end
