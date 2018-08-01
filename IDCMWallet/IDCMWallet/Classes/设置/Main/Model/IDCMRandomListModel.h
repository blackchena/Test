//
//  IDCMRandomListModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/30.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDCMPhraseModel;

@interface IDCMRandomListModel : NSObject
/**
 *  存储12组随机短语model
 */
@property (strong, nonatomic) NSArray<IDCMPhraseModel *> *RandomWord;
/**
 *  存储4组验证短语model
 */
@property (strong, nonatomic) NSArray<IDCMPhraseModel *> *VerinfyWord;
@end
