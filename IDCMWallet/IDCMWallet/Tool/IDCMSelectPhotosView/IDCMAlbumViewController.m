//
//  IDCMAlbumViewController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/29.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMAlbumViewController.h"


@interface IDCMAlbumViewController ()
@property(nonatomic, strong) NSMutableArray<QMUIAssetsGroup *> *albumsArray;
@property (nonatomic,assign) BOOL photoAuthoritySuccess;
@end


@implementation IDCMAlbumViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([QMUIAssetsManager authorizationStatus] != QMUIAssetAuthorizationStatusAuthorized) {
        [self checkPhotoAuthority];
        @weakify(self);
        [RACObserve(self, photoAuthoritySuccess) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if ([x boolValue]) {
                [self configPotho];
            }
        }];
    }
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    if (!self.title) {
        self.title = NSLocalizedString(@"2.1_SelectSingleImage", nil);
    }
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem qmui_itemWithTitle:NSLocalizedString(@"3.0_Hy_cancel", nil)
                                 target:self
                                 action:@selector(handleCancelSelectAlbum:)];
}

- (void)configPotho {
    self.albumsArray = [[NSMutableArray alloc] init];
    // 获取相册列表较为耗时，交给子线程去处理，因此这里需要显示 Loading
    if ([self.albumViewControllerDelegate respondsToSelector:@selector(albumViewControllerWillStartLoading:)]) {
        [self.albumViewControllerDelegate albumViewControllerWillStartLoading:self];
    }
    if (self.shouldShowDefaultLoadingView) {
        [self showEmptyViewWithLoading];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __weak __typeof(self)weakSelf = self;
        [[QMUIAssetsManager sharedInstance] enumerateAllAlbumsWithAlbumContentType:self.contentType usingBlock:^(QMUIAssetsGroup *resultAssetsGroup) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 这里需要对 UI 进行操作，因此放回主线程处理
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (resultAssetsGroup) {
                    [strongSelf.albumsArray addObject:resultAssetsGroup];
                } else {
                    if ([strongSelf respondsToSelector:NSSelectorFromString(@"refreshAlbumAndShowEmptyTipIfNeed")]) {
                        [strongSelf performSelectorOnMainThread:NSSelectorFromString(@"refreshAlbumAndShowEmptyTipIfNeed")
                                               withObject:nil
                                            waitUntilDone:NO];
                    }
//                  [strongSelf refreshAlbumAndShowEmptyTipIfNeed];
                }
            });
        }];
    });
}

- (void)checkPhotoAuthority {
    @weakify(self);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        @strongify(self);
        self.photoAuthoritySuccess = status == PHAuthorizationStatusAuthorized;
    }];
}

- (void)dealloc {
    [self removeBlackView];
}

- (void)removeBlackView {
    UIView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:10245];
    if (!view) {return;}
    [UIView animateWithDuration:.3 animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

@end











