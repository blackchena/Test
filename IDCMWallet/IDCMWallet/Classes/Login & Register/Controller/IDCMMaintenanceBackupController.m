//
//  IDCMMaintenanceBackupController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/27.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMMaintenanceBackupController.h"
#import "IDCMBackupMemorizingWordsViewModel.h"
#import "IDCMWhiteNavigationBar.h"
#import "IDCMPhraseModel.h"

@interface IDCMMaintenanceBackupController ()
@property (nonatomic,strong) IDCMBackupMemorizingWordsViewModel *viewModel;
@property (nonatomic,strong) IDCMWhiteNavigationBar *navigationBar;
@property (nonatomic,strong) UIView *memorizingWordsView;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UILabel *tipLabelOne;
@property (nonatomic,strong) UILabel *tipLabelTwo;
@property (nonatomic,strong) UILabel *tipLabelThree;
@property (nonatomic,strong) UIButton *backupBtn;
@end

@implementation IDCMMaintenanceBackupController

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
    
    [[[self.backupBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         // 去备份
         @strongify(self);
         [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMVerifyBackUpPhrasesController"
                                                            withViewModelName:@"IDCMVerifyPhrasesOrderViewModel"
                                                                   withParams:@{@"listModel":self.viewModel.listModel,@"backupType":self.viewModel.backupType}];
     }];
    
    [[[self.viewModel.memorizingWordsCommand.executionSignals switchToLatest]
      deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.listModel.RandomWord enumerateObjectsUsingBlock:^(IDCMPhraseModel *obj,
                                                                          NSUInteger idx,
                                                                          BOOL *stop) {
            if ([obj.serial_number integerValue] < 13) {
                ((UILabel *)[self.memorizingWordsView viewWithTag:[obj.serial_number integerValue]]).text = obj.phrase;
            }
        }];
        self.backupBtn.enabled = YES;
    }];
    [self.viewModel.memorizingWordsCommand execute:nil];
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
    self.fd_interactivePopDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.memorizingWordsView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.tipLabelOne];
    [self.view addSubview:self.tipLabelTwo];
    [self.view addSubview:self.tipLabelThree];
    [self.view addSubview:self.backupBtn];
    
}

#pragma mark — 配置布局相关
- (void)configLayout {
    
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(10);
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.height.greaterThanOrEqualTo(@40);
    }];
    [self.memorizingWordsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.height.equalTo(@((159.0/295) * (SCREEN_WIDTH - 80)));
    }];
    [self.tipLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memorizingWordsView.mas_bottom).offset(20);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.greaterThanOrEqualTo(@20);
    }];
    [self.tipLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabelOne.mas_bottom).offset(20);
        make.left.right.equalTo(self.tipLabelOne);
        make.height.greaterThanOrEqualTo(@40);
    }];
    [self.tipLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabelTwo.mas_bottom).offset(20);
        make.left.right.equalTo(self.tipLabelOne);
        make.height.greaterThanOrEqualTo(@40);
    }];

    [self.backupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-60-kSafeAreaBottom);
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.height.equalTo(@40);
    }];
}

#pragma mark - getters and setters
- (IDCMWhiteNavigationBar *)navigationBar {
    return SW_LAZY(_navigationBar, ({
        
        IDCMWhiteNavigationBar *view = [IDCMWhiteNavigationBar new];
        view.backButton.hidden = YES;
        view.titlelable.text = SWLocaloziString(@"3.0_Bin_SafeUpdateTitle");
        view;
    }));
}

- (UIImageView *)logoImageView {
    return SW_LAZY(_logoImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"21._wake_app_logo_icon"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView;
    }));
}

- (UIView *)memorizingWordsView {
    return SW_LAZY(_memorizingWordsView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        for (NSInteger i = 1; i < 13; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.tag = i;
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 2;
            label.layer.borderWidth = 0.5;
            label.layer.borderColor = [UIColor colorWithHexString:@"#2968B9"].CGColor;
            label.font = textFontPingFangRegularFont(14);
            label.textColor = textColor333333;
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
        }
        [view.subviews mas_distributeSudokuViewsWithFixedLineSpacing:13
                                               fixedInteritemSpacing:20
                                                           warpCount:3
                                                          topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
        view;
    }));
}
- (UILabel *)tipLabel {
    return SW_LAZY(_tipLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = UIColorMakeWithHex(@"#FC8968");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = SWLocaloziString(@"3.0_Bin_SafeUpdateTipOne");
        label;
    }));
}
- (UILabel *)tipLabelOne {
    return SW_LAZY(_tipLabelOne, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = UIColorMakeWithHex(@"#FC8968");
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.text = SWLocaloziString(@"3.0_Bin_SafeUpdateTipTwo");
        label;
    }));
}

- (UILabel *)tipLabelTwo {
    return SW_LAZY(_tipLabelTwo, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = UIColorMakeWithHex(@"#FC8968");
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.text = SWLocaloziString(@"3.0_Bin_SafeUpdateTipThree");
        label;
    }));
}
- (UILabel *)tipLabelThree {
    return SW_LAZY(_tipLabelThree, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = UIColorMakeWithHex(@"#FC8968");
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.text = SWLocaloziString(@"3.0_Bin_SafeUpdateTipFour");
        label;
    }));
}

- (UIButton *)backupBtn {
    return SW_LAZY(_backupBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"2.0_GoBackups", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithHexString:@"#999FA5"]];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setBackgroundImage:image2 forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateDisabled];
        btn;
    }));
}

#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end