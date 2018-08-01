//
//  IDCMRandomListModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/30.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMRandomListModel.h"
#import "IDCMPhraseModel.h"

@implementation IDCMRandomListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"RandomWord":[IDCMPhraseModel class],@"VerinfyWord":[IDCMPhraseModel class]};
}
@end
