//
//  UITableView+Refresh.m
//  RMTiOSApp
//
//  Created by Jason on 2016/11/2.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "UITableView+Refresh.h"


@implementation UITableView (Refresh)

#pragma mark
#pragma mark - KakaRefesh
- (void)addRefreshForTableViewHeaderWithKaKaHeaderBlock:(void (^)(void))headerRefreshBlock footerWithKaKaFooterBlock:(void (^)(void))footerRefreshBlock
{
    if (headerRefreshBlock) {
        [self bindRefreshStyle:KafkaRefreshStyleReplicatorCircle
                                          fillColor:kThemeColor
                            animatedBackgroundColor:[UIColor clearColor]
                                         atPosition:KafkaRefreshPositionHeader refreshHanler:^{
                                             dispatch_main_async_safe(^{
                                                 headerRefreshBlock();
                                             });
                                         }];
        self.headRefreshControl.backgroundColor = [UIColor clearColor];
        [self.headRefreshControl setAlertTextColor:kThemeColor];
    }
    
    if (footerRefreshBlock) {
        
        [self bindRefreshStyle:KafkaRefreshStyleReplicatorCircle
                     fillColor:kThemeColor
       animatedBackgroundColor:[UIColor clearColor]
                    atPosition:KafkaRefreshPositionFooter refreshHanler:^{
                        dispatch_main_async_safe(^{
                            footerRefreshBlock();
                        });
                    }];
        self.footRefreshControl.hidden = YES;
        [self.footRefreshControl setAlertTextColor:SetColor(204, 204, 204)];
        [self.footRefreshControl setAlertBackgroundColor:self.backgroundColor]; 
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.footRefreshControl setAlertTextColor:SetColor(204, 204, 204)];
    [self.footRefreshControl setAlertBackgroundColor:self.backgroundColor];
}

- (void)endRefreshWithTitle:(NSString *)title
{
   
    if ([title isNotBlank]) {
        [self.headRefreshControl endRefreshingWithAlertText:title completion:nil];
//      [self.footRefreshControl endRefreshingWithAlertText:title completion:nil];
    }else{
        [self.headRefreshControl endRefreshing];
//      [self.footRefreshControl endRefreshing];
    }
    [self.footRefreshControl endRefreshing];

}
@end

















