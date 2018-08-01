//
//  IDCMSingleImagePickerPreviewViewController.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/18.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
@class IDCMSingleImagePickerPreviewViewController;

@protocol IDCMSingleImagePickerPreviewViewControllerDelegate <QMUIImagePickerPreviewViewControllerDelegate>

@required
- (void)imagePickerPreviewViewController:(IDCMSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset;

@end


@interface IDCMSingleImagePickerPreviewViewController : QMUIImagePickerPreviewViewController

@property(nonatomic, weak) id<IDCMSingleImagePickerPreviewViewControllerDelegate> delegate;
@property(nonatomic, strong) QMUIAssetsGroup *assetsGroup;
@property (nonatomic,assign) BOOL animated;

@end
