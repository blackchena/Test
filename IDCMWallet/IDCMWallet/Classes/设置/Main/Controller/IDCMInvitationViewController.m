//
//  IDCMInvitationViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/2.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMInvitationViewController.h"
#import "IDCMInvitationViewModel.h"
#import "IDCMShareView.h"
#import "IDCMQRCodeView.h"

@interface IDCMInvitationViewController ()<FTDIntegrationWebViewDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMInvitationViewModel *viewModel;
/**
 *  webview
 */
@property (strong, nonatomic) FTDIntegrationWebView *webView;
@end

@implementation IDCMInvitationViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];

    [self configInitView];
    
    @weakify(self);
    // 自定义分享页
    IDCMShareView *shareView = [IDCMShareView bondSureViewWithSureBtnTitle:SWLocaloziString(@"2.0_Cancel")
                                                                confidSignal:self.viewModel.shareItemSignal
                                                              sureBtnInput:^(id input) {
                                                                  [IDCMBaseBottomTipView dismissWithCompletion:nil];
                                                              }
                                                              shareCommand:self.viewModel.shareCommand];
    // 监听分享邀请好友
    [self.webView.bridge registerHandler:@"showSharePanel" handler:^(id data, WVJBResponseCallback responseCallback) {
        DDLogDebug(@"分享邀请好友:%@",data);
        @strongify(self);
        NSString *shareURL = [NSString idcw_stringWithFormat:@"%@",data[@"url"]];
        NSString *shareTitle = [NSString idcw_stringWithFormat:@"%@",data[@"title"]];
        NSString *shareDesc = [NSString idcw_stringWithFormat:@"%@",data[@"desc"]];
        NSString *shareImage = [NSString idcw_stringWithFormat:@"%@",data[@"img"]];
        if ([shareTitle isNotBlank]) {
            self.viewModel.shareTitle = shareTitle;
        }
        if ([shareDesc isNotBlank]) {
            self.viewModel.shareSubTitle = shareDesc;
        }
        if ([shareImage isNotBlank]) {
            self.viewModel.shareImage = shareImage;
        }
        if ([shareURL isNotBlank]) {
            self.viewModel.shareURL = shareURL;
            [IDCMBaseBottomTipView showTipViewToView:nil
                                                size:CGSizeMake(SCREEN_WIDTH-30, 270+kSafeAreaBottom)
                                          blackAlpha:0.5
                                         blackAction:YES
                                         contentView:shareView
                               tipViewStatusCallback:nil
                                         ];
        }
    }];

    // 监听我的二维码
    [self.webView.bridge registerHandler:@"showMyQrCode" handler:^(id data, WVJBResponseCallback responseCallback) {
        DDLogDebug(@"我的二维码:%@",data);
        NSString *title = [NSString idcw_stringWithFormat:@"%@",data[@"title"]];
        NSString *shareURL = [NSString idcw_stringWithFormat:@"%@",data[@"url"]];
        NSString *subTitle = [NSString idcw_stringWithFormat:@"%@",data[@"subtitle"]];
        if ([shareURL isNotBlank]) {
            RACTuple *tupe = RACTuplePack(title,shareURL,subTitle);
            // 我的二维码页面
            IDCMQRCodeView *QRCodeView = [IDCMQRCodeView bondSureViewWithSureBtnTitle:nil
                                                                           confidTupe:tupe
                                                                         sureBtnInput:^(id input) {
                                                                             [IDCMBaseCenterTipView dismissWithCompletion:nil];
                                                                         }];
            [IDCMBaseCenterTipView showTipViewToView:nil
                                                size:CGSizeMake(SCREEN_WIDTH-30, 365)
                                         contentView:QRCodeView
                                    automaticDismiss:NO
                                      animationStyle:IDCMBaseTipViewAnimationStyleScale
                               tipViewStatusCallback:nil];
        }
    }];

    // 监听复制邀请码
    [self.webView.bridge registerHandler:@"copyCode" handler:^(id data, WVJBResponseCallback responseCallback) {
        DDLogDebug(@"复制邀请码:%@",data);
        NSString *code = [NSString idcw_stringWithFormat:@"%@",data[@"code"]];
        if ([code isNotBlank]) {
            //放到粘贴板
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = code;
            [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_ShareCopy")];
        }
    }];
    
    // 监听标题
    [[self
      rac_signalForSelector:@selector(FTD_WebView:title:)
      fromProtocol:@protocol(FTDIntegrationWebViewDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self);
         self.navigationItem.title = tuple.second;
     }];

    self.webView.delegate = self;
}
#pragma mark - config
- (void)configInitView{
    
    if ([self.viewModel.webLink isNotBlank]) {
        IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
        NSString *url = [NSString idcw_stringWithFormat:@"%@?userid=%@&clientType=ios&lang=%@",self.viewModel.webLink,model.userID,[IDCMUtilsMethod getH5Language]];
//        NSString *urlString = [NSString idcw_stringWithFormat:@"https://telegram.me/share/url?url=%@&text=%@",IDCMWebURL,@"sgdh"];
        [self.webView loadURLString:url];
        // 创建JavaScriptBridge
        [self.webView FTD_registerJavaScriptBridge];
    }
}
#pragma mark - UINavigationControllerBackButtonHandlerProtocol
- (BOOL)shouldHoldBackButtonEvent {
    return YES;
}
- (BOOL)canPopViewController {
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return NO;
    }else{
        return YES;
    }
    
}
#pragma mark - getter
- (FTDIntegrationWebView *)webView
{
    return SW_LAZY(_webView, ({
        
        FTDIntegrationWebView *view = [FTDIntegrationWebView new];
        [self.view addSubview:view];
        view;
    }));
}

@end
