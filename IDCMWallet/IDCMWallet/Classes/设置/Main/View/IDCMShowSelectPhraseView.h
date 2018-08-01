//
//  IDCMShowSelectPhraseView.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMPhraseModel.h"


@interface IDCMShowSelectPhraseView : UIView

/**
 *  展示的数组
 */
@property (strong, nonatomic) NSArray <IDCMPhraseModel *> *listModelArray;

/**
 *  选中的单词
 */
@property (strong, nonatomic) NSNumber *selectIndex;
/**
 *  恢复选中的单词
 */
@property (strong, nonatomic) IDCMPhraseModel *UnSelectModel;

@end
