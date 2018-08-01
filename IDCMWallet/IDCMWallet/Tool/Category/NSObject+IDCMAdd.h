//
//  NSObject+IDCMAdd.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (IDCMAdd)
/**
 Returns a copy of the instance with `NSKeyedArchiver` and ``NSKeyedUnarchiver``.
 Returns nil if an error occurs.
 */
- (nullable id)deepCopy;

/**
 Returns a copy of the instance use archiver and unarchiver.
 Returns nil if an error occurs.
 
 @param archiver   NSKeyedArchiver class or any class inherited.
 @param unarchiver NSKeyedUnarchiver clsas or any class inherited.
 */
- (nullable id)deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver;
@end
NS_ASSUME_NONNULL_END
