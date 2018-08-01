//
//  NSDictionary+Extension.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/10.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^objectBlock)(id value, BOOL suceess);
@interface NSDictionary (Extension)


- (void)idcw_objectForKey:(NSString *)key
              objectClass:(Class)objectClass
               completion:(objectBlock)completion;

- (void)createPropertyCode;


@end
