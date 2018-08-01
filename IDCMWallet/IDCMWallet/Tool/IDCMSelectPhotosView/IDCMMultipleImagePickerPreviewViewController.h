//
//  IDCMMultipleImagePickerPreviewViewController.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/18.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "QMUIImagePickerPreviewViewController.h"



@class IDCMMultipleImagePickerPreviewViewController;
@protocol IDCMMultipleImagePickerPreviewViewControllerDelegate <QMUIImagePickerPreviewViewControllerDelegate>

@required
- (void)imagePickerPreviewViewController:(IDCMMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray;

@end



@interface IDCMMultipleImagePickerPreviewViewController : QMUIImagePickerPreviewViewController
@property(nonatomic, weak) id<IDCMMultipleImagePickerPreviewViewControllerDelegate> delegate;
@property(nonatomic, strong) QMUILabel *imageCountLabel;
@property(nonatomic, strong) QMUIAssetsGroup *assetsGroup;
@property(nonatomic, assign) BOOL shouldUseOriginImage;

@property (nonatomic,assign) BOOL animated;
@property (nonatomic,strong, readonly) NSMutableArray<UIImageView *> *selectedImageViews;
@end




