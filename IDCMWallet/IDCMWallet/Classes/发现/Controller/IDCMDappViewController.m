//
//  IDCMDappViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/28.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMDappViewController.h"
#import "IDCMDappViewModel.h"

@interface IDCMDappViewController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMDappViewModel *viewModel;
/**
 *  webview
 */
@property (strong, nonatomic) FTDIntegrationWebView *webView;
/**
 *  分享按钮
 */
@property (strong, nonatomic) UIButton *shareButton;
@end

@implementation IDCMDappViewController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    
    [self configInitView];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
#pragma mark - Bind
- (void)bindViewModel{
    [super bindViewModel];
    
    [[[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         
     }];
}
#pragma mark - Privater Methods
- (void)configNavigationBar{
    
    self.view.backgroundColor = UIColorWhite;
    UIView *rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 22)];
    [rightBarView addSubview:self.shareButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarView];
}
- (void)configInitView{
    
    if ([self.viewModel.requestURL isNotBlank]) {

        [self.webView loadURLString:self.viewModel.requestURL];
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
#pragma mark - Getter & Setter
- (FTDIntegrationWebView *)webView
{
    return SW_LAZY(_webView, ({
        
        FTDIntegrationWebView *view = [FTDIntegrationWebView new];
        [self.view addSubview:view];
        view;
    }));
}
- (UIButton *)shareButton
{
    return SW_LAZY(_shareButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIImageMake(@"3.0_DappShareButton") forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.frame = CGRectMake(0, 0, 22, 22);
        button;
    }));
}
@end
