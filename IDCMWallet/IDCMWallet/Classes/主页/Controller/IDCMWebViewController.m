//
//  IDCMWebViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMWebViewController.h"
#import "IDCMWebViewModel.h"

@interface IDCMWebViewController ()<FTDIntegrationWebViewDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMWebViewModel *viewModel;
/**
 *  webview
 */
@property (strong, nonatomic) FTDIntegrationWebView *webView;
@end

@implementation IDCMWebViewController
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
    
    self.navigationItem.title = self.viewModel.title;
    
    [self.webView loadURLString:self.viewModel.requestURL];

    self.webView.delegate = self;
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
