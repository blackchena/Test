//
//  IDCMReceiveViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/19.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMReceiveViewController.h"
#import "IDCMReceiveViewModel.h"
#import "IDCMReceiveNavBarView.h"
#import "UIWindow+Extension.h"


@interface IDCMReceiveViewController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMReceiveViewModel *viewModel;
@property (nonatomic,strong) IDCMReceiveNavBarView *navifationBarView;
@property (nonatomic,strong) UIImageView *qrCodeImageView;
@property (nonatomic,strong) UILabel *qrCodeStringLabel;
@property (nonatomic,strong) QMUIButton *pasteButton;
@property (nonatomic,strong) QMUIButton *saveButton;
@property (nonatomic,strong) UILabel *tipTopLabel;
@property (nonatomic,strong) UILabel *receiveLabel;
@property (nonatomic,strong) UIImageView *logo;
/**
 *  交易详情Disposable
 */
@property (strong, nonatomic) RACDisposable *requestDisposable;
@end

@implementation IDCMReceiveViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.navifationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarHeight + kSafeAreaTop);
    }];
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@300);
        make.top.equalTo(self.navifationBarView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrCodeImageView.mas_centerX);
        make.centerY.equalTo(self.qrCodeImageView.mas_centerY);
        make.width.height.equalTo(@60);
    }];
    [self.qrCodeStringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.qrCodeImageView.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    [self.pasteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.saveButton.mas_left).offset(-20);
        make.top.equalTo(self.qrCodeStringLabel.mas_bottom).offset(30);
        make.height.equalTo(@45);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.qrCodeStringLabel.mas_bottom).offset(30);
        make.height.equalTo(@45);
        make.width.equalTo(self.pasteButton);
    }];
    [self.tipTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.pasteButton.mas_bottom).offset(30);
        make.height.greaterThanOrEqualTo(@40);
    }];
    [self.receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.tipTopLabel.mas_bottom).offset(10);
        make.height.greaterThanOrEqualTo(@30);
    }];
}
#pragma mark
#pragma mark  -- initData
- (void)initData
{
    self.view.backgroundColor = textColorFFFFFF;
    self.fd_prefersNavigationBarHidden = YES;

    RACTuple *tupe = RACTuplePack([self.viewModel.marketModel.currency uppercaseString],self.viewModel.marketModel.logo_url);
    [self.navifationBarView.iconSubject sendNext:tupe];
}

#pragma mark
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    
    RACSignal *validTextSignal = [[RACSignal
                                   combineLatest:@[RACObserve(self.qrCodeStringLabel, text)]
                                   reduce:^(NSString *text) {
                                       return @(text.length > 0);
                                   }]
                                  distinctUntilChanged];
    
    RAC(self.pasteButton,enabled) = validTextSignal;
    RAC(self.saveButton,enabled) = validTextSignal;
    
    // 复制地址
    [[[self.pasteButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         //放到粘贴板
         UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
         pasteboard.string = self.qrCodeStringLabel.text;
         [IDCMShowMessageView showMessage:SWLocaloziString(@"2.0_CopySuccess") withPosition:QMUIToastViewPositionBottom];
     }];
    // 保存到相册
    [[[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         
         
         [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
             @strongify(self);
             if (granted) {
                 //先截屏
                 UIWindow *window = [UIApplication sharedApplication].keyWindow;
                 UIImage *photo = [window screenshot];
                 UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                 
             }else if (!firstTime){
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
    
    // 接收地址信号
    self.requestDisposable = [[[self.viewModel.reciveCommand.executionSignals switchToLatest] deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
         if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSString class]]) {
             
             // 生成的二维码
             if ([response[@"data"] isKindOfClass:[NSString class]]) {
                 NSString *str = [NSString idcw_stringWithFormat:@"%@",response[@"data"]];
                 UIImage *image = [LBXScanNative createQRWithString:response[@"data"] QRSize:self.qrCodeImageView.size];
                 self.qrCodeImageView.image = image;
                 self.logo.image = UIImageMake(@"2.0_logo");
                 self.qrCodeStringLabel.text = nilHandleString(str);
             }
             
         }else{
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_GetAddressFail", nil)];
         }
     }];
    
    [self.viewModel.reciveCommand execute:nil];
}



#pragma mark
#pragma mark  -- Prevete Method
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.1_Save_To_Album_Failure")];
    }else
    {
        [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.1_Save_To_Album_Success")];
    }
}
#pragma mark
#pragma mark  -- getter
- (IDCMReceiveNavBarView *)navifationBarView
{
    return SW_LAZY(_navifationBarView, ({
        IDCMReceiveNavBarView *view = [[IDCMReceiveNavBarView alloc] init];
        [self.view addSubview:view];
        view;
    }));
}
- (UIImageView *)qrCodeImageView
{
    return SW_LAZY(_qrCodeImageView, ({
        UIImageView *view = [UIImageView new];
        view.layer.borderWidth = 0.5f;
        view.layer.borderColor = UIColorFromRGB(0x2968B9).CGColor;
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        [self.view addSubview:view];
        view;
    }));
}
- (UILabel *)qrCodeStringLabel
{
    return SW_LAZY(_qrCodeStringLabel, ({
        UILabel *label = [UILabel new];
        label.layer.borderWidth = 0.5f;
        label.layer.borderColor = UIColorFromRGB(0x2968B9).CGColor;
        label.layer.cornerRadius = 5.0f;
        label.layer.masksToBounds = YES;
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFontPingFangRegularFont(12);
        [self.view addSubview:label];
        label;
    }));
}
- (QMUIButton *)pasteButton
{
    return SW_LAZY(_pasteButton, ({
        QMUIButton *button = [[QMUIButton alloc] init];
        button.imagePosition = QMUIButtonImagePositionLeft;
        button.spacingBetweenImageAndTitle = 5;
        button.backgroundColor = kThemeColor;
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
        [button setImage:UIImageMake(@"2.1_paste_To_board_icon") forState:UIControlStateNormal];
        [button setTitle:SWLocaloziString(@"2.0_CopyAddress") forState:UIControlStateNormal];
        button.titleLabel.font = textFontPingFangRegularFont(14);
        [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
}
- (QMUIButton *)saveButton
{
    return SW_LAZY(_saveButton, ({
        QMUIButton *button = [[QMUIButton alloc] init];
        button.imagePosition = QMUIButtonImagePositionLeft;
        button.spacingBetweenImageAndTitle = 5;
        button.backgroundColor = UIColorWhite;
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = kThemeColor.CGColor;
        [button setImage:UIImageMake(@"2.1_save_screan_shot_to_album_icon") forState:UIControlStateNormal];
        [button setTitle:SWLocaloziString(@"2.1_Save_To_Album") forState:UIControlStateNormal];
        button.titleLabel.font = textFontPingFangRegularFont(14);
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
}
- (UILabel *)tipTopLabel
{
    return SW_LAZY(_tipTopLabel, ({
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.textColor = UIColorFromRGB(0xbbbbbb);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFontPingFangRegularFont(14);
        label.text = SWLocaloziString(@"2.1_Receive_Tips_Text");
        [self.view addSubview:label];
        label;
    }));
}
- (UILabel *)receiveLabel
{
    return SW_LAZY(_receiveLabel, ({
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.textColor = UIColorFromRGB(0xFC8968);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFontPingFangRegularFont(14);
        label.text = [SWLocaloziString(@"2.0_ReciveHint") stringByReplacingOccurrencesOfString:@"[IDCW]" withString:[self.viewModel.marketModel.currency uppercaseString]];
        [self.view addSubview:label];
        label;
    }));
}
- (UIImageView *)logo
{
    return SW_LAZY(_logo, ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        [self.qrCodeImageView addSubview:view];
        view;
    }));
}
#pragma mark
#pragma mark  -- UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)dealloc{
    
    [self.requestDisposable dispose];
}
@end
