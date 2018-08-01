//
//  IDCMMaintenanceViewController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/26.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMMaintenanceViewController.h"
#import "IDCMMaintenanceViewModel.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "FLAnimatedImage.h"

@interface IDCMMaintenanceViewController ()<MFMailComposeViewControllerDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMMaintenanceViewModel *viewModel;
/**
 *  icon
 */
@property (strong, nonatomic) FLAnimatedImageView *iconImageView;
/**
 *  tipsView
 */
@property (strong, nonatomic) UIView *tipsView;
/**
 *  开头
 */
@property (strong, nonatomic) UILabel *userLable;
/**
 *  内容
 */
@property (strong, nonatomic) YYLabel *contentLable;
/**
 *  联系提示
 */
@property (strong, nonatomic) UILabel *tipsLable;
/**
 *  刷新按钮
 */
@property (strong, nonatomic) UIButton *refreshButton;
/**
 *  View
 */
@property (strong, nonatomic) UIView *whiteView;
/**
 *  webview
 */
@property (strong, nonatomic) FTDIntegrationWebView *webView;
@end

@implementation IDCMMaintenanceViewController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWhite;
    self.fd_prefersNavigationBarHidden = YES;
    if ([self.viewModel.url isNotBlank] && ([self.viewModel.url hasPrefix:@"http://"] || [self.viewModel.url hasPrefix:@"https://"])) {
        // 如果有web维护链接，挂web维护页面
        [self configWebMaintenanceView];
    }else{
        // 如果没有web维护链接，挂原生维护页面
        [self configContentAttribute];
        [self configNativeMaintenanceView];
    }
}

#pragma mark - Bind
- (void)bindViewModel{
    [super bindViewModel];
    @weakify(self);
    // 刷新
    [[[self.refreshButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self.viewModel.requestDataCommand execute:nil];
     }];
    // 监听邮箱回调
    [[self
      rac_signalForSelector:@selector(mailComposeController:didFinishWithResult:error:)
      fromProtocol:@protocol(MFMailComposeViewControllerDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
    // 监听Web维护页面刷新(暂时预留)
    [self.webView.bridge registerHandler:@"refreshMaintenance" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        [self.viewModel.requestDataCommand execute:nil];
    }];
}

#pragma mark - config
- (void)configNativeMaintenanceView{
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(80+kSafeAreaTop);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(150));
        make.width.equalTo(@(290));
    }];
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
    }];
    [self.userLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsView.mas_top).offset(20);
        make.left.equalTo(self.tipsView.mas_left).offset(15);
        make.right.equalTo(self.tipsView.mas_right).offset(-15);
        make.height.greaterThanOrEqualTo(@(20));
    }];
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userLable.mas_bottom).offset(10);
        make.left.equalTo(self.tipsView.mas_left).offset(15);
        make.right.equalTo(self.tipsView.mas_right).offset(-15);
        make.height.greaterThanOrEqualTo(@(40));
    }];
    [self.tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLable.mas_bottom).offset(20);
        make.left.equalTo(self.tipsView.mas_left).offset(15);
        make.right.equalTo(self.tipsView.mas_right).offset(-15);
        make.height.greaterThanOrEqualTo(@(20));
        make.bottom.equalTo(self.tipsView.mas_bottom).offset(-20);
    }];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsView.mas_bottom).offset(40);
        make.centerX.equalTo(self.tipsView.mas_centerX);
        make.width.equalTo(@(170));
        make.height.equalTo(@(40));
    }];
}
- (void)configWebMaintenanceView{
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(kSafeAreaTop));
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.whiteView.mas_bottom);
    }];
    
    [self.webView loadURLString:self.viewModel.url];
    // 创建JavaScriptBridge
    [self.webView FTD_registerJavaScriptBridge];
}
#pragma mark - Action
- (void)configContentAttribute{
    
    @weakify(self);
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:SWLocaloziString(@"3.0_Bin_MaintenanceContent")];
    [text yy_setFont:textFontPingFangRegularFont(14) range:text.yy_rangeOfAll];
    UIColor *colorNormal = UIColorMakeWithHex(@"#FC8968");
    UIColor *colorHighlight = UIColorMake(238, 107, 69);
    NSRange range9 = [[text string] rangeOfString:@"support@idcw.io" options:NSCaseInsensitiveSearch];
    [text yy_setColor:colorNormal range:range9];
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:colorHighlight];
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        @strongify(self);
        [self sendEmail];
    };
    [text yy_setTextHighlight:highlight range:range9];
    self.contentLable.attributedText = text;
}
- (void)sendEmail{
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    if (mailViewController && [MFMailComposeViewController canSendMail]) { // 邮件控制器不为空且邮箱已经绑定了账号
        
        mailViewController.mailComposeDelegate = self;
        //添加收件人
        NSArray *toRecipients = [NSArray arrayWithObject: @"support@idcw.io"];
        [mailViewController setToRecipients:toRecipients];
        [self presentViewController:mailViewController animated:YES completion:nil];
        
    }else{ // 邮件控制器为空或邮箱未绑定账号
        
        if (@available(iOS 10,*)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@idcw.io"] options:@{} completionHandler:^(BOOL success) {
            }];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@idcw.io"]];
        }
    }
}

#pragma mark - Getter & Setter
- (UIView *)tipsView
{
    return SW_LAZY(_tipsView, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorWhite;
        view.layer.borderColor = SetColor(225, 231, 247).CGColor;
        view.layer.borderWidth= 0.5;
        view.layer.cornerRadius = 10;
        view.layer.shadowOpacity = 1;// 阴影透明度
        view.layer.shadowColor = SetColor(214, 223, 245).CGColor;// 阴影的颜色
        view.layer.shadowRadius = 2;// 阴影扩散的范围控制
        view.layer.shadowOffset = CGSizeMake(0, 2);// 阴影的范围
        [self.view addSubview:view];
        view;
    }));
}
- (UILabel *)userLable {
    return SW_LAZY(_userLable, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.text = SWLocaloziString(@"3.0_Bin_MaintenanceUser");
        [self.tipsView addSubview:label];
        label;
    }));
}
- (YYLabel *)contentLable {
    return SW_LAZY(_contentLable, ({
        
        YYLabel *label = [[YYLabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.userInteractionEnabled = YES;
        label.preferredMaxLayoutWidth = SCREEN_WIDTH - 55;
        [self.tipsView addSubview:label];
        label;
    }));
}
- (UILabel *)tipsLable{
    return SW_LAZY(_tipsLable, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        label.text = SWLocaloziString(@"3.0_Bin_MaintenanceTips");
        [self.tipsView addSubview:label];
        label;
    }));
}
- (UIButton *)refreshButton{
    
    return SW_LAZY(_refreshButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = textFontPingFangRegularFont(16);
        [button setTitle:SWLocaloziString(@"3.0_Refresh") forState:UIControlStateNormal];
        [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:kThemeColor];
        [self.view addSubview:button];
        button;
    }));
    
}
- (FLAnimatedImageView *)iconImageView
{
    return SW_LAZY(_iconImageView, ({
        FLAnimatedImageView *view = [FLAnimatedImageView new];
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"3.0_Maintenance" withExtension:@"gif"];
        NSData *data1 = [NSData dataWithContentsOfURL:url1];
        FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
        view.animatedImage = animatedImage1;
        view.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:view];
        view;
    }));
}
- (FTDIntegrationWebView *)webView
{
    return SW_LAZY(_webView, ({
        
        FTDIntegrationWebView *view = [FTDIntegrationWebView new];
        [self.view addSubview:view];
        view;
    }));
}
- (UIView *)whiteView
{
    return SW_LAZY(_whiteView, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorWhite;
        [self.view addSubview:view];
        view;
    }));
}
#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
