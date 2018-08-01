//
//  IDCMBackupMemorizingWordsController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBackupMemorizingWordsController.h"
#import "IDCMBackupMemorizingWordsViewModel.h"
#import "IDCMWhiteNavigationBar.h"
#import "IDCMPhraseModel.h"


@interface IDCMBackupMemorizingWordsController ()
@property (nonatomic,strong) IDCMBackupMemorizingWordsViewModel *viewModel;
@property (nonatomic,strong) IDCMWhiteNavigationBar *navigationBar;
@property (nonatomic,strong) UIView *memorizingWordsView;
@property (nonatomic,strong) UIButton *nextTimeBtn;
@property (nonatomic,strong) UILabel *tipLabelOne;
@property (nonatomic,strong) UILabel *tipLabelTwo;
@property (nonatomic,strong) UIButton *backupBtn;
@end


@implementation IDCMBackupMemorizingWordsController
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
          
          [[IDCMMediatorAction sharedInstance]
           pushViewControllerWithClassName:@"IDCMVerifyBackUpPhrasesController"
           withViewModelName:@"IDCMVerifyPhrasesOrderViewModel" withParams:@{@"listModel" : self.viewModel.listModel,@"backupType":self.viewModel.backupType}];
     }];
    
    [[[self.nextTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
      subscribeNext:^(UIControl *x) {
          @strongify(self);
         // 下次再说
          if ([self.viewModel.backupType isEqualToNumber:@(0)]) {
              [[IDCMMediatorAction sharedInstance]
               pushViewControllerWithClassName:@"IDCMSetPINController"
               withViewModelName:@"IDCMSetPINViewModel" withParams:nil];
          }else{
              [self.navigationController popViewControllerAnimated:YES];
          }
          
     }];
    
    [[[self.viewModel.memorizingWordsCommand.executionSignals switchToLatest]
      deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.listModel.RandomWord enumerateObjectsUsingBlock:^(IDCMPhraseModel *obj,
                                                                          NSUInteger idx,
                                                                          BOOL *stop) {
            @strongify(self);
            if ([obj.serial_number integerValue] < 13) {
                ((UILabel *)[self.memorizingWordsView viewWithTag:[obj.serial_number integerValue]]).text = obj.phrase;
            }
        }];
        [self startTimer];
    }];
    [self.viewModel.memorizingWordsCommand execute:nil];
}

- (void)startTimer {
    
    self.backupBtn.enabled = YES;
    id (^counterSignalMap)(NSNumber *value) = ^(NSNumber *value){
        return [NSString stringWithFormat:@"%@(%@s)", NSLocalizedString(@"2.0_NoGoBackups", nil), value];
    };
    BOOL (^resetSignalFilter)(NSNumber *value) = ^BOOL(NSNumber *value){
        return !value.boolValue;
    };
    
    RACSignal *counterSignal =
    [[self.viewModel.timerCommand.executionSignals switchToLatest] map:counterSignalMap];
    RACSignal *resetSignal =
    [[[self.viewModel.timerCommand.executing skip:1] filter:resetSignalFilter]
                                        mapReplace:NSLocalizedString(@"2.0_NoGoBackups", nil)];

    [self.nextTimeBtn rac_liftSelector:@selector(setTitle:forState:)
                           withSignals:[RACSignal merge:@[counterSignal, resetSignal]],
                                       [RACSignal return:@(UIControlStateNormal)], nil];
    
    @weakify(self);
    [[[self.viewModel.timerCommand.executing skip:1] filter:resetSignalFilter]
     subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.nextTimeBtn.enabled = YES;
        self.nextTimeBtn.layer.borderColor = kThemeColor.CGColor;
    }];
    [self.viewModel.timerCommand execute:nil];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
    [self configLayout];
    // 作为跟控制器时隐藏返回按钮
    if ([self.viewModel.isSetRootViewController boolValue]) {
        self.navigationBar.backButton.hidden = YES;
    }
}

#pragma mark — 配置UI相关
- (void)configUI {
    
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.memorizingWordsView];
    [self.view addSubview:self.tipLabelOne];
    [self.view addSubview:self.tipLabelTwo];
    [self.view addSubview:self.backupBtn];
    [self.view addSubview:self.nextTimeBtn];
}

#pragma mark — 配置布局相关
- (void)configLayout {
    
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
    }];

    [self.memorizingWordsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(30);
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.height.equalTo(@((159.0/295) * (SCREEN_WIDTH - 80)));
    }];
    [self.tipLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memorizingWordsView.mas_bottom).offset(35);
        make.left.right.equalTo(self.memorizingWordsView);
        make.height.greaterThanOrEqualTo(@40);
    }];
    [self.tipLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabelOne.mas_bottom).offset(10);
        make.left.right.equalTo(self.tipLabelOne);
        make.height.greaterThanOrEqualTo(@40);
    }];
    [self.backupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabelTwo.mas_bottom).offset(50);
        make.left.equalTo(@38);
        make.right.equalTo(@-38);
        make.height.equalTo(@40);
    }];
    [self.nextTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backupBtn.mas_bottom).offset(20);
        make.left.right.height.equalTo(self.backupBtn);
    }];
}

#pragma mark - getters and setters
- (IDCMWhiteNavigationBar *)navigationBar {
    return SW_LAZY(_navigationBar, ({
        
        IDCMWhiteNavigationBar *view = [IDCMWhiteNavigationBar new];
        view.titlelable.text = SWLocaloziString(@"2.2.3_SettingMemorizingWordsTitle");
        view;
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

- (UILabel *)tipLabelOne {
    return SW_LAZY(_tipLabelOne, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor666666;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = NSLocalizedString(@"2.2.3_BackupMemorizingWordsTipBlack", nil);
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
        label.text = NSLocalizedString(@"2.2.3_BackupMemorizingWordsTipRed", nil);
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

- (UIButton *)nextTimeBtn {
    return SW_LAZY(_nextTimeBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#999FA5"].CGColor;
        btn.layer.borderWidth = 1.0;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:[NSString stringWithFormat:@"%@(5s)", NSLocalizedString(@"2.0_NoGoBackups", nil)]
             forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#999FA5"] forState:UIControlStateDisabled];
        btn;
    }));
}
#pragma mark - statusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end



