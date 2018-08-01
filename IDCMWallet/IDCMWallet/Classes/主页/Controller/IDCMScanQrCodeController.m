//
//  IDCMScanQrCodeController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/20.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMScanQrCodeController.h"
#import "IDCMSingleImagePickerPreviewViewController.h"


@interface IDCMScanQrCodeController ()<QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,IDCMSingleImagePickerPreviewViewControllerDelegate>

/**
 *  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;
/**
 *  增加拉近/远视频界面
 */
@property (nonatomic, assign) BOOL isVideoZoom;
/**
 *  底部显示的功能项
 */
@property (nonatomic, strong) UIView *bottomItemsView;
/**
 *  关闭
 */
@property (strong, nonatomic) QMUIButton *closeButton;
/**
 *  相册
 */
@property (strong, nonatomic) QMUIButton *photoButton;
/**
 *  闪光灯
 */
@property (strong, nonatomic) QMUIButton *flashButton;
@end

@implementation IDCMScanQrCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    
    CGFloat height,maxheight;
    if (isiPhoneX ) {
        height = 34;
        maxheight = 124;
    }else{
        height = 20;
        maxheight = 95;
    }
    
    [self.topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(60);
        make.height.equalTo(@100);
    }];
    
    [self.bottomItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.equalTo(@(maxheight));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bottomItemsView.mas_left);
        make.bottom.equalTo(self.bottomItemsView.mas_bottom).offset(-height);
        make.height.equalTo(@80);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.bottomItemsView.mas_right);
        make.bottom.equalTo(self.bottomItemsView.mas_bottom).offset(-height);
        make.height.equalTo(@80);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.bottomItemsView.mas_bottom).offset(-height);
        make.height.equalTo(@80);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    @weakify(self);
    [self.flashButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self openOrCloseFlash];
    }];
    
    [self.closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.photoButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
            if (granted) {
                [self presentAlbumViewControllerWithTitle];
            }
            else if (!firstTime )
            {
                //用户已经拒绝本软件访问相册 或者 手机没有开通访问权限
                [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.1_Open_Album_Permissions_Tips") message:SWLocaloziString(@"2.1_Open_Album_Permissions_Action_Tips") buttonArray:@[SWLocaloziString(@"2.1_SetCamerPermissions"),SWLocaloziString(@"2.0_Cancel")] actionBlock:^(NSInteger clickIndex) {
                    if (clickIndex ==0) {
                        // 跳转至设置界面
                        [LBXPermissionSetting displayAppPrivacySettings];
                        
                    }
                }];
            }
        }];
    }];
}
#pragma mark - Action
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];

    if (self.isOpenFlash){
        [self.flashButton setImage:UIImageMake(@"2.1_FlashOpen") forState:UIControlStateNormal];
    }else{
        [self.flashButton setImage:UIImageMake(@"2.1_FlashClose") forState:UIControlStateNormal];
    }

}
#pragma mark - 相册
- (void)presentAlbumViewControllerWithTitle
{
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeOnlyPhoto;
    albumViewController.title = NSLocalizedString(@"2.1_SelectSingleImage", nil);

    
    QMUINavigationController *navigationController = [[QMUINavigationController alloc] initWithRootViewController:albumViewController];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}
#pragma mark - <QMUIAlbumViewControllerDelegate>
- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 1;
    imagePickerViewController.allowsMultipleSelection = NO;
    
    return imagePickerViewController;
}
#pragma mark - <QMUIImagePickerViewControllerDelegate>
- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController
{
    IDCMSingleImagePickerPreviewViewController *imagePickerPreviewViewController = [[IDCMSingleImagePickerPreviewViewController alloc] init];
    imagePickerPreviewViewController.delegate = self;
    return imagePickerPreviewViewController;
}
#pragma mark - <IDCMSingleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(IDCMSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
   @weakify(self);
    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGif, BOOL isHEIC) {
        UIImage *targetImage = [UIImage imageWithData:imageData];
        if (isHEIC) {
            // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
            targetImage = [UIImage imageWithData:UIImageJPEGRepresentation(targetImage, 1)];
        }
        
        [LBXScanNative recognizeImage:targetImage success:^(NSArray<LBXScanResult *> *array) {
            @strongify(self);
            [self scanResultWithArray:array];
        }];
    }];
}

#pragma mark - 扫描结果
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.1_ScanFail", nil)];
        
        return;
    }

    if (!array[0].strScanned || ![array[0].strScanned isNotBlank] ) {
        
        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.1_ScanFail", nil)];
        return;
    }
    LBXScanResult *scanResult = array[0];
    NSString*strResult = scanResult.strScanned;
    
    if (self.scanQRCodeBlock) {
        self.scanQRCodeBlock(strResult);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - getter
- (UILabel *)topTitle
{
    return SW_LAZY(_topTitle, ({
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Regular", 15);
        lable.text = NSLocalizedString(@"2.0_AutoScan", nil);
        lable.numberOfLines = 0;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        [self.view addSubview:lable];
        lable;
    }));
}
- (UIView *)bottomItemsView
{
    return SW_LAZY(_bottomItemsView, ({
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.qRScanView addSubview:view];
        view;
    }));
}

- (QMUIButton *)closeButton
{
    return SW_LAZY(_closeButton, ({
        QMUIButton *button = [[QMUIButton alloc] init];
        
        button.imagePosition = QMUIButtonImagePositionTop;
        button.spacingBetweenImageAndTitle = 8;
        [button setImage:UIImageMake(@"2.1_ScanClose") forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"2.1_ScanClose", nil) forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 15);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bottomItemsView addSubview:button];
        button;
    }));
}
- (QMUIButton *)photoButton
{
    return SW_LAZY(_photoButton, ({
        QMUIButton *button = [[QMUIButton alloc] init];
        
        button.imagePosition = QMUIButtonImagePositionTop;
        button.spacingBetweenImageAndTitle = 8;
        [button setImage:UIImageMake(@"2.1_ScanXiangce") forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"2.1_ScanAlbum", nil) forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 15);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bottomItemsView addSubview:button];
        button;
    }));
}
- (QMUIButton *)flashButton
{
    return SW_LAZY(_flashButton, ({
        QMUIButton *button = [[QMUIButton alloc] init];
        
        button.imagePosition = QMUIButtonImagePositionTop;
        button.spacingBetweenImageAndTitle = 8;
        [button setImage:UIImageMake(@"2.1_FlashClose") forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"2.1_ScanFlash", nil) forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 15);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bottomItemsView addSubview:button];
        button;
    }));
}
@end
