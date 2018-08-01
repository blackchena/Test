//
//  IDCMPhraseModel.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/30.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCMPhraseModel : NSObject
/**
 *   短语
 */
@property (copy, nonatomic) NSString *phrase;
/**
 *  序号
 */
@property (strong, nonatomic) NSNumber *serial_number;
@end
