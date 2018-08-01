//
//  IDCMUnopendFindWalletPWController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/4.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMUnopendFindWalletPWController.h"
#import "IDCMWhiteNavigationBar.h"


@interface IDCMUnopendFindWalletPWController ()
@property (nonatomic,strong) IDCMWhiteNavigationBar *navigationBar;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *infoLabel;
@end


@implementation IDCMUnopendFindWalletPWController
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
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
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.infoLabel];
}

#pragma mark — 配置Layout相关
- (void)configLayout {
    
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(50);
        make.left.equalTo(@14);
        make.right.equalTo(@-14);
        make.height.equalTo(@((219.0 / 348.0) * (SCREEN_WIDTH - 28)));
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(42);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.height.equalTo(@20);
    }];
}

#pragma mark - getters and setters
- (IDCMWhiteNavigationBar *)navigationBar {
    return SW_LAZY(_navigationBar, ({
        
        IDCMWhiteNavigationBar *view = [IDCMWhiteNavigationBar new];
        view.titlelable.text = NSLocalizedString(@"2.0_FindWalletPW", nil);;
        view;
    }));
}

- (UIImageView *)imageView {
    return SW_LAZY(_imageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:@"2.1_NoDataImage"];
        imageView;
    }));
}

- (UILabel *)infoLabel {
    return SW_LAZY(_infoLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFontPingFangRegularFont(14);
        label.text = NSLocalizedString(@"2.2.3_UnopendFindWalletPW", nil);;
        label;
    }));
}

#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end



