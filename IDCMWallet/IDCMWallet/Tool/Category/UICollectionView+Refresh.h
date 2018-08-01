//
//  UICollectionView+Refresh.h
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Refresh)
/**
 给tableView增加上下拉刷新 (KK)
 
 @param headerRefreshBlock 头部进入刷新的时候会调用的方法 如果传空，则头部不能刷新
 @param footerRefreshBlock  尾部进入刷新的时候会调用的方法 如果传空，则尾部不能刷新
 */
- (void)addRefreshForTableViewHeaderWithKaKaHeaderBlock:(void(^)(void))headerRefreshBlock footerWithKaKaFooterBlock:(void(^)(void))footerRefreshBlock;

//停止刷新
- (void)endRefreshWithTitle:(NSString *)title;

@end
