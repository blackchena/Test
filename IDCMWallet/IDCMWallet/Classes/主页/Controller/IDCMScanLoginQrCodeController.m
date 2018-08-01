//
//  IDCMScanQrCodeController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/20.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMScanLoginQrCodeController.h"
#import "IDCMSingleImagePickerPreviewViewController.h"


@interface IDCMScanLoginQrCodeController ()<QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,IDCMSingleImagePickerPreviewViewControllerDelegate>

/**
 *  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *tipTitle;
/**
 *  增加拉近/远视频界面
 */
@property (nonatomic, assign) BOOL isVideoZoom;
@end

@implementation IDCMScanLoginQrCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"2.2.3_Scan", nil);;
    self.fd_interactivePopDisabled = YES;
    
    [self.tipTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(80 + 260 + 30);
        make.height.equalTo(@100);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    if (array.count < 1) {
//        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.1_ScanFail", nil)];
        [self reBegin];
        return;
    }
    
    if (!array[0].strScanned || ![array[0].strScanned isNotBlank] ) {
//        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.1_ScanFail", nil)];
        [self reBegin];
        return;
    }
    
    LBXScanResult *scanResult = array[0];
    NSString*strResult = scanResult.strScanned;
    [self checkStrResult:strResult];
}

- (void)checkStrResult:(NSString *)strResult{
    // http://www.idcw.io?type=idcw_login&clientId=0871e9911dbc443c8b403415f047c308
    
    NSString *BaseUrl = @"http://www.idcw.io?";
    NSString *BaseUrls = @"https://www.idcw.io?";
    NSString *type = @"idcw_login";
    NSString *checkType = @"type=";
    NSString *checkClientId = @"clientId=";
    
    BOOL canOne = (![strResult hasPrefix:BaseUrl] && ![strResult hasPrefix:BaseUrls]);
    BOOL canTwo = ([strResult isEqualToString:BaseUrl] || [strResult isEqualToString:BaseUrls]);
    if (canOne ||
        canTwo ||
        [strResult componentsSeparatedByString:@"?"].count != 2) {
        [self reBegin];
        return;
    }
    
    NSArray *array = [strResult componentsSeparatedByString:@"?"];
    NSArray *subArray = [array.lastObject componentsSeparatedByString:@"&"];
    NSString *cliendId = [self checkArray:subArray string:checkClientId];
    NSString *checkTypeStr = [self checkArray:subArray string:checkType];
    if (cliendId.length && [checkTypeStr isEqualToString:type]) {
        self.scanQRCodeBlock ? self.scanQRCodeBlock(cliendId) : nil;
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self reBegin];
    }
}

- (NSString *)checkArray:(NSArray *)array string:(NSString *)str {
    __block NSString *resutlStr = @"";
    if (array && array.count) {
        [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj hasPrefix:str]) {
                resutlStr = [obj componentsSeparatedByString:@"="].lastObject;
            }
        }];
    }
    return resutlStr;
}

- (void)reBegin {
    [self showErrorToast];
    [[RACScheduler mainThreadScheduler] afterDelay:1.5 schedule:^{
        [self stopScan];
        [self reStartDevice];
    }];
}

- (void)showErrorToast {
    
    QMUITips * toastView = [[QMUITips alloc] initWithView:self.view];
    QMUIToastBackgroundView  * backView = (QMUIToastBackgroundView *) toastView.backgroundView;
    backView.cornerRadius = 5;
    toastView.toastPosition = QMUIToastViewPositionCenter;
    toastView.removeFromSuperViewWhenHide = YES;
    toastView.offset = CGPointMake(0, 170);
    [self.view addSubview:toastView];
    QMUIToastContentView * contentView = (QMUIToastContentView *) toastView.contentView;
    contentView.insets = UIEdgeInsetsMake(7, 15, 7, 15);
    contentView.detailTextLabel.text = NSLocalizedString(@"2.2.3_InvalidScan", nil);
    contentView.detailTextLabel.font = SetFont(@"PingFangSC-Regular", 12);
    [toastView showAnimated:YES];
    [toastView hideAnimated:YES afterDelay:1.5];
}

#pragma mark - getter
- (UILabel *)tipTitle
{
    return SW_LAZY(_tipTitle, ({
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = SetFont(@"PingFang-SC-Regular", 14);
        lable.text = NSLocalizedString(@"2.2.3_ScanLoginTip", nil);;
        lable.numberOfLines = 0;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        [self.view addSubview:lable];
        lable;
    }));
}

@end

