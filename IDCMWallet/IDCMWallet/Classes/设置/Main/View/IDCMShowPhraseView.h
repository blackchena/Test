//
//  IDCMShowPhraseView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMShowPhraseView
// @abstract <#类的描述#>
// @discussion <#类的功能#>
#import <UIKit/UIKit.h>
#import "IDCMPhraseModel.h"
#import "KVOMutableArray.h"

@interface IDCMShowPhraseView : UIView
/**
 *  选中的单词
 */
@property (strong, nonatomic) IDCMPhraseModel *selectModel;
/**
 *  恢复选中的单词
 */
@property (strong, nonatomic) IDCMPhraseModel *UnSelectModel;
/**
 *  添加的数组
 */
@property (strong, nonatomic) KVOMutableArray *selectArr;
@end
