//
//  IDCMMultipleImagePickerPreviewViewController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/18.
//  Copyright © 2018年 BinBear. All rights reserved.
//


#define BottomToolBarViewHeight 45
#define ImageCountLabelSize CGSizeMake(18, 18)
#import "IDCMMultipleImagePickerPreviewViewController.h"


@implementation IDCMMultipleImagePickerPreviewViewController {
    QMUIButton *_sendButton;
    QMUIButton *_originImageCheckboxButton;
    UIView *_bottomToolBarView;
}

@dynamic delegate;
- (void)initSubviews {
    [super initSubviews];
    _bottomToolBarView = [[UIView alloc] init];
    _bottomToolBarView.backgroundColor = self.toolBarBackgroundColor;
    [self.view addSubview:_bottomToolBarView];
    
    _sendButton = [[QMUIButton alloc] init];
    _sendButton.qmui_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    [_sendButton setTitleColor:self.toolBarTintColor forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_sendButton setTitle:NSLocalizedString(@"2.0_Complete", nil) forState:UIControlStateNormal];
    _sendButton.titleLabel.font = UIFontMake(16);
    [_sendButton sizeToFit];
    [_sendButton addTarget:self action:@selector(handleSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBarView addSubview:_sendButton];
    
    _imageCountLabel = [[QMUILabel alloc] init];
    _imageCountLabel.backgroundColor = ButtonTintColor;
    _imageCountLabel.textColor = UIColorWhite;
    _imageCountLabel.font = UIFontMake(12);
    _imageCountLabel.textAlignment = NSTextAlignmentCenter;
    _imageCountLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _imageCountLabel.layer.masksToBounds = YES;
    _imageCountLabel.layer.cornerRadius = ImageCountLabelSize.width / 2;
    _imageCountLabel.hidden = YES;
    [_bottomToolBarView addSubview:_imageCountLabel];
    
    _originImageCheckboxButton = [[QMUIButton alloc] init];
    _originImageCheckboxButton.titleLabel.font = UIFontMake(14);
    [_originImageCheckboxButton setTitleColor:self.toolBarTintColor forState:UIControlStateNormal];
    [_originImageCheckboxButton setImage:UIImageMake(@"origin_image_checkbox") forState:UIControlStateNormal];
    [_originImageCheckboxButton setImage:UIImageMake(@"origin_image_checkbox_checked") forState:UIControlStateSelected];
    [_originImageCheckboxButton setImage:UIImageMake(@"origin_image_checkbox_checked") forState:UIControlStateSelected|UIControlStateHighlighted];
    [_originImageCheckboxButton setTitle:NSLocalizedString(@"3.0_Hy_originalPhoto", nil) forState:UIControlStateNormal];
    [_originImageCheckboxButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5.0f, 0, 5.0f)];
    [_originImageCheckboxButton setContentEdgeInsets:UIEdgeInsetsMake(0, 5.0f, 0, 0)];
    [_originImageCheckboxButton sizeToFit];
    _originImageCheckboxButton.qmui_outsideEdge = UIEdgeInsetsMake(-6.0f, -6.0f, -6.0f, -6.0f);
    [_originImageCheckboxButton addTarget:self action:@selector(handleOriginImageCheckboxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBarView addSubview:_originImageCheckboxButton];
    
    _originImageCheckboxButton.hidden = YES;
    
    NSString *maxStr = [NSString stringWithFormat:@"%zd", self.maximumSelectImageCount];
    NSString *str =
    [NSLocalizedString(@"3.0_Hy_selectPhotoMaxCount", nil) stringByReplacingOccurrencesOfString:@"[IDCW_HY]" withString:maxStr];
    self.alertTitleWhenExceedMaxSelectImageCount = str;
     self.alertButtonTitleWhenExceedMaxSelectImageCount = NSLocalizedString(@"3.0_IKnow", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateOriginImageCheckboxButtonWithIndex:self.imagePreviewView.currentImageIndex];
    if ([self.selectedImageAssetArray count] > 0) {
        NSUInteger selectedCount = [self.selectedImageAssetArray count];
        _imageCountLabel.text = [[NSString alloc] initWithFormat:@"%@", @(selectedCount)];
        _imageCountLabel.hidden = NO;
         _sendButton.enabled = YES;
    } else {
        _imageCountLabel.hidden = YES;
         _sendButton.enabled = NO;
    }

    self.backButton.alpha = 0.0;
    self.checkboxButton.alpha = 0.0;
    self.backButton.left = 11;
    self.backButton.centerY = ((NavigationBarHeight + IPhoneXSafeAreaInsets.top) / 2) + 20;
    if (!self.checkboxButton.hidden) {
        self.checkboxButton.size = CGSizeMake(30, 30);
        self.checkboxButton.right = self.topToolBarView.width - 10;
        self.checkboxButton.centerY = self.backButton.centerY;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.backButton.left = 11;
    self.backButton.centerY = ((NavigationBarHeight + IPhoneXSafeAreaInsets.top) / 2) + 20;
    if (!self.checkboxButton.hidden) {
        self.checkboxButton.size = CGSizeMake(30, 30);
        self.checkboxButton.right = self.topToolBarView.width - 10;
        self.checkboxButton.centerY = self.backButton.centerY;
    }
    
    CGFloat bottomToolBarPaddingHorizontal = 12.0f;
    _bottomToolBarView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - ToolBarHeight, CGRectGetWidth(self.view.bounds), ToolBarHeight);
    
    _sendButton.frame = CGRectSetXY(_sendButton.frame, CGRectGetWidth(_bottomToolBarView.frame) - bottomToolBarPaddingHorizontal - CGRectGetWidth(_sendButton.frame), CGFloatGetCenter(CGRectGetHeight(_bottomToolBarView.frame) - IPhoneXSafeAreaInsets.bottom, CGRectGetHeight(_sendButton.frame)));
    
    _imageCountLabel.frame = CGRectMake(CGRectGetMinX(_sendButton.frame) - 5 - ImageCountLabelSize.width, CGRectGetMinY(_sendButton.frame) + CGFloatGetCenter(CGRectGetHeight(_sendButton.frame), ImageCountLabelSize.height), ImageCountLabelSize.width, ImageCountLabelSize.height);
    _imageCountLabel.centerY = _sendButton.centerY;
    
    _originImageCheckboxButton.frame = CGRectSetXY(_originImageCheckboxButton.frame, bottomToolBarPaddingHorizontal, CGFloatGetCenter(CGRectGetHeight(_bottomToolBarView.frame) - IPhoneXSafeAreaInsets.bottom, CGRectGetHeight(_originImageCheckboxButton.frame)));
    _originImageCheckboxButton.centerY = _sendButton.centerY;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:.25 animations:^{
        self.backButton.alpha = 1.0;
        self.checkboxButton.alpha = 1.0;
    }];
    self.backButton.left = 11;
    self.backButton.centerY = ((NavigationBarHeight + IPhoneXSafeAreaInsets.top) / 2) + 20;
    if (!self.checkboxButton.hidden) {
        self.checkboxButton.size = CGSizeMake(25, 25);
        self.checkboxButton.right = self.topToolBarView.width - 10;
        self.checkboxButton.centerY = self.backButton.centerY;
    }
}

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    [super singleTouchInZoomingImageView:zoomImageView location:location];
    _bottomToolBarView.hidden = !_bottomToolBarView.hidden;
}

- (void)zoomImageView:(QMUIZoomImageView *)imageView didHideVideoToolbar:(BOOL)didHide {
    [super zoomImageView:imageView didHideVideoToolbar:didHide];
    _bottomToolBarView.hidden = didHide;
}

- (void)handleSendButtonClick:(id)sender {
    
    if (self.animated) {
        @weakify(self);
        [self.navigationController dismissViewControllerAnimated:self.animated completion:^(void) {
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:sendImageWithImagesAssetArray:)]) {
                if (self.selectedImageAssetArray.count == 0) {
                    // 如果没选中任何一张，则点击发送按钮直接发送当前这张大图
                    QMUIAsset *currentAsset = self.imagesAssetArray[self.imagePreviewView.currentImageIndex];
                    [self.selectedImageAssetArray addObject:currentAsset];
                }
                [self.delegate imagePickerPreviewViewController:self sendImageWithImagesAssetArray:self.selectedImageAssetArray];
            }
        }];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:sendImageWithImagesAssetArray:)]) {
            if (self.selectedImageAssetArray.count == 0) {
                // 如果没选中任何一张，则点击发送按钮直接发送当前这张大图
                QMUIAsset *currentAsset = self.imagesAssetArray[self.imagePreviewView.currentImageIndex];
                [self.selectedImageAssetArray addObject:currentAsset];
            }
            [self.delegate imagePickerPreviewViewController:self sendImageWithImagesAssetArray:self.selectedImageAssetArray];
        }
        [self.navigationController dismissViewControllerAnimated:self.animated completion:nil];
    }
}

- (void)handleOriginImageCheckboxButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        [button setTitle:NSLocalizedString(@"2.0_Complete", nil) forState:UIControlStateNormal];
        [button sizeToFit];
        [_bottomToolBarView setNeedsLayout];
    } else {
        button.selected = YES;
        [self updateOriginImageCheckboxButtonWithIndex:self.imagePreviewView.currentImageIndex];
        
    }
    self.shouldUseOriginImage = button.selected;
}

- (void)updateOriginImageCheckboxButtonWithIndex:(NSInteger)index {
//    QMUIAsset *asset = self.imagesAssetArray[index];
//    if (asset.assetType == QMUIAssetTypeAudio || asset.assetType == QMUIAssetTypeVideo) {
//        _originImageCheckboxButton.hidden = YES;
//    } else {
//        _originImageCheckboxButton.hidden = NO;
//        if (_originImageCheckboxButton.selected) {
//            [asset assetSize:^(long long size) {
//                [_originImageCheckboxButton setTitle:[NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"3.0_Hy_originalPhoto", nil), [self humanReadableFileSize:size]] forState:UIControlStateNormal];
//                [_originImageCheckboxButton sizeToFit];
//                [_bottomToolBarView setNeedsLayout];
//            }];
//        }
//    }
}

- (NSString *)humanReadableFileSize:(long long)size {
    NSString * strSize = nil;
    if (size >= 1048576.0) {
        strSize = [NSString stringWithFormat:@"%.2fM", size / 1048576.0f];
    } else if (size >= 1024.0) {
        strSize = [NSString stringWithFormat:@"%.2fK", size / 1024.0f];
    } else {
        strSize = [NSString stringWithFormat:@"%.2fB", size / 1.0f];
    }
    return strSize;
}

- (void)handleCheckButtonClick:(QMUIButton *)button {
    [QMUIImagePickerHelper removeSpringAnimationOfImageCheckedWithCheckboxButton:button];
    
    if (button.selected) {
        if ([self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:willUncheckImageAtIndex:)]) {
            [self.delegate imagePickerPreviewViewController:self willUncheckImageAtIndex:self.imagePreviewView.currentImageIndex];
        }
        
        button.selected = NO;
        QMUIAsset *imageAsset = self.imagesAssetArray[self.imagePreviewView.currentImageIndex];
        [self.selectedImageAssetArray removeObject:imageAsset];
        
        if ([self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:didUncheckImageAtIndex:)]) {
            [self.delegate imagePickerPreviewViewController:self didUncheckImageAtIndex:self.imagePreviewView.currentImageIndex];
        }
        
    } else {
        if ([self.selectedImageAssetArray count] >= self.maximumSelectImageCount) {
            if (!self.alertTitleWhenExceedMaxSelectImageCount) {
                self.alertTitleWhenExceedMaxSelectImageCount = [NSString stringWithFormat:@"你最多只能选择%@张图片", @(self.maximumSelectImageCount)];
            }
            if (!self.alertButtonTitleWhenExceedMaxSelectImageCount) {
                self.alertButtonTitleWhenExceedMaxSelectImageCount = [NSString stringWithFormat:@"我知道了"];
            }
            [IDCMActionTipsView showWithConfigure:^(IDCMActionTipViewConfigure *configure) {
                
                [configure.getBtnsConfig removeFirstObject];
                configure.title(self.alertTitleWhenExceedMaxSelectImageCount);
                configure
                .getBtnsConfig
                .lastObject
                .btnTitle(self.alertButtonTitleWhenExceedMaxSelectImageCount);
            }];
            
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:willCheckImageAtIndex:)]) {
            [self.delegate imagePickerPreviewViewController:self willCheckImageAtIndex:self.imagePreviewView.currentImageIndex];
        }
        
        button.selected = YES;
        [QMUIImagePickerHelper springAnimationOfImageCheckedWithCheckboxButton:button];
        QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:self.imagePreviewView.currentImageIndex];
        [self.selectedImageAssetArray addObject:imageAsset];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:didCheckImageAtIndex:)]) {
            [self.delegate imagePickerPreviewViewController:self didCheckImageAtIndex:self.imagePreviewView.currentImageIndex];
        }
    }
    
    NSUInteger selectedCount = [self.selectedImageAssetArray count];
    if (selectedCount) {
        _sendButton.enabled = YES;
        _imageCountLabel.hidden = NO;
        _imageCountLabel.text = [[NSString alloc] initWithFormat:@"%@", @(selectedCount)];
    } else {
        _imageCountLabel.hidden = YES;
        _sendButton.enabled = NO;
    }
}

#pragma mark - <QMUIImagePreviewViewDelegate>
- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView willScrollHalfToIndex:(NSUInteger)index {
    [super imagePreviewView:imagePreviewView willScrollHalfToIndex:index];
    [self updateOriginImageCheckboxButtonWithIndex:index];
}

- (NSMutableArray<UIImageView *> *)selectedImageViews {
    NSMutableArray *selectedImageViews = [NSMutableArray array];
    for (QMUIAsset *asset in self.selectedImageAssetArray) {
        UIImage *image = asset.originImage;
        UIImageView *imageView = [[UIImageView alloc] init];
        CGFloat falte = image.size.height / image.size.width;
        imageView.size = CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH) * falte);
        imageView.centerX = SCREEN_WIDTH / 2;
        imageView.centerY = SCREEN_HEIGHT / 2;
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [selectedImageViews addObject:imageView];
    }
    return selectedImageViews;
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
