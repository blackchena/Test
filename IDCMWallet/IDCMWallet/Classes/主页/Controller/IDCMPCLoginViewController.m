//
//  IDCMPCLoginViewController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMPCLoginViewController.h"
#import "IDCMWhiteNavigationBar.h"
#import "IDCMPCLoginViewModel.h"


@interface IDCMPCLoginViewController ()
@property (nonatomic,strong) IDCMPCLoginViewModel *viewModel;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UILabel *tipLabelOne;
@property (nonatomic,strong) UILabel *tipLabelTwo;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *cancelbtn;
@property (nonatomic,strong) UIView *coverView;
@end


@implementation IDCMPCLoginViewController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

#pragma mark — supper methods
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    
    void (^dissmissSubscribe)(UIControl *x) = ^(UIControl *x){
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [[[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:dissmissSubscribe];
    [[[self.cancelbtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:dissmissSubscribe];
    
    [RACObserve(self.viewModel, invalid) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            self.tipLabelTwo.hidden = NO;
            [self.loginBtn setTitle:NSLocalizedString(@"2.2.3_ReScan", nil) forState:UIControlStateNormal];
        }
    }];
    
    void(^reScanCallback)(void) = ^(){
       UITabBarController *tabbarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *homeVc = ((UINavigationController *)(tabbarVc.selectedViewController)).topViewController;
        
           if ([homeVc respondsToSelector:NSSelectorFromString(@"gotoSCanVc")]) {
               [homeVc performSelectorOnMainThread:NSSelectorFromString(@"gotoSCanVc")
                                        withObject:nil waitUntilDone:nil];
           }
    };
    
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         @strongify(self);
         if ([self.viewModel.invalid boolValue]) {
             [self dismissViewControllerAnimated:YES completion:reScanCallback];
         } else {
             [self.viewModel.authorizedCommand execute:@1];
         }
     }];
    
    [self.viewModel.authorizedCommand.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        if (x) {
            
        } else {
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.3_PCLoginInvalid", nil)];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [[[self.viewModel.authorizedCommand.executionSignals switchToLatest]
      deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        if (x) {
//            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"3.0_Hy_ScanPcLoginSuceessTip", nil)];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [self.viewModel.authorizedCommand.executing subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [self showActivityIndicator];
        } else {
            [self dismissActivityIndicator];
        }
    }];
    [self.viewModel.authorizedCommand execute:@0];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
    [self configLayout];
}

#pragma mark — 配置UI相关
- (void)configUI {
    
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.tipLabelOne];
    [self.view addSubview:self.tipLabelTwo];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.cancelbtn];
}

- (void)configLayout {
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kSafeAreaTop + 2);
        make.width.height.equalTo(@40);
        make.left.equalTo(self.view);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100 + kSafeAreaTop);
        make.width.equalTo(@130);
        make.height.equalTo(@107);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.tipLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(40);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.height.equalTo(@20);
    }];
    [self.tipLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabelOne.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.tipLabelOne);
    }];
    [self.tipLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabelOne.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.tipLabelOne);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-(138 + kSafeAreaBottom));
        make.width.equalTo(@160);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(20);
        make.width.height.centerX.equalTo(self.loginBtn);
    }];
}

#pragma mark - getters and setters
- (UIButton *)closeBtn {
    return SW_LAZY(_closeBtn, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"3.0_closePIN"] forState:UIControlStateNormal];
        btn;
    }));
}

- (UIImageView *)logoImageView {
    return SW_LAZY(_logoImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"2.2.3_PCLogin"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView;
    }));
}

- (UILabel *)tipLabelOne {
    return SW_LAZY(_tipLabelOne, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = NSLocalizedString(@"2.2.3_PCLoginSure", nil);;
        label;
    }));
}

- (UILabel *)tipLabelTwo {
    return SW_LAZY(_tipLabelTwo, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = [UIColor colorWithHexString:@"#FC8968"];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = NSLocalizedString(@"2.2.3_PCLoginInvalid", nil);
        label.hidden = YES;
        label;
    }));
}

- (UIButton *)loginBtn {
    return SW_LAZY(_loginBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 6.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = kThemeColor.CGColor;
        btn.layer.borderWidth = .5;
        btn.adjustsImageWhenHighlighted = NO;
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        [btn setTitle:NSLocalizedString(@"2.0_Login", nil) forState:UIControlStateNormal];
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        btn;
    }));
}

- (UIButton *)cancelbtn {
    return SW_LAZY(_cancelbtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor whiteColor];;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"2.0_Cancel", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        btn;
    }));
}

- (void)showActivityIndicator {
    UIView *coverView = [[UIView alloc] init];
    coverView.frame = CGRectMake(0, 100 , SCREEN_WIDTH, SCREEN_HEIGHT - 100);
    coverView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:coverView];
    self.coverView = coverView;
    UIActivityIndicatorView *inDicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    inDicatorView.color = kThemeColor;
    [inDicatorView startAnimating];
    
    [coverView addSubview:inDicatorView];
    inDicatorView.centerX = coverView.width / 2;
    inDicatorView.centerY = SCREEN_HEIGHT / 2 - 100;
}

- (void)dismissActivityIndicator {
    [self.coverView removeFromSuperview];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end





