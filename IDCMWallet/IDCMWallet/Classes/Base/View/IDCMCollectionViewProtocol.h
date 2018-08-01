//
//  IDCMCollectionViewProtocol.h
//  IDCMWallet
//
//  Created by BinBear on 2018/5/22.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDCMCollectionViewProtocol <NSObject>
/**
 绑定一个viewmodel给view
 
 @param viewModel Viewmodel
 */
- (void)bindViewModel:(id)viewModel;
@end
