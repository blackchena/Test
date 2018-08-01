//
//  IDCMImagePickerViewController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/18.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMImagePickerViewController.h"


@implementation IDCMImagePickerViewController
- (void)viewDidLoad {
    self.animated = YES;
    [super viewDidLoad];
}

- (void)initSubviews {
    [super initSubviews];
    [self.sendButton setTitle:NSLocalizedString(@"2.0_Complete", nil) forState:UIControlStateNormal];
    [self.previewButton setTitle:NSLocalizedString(@"3.0_Hy_PhotoAlbumPreview", nil) forState:UIControlStateNormal];
    [self.sendButton sizeToFit];
    [self.previewButton sizeToFit];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem qmui_itemWithTitle:NSLocalizedString(@"3.0_Hy_cancel", nil)
                                 target:self
                                 action:@selector(handleCancelPickerImage:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *maxStr = [NSString stringWithFormat:@"%zd", self.maximumSelectImageCount];
    NSString *str =
    [NSLocalizedString(@"3.0_Hy_selectPhotoMaxCount", nil) stringByReplacingOccurrencesOfString:@"[IDCW_HY]" withString:maxStr];
    self.alertTitleWhenExceedMaxSelectImageCount = str;
    self.alertButtonTitleWhenExceedMaxSelectImageCount = NSLocalizedString(@"3.0_IKnow", nil);
}

- (NSMutableArray<UIImageView *> *)selectedImageViews {
    NSMutableArray *selectedImageViews = [NSMutableArray array];
    NSArray<QMUIImagePickerCollectionViewCell *> *cells = self.collectionView.visibleCells;
    [cells enumerateObjectsUsingBlock:^(QMUIImagePickerCollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
        if (cell.isChecked) {
            [selectedImageViews addObject:cell.contentImageView];
        }
    }];
    return selectedImageViews;
}

- (void)handleSendButtonClick:(id)sender {
    if (self.imagePickerViewControllerDelegate && [self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:didFinishPickingImageWithImagesAssetArray:)]) {
        [self.imagePickerViewControllerDelegate imagePickerViewController:self didFinishPickingImageWithImagesAssetArray:self.selectedImageAssetArray];
    }
    [self.navigationController dismissViewControllerAnimated:self.animated completion:NULL];
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







