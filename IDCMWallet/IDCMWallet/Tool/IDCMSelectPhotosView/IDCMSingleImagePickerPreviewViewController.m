//
//  IDCMSingleImagePickerPreviewViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/18.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSingleImagePickerPreviewViewController.h"


@implementation IDCMSingleImagePickerPreviewViewController{
    QMUIButton *_confirmButton;
}

@dynamic delegate;
- (void)initSubviews {
    [super initSubviews];

    _confirmButton = [[QMUIButton alloc] init];
    _confirmButton.qmui_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    [_confirmButton setTitleColor:self.toolBarTintColor forState:UIControlStateNormal];
    [_confirmButton setTitle:SWLocaloziString(@"2.1_UseImage") forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(handleUserAvatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton sizeToFit];
    [self.topToolBarView addSubview:_confirmButton];
    [self.checkboxButton setImage:[UIImage new] forState:UIControlStateNormal];
    [self.checkboxButton setImage:[UIImage new] forState:UIControlStateSelected];
}

- (void)setDownloadStatus:(QMUIAssetDownloadStatus)downloadStatus {
    [super setDownloadStatus:downloadStatus];
    switch (downloadStatus) {
        case QMUIAssetDownloadStatusSucceed:
            _confirmButton.hidden = NO;
            break;
            
        case QMUIAssetDownloadStatusDownloading:
            _confirmButton.hidden = YES;
            break;
            
        case QMUIAssetDownloadStatusCanceled:
            _confirmButton.hidden = NO;
            break;
            
        case QMUIAssetDownloadStatusFailed:
            _confirmButton.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    self.animated = YES;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backButton.alpha = 0.0;
    _confirmButton.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:.25 animations:^{
        self.backButton.alpha = 1.0;
        _confirmButton.alpha = 1.0;
    }];
    self.backButton.left = 11;
    self.backButton.centerY = ((NavigationBarHeight + IPhoneXSafeAreaInsets.top) / 2) + 20;
    if (!_confirmButton.hidden) {
        [_confirmButton sizeToFit];
        _confirmButton.right = self.topToolBarView.width - 10;
       _confirmButton.centerY = self.backButton.centerY;
    }
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    _confirmButton.frame = CGRectSetXY(_confirmButton.frame, CGRectGetWidth(self.topToolBarView.frame) - CGRectGetWidth(_confirmButton.frame) - 10, CGRectGetMinY(self.backButton.frame) + CGFloatGetCenter(CGRectGetHeight(self.backButton.frame), CGRectGetHeight(_confirmButton.frame)));
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleUserAvatarButtonClick:(id)sender {
    
    if (self.animated) {
        [self.navigationController dismissViewControllerAnimated:self.animated completion:^(void) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:didSelectImageWithImagesAsset:)]) {
                QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:self.imagePreviewView.currentImageIndex];
                [self.delegate imagePickerPreviewViewController:self didSelectImageWithImagesAsset:imageAsset];
            }
        }];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:didSelectImageWithImagesAsset:)]) {
            QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:self.imagePreviewView.currentImageIndex];
            [self.delegate imagePickerPreviewViewController:self didSelectImageWithImagesAsset:imageAsset];
        }
        [self.navigationController dismissViewControllerAnimated:self.animated completion:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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







