//
//  UITableView+Refresh.h
//  RMTiOSApp
//
//  Created by Jason on 2016/11/2.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
@interface UITableView (Refresh)

/**
 给tableView增加上下拉刷新 (KK)
 
 @param headerRefreshBlock 头部进入刷新的时候会调用的方法 如果传空，则头部不能刷新
 @param footerRefreshBlock  尾部进入刷新的时候会调用的方法 如果传空，则尾部不能刷新
 */
- (void)addRefreshForTableViewHeaderWithKaKaHeaderBlock:(void(^)(void))headerRefreshBlock footerWithKaKaFooterBlock:(void(^)(void))footerRefreshBlock;

//停止刷新
- (void)endRefreshWithTitle:(NSString *)title;

@end
