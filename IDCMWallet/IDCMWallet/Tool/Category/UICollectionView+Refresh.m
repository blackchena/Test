//
//  UICollectionView+Refresh.m
//  IDCMWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "UICollectionView+Refresh.h"

@implementation UICollectionView (Refresh)
#pragma mark
#pragma mark - KakaRefesh
- (void)addRefreshForTableViewHeaderWithKaKaHeaderBlock:(void (^)(void))headerRefreshBlock
                              footerWithKaKaFooterBlock:(void (^)(void))footerRefreshBlock
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
        //      [self addRefreshNormalFooterWithRefreshBlock:footerRefreshBlock];
    }
}

- (void)endRefreshWithTitle:(NSString *)title {
    if ([title isNotBlank]) {
        [self.headRefreshControl endRefreshingWithAlertText:title completion:nil];
    }else{
        [self.headRefreshControl endRefreshing];
    }
    [self.footRefreshControl endRefreshing];
}
@end
