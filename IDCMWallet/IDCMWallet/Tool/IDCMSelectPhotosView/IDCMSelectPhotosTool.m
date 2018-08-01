//
//  IDCMSelectPhotosTool.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/18.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#define KeyWindow [UIApplication sharedApplication].keyWindow
#import "IDCMMultipleImagePickerPreviewViewController.h"
#import "IDCMSingleImagePickerPreviewViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "IDCMImagePickerViewController.h"
#import "IDCMAlbumViewController.h"
#import "LBXPermissionSetting.h"
#import "IDCMSelectPhotosTool.h"
#import "LBXPermission.h"


typedef NS_ENUM(NSUInteger, SelectPhotoType) {
    SelectPhotoType_AlbumSigle,
    SelectPhotoType_CameraSigle,
    SelectPhotoType_AlbumMultiple,
};


@interface IDCMSelectPhotosTool () <UINavigationControllerDelegate,
                                    UIImagePickerControllerDelegate,
                                    QMUIAlbumViewControllerDelegate,
                                    QMUIImagePickerViewControllerDelegate,
                                    IDCMSingleImagePickerPreviewViewControllerDelegate,
                                    IDCMMultipleImagePickerPreviewViewControllerDelegate>
@property (nonatomic,assign) NSInteger maxCount;
@property (nonatomic,assign) CGSize thumbnailSize;
@property (nonatomic,assign) SelectPhotoType photoType;
@property (nonatomic,copy)   SelectSiglePhotoBlock sigleCompleteCallback;
@property (nonatomic,copy)   SelectMultiplePhotoBlock multipleCompleteCallback;
@property (nonatomic,strong) NSMutableArray<UIImageView *> *pickerSelectedImageViews;
@property (nonatomic,copy) AnimationImageViewBlock animationImageViews;
@property (nonatomic,copy)  AnimationCompletionBlock animationCompletionCallback;
@end


static id _instance;
@implementation IDCMSelectPhotosTool

- (void)selectSiglePhotoFromCamera:(BOOL)fromCamera
                 thumbnailWithSize:(CGSize)size
                  completeCallback:(SelectSiglePhotoBlock)completeCallback {
    
    if (![self handleAuthorityFromCamera:fromCamera]) {return;}
    
    self.thumbnailSize = size;
    self.sigleCompleteCallback = completeCallback;
    fromCamera ?
    ({
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
        self.photoType = SelectPhotoType_CameraSigle;
        [self gotoCamer];
    }):
    ({
        self.photoType = SelectPhotoType_AlbumSigle;
        [self presentAlbumViewController];
    });
}

- (void)selectMultiplePhotoWithMaxCount:(NSInteger)maxCount
                      thumbnailWithSize:(CGSize)size
                       completeCallback:(SelectMultiplePhotoBlock)completeCallback {
    
    if (maxCount <= 0) {return;};
    if (![self handlePhotoAuthority]) {return;}
    
    self.maxCount = maxCount;
    self.thumbnailSize = size;
    self.multipleCompleteCallback = [completeCallback copy];
    self.photoType = SelectPhotoType_AlbumMultiple;
    [self presentAlbumViewController];;
}

- (void)setAnimationImageViews:(AnimationImageViewBlock)animationImageViews
   animationCompletionCallback:(AnimationCompletionBlock)animationCompletionCallback {
    _animationImageViews = [animationImageViews copy];
    _animationCompletionCallback = [animationCompletionCallback copy];
}

- (void)gotoCamer {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
    [[IDCMUtilsMethod currentViewController] presentViewController:imagePicker animated:YES completion:nil];
}

- (BOOL)handleAuthorityFromCamera:(BOOL)isFromCamera {
    return isFromCamera ?
    [self handleCameraAuthority] :
    [self handlePhotoAuthority];
}

- (BOOL)handleCameraAuthority {
    __block BOOL authority = YES;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (!granted && !firstTime ) {
            [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.1_OpenCamerPermissions") message:SWLocaloziString(@"2.1_SetCamerPermissionsTips") buttonArray:@[SWLocaloziString(@"2.1_SetCamerPermissions"),SWLocaloziString(@"2.0_Cancel")] actionBlock:^(NSInteger clickIndex) {
                if (clickIndex ==0) {
                    // 跳转至设置界面
                    [LBXPermissionSetting displayAppPrivacySettings];
                }
            }];
            authority = NO;
        }
    }];
    return authority;
}

- (BOOL)handlePhotoAuthority {
    __block BOOL authority = YES;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (!granted && !firstTime ) {
            //用户已经拒绝本软件访问相册 或者 手机没有开通访问权限
            [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.1_Open_Album_Permissions_Tips") message:SWLocaloziString(@"2.1_Open_Album_Permissions_Action_Tips") buttonArray:@[SWLocaloziString(@"2.1_SetCamerPermissions"),SWLocaloziString(@"2.0_Cancel")] actionBlock:^(NSInteger clickIndex) {
                if (clickIndex ==0) {
                    // 跳转至设置界面
                    [LBXPermissionSetting displayAppPrivacySettings];
                }
            }];
            authority = NO;
        }
    }];
    return authority;
}


#pragma mark - 相册
- (void)presentAlbumViewController {
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    IDCMAlbumViewController *albumViewController = [[IDCMAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeOnlyPhoto;
    albumViewController.title = NSLocalizedString(@"2.1_SelectSingleImage", nil);
    albumViewController.tipTextWhenNoPhotosAuthorization = NSLocalizedString(@"3.0_Hy_NoPhotoAuthority", nil);
    QMUINavigationController *navigationController = [[QMUINavigationController alloc] initWithRootViewController:albumViewController];
    
    [[IDCMUtilsMethod currentViewController] presentViewController:navigationController
                                                          animated:YES completion:NULL];
}

#pragma mark - <QMUIAlbumViewControllerDelegate>
- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    
    IDCMImagePickerViewController *imagePickerViewController = [[IDCMImagePickerViewController alloc] init];
    BOOL animated = !self.animationImageViews;
    imagePickerViewController.animated = animated;
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    if (self.photoType == SelectPhotoType_AlbumSigle) {
        imagePickerViewController.maximumSelectImageCount = 1;
        imagePickerViewController.allowsMultipleSelection = NO;
    } else if (self.photoType == SelectPhotoType_AlbumMultiple) {
        imagePickerViewController.maximumSelectImageCount = self.maxCount;
        imagePickerViewController.allowsMultipleSelection = YES;
    }
    return imagePickerViewController;
}

- (void)imagePickerPreviewViewController:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController didCheckImageAtIndex:(NSInteger)index {
    
    if (self.photoType == SelectPhotoType_AlbumMultiple) {
        // 在预览界面选择图片时，控制显示当前所选的图片，并且展示动画
        IDCMMultipleImagePickerPreviewViewController *customImagePickerPreviewViewController = (IDCMMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController;
        NSUInteger selectedCount = [imagePickerPreviewViewController.selectedImageAssetArray count];
        if (selectedCount > 0) {
            customImagePickerPreviewViewController.imageCountLabel.text = [[NSString alloc] initWithFormat:@"%@", @(selectedCount)];
            customImagePickerPreviewViewController.imageCountLabel.hidden = NO;
            [QMUIImagePickerHelper springAnimationOfImageSelectedCountChangeWithCountLabel:customImagePickerPreviewViewController.imageCountLabel];
        } else {
            customImagePickerPreviewViewController.imageCountLabel.hidden = YES;
        }
    }
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>
- (void)imagePickerViewController:(IDCMImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup
                                            ablumContentType:QMUIAlbumContentTypeAll userIdentify:nil];
    
    if (self.animationImageViews) {
        self.pickerSelectedImageViews =
        [self addAnimationImageViews:imagePickerViewController.selectedImageViews];
    }
    [self sendImageWithImagesAssetArray:imagesAssetArray];
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>
- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    
    if (self.photoType == SelectPhotoType_AlbumSigle) {
        IDCMSingleImagePickerPreviewViewController *imagePickerPreviewViewController = [[IDCMSingleImagePickerPreviewViewController alloc] init];
        BOOL animated = !self.animationImageViews;
        imagePickerPreviewViewController.animated = animated;
        imagePickerPreviewViewController.delegate = self;
        return imagePickerPreviewViewController;
    } else if (self.photoType == SelectPhotoType_AlbumMultiple) {
        IDCMMultipleImagePickerPreviewViewController *imagePickerPreviewViewController = [[IDCMMultipleImagePickerPreviewViewController alloc] init];
        BOOL animated = !self.animationImageViews;
        imagePickerPreviewViewController.animated = animated;
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
        return imagePickerPreviewViewController;
    }
    return nil;
}

#pragma mark — 选择单张图片的回调
#pragma mark - <IDCMSingleImagePickerPreviewViewControllerDelegate>
- (void)imagePickerPreviewViewController:(IDCMSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
    
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup
                                            ablumContentType:QMUIAlbumContentTypeAll userIdentify:nil];
    
    UIImageView *imageView;
    if (self.animationImageViews) {
        [self addBlackView];
        CGFloat falte = imageAsset.originImage.size.height / imageAsset.originImage.size.width;
        imageView = [[UIImageView alloc] init];
        imageView.size = CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH) * falte);
        imageView.centerX = SCREEN_WIDTH / 2;
        imageView.centerY = SCREEN_HEIGHT / 2;
        imageView.image = imageAsset.originImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [KeyWindow addSubview:imageView];
    }

    @weakify(self);
    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGif, BOOL isHEIC) {
        UIImage *targetImage = [UIImage imageWithData:imageData];
        if (isHEIC) {
            targetImage = [UIImage imageWithData:UIImageJPEGRepresentation(targetImage, 1)];
        }
        @strongify(self);
        
        UIImage *thumbnailPhoto = targetImage;
        if (self.thumbnailSize.width && self.thumbnailSize.height) {
//            thumbnailPhoto = [imageAsset thumbnailWithSize:self.thumbnailSize];
          thumbnailPhoto =  [self thumbnailWithImage:thumbnailPhoto size:self.thumbnailSize];
        }

        !self.sigleCompleteCallback ?:
         self.sigleCompleteCallback(thumbnailPhoto, targetImage);
         self.sigleCompleteCallback = nil;
        if (self.animationImageViews) {
            [self handleAnimationImageViews: @[imageView] completion:nil];
        } else {
            [self removeBlackView];
        }
    }];
}

#pragma mark — 选择多张图片的回调
#pragma mark - <IDCMMultipleImagePickerPreviewViewControllerDelegate>
- (void)imagePickerPreviewViewController:(IDCMMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup
                                            ablumContentType:QMUIAlbumContentTypeAll userIdentify:nil];
    
    if (self.animationImageViews) {
        [self addBlackView];
        self.pickerSelectedImageViews =
        [self addAnimationImageViews:imagePickerPreviewViewController.selectedImageViews];
    }
    [self sendImageWithImagesAssetArray:imagesAssetArray];
}

- (void)sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    @weakify(self);
    if (![QMUIImagePickerHelper imageAssetsDownloaded:imagesAssetArray]) {
        
        for (QMUIAsset *asset in imagesAssetArray) {
            [QMUIImagePickerHelper requestImageAssetIfNeeded:asset completion:^(QMUIAssetDownloadStatus downloadStatus, NSError *error) {
                @strongify(self);
                if (downloadStatus == QMUIAssetDownloadStatusDownloading) {
                    // @"从 iCloud 加载中"
                } else if (downloadStatus == QMUIAssetDownloadStatusSucceed) {
                    [self sendImageWithImagesAssetArrayIfDownloadStatusSucceed:imagesAssetArray];
                } else {
                    // @"iCloud 下载错误，请重新选图"
                }
            }];
        }
    } else {
        [self sendImageWithImagesAssetArrayIfDownloadStatusSucceed:imagesAssetArray];
    }
}

- (void)sendImageWithImagesAssetArrayIfDownloadStatusSucceed:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    if (![QMUIImagePickerHelper imageAssetsDownloaded:imagesAssetArray]) {
        return;
    }
    
    NSMutableArray <UIImage *> *thumbnailPhotos = @[].mutableCopy;
    NSMutableArray <UIImage *> *originPhotos = @[].mutableCopy;
    for (QMUIAsset *imageAsset in imagesAssetArray) {
        if (self.thumbnailSize.width && self.thumbnailSize.height) {
             [thumbnailPhotos addObject:[self thumbnailWithImage:imageAsset.originImage size:self.thumbnailSize]];
        } else {
            [thumbnailPhotos addObject:imageAsset.originImage];
        }
        [originPhotos addObject:imageAsset.originImage];
    }
    
    !self.multipleCompleteCallback ?:
    self.multipleCompleteCallback(thumbnailPhotos, originPhotos);
    self.multipleCompleteCallback = nil;
    
    if (self.animationImageViews) {
        [[RACScheduler mainThreadScheduler] afterDelay:0.15 schedule:^{
            [self handleAnimationImageViews:self.pickerSelectedImageViews completion:nil];
        }];
    } else {
        [self removeBlackView];
    }
}

#pragma mark — 相机
- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *thumbnailPhoto;
    UIImage *originPhoto;
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0)== kCFCompareEqualTo) {
        originPhoto = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        thumbnailPhoto = originPhoto;
        if (self.thumbnailSize.width && self.thumbnailSize.height) {
            thumbnailPhoto = [self thumbnailWithImage:originPhoto size:self.thumbnailSize];
        }
        
        BOOL animated = !self.animationImageViews;
        if (!animated) {
            CGFloat falte = originPhoto.size.height / originPhoto.size.width;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.size = CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH) * falte);
            imageView.centerX = SCREEN_WIDTH / 2;
            imageView.centerY = SCREEN_HEIGHT / 2;
            imageView.image = originPhoto;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [KeyWindow addSubview:imageView];
            
            !self.sigleCompleteCallback ?:
            self.sigleCompleteCallback(thumbnailPhoto, originPhoto);
            self.sigleCompleteCallback = nil;
            
            [[RACScheduler mainThreadScheduler] afterDelay:.15 schedule:^{
                [self handleAnimationImageViews: @[imageView] completion:nil];
            }];
        }
        
        @weakify(self);
        [picker dismissViewControllerAnimated:animated completion:^{
            @strongify(self);
            
            if (animated) {
                !self.sigleCompleteCallback ?:
                self.sigleCompleteCallback(thumbnailPhoto, originPhoto);
                self.sigleCompleteCallback = nil;
            }
        }];
    }
}

- (NSMutableArray<UIImageView *> *)addAnimationImageViews:(NSArray<UIImageView *> *)animationImageView {
    
    NSMutableArray *array = @[].mutableCopy;
    UIWindow *keyWindow =  [UIApplication sharedApplication].keyWindow;
    for (UIImageView *imageV in animationImageView) {
        if (imageV.superview) {
            CGRect fromFrame = [imageV convertRect:imageV.frame toView:keyWindow];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = fromFrame;
            imageView.image = imageV.image;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [KeyWindow addSubview:imageView];
            if (![array containsObject:imageView]) {
                [array addObject:imageView];
            }
        } else {
             [KeyWindow addSubview:imageV];
            if (![array containsObject:imageV]) {
                [array addObject:imageV];
            }
        }
    }
    return array;
}

- (void)handleAnimationImageViews:(NSArray<UIImageView *> *)animationImageViews
                       completion:(void(^)(void))completion {
    
    [self removeBlackView];
     if (!self.animationImageViews || !animationImageViews.count) {
         self.animationImageViews = nil;
         self.animationCompletionCallback = nil;
         return;
     }
    
    NSArray<UIImageView *> *originImageViews =
    self.animationImageViews(animationImageViews.count);
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         for (UIImageView *imageView in animationImageViews) {
                             NSInteger index = [animationImageViews indexOfObject:imageView];
                             if (index < originImageViews.count) {
                                 UIImageView *originImageView = originImageViews[index];
                                 CGRect fromFrame = [originImageView convertRect:originImageView.bounds toView:KeyWindow];
                                 imageView.center =
                                 CGPointMake(CGRectGetMidX(fromFrame),
                                             CGRectGetMinY(fromFrame) + originImageView.height / 2);
                                 CGFloat scaleW = originImageView.width / (imageView.width);
                                 CGFloat scaleH = originImageView.height / (imageView.height);
                                 imageView.transform = CGAffineTransformMakeScale(scaleW, scaleH);
                                 imageView.contentMode = UIViewContentModeScaleAspectFill;
                                 imageView.clipsToBounds = YES;
                             } else {
                                 imageView.hidden = YES;
                             }
                         }
                     } completion:^(BOOL finished) {
                         
                         
                     }];
    
    [UIView animateWithDuration:.25
                          delay:.3
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            for (UIImageView *imageView in animationImageViews) {
                                imageView.alpha = 0.0;
                            }
                        } completion:^(BOOL finished) {
                            for (UIImageView *imageV in animationImageViews) {
                                NSInteger index = [animationImageViews indexOfObject:imageV];
                                !self.animationCompletionCallback ?: self.animationCompletionCallback(index);
                                [imageV removeFromSuperview];
                            }
                            [self.pickerSelectedImageViews removeAllObjects];
                            self.animationImageViews = nil;
                            self.animationCompletionCallback = nil;
                        }];
}

- (void)addBlackView {
    UIView *view =  [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.9;
    view.tag = 10245;
    view.frame = KeyWindow.bounds;
    [KeyWindow addSubview:view];
}

- (void)removeBlackView {
    UIView *view = [KeyWindow viewWithTag:10245];
    if (!view) {return;}
    [UIView animateWithDuration:.3 animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (instancetype)sharedSelectPhotosTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
- (NSArray<UIImageView *> *)pickerSelectedImageViews {
    return SW_LAZY(_pickerSelectedImageViews, ({@[].mutableCopy;}));
}
- (BOOL)checkAnimationImageViewsWithCount:(NSInteger)count {
    return self.animationImageViews ? (self.animationImageViews(count).count) : NO;
}
@end





